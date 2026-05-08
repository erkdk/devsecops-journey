# [dockerize-dataDash](https://github.com/erkdk/dockerize-dataDash)

![Diagram](https://github.com/erkdk/devops-journey/blob/main/06-docker/dockerize-dataDash/dockerize-dataDash-diagram.png)

A fully Dockerized, full-stack CRUD application ([dataDash](https://github.com/erkdk/dataDash/tree/feature/initial-setup)) deployed on a **Docker Swarm cluster** with:

-  **React frontend**
-  **Node.js/Express backend**
-  **MongoDB Atlas database**
-  **Private Harbor registry**
-  **Portainer UI for cluster management**
-  **Vagrant-provisioned virtual machines**

This project demonstrates real-world DevOps practices by deploying containerized services in a Swarm cluster environment.

---

### [Demo video](https://youtu.be/uibuKgP5ROw?si=wK-3Ldf9AOJigrzj)

###  Swarm Topology

- 2 × Manager Nodes
- 3 × Worker Nodes
- VMs created using Vagrant + VirtualBox
- Portainer deployed on manager node for visual control
- Images pulled from Harbor (private registry) from separate VM

---

### Services
- `client` – React app
- `server` – Node.js API with `express`, connects to MongoDB Atlas
- Both services run in **replicated mode** and are attached to a **Docker overlay network**
- `portainer`– Web-based Docker Swarm manager running on a manager node (Port :9443)


###  DevOps Stack
| Component    | Role                            |
|--------------|----------------------------------|
| Docker Swarm | Container orchestration          |
| Harbor       | Private image registry           |
| Portainer    | Swarm dashboard & stack manager  |
| VirtualBox + Vagrant    | Local VMs provisioning            |
| MongoDB Atlas| Cloud-hosted NoSQL DB            |

---
## Infrastructure Setup & Commands
### [Vagrantfile to create Harbor VM](https://github.com/erkdk/devops-journey/blob/main/06-docker/dockerize-dataDash/Vagrantfile-harbor)
### [Commands used on Harbor VM](https://raw.githubusercontent.com/erkdk/devops-journey/refs/heads/main/06-docker/dockerize-dataDash/Commands-used-on-Harbor-VM)
### [Vagrantfile to create the multiple manager nodes and worker nodes](https://github.com/erkdk/devops-journey/blob/main/06-docker/dockerize-dataDash/Vagrantfile)
### [Commands used on Manager nodes](https://raw.githubusercontent.com/erkdk/devops-journey/refs/heads/main/06-docker/dockerize-dataDash/commands-used-on-manager-nodes)
### [Commands used on Worker nodes](https://raw.githubusercontent.com/erkdk/devops-journey/refs/heads/main/06-docker/dockerize-dataDash/commands-used-on-worker-nodes)
