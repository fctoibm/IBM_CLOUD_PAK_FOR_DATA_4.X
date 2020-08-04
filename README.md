

# Deploy Cloud Pak for Data on OpenShift 4.3 on Classic IBM Cloud Infrastructure or IC4G

##

## Introduction

The purpose of this tutorial is to install IBM Cloud Pak for Data (CP4D) on OpenShift 4.3. The setup assumes OCP 4.3 is already deployed in IBM Cloud on Classic infrastructure using VSI. One can easily modify the ansible-playbook to implement the CP4D using other hypervisors, such as VMware or Openstack. The CP4D uses Portworx as a storage class. The internal OpenShift registry is also enabled but uses local storage disk on one node.

### Services used

This tutorial uses the following runtimes and services:

- [Virtual Servers](https://cloud.ibm.com/gen1/infrastructure/provision/vs?)

> **NOTE:** This tutorial may incur costs. Use the [Pricing Calculator](https://cloud.ibm.com/estimator/review) to generate a cost estimate based on your projected usage.

##  
## 	Architecture Diagram
<img src=images/cp4d-cluster-arch.png width="900"/>

#### Steps performed by Playbook
1.  [SoftLayer API Python Client](https://softlayer-api-python-client.readthedocs.io/en/latest/) (scli) orders the  VSI as a Pak Helper VM to deploy all the CP4D cloud pak types
2. Enables internal OpenShift registry with 500 GB space
3. Enables Portworx which requires a minimum of 3 worker nodes
4. Option to enable lite, watson-ks, watson-discovery, spark and runtime-addon-r36 CP4D assembly type.


##  

## Prerequisites

This tutorial requires:

- Macbook or Linux desktop (CentOS or Redhat) to kick off the ansible playbook and make sure [ansible is installed](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
  - ansible –version
- Make sure [pip is installed](https://pip.pypa.io/en/stable/installing/) by verifying
  - pip version
- Make sure following packages are installed on a Linux CentOS/RedHat System
  - yum install git gcc gcc-c++ python-devel cairo-devel gobject-introspection-devel cairo-gobject-devel ansible
- Make sure following packages are installed on a MacOS System
  - brew install pygobject3 gtk+3 libffi python cairo pkg-config gobject-introspection atk glib
- Motion Pro VPN to access IBM Cloud or IC4G.
- Git to clone the source code
- [Private VLAN routed through Vyatta](https://cloud.ibm.com/docs/virtual-router-appliance?topic=virtual-router-appliance-routing-your-vlans) using [NAT masquerade to Internet](https://cloud.ibm.com/docs/virtual-router-appliance?topic=solution-tutorials-nat-config-private) for public internet access to pull down CP4D binaries and updates.
- A minimum 4 OpenShift worker nodes required for the install to complete. Six OpenShift worker nodes are recommended.

##Estimated time
 Tasks in this tutorial should take about 2 hour, but depending on the assembly type selected the install time can vary.

##  
## Steps

1. Add 2 disks, 1 TB and 250 GB, to the Portworx OpenShift worker nodes. You can enable this by logging into the IBM Cloud Portal and resizing the VM's

  <img src=images/attached-storage-disks-2.png width="1000"/>
  
2. Add 500 GB disk to one of the OpenShift registry worker node;  this should not be one of the Portworx worker nodes. You can enable this by login into IBM Cloud Portal and resize the VM's.
  <img src=images/attached_storage_disks.png width="1000"/>

3. Depending on your assembly type you might want to resize the OpenShift worker node memory and CPU. For a lite installation, these install instructions will work without having to adjust the worker node resource. For other assemblies, it is recommended to upgrade the VM's compute memory and CPU accordingly (refer to https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_current/cpd/plan/rhos-reqs.html)

4. Clone the ansible playbook repo:

```  
	$ git clone https://github.ibm.com/harsingh/OCP_4.X_VSI.git

```
5. Copy the the content of artifacts directory from the previous OpenShift install to the artifact directory in the CP4D folder structure.

```  
	$ cd OCP_4.X_VSI/artifacts

```
```
  $ cp -r <<YOUR_LOCATION/artifacts/>  .

```
6. Run the following command which will validate that all pre-reqs are installed

```  
	$ cd OCP_4.X_VSI/artifacts

```

```  
   	$ while read p; do pip install  --ignore-installed ${p}; done <artifacts/pip-req.txt

```
7. Copy the variable file:

```  
	$ cp vars.yaml.template vars.yaml

```
8. Update the variables in var.yaml file

```  
	 $ vi vars.yaml

```

> Make the following updates:
> - ocp_ip: <IP address for load balancer node>
> - oc_admin_password: “KUBE_ADMIN_PASSWORD” 
> - ENTITLED_REGISTRY_KEY: <YOUR_KEY_FOR_CP4D> 
> - CP4D_NAMESPACE: “zen” 
> - ASSEMBLY_TYPE: lite
> - sl_ocp_portworx_storage_workers: Include all Portworx storage node names
> - sl_ocp_registry_storage_worker: Registry worker node name

9. Download the CP4D_EE_Portworx.bin file for CP4D from IBM Software Download and copy into the artifact directory

```
   $ cp CP4D_EE_Portworx.bin  OCP_4.X_VSI/artifacts/

```
10. Execute the bash script to run the playbook

```  
	$ chmod +x *.sh

	$ ./deploy_playbooks.sh

```

## Verify CP4D install

In this section, you are going to verify that CP4D has been created successfully.

1. Add zen-cpd url as OpenShift Load balancer IP address to your DNS or /etc/hosts file for example

> <helpernode_ip_address> zen-cpd.apps.<base_domain_prefix>.<base_domain>


2. Open a browser and type in the following URL and login in as kubeadmin

> https://zen-cpd.apps.<base_domain_prefix>.<base_domain>  

## Summary

Hopefully, you found this tutorial helpful and educational by deploying CP4D on OpenShift 4.3 and above on the virtual classic infrastructure layer. Once the OCP 4.x solution deployed, it inherits all IBM Cloud advantages like Elasticity of CPU and Memory and Disk.


## Related links
- https://www.ibm.com/cloud
- https://www.ansible.com/
- https://cloud.ibm.com/docs/iaas-vpn?topic=iaas-vpn-getting-started
- https://docs.openshift.com/container-platform/4.3/release_notes/ocp-4-4-release-notes.html
- https://cloud.ibm.com/docs/virtual-router-appliance?topic=virtual-router-appliance-getting-started
- https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_current/cpd/overview/overview.html
