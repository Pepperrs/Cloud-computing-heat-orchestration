# Heat

## Installation

`pip install python-heatclient` and setup a similar script like
`cc-openstack` and replace the password:

``` shell
#!/usr/bin/env bash

export OS_AUTH_URL=http://cloud.cit.tu-berlin.de:5000/v2.0
export OS_TENANT_ID=06b5ed6b475043d3b619d0b2d1a3f95f
export OS_TENANT_NAME="cc17-group16"
unset OS_PROJECT_ID
unset OS_PROJECT_NAME
unset OS_USER_DOMAIN_NAME
export OS_USERNAME="cc17-group16"
export OS_PASSWORD="XXXXXXXXXXXXXX"
export OS_REGION_NAME="RegionOne"
export OS_ENDPOINT_TYPE=publicURL
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=2

heat "$@"
```

## Preparation

There needs to be a keypair, security group, just like in
assignment 1.

## Usage
Then the command I used to is:

``` shell
cc-heat stack-create grp17_stack -f server.yml -P "name=grp17_instance;key_pair=$USER;flavor=Cloud Computing;image=ubuntu-16.04;network=cc17-net"
```
or
``` shell
./cc-openstack stack create grp17_stack -t server-landscape-corrected.yaml --parameter "key_name=kybranz;flavor=Cloud Computing;image=ubuntu-16.04;public_net_id=pub_network_01;private_net_id=priv_network_01;private_subnet_id=priv_subnet_01;availability_zone=Cloud Computing 2017"
```

But like Anton said in the forum we need to boot the machine in the
"Cloud Computing 2017" availability zone. So the command still needs
to be extended.
