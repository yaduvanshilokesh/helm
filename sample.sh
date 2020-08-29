echo "[Creating devops user]"
if id "devops" &>/dev/null; then
        echo "User devops already exists"
else
        sudo su -c "useradd devops -s /bin/bash -m -U"
        echo "User devops created successfully"
fi
echo "[Setting password for devops user]"
sudo su -c "echo 'devops:devops' | chpasswd"
echo "[Adding devops user to sudo group]"
sudo su -c "echo '%devops ALL=(ALL:ALL) NOPASSWD:ALL' | tee /etc/sudoers.d/devops > /dev/null"
echo "[Enable Firewall]"
sudo ufw enable
echo "[Open Port 22]"
sudo ufw allow 22
echo "[Open Port 80]"
sudo ufw allow 80
echo "[Open Port 443]"
sudo ufw allow 443
echo "[Open Port 27017]"
sudo ufw allow 27017
echo "[Create dev group]"
if getent group "dev" &>/dev/null; then
       echo "Group dev already exists"
else
        sudo su -c "groupadd dev"
        echo "[Group dev created successfully ]"
fi
echo "[Creating '/opt/zyla/sample-web-app' directory]"
sudo mkdir -p "/opt/zyla/sample-web-app"
echo "[Provide access to '/opt/zyla/sample-web-app' dir for dev group]"
sudo chown -R :dev '/opt/zyla/sample-web-app'
echo "[Provide access to /var/log/*.log for dev group]"
sudo chown :dev /var/log/*.log
sudo chmod g+r /var/log/*.log
echo "[Rotate logs]"
sudo su -c "cat  > /etc/logrotate.d/sample <<EOF
 /var/log/*.log{ 
	    	rotate 14 
		daily 
		compress 
		dateext
		dateformat -%Y%m%d
	} 
EOF"

