#! /bin/bash -f
#install docker (for building images)
sudo snap install docker
sudo snap install microk8s --classic                                                                                                         
sudo snap install kubectl --classic
echo "source <(kubectl completion bash)" >> ~/.bashrc
sudo microk8s.start
sleep 2
sudo microk8s.enable dns
sleep 2
sudo microk8s.enable istio
sudo chown -R $USER $HOME/.kube
sudo microk8s.kubectl config view --raw > $HOME/.kube/config
sudo chown $USER $HOME/.kube/config
#wait before enabling metrics server
sleep 2
sudo microk8s.enable metrics-server
sudo usermod -a -G microk8s $USER
# allow current user to access docker socket
sudo setfacl -m user:${USER}:rw /var/run/docker.sock
# allow istio pods to communicate
sudo iptables -P FORWARD ACCEPT
