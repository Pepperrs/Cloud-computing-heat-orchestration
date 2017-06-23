Cloud Computing
================
Summer Term 2017
----------------
#### Assignment 2 - Cloud Benchmarking and Orchestration

### Student Group
  **Name:** CC_GROUP_16

  **Members:**
  1. Peter Schuellermann |   *380490*
  2. Sebastian Schasse   |   *318569*
  3. Felix Kybranz       |   *380341*
  4. Hafiz Umar Nawaz    |   *389922*

* * *

### 1. Cloud Benchmark

### 2. Introducing Heat

Firstly we need to prepare the environment. We need to create and
upload a ssh key. We need a security group with icmp ingress as well
as port 22 ingress for ssh. Lastly a floating ip is necessary.

``` shell
# create ssh key and upload to openstack
ssh-keygen -t rsa -b 4096 -C $USER
openstack keypair create $USER --public-key ~/.ssh/id_rsa.pub

# create security group with icmp and ssh ingress
openstack security group create grp17_security_group
openstack security group rule create grp17_security_group \
  --description icmp-ingress --ingress --protocol icmp
openstack security group rule create grp17_security_group \
  --description ssh-ingress --ingress --protocol tcp --dst-port 22:22

# create floating ip
cc-openstack floating ip create tu-internal
```

Then we can actually create the stack with the correct parameters.

``` shell
openstack stack create \
  --parameter name=grp17_instance \
  --parameter key_pair=$USER \
  --parameter 'flavor=Cloud Computing' \
  --parameter image=ubuntu-16.04 \
  --parameter 'zone=Cloud Computing 2017' \
  --parameter network=cc17-net \
  -t server.yml grp17_stack
```

To have the server reachable, we need to connect it to the floating ip.

``` shell
grp17_ip=$(openstack floating ip list -c 'Floating IP Address' -f value)
openstack server add floating ip grp17_instance $grp17_ip
```

Then we can connect to the server via ssh.

``` shell
ssh ubuntu@$grp17_ip
```

To cleanup, we delete the stack and check the server is gone.

``` shell
openstack stack delete -y grp17_stack
openstack server list
```

### 3. Advanced Heat Templates

### Submission Deliverable

1. Detailed description of your cloud benchmarking methodology, including any scripts or other code
2. Benchmarking results of the six different combinations of scenarios and time slots, including plots and interpretation of the results
3. Commented listing of commands you executed for Task 2
4. The contents of your server-landscape.yml​ file
5. Commented listing of commands you executed to test your advanced Heat template
