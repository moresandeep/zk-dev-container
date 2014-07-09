# running

```
# run the container selecting a hostname, and exposing exhibitor on 8080 and zk on 2181
ZK=$(sudo docker run -d -e HOSTNAME=192.168.1.1 -p 8080:8080 -p 2181:2181 sclasen/zk-dev-container)

# the container runs pipework --wait and waits on its ntework interface being ready
# this is neeed so other containers can talk to this one
pipework br1 $ZK 192.168.1.1/24

#check zk is up
sudo docker logs $ZK

echo ruok | nc localhost 2181
imok

```
