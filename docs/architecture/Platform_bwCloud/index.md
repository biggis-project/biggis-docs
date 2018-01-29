!!! note "Responsible person for this section"
    Patrick Wiener

# bwCloud

![](bwcloud_logo.svg)

Within the scope of BigGIS, we build our platform on top of the [bwCloud](https://www.bw-cloud.org/) offering. The Baden-Württemberg Cloud (bwCloud) 
provides virtual machines (servers) for members of science- and research institutions in Baden-Württemberg (e.g. students and 
staff-members) much like Amazon’s EC2. Building on the openstack-platform the infrastructure is currently operated by four sites 
in Baden-Württemberg: the Universities of Mannheim, Karlsruhe, Ulm and Freiburg.

## Infrastructure
Currently, we run a total of **nine** Virtual Machines (VM), serving different kinds of purposes, that are providing (1) 
a single-node Rancher Testing environment, (2) a multi-node Rancher Cluster environment, and (3) infrastructure supporting services (e.g. private
Docker registry for sensitive images, OpenVPN server to connect to the virtual private cloud).

|        |      m1.xlarge      |                         m1.large                        |   m1.medium  |
|--------|:-------------------:|:-------------------------------------------------------:|:------------:|
| OS     |     Ubuntu 16.04    |                       Ubuntu 16.04                      | Ubuntu 16.04 |
| CPU    |        8 vCPU       |                          4 vCPU                         |    2 vCPU    |
| Memory |         8 GB        |                           8 GB                          |     4 GB     |
| Disk   |        50 GB        |                          50 GB                          |     50 GB    |
| #VM    |          1          |                            7                            |       1      |
| Usage  | Rancher Dev/Testing | Rancher Server, Rancher Cluster (5 VM), Docker Registry |    OpenVPN   |

Rancher is deployed as a set of Docker containers. Running Rancher involves launching at least two containers. One container as the management **server** and another container on a node as an **agent**.

Whilte the server runs on a single VM, we set up a single node agent for development and testing environment as well as a five node cluster environment to run the BigGIS components in a distributed manner (see figure below). Both, the dev/testing as well as the cluster environment make use of a the network file system (NFS) in order to overcome the problem of strictly coupeling a service to a node. While this is only mandatory in the cluster environment, it makes sense to setup the dev/testing environment as an exact clone to have the same workflows within Rancher.

![](bwcloud_infrastructure.png)
> **Figure:**
> Container-based Rancher Setup in bwCloud.