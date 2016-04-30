## Load-Balancing Web Services with Nginx and Consul

### Introduction
Load-balancing is a technique for distributing workloads across multiple computing resources. In this example, we implement an [Nginx](https://www.nginx.com) load-balancer that distributes HTTP requests across multiple [Python](https://www.python.org) web servers. Availability of the web servers is determined by [Consul](https://www.consul.io). We use [Consul-Template](https://github.com/hashicorp/consul-template) to query Consul and dynamically reconfigure the load-balancer based on changes to availability of the web servers.

### Prerequisites
Download and install [Vagrant](https://www.vagrantup.com/downloads.html) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads). It might also be helpful to familiarize yourself with some basic Vagrant commands like `vagrant up` and `vagrant destroy`.

### Configuration
Run the following command from inside this directory to configure the virtual machines that make up this example.

```bash
vagrant up
```

### Usage
You can send HTTP requests to the load-balancer by curling localhost.

```bash
for i in `seq 1 10`; do
    curl http://localhost:8000
    echo
done
```

You can simulate failover by destroying one of the web servers.

```bash
vagrant destroy app1
```

### Destruction
Run the following command from inside this directory to destroy the virtual machines that make up this example.

```bash
vagrant destroy
```
