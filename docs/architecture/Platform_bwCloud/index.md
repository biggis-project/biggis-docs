!!! note "Responsible person for this section"
    Patrick Wiener

# Platform bwCloud

![](bwcloud_logo.svg)

Within the scope of BigGIS, we build our platform on top of the [bwCloud](https://www.bw-cloud.org/) offering. The Baden-Württemberg Cloud (bwCloud) 
provides virtual machines (servers) for members of science- and research institutions in Baden-Württemberg (e.g. students and 
staff-members) powered by OpenStack's cloud software much like Amazon’s EC2. Building on the openstack-platform the infrastructure is currently operated by four sites 
in Baden-Württemberg: the Universities of Mannheim, Karlsruhe, Ulm and Freiburg.

## Infrastructure
Currently, we run a total of **nine** Virtual Machines (VM), serving different kinds of purposes, that are providing (1) 
a single-node Rancher Testing environment, (2) a multi-node Rancher Cluster environment, and (3) infrastructure supporting services (e.g. private
Docker registry for sensitive images, OpenVPN server to connect to the virtual private cloud).

|        |      m1.xlarge      |                 m1.large                |   m1.medium  |
|--------|:-------------------:|:---------------------------------------:|:------------:|
| OS     |     Ubuntu 16.04    |               Ubuntu 16.04              | Ubuntu 16.04 |
| CPU    |        8 vCPU       |                  4 vCPU                 |    2 vCPU    |
| Memory |         8 GB        |                   8 GB                  |     4 GB     |
| Disk   |        50 GB        |                  50 GB                  |     50 GB    |
| #VM    |          1          |                    7                    |       1      |
| Usage  | Rancher Dev/Testing | Rancher Cluster (6 VM), Docker Registry |    OpenVPN   |


## Container-based Rancher Setup
description tbd.
![](bwcloud_infrastructure.png)