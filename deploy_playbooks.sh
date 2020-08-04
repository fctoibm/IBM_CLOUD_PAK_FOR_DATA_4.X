#!/bin/sh
export ANSIBLE_HOST_KEY_CHECKING=False
dir=${PWD}  
p_now=$(date +"%T")
start=$(date +%s)
echo "############################################################################################"
echo "#                    PROVISIONED START TIME : $p_now                                       #"
echo "############################################################################################"

#ansible-playbook  -e @vars.yaml  $dir/play0.yaml -i hosts
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi

now=$(date +"%T")

echo "Current time : $now"
#ansible-playbook  -e @vars.yaml  $dir/play1.yaml -i $dir/artifacts/hosts
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
e_now=$(date +"%T")
duration=$(echo "$(date +%s) - $start" | bc)
execution_time=`printf "%.2f seconds" $duration`
chmod 600 $dir/artifacts/ocp4_rsa
now=$(date +"%T")

echo "Current time : $now"
#ansible-playbook  -e @vars.yaml  $dir/play2.yaml -i $dir/artifacts/hosts
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
e_now=$(date +"%T")
duration=$(echo "$(date +%s) - $start" | bc)
execution_time=`printf "%.2f seconds" $duration`


now=$(date +"%T")

echo "Current time : $now"
#ansible-playbook  -e @vars.yaml  $dir/play3.yaml -i $dir/artifacts/hosts 
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
e_now=$(date +"%T")
duration=$(echo "$(date +%s) - $start" | bc)
execution_time=`printf "%.2f seconds" $duration`

now=$(date +"%T")

echo "Current time : $now"
ansible-playbook  -e @vars.yaml  $dir/play4.yaml -i $dir/artifacts/hosts 
rc=$?; if [[ $rc != 0 ]]; then exit $rc; fi
e_now=$(date +"%T")
duration=$(echo "$(date +%s) - $start" | bc)
execution_time=`printf "%.2f seconds" $duration`

echo "###############################################################################################"
echo "#         PROVISIONED START TIME : $p_now             PROVISIONED END TIME : $e_now           #"
echo "#                                 Execution Time: $execution_time                             #"
echo "###############################################################################################"