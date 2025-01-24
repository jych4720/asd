# Subnet and NAT Configuration

You can work individually or in groups of two.
The exercise requires access to a Linux server where you have sudo access.

In this exercise, you are asked to work as a network engineer and configure the networking infrastructure of your company.
The topology of the infrastructure can be seen in the next Figure.

![Network Topology](img/architecture.jpeg)

The topology consists of three different routers (R1-R3) and four hosts (h1-h4).
The Figure indicates in light grey the different subnets and their size.
It also indicates the router interfaces and how they are connected to each other.
All hosts include a single interface that it is named `hN-eth0`, where N is the host number.

## Step 0: Setting up the testbed

For debugging and development purposes, the networking team of the company has created a virtual clone of the topology using [network namespaces](https://lwn.net/Articles/580893/) and [Linux bridges](https://wiki.linuxfoundation.org/networking/bridge).
The specifics of how this virtual infrastructure is created goes beyond the scope of this exercise.

To setup the topology, first you need to install certain packages:
```
sudo apt-get install net-tools bridge-utils
```

and then from within the `scripts` directory run:

```
sudo ./testbed-setup.sh
```

To be able to easily switch across different namespaces, you need to run `source alias.sh` in every terminal tab you work.
This way, by prefixing the host name, e.g. `h1`, or the router name, e.g. `r1`, before the command you want to execute, you indicate that you want to run this command inside a certain machine.

For example, you can inspect the interfaces of router 1 as follows:
```
r1 ifconfig
```
Do you see the three interfaces `r1-eth0`, `r1-eth1`, and `r1-eth2`?

You can easily destroy the topology as follows:
```
sudo ./testbed-teardown.sh
```

## Step 1: Subnet Configuration
The provided scripts only create the above topology but do not configure the host and router interfaces.
As a first task, configure all the host and router interfaces given the IP subnets provided in the figure.
To do so, you will use the [ip](https://linux.die.net/man/8/ip) command.

After you are done, can you ping `h2` from `h1`?
```
h1 ping <h2 IP>
```

How about `h1` from `h2`?
```
h2 ping <h1 IP>
```

## Step 2: NAT configuration
As you can see in the topology figure, hosts 3 and 4 are in a private network (the `10.0.0.0/24` is a private subnet).
In this case, `r3` needs to perform NAT for those servers.
Your task is to configure `r3` to do so.
To do so, you will use the [iptables](https://linux.die.net/man/8/iptables) utility.
`iptables` is a widely used Linux tool that can filter traffic and configure NAT on different network interfaces.

After configuring `r3` try ping-ing `h1` from `h3`
```
h3 ping <h1 IP address>
```

While doing so, capture the traffic going through the two interfaces using [tcpdump](https://www.tcpdump.org/manpages/tcpdump.1.html).

```
h3 tcpdump -i h3-eth0 -w h3.pcap
```
and
```
h1 tcpdump -i h1-eth0 -w h1.pcap
```

The above commands will capture all packets going through the two interfaces and create two pcap files (h1.pcap and h3.pcap).
Load these pcap files in Wireshark and inspect the traffic.
What is the IP address that `h1` sees as the source address of the incoming `ICMP` packets?

Can you do the opposite, i.e. ping `h3` from `h1`? Explain your answer.

## Deliverables
For convenience, you should extend the provided `sol.sh` file for your solution.
Eventually, you should be able to configure the entire network with
```
sudo ./sol.sh
```

At any point in time, if you make a mistake, you can easily destroy and recreate the topology, using the provided scripts.

You should create a zip file that includes the `sol.sh` script with the full configuration for all interfaces and a short report in PDF that i) describes your logic, ii) includes screenshots from the two steps, iii) answers the above questions.
