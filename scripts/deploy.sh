#!/usr/bin/env bash


if [[ $2 -eq 1 ]]
then
    SERVER=52.66.45.141
    KEY="butterjam.pem"
else
    SERVER=3.110.148.251
    KEY="ubuntuking.pem"
fi


echo "Making project directory"

timeout 100 ssh -i ~/$KEY ubuntu@$SERVER "mkdir -p /var/www/html/$SERVER"

echo "Successfully created project directory"

echo "Copying files to remote server"

timeout 100 scp -i ~/$KEY -r build/* ubuntu@$SERVER:/var/www/html/$SERVER

echo "Copyed files to remote server"

echo "Configuring nginx server"

timeout 200 ssh -t -i ~/$KEY ubuntu@$SERVER <<EOF
sudo touch /etc/nginx/sites-available/$SERVER
sudo touch /var/log/nginx/$SERVER.access.log
sudo touch /var/log/nginx/$SERVER.error.log

sudo tee -a /etc/nginx/sites-available/$SERVER <<'eof'
access_log      /var/log/nginx/$SERVER.access.log;
error_log       /var/log/nginx/$SERVER.access.error.log;

server {
	listen			80;
	server_name		$SERVER;
	root			/var/www/html/$SERVER;
	index			index.html index.htm;
    location / {
		try_files \$uri /index.html = 404;
		}
}

eof

sudo ln -s /etc/nginx/sites-available/$SERVER /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
EOF

echo "Successfully configured nginx server"
echo "Successfully deployed to $SERVER"
