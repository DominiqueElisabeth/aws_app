server '44.197.43.56', user: 'ec2-user', roles: %w{app db web}
set :ssh_options, keys: '/Users/domel/.ssh/id_rsa'
