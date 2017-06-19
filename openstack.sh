#!/bin/bash

if [[ ! -f $HOME/.ssh/id_rsa ]]; then
  ssh-keygen -t rsa -b 4096 -C $USER
fi

cc-openstack keypair create $USER --public-key ~/.ssh/id_rsa.pub
cc-openstack security group create grp17
cc-openstack security group rule create grp17 --description ssh-ingress --ingress --protocol tcp --dst-port 22:22
cc-openstack security group rule create grp17 --description icmp-ingress --ingress --protocol icmp
cc-openstack server create grp17 --image ubuntu-16.04 --flavor 'Cloud Computing' --network cc17-net --security-group grp17 --key-name $USER
cc-openstack floating ip create tu-internal
grp17_ip=$(cc-openstack floating ip list -c 'Floating IP Address' -f value)
cc-openstack server add floating ip grp17 $grp17_ip

printf "\ngrab a coffee and wait for the machine $grp17_ip to boot\n"
while [[ $(bash -c "(echo > /dev/tcp/$grp17_ip/22) 2>&1") ]]; do
  echo 'still waiting...'
  sleep 10
done

ssh ubuntu@$grp17_ip

# cc-openstack server delete grp17
# cc-openstack security group delete grp17
# cc-openstack floating ip delete $grp17_ip
# cc-openstack keypair delete $USER
