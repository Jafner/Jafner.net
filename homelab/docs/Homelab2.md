# What is Homelab2?
The Homelab2 project's purpose is to transition from a compute resource model built around individual "snowflake" servers to a model built around commodified compute resources. Homelab2 will involve a complete rebuild of the underlying infrastructure, down to bare metal. 

## Why?
This project is motivated on one hand by the practical improvements to availability, portability, and efficiency, and on the other hand by the educational value of learning these enterprise technologies by working with them.

The practical benefits of making the [pet-to-cattle paradigm shift](http://cloudscaling.com/blog/cloud-computing/the-history-of-pets-vs-cattle/) are myriad but nuanced. Here they are summarized:

- Availability. By abstracting workloads from the hardware they run on, high-availability ([HA](https://en.wikipedia.org/wiki/High_availability)) can be achieved for stateless applications, and downtime can be reduced for stateful applications. 
- Portability. By treating nodes as simple piles of resources, a configuration can be picked up and plopped onto another pile of resources and run. This allows for easier integration with [public cloud](https://en.wikipedia.org/wiki/Cloud_computing) and multi-cloud resources.
- Efficiency. By implementing the same technologies used by [hyper-scale](https://en.wikipedia.org/wiki/Hyperscale_computing) cloud providers, the system can scale dynamically with load for many applications. 

## How?
The first stage is research. There are several prerequisite research steps before any infrastructural change can begin. 
So let's break down what we need to learn before we can break ground:
- Take inventory of currently provided applications. 
- Distinguish between Stateless and Stateful applications.
- Will use [Kubernetes](https://github.com/kubernetes/kubernetes) to manage nodes and workloads.
- Will need to determine whether to use a "General Purpose OS" like [Debian](https://www.debian.org/), or a "Container Optimized OS" like [Talos OS](https://www.siderolabs.com/platform/talos-os-for-kubernetes/).
- Will likely need to re-architect NAS. Switch to [TrueNAS Scale](https://www.truenas.com/truenas-scale/) and implement Minio S3 for object storage.


# References

- https://thenewstack.io/a-guide-to-linux-operating-systems-for-kubernetes/