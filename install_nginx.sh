#!/bin/bash
apt update -y
apt install nginx -y
systemctl enable nginx
systemctl start nginx
echo "<h1>Nginx Installed on Ubuntu Server</h1>" > /var/www/html/index.nginx-debian.html
