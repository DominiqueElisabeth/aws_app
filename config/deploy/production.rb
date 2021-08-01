server '44.197.43.56', user: 'ec2-user', roles: %w{ec2-user db web}
set :ssh_options, keys: '/Users/domel/.ssh/id_rsa'
