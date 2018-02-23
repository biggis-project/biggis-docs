# Exasol Docker Support

Exasol has developed support for running the Exasol RDBMS inside a dockerized environment.

Currently supported features:

- create / start / stop a database in a virtual cluster
- use the UDF framework
- expose ports from containers on the local host
- update the virtual cluster
- create backups on archive volumes

# How to use this image

- Pull the image to your Docker host:
  ```console
  $ docker pull exasol/docker-db:latest
  ```
- Install `exadt`:
  ```console
  $ git clone https://github.com/EXASOL/docker-db.git
  $ cd docker-db
  ```
- Install the `exadt` dependencies:
  ```console
  $ pip install --upgrade -r exadt_requirements.txt
  ```
- Create and configure your virtual EXASOL cluster by using the commands described in the `exadt` documentation below.

## EXASOL Docker Tool — `exadt`

The `exadt` command-line tool is used to create, initialize, start, stop, update and delete a Docker based EXASOL cluster.

**NOTE: exadt currently only supports single-host-clusters. See below for how to create a multi-host-cluster (with one container per host).**

### 1. Creating a cluster

Select a root directory for your EXASOl cluster. It will be used to store the data, metadata and buckets of all local containers and should therefore be located on a filesystem with sufficient free space (min. 10 GiB are recommended).

**NOTE: this example creates only one node. You can easily create mutliple (virtual) nodes by using the --num-nodes option.**

```console
$ ./exadt create-cluster --root ~/MyCluster/ --create-root MyCluster
Successfully created cluster 'MyCluster' with root directory '/home/user/MyCluster/'.
```

`exadt` stores information about all clusters within `$HOME/.exadt.conf` and `/etc/exadt.conf` (if the current user has write permission in `/etc`). Both files are searched when executing a command that needs the cluster name as an argument. 

In order to list all existing clusters you can use `exadt list-clusters`:

```console
$ ./exadt list-clusters
 CLUSTER                     ROOT                                       IMAGE                    
 MyCluster                   /home/user/MyCluster                       <uninitialized>
```

### 2. Initializing a cluster

After creating a cluster it has to be initialized. Mandatory parameters are:

- the EXASOL Docker image 
- the license file
- the type of EXAStorage devices (currently only 'file' is supported)

```console
$ ./exadt init-cluster --image exasol/docker-db:latest --license ./license/license.xml --auto-storage MyCluster
Successfully initialized configuration in '/home/user/MyCluster/EXAConf'.
Successfully initialized root directory '/home/user/MyCluster/'.
```

This command creates subdirectories for each virtual node in the root directory. These are mounted as Docker volumes within each container (at '/exa') and contain all data, metadata and buckets.

It also creates the file `EXAConf` in the root directory, which contains the configuration for the whole cluster and currently has to be edited manually if a non-default setup is used.

#### Automatically creating and assigning file devices

The example above uses the `--auto-storage` option which tells `exadt` to automatically create file-devices for all virtual nodes (within the root directory). These devices are assigned to the EXAStorage volumes, that are also automatically created. The devices need at least 10GiB of free space and use up to 100GiB of it (all devices combined). 

If `--auto-storage` is used, you can skip the next step entirely (and *continue with section 4*).

### 3. Adding EXAStorage devices

**NOTE:  This step can be skipped if `--auto-storage` has been used during initialization.**

Next, devices for EXAStorage need to be added. This can be done by executing:

```console
$ ./exadt create-file-devices --size 80GiB MyCluster
Successfully created the following file devices:
Node 11 : ['/home/user/MyCluster/n11/data/storage/dev.1']
```

As you can see, the file devices are created within the `data/storage` subdirectory of each node's Docker root. They are created as *sparse files*, i. e. their size is stated as the given size but they actually have size 0 and grow as new data is being written.

All devices must be assigned to a 'disk'. A disk is a group of devices that can be assigned to an EXAStorage volume. The disk name can be specified with the `--disk` parameter. If omitted, the newly created devices will be assigned to the disk named 'default'.

#### Assigning devices to volumes

After creating the devices, they have to be assigned to the corresponding volumes. If you did not use `--auto-storage` (see above), you have to edit `EXAConf` manually. Open it and locate the following section:

```
[EXAVolume : DataVolume1]
    Type = data
    Nodes = 11
    Disk =
    Size =
    Redundancy = 1
```

Now add the name of the disk ('default', if you did not specify a name when executing `create-file-devices`) and the volume size, e. g:

```
    Disk = default
    Size = 100GiB
```

Then do the same for the section `[EXAVolume : ArchiveVolume1]`.

Make sure not to make the volume too big! The specified size is the size that is available for the database, i. e. if the redundancy is 2, the volume will actually use twice the amount of space! Also make sure to leave some free space for the temporary volume, that is created by the database during startup.

### 4. Starting a cluster

The cluster is started using the `exadt start-cluster` command. Before the containers are actually created, `exadt` checks if there is enough free space for the sparse files (if they grow to their max. size). If not, the startup will fail:

```console
$ ./exadt start-cluster MyCluster
Free space on '/' is only 22.2 GiB, but accumulated size of (sparse) file-devices is 80.0 GiB!
'ERROR::DockerHandler: Check for space usage failed! Aborting startup.'
```

If that's the case, you can replace the existing devices with smaller ones and (optionally) place them on an external partition:

```console
$ ./exadt create-file-devices --size 10GiB MyCluster --replace --path /mnt/data/
Do you really want to replace all file-devices of cluster 'MyCluster'? (y/n): y
The following file devices have been removed:
Node 11 : ['/home/user/MyCluster/n11/data/storage/dev.1']
Successfully created the following file devices:
Node 11 : ['/mnt/data/n11/dev.1']
```

The devices that are located outside of the root directory are mapped into the file system of the container (within `/exa/data/storage/`). They are often referenced as 'mapped devices'.

Now the cluster can be started:

```console
$ ./exadt start-cluster MyCluster
Copying EXAConf to all node volumes.
Creating private network 10.10.10.0/24 ('MyCluster_priv')... successful
No public network specified.
Creating container 'MyCluster_11'... successful
Starting container 'MyCluster_11'... successful
```

This command creates and starts all containers and networks. Each cluster uses one or two networks to connect the containers. These networks are not connected to other clusters. 

The containers are (re)created each time the cluster is started and they are destroyed when it is deleted! All persistent data is stored within the root directory (and the mapped devices, if any).

### 5. Inspecting a cluster

All containers of an existing cluster can be listed by executing:

```console
$ ./exadt ps MyCluster
 NODE ID      STATUS          IMAGE                       NAME   CONTAINER ID   CONTAINER NAME    EXPOSED PORTS       
 11           Up 5 seconds    exasol/docker-db:6.0.0-d1   n11    e9347c3e41ca   MyCluster_11      8899->8888,6594->6583
```

The `EXPOSED PORTS` column shows all container ports that are reachable from outside the local host ('host'->'container'), usually one for the database and one for BucketFS.

### 6. Stopping a cluster

A cluster can be stopped by executing:

```console
$ ./exadt stop-cluster MyCluster
Stopping container 'MyCluster_11'... successful
Removing container 'MyCluster_11'... successful
Removing network 'MyCluster_priv'... successful
```

As stated above, the containers are deleted when a cluster is stopped, but the root directory is preserved (as well as all mapped devices). Also the automatically created networks are removed. 
 
### 7. Updating a cluster

A cluster can be updated by exchanging the EXASOL Docker image (but it has to be stopped first):

```console
$ git pull
$ pip install --upgrade -r exadt_requirements.txt
$ docker pull exasol/docker-db:latest
$ ./exadt update-cluster --image exasol/docker-db:latest MyCluster
Cluster 'MyCluster' has been successfully updated!
- Image :  exasol/docker-db:6.0.0-d1 --> exasol/docker-db:6.0.0-d2
- DB    :  6.0.0                     --> 6.0.1
- OS    :  6.0.0                     --> 6.0.0
Restart the cluster in order to apply the changes.
```

The cluster has to be restarted in order to recreate the containers from the new image (and trigger the internal update mechanism).
 
### 8. Deleting a cluster

A cluster can be completely deleted by executing:

```console
$ ./exadt delete-cluster MyCluster
Do you really want to delete cluster 'MyCluster' (and all file-devices)?  (y/n): y
Deleting directory '/mnt/data/n11'.
Deleting directory '/mnt/data/n11'.
Deleting root directory '/home/user/MyCluster/'.
Successfully removed cluster 'MyCluster'.
```

Note that all file devices (even the mapped ones) and the root directory are deleted. You can use `--keep-root` and `--keep-mapped-devices` in order to prevent this.

A cluster has to be stopped before it can be deleted (even if all containers are down)!

## Creating a stand-alone EXASOL container

Starting with version 6.0.2-d1, there is no more separate "self-contained" image version. You can simply create an EXASOL container from the EXASOL docker image using the following command:

```console
$ docker run --name exasoldb -p 127.0.0.1:8899:8888 --detach --privileged --stop-timeout 120  exasol/docker-db:latest
```

In this example port 8888 (within the container) is exposed on the local port 8899. Use this port to connect to the DB.

All data is stored within the container and lost when the container is removed. In order to make it persistent, you'd have to mount a volume into the container at `/exa`, for example:

```console
$ docker run --name exasoldb  -p 127.0.0.1:8899:8888 --detach --privileged --stop-timeout 120 -v exa_volume:/exa exasol/docker-db:latest
```

See [the Docker volumes documentation](https://docs.docker.com/engine/tutorials/dockervolumes/) for more examples on how to create and manage persistent volumes.

**NOTE: Make sure the database has been shut down correctly before stopping the container!**

A high stop-timeout (see example above) increases the chance that the DB can be shut down gracefully before the container is stopped, but it's not guaranteed. However, it can be stopped manually by executing the following command within the container (after attaching to it):

```console
$ dwad_client stop-wait DB1
```

Or from outside the container:

```console
$ docker exec -ti exasoldb dwad_client stop-wait DB1
```


### Updating the persistent volume of a stand-alone EXASOL container

Starting with version 6.0.3-d1, an existing persistent volume can be updated (for use with a later version of an EXASOL image) by calling the following command with the *new* image:

```console
$ docker run -v exa_volume:/exa exasol/docker-db:6.0.3-d1 update-sc
```

If everything works correctly, you should see output similar to this:

```console
Updating EXAConf '/exa/etc/EXAConf' from version '6.0.2' to '6.0.3'
Container has been successfully updated!
- Image ver. :  6.0.2-d1 --> 6.0.3-d1
- DB ver.    :  6.0.2 --> 6.0.3
- OS ver.    :  6.0.2 --> 6.0.3
```

After that, a new container can be created (from the new image) using the old / updated volume.

## Creating a multi-host EXASOL cluster

Starting with version 6.0.7-d1, it's possible to create multiple containers on different hosts and connect them to a cluster (one container per host). 

### 1. Create the configuration 

First you have to create the configuration for the cluster. There are two possible ways to do so:
 
#### a. Create an /exa/ directory template (RECOMMENDED):

Execute the following command (`--num-nodes` is the number of containers in the cluster):

```console
$ docker run -v $HOME/exa_template:/exa --rm -i exasol/docker-db:latest init-sc --template --num-nodes 3
```

After the command has finished, the directory `$HOME/exa_template` contains all subdirectories as well as an EXAConf template (in `/etc`). The EXAConf is also printed to stdout.
 
#### b. Create an EXAConf template

You can create a template file and redirect it to wherever you want by executing: 

```console
$ docker run --rm -i exasol/docker-db:latest init-sc --template --num-nodes 3 > ~/MyExaConf
```

**NOTE: we recommend to create an /exa/ template directory and the following steps assume that you did so. If you choose to only create the EXAConf file, you have to build a new Docker image with it and create the EXAStorage devices files within that image.**

### 2. Complete the configuration

The EXAConf template has to be completed before the cluster can be started. You have to provide:

#### The private network of all nodes:
```console
[Node : 11]
    PrivateNet = 10.10.10.11/24 # <-- replace with the real network
```

#### The EXAStorage devices on all nodes:
```console
[[Disk : default]]
        Devices = dev.1    #'dev.1.data' and 'dev.1.meta' files must be located in '/exa/data/storage'
```

**NOTE: You can leave this entry as it is if you create the devices as described below.**

#### The EXAVolume sizes:
```console
[EXAVolume : DataVolume1]
    Type = data
    Nodes = 11, 12, 13
    Disk = default
    # Volume size (e. g. '1 TiB')
    Size =  # <-- enter volume size here
```
  
#### The network port numbers (optional)

If you are using the host network mode (see "Start the cluster" below), you may have to adjust the port numbers used by the EXASOL services. The one that's most likely to collide is the SSH daemon, which is using the well-known port 22. You can change it in EXAConf:
```console
[Global]
    SSHPort = 22  # <-- replace with any unused port number
```

The other EXASOL services (e. g. Cored, BucketFS and the DB itself) are using port numbers above 1024. However, you can change them all by editing EXAConf.
 
#### The nameservers (optional):
```console
[Global]
    ...
    # Comma-separated list of nameservers for this cluster.
    NameServers =
```
 
### 3. Copy the configuration to all nodes

Copy the `$HOME/exa_template/` directory to all cluster nodes (the exact path is not relevant, but should be identical on all nodes).

### 4. Create the EXAStorage device files

You can create the EXAStorage device files by executing (on each node):

```console
$ dd if=/dev/zero of=$HOME/exa_template/data/storage/dev.1.data bs=1M count=1 seek=999
$ touch $HOME/exa_template/data/storage/dev.1.meta
```

This will create a sparse file of 1GB (1000 blocks of 1 MB) that holds the data and also a file that holds the metadata for that device. Adjust the size to your needs. 

**NOTE: Alternatively you can partition a block-device (the meta partition needs only 2 MB) and place symlinks (or new device files) named `dev.1.data` and `dev.1.meta` in the same directory.**
 
### 5. Start the cluster

The cluster is started by creating all containers individually and passing each of them its ID from the EXAConf. For `n11` the command would be:

```console
$ docker run --detach --network=host --privileged -v $HOME/exa_template:/exa exasol/docker-db:latest init-sc --node-id 11
```

**NOTE: this example uses the host network stack, i. e. the containers are directly accessing a host interface to connect to each other. There is no need to expose ports in this mode: they are all accessible on the host.**

## Installing custom JDBC drivers

Starting with version 6.0.7-d1, custom JDBC drivers can be added by uploading them into a bucket. The bucket and path for the drivers can be configured in each database section of EXAConf. The default configuration is:

```console
[DB : DB1]
    ...
    # OPTIONAL: JDBC driver configuration
    [[JDBC]]
        BucketFS = bfsdefault
        Bucket = default
        # Directory within the bucket that contains the drivers
        Dir = drivers/jdbc
```

In order for the database to find the driver, you need to upload it into a subdirectory of `drivers/jdbc` of the default bucket (which is automatically created if you don't modify EXAConf). See the section `Installing Oracle drivers` for help on how to upload files to BucketFS.

In addition to the driver file(s), you also have to create and upload a file called `settings.cfg` , that looks like this:

```console
DRIVERNAME=MY_JDBC_DRIVER
JAR=my_jdbc_driver.jar
DRIVERMAIN=com.mydriver.jdbc.Driver
PREFIX=jdbc:mydriver:
FETCHSIZE=100000
INSERTSIZE=-1
```

Change the variables DRIVERNAME, JAR, DRIVERMAIN and PREFIX according to your driver and upload the file (into the **same directory** as the driver itself).

**IMPORTANT: Do not modify the last two lines!**

If you use the default bucket and the default path, you can add multiple JDBC drivers during runtime. The DB will find them without having to restart it (as long as they're located in a subfolder of the default path). Otherwise, a container restart is required. 
 
## Installing Oracle drivers

Starting with version 6.0.7-d1, Oracle drivers can be added by uploading them into a bucket. The bucket and path for the drivers can be configured in each database section of EXAConf. The default configuration is:

```console
[DB : DB1]
    ...
    # OPTIONAL: Oracle driver configuration
    [[ORACLE]]
        BucketFS = bfsdefault
        Bucket = default
        # Directory within the bucket that contains the drivers
        Dir = drivers/oracle
```

In order for the database to find the driver, you have to upload it to `drivers/oracle` of the default bucket (which is automatically created if you don't modify EXAConf).

You can use `curl` for uploading, e. g.:

```
$ curl -v -X PUT -T instantclient-basic-linux.x64-12.1.0.2.0.zip http://w:PASSWORD@10.10.10.11:6583/default/drivers/oracle/instantclient-basic-linux.x64-12.2.0.1.0.zip
```

Replace `PASSWORD` with the `WritePasswd` for the bucket. You can find it in the EXAConf. It's base64 encoded and can be decoded like this:

```
$ awk '/WritePasswd/{ print $3; }' EXAConf | base64 -d
```

**NOTE: The only currently supported driver version is 12.1.0.20. Please download the package `instantclient-basic-linux.x64-12.1.0.2.0.zip` from oracle.com and upload it as described above.**
