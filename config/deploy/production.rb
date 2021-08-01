server '44.197.43.56', user: 'ec2-user', roles: %w{app db web}
set :ssh_options, {keys: %w(~/.ssh/id_rsa)}
