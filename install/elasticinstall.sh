#/usr/local/bin/bash

# Install elasticsearch and configure firewall
/bin/rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch
/usr/bin/cp ./elasticsearch.repo /etc/yum.repos.d/elasticsearch.repo
/usr/bin/yum install -y elasticsearch
/bin/sed -ie "s/#network.host: 192.168.0.1/network.host: 0.0.0.0/" /etc/elasticsearch/elasticsearch.yml
/bin/sed -ie "s/#http.port: 9200/http.port: 9200/" /etc/elasticsearch/elasticsearch.yml
/bin/systemctl daemon-reload
/bin/systemctl enable elasticsearch.service
/bin/systemctl start elasticsearch.service
/bin/firewall-cmd --permanent --zone=public --add-port=9200/tcp
/bin/firewall-cmd --reload
/bin/ln -s /usr/share/elasticsearch ../index/elasticsearch
/bin/ln -s /var/lib/elasticsearch ../index/data
