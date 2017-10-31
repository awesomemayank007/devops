#!/bin/bash
a=`neutron port-list | grep -w $1 |cut -d"|" -f2`
neutron port-update --no-security-groups  $a
neutron port-update --port-security-enabled=false  $a