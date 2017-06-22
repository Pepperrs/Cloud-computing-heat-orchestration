#!/usr/bin/env ruby

def create_server
  puts 'creating server'
  cmd =
    'cc-openstack server create grp17_instance'\
    ' --image ubuntu-16.04'\
    " --flavor 'Cloud Computing'"\
    ' --network cc17-net'\
    ' --security-group grp17_security_group'\
    " --key-name #{ENV['USER']}"
  `#{cmd}`
  puts 'connecting floating ip to server'
  `cc-openstack server add floating ip grp17_instance #{floating_ip}`
end

def floating_ip
  @floating_ip ||=
    `cc-openstack floating ip list -c 'Floating IP Address' -f value`.strip
end

def wait_for_server
  print 'waiting for server '
  loop do
    error = `bash -c '(echo > /dev/tcp/#{floating_ip}/22) 2>&1'`
    break if error.empty?
    print '.'
    sleep 0.5
  end
  print "\n"
end

def destroy_server
  puts 'destroying server'
  `cc-openstack server delete grp17_instance`
  while `cc-openstack server list`.include?('grp17_instance')
    sleep 0.5
  end
end

def server_creation_duration
  puts 'start measuring server creation'
  start = Time.now
  create_server
  wait_for_server
  duration = Time.now - start
  destroy_server
  puts 'end measuring server creation'
  duration
end

def server_list_duration
  puts 'start measuring server list'
  start = Time.now
  `cc-openstack server list`
  duration = Time.now - start
  puts 'end measuring server list'
  duration
end

def append_result
  scenario_one = server_list_duration
  scenario_two = server_creation_duration
  File.open('results.csv', 'a') do |f|
    f << "#{Time.now};#{scenario_one};#{scenario_two}\n"
  end
end

3.times { append_result }
