#! /bin/bash

# Database
until apt-get remove -y unattended-upgrades; do sleep 5; done

export DEBIAN_FRONTEND=noninteractive

echo "mysql-apt-config mysql-apt-config/repo-codename select bionic" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/repo-distro select ubuntu" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-preview select Disabled" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-product select Ok" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-server select mysql-5.7" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/select-tools select Enabled" | debconf-set-selections
echo "mysql-apt-config mysql-apt-config/unsupported-platform select ubuntu bionic" | debconf-set-selections
echo "mysql-apt-config/enable-repo select mysql-5.7-dmr" | debconf-set-selections

wget https://dev.mysql.com/get/mysql-apt-config_0.8.22-1_all.deb
dpkg --install mysql-apt-config_0.8.22-1_all.deb

apt update
apt install -y -f mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7*
until echo "show databases;" | mysql; do sleep 5; done
cat << EOF | mysql
create database plantshop;
use plantshop;

drop table items;
create table items (
  id int not null auto_increment,
  name varchar(255) not null,
  description varchar(255) not null,
  price int not null,
  primary key (id)
);

insert into items (name, description, price) values ("Strawberry", "A strawberry plant.", 5);
insert into items (name, description, price) values ("Raphidophora", "Also called monstera minima.", 25);
insert into items (name, description, price) values ("Aloe Vera", "Produces a medicinal gel.", 9);
insert into items (name, description, price) values ("Watermelon seeds", "A packet of watermelon seeds.", 1);
insert into items (name, description, price) values ("Iresine", "Also called bloodleaf due to its red leaves.", 9);
insert into items (name, description, price) values ("String of Pearls", "A small succulent plant.", 5);

create user 'plantshop' identified with mysql_native_password by '6qNaYDdq3pBc34';
grant select on plantshop.items to plantshop;
EOF

# API
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
apt update
apt install -y nodejs=18.3.0-deb-1nodesource1

cd /opt
rm -rf ctaws-plant-shop
git clone https://github.com/ACloudGuru/ctaws-plant-shop.git

cd /opt/ctaws-plant-shop/api
npm install
cat << EOF > /etc/systemd/system/ctaws-plant-shop-api.service
[Service]
WorkingDirectory=/opt/ctaws-plant-shop/api
ExecStart=node server.js
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=ctaws-plant-shop-api
User=plantshop
Group=plantshop
Environment=DB_HOST=127.0.0.1
Environment=DB_USER=plantshop
Environment=DB_PASS=6qNaYDdq3pBc34

[Install]
WantedBy=multi-user.target
EOF

useradd plantshop
chown -R plantshop:plantshop /opt/ctaws-plant-shop

systemctl daemon-reload
systemctl enable ctaws-plant-shop-api
systemctl restart ctaws-plant-shop-api

# Frontend
npm install -g serve

cat << EOF > /etc/systemd/system/ctaws-plant-shop-frontend.service
[Service]
WorkingDirectory=/opt/ctaws-plant-shop/frontend
ExecStart=serve -s build
Restart=always
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=ctaws-plant-shop-frontend
User=plantshop
Group=plantshop
Environment=PORT=8081

[Install]
WantedBy=multi-user.target
EOF

cd /opt/ctaws-plant-shop/frontend
rm package-lock.json
npm install
npm run build
chown -R plantshop:plantshop /opt/ctaws-plant-shop
systemctl daemon-reload
systemctl enable ctaws-plant-shop-frontend
systemctl restart ctaws-plant-shop-frontend
