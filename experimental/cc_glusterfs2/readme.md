lding the infrastructure
Here we will explain how to deploy a full GlusterFS system with a VNET, JUMPBOX, CYCLESERVER and Gluster by using building blocks. These blocks are stored into the experimental/blocks directory.

## Step 1 - install azhpc
after cloning azhpc, source the install.sh script

## Step 2 - Initialize the configuration files
Create a working directory from where you will do the deployment and configuration update. Don't work directly from the cloned repo.

```
$ mkdir cluster
$ cd cluster
```

Then copy the init.sh,variables.json, and scripts directory from examples/cc_glusterfs2 to your working directory.

```
$ cp $azhpc_dir/examples/cc_glusterfs2/init.sh .
$ cp $azhpc_dir/examples/cc_glusterfs2/variables.json .
$ cp -r $azhpc_dir/examples/cc_glusterfs2/scripts .
```

Edit the variables.json to match your environment. Leave the projectstore empty as it will be filled up with a random value by the init script. An existing keyvault should be referenced as it won't be created for you.

```json
{
    "resource_group": "my resource group",
    "location": "location",
    "key_vault": "my key vault",
    "projectstore": ""
  }
```

Run the init.sh script which will copy all the config files of the building blocks and initialize the variables by using the variables.json updated above.

```
$ ./init.sh
```

## Step 2 - Build the system

```
$ azhpc-build -c vnet.json
$ azhpc-build --no-vnet -c jumpbox.json
$ azhpc-build --no-vnet -c cycle-prereqs-managed-identity.json
$ azhpc-build --no-vnet -c cycle-install-server-managed-identity.json
```

## Step 3 - Deploy the Cycle CLI
Deploy the Cycle CLI locally and on the jumpbox

```
$ azhpc-build --no-vnet -c cycle-cli-local.json
$ azhpc-build --no-vnet -c cycle-cli-jumpbox.json
```

## Step 4 - Now deploy the GlusterFS cluster
```
$ azhpc-build --no-vnet -c gluster-cluster.json
```

## Step 5 - Create the PBS cluster in CycleCloud

```
$ azhpc build -c pbscycle.json --no-vnet
```

## Step 6 - Connect to CycleServer UI
Retrieve the CycleServer DNS name by connecting with azhpc

```
$ azhpc-connect -c cycle-install-server-managed-identity.json cycleserver
[2020-06-10 08:28:04] logging directly into cycleserver559036.westeurope.cloudapp.azure.com
$ [hpcadmin@cycleserver ~]$ exit
```

Retrieve the Cycle admin password from the logs 

```
$ grep password azhpc_install_cycle-install-server-managed-identity/install/*.log
```

Connect to the Cycle UI with hpcadmin user and the password retrieved above. Check that you have a pbscycle cluster ready and start it
# AzureHPC BeeGFS and CycleCloud Integration
