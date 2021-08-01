$worker  = 2
$timeout = 30

$ec2-user_dir = "/var/www/aws_app/current"
$listen  = File.expand_path 'tmp/sockets/unicorn.sock', $ec2-user_dir
$pid     = File.expand_path 'tmp/pids/unicorn.pid', $ec2-user_dir
$std_log = File.expand_path 'log/unicorn.log', $ec2-user_dir

worker_processes  $worker
working_directory $ec2-user_dir
stderr_path $std_log
stdout_path $std_log
timeout $timeout
listen  $listen
pid $pid
preload_app true
before_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!
  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      Process.kill "QUIT", File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
