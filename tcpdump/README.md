1. Capture 10,000 raw packet
tcpdump -i any -nn -c 10000

2. 
```
tcpdump -n -i ens3 -w /home/lms.pcap
tcpdump -n -i ens3 -w /home/lms.pcap -W 300 -C 100
nohup tcpdump -n -i ens3 -w /tmp/lms.pcap -W 300 -C 100 &
```

3. 
```
tcpdump -nn -i eth0 host 10.204.57.136 and tcp port 2775 -w smpp_new.pcap
tcpdump -i any port 5060 -w /home/64.69.pcap -W 300 -C 100
```
