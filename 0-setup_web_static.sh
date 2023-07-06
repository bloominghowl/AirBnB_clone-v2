#!/usr/bin/env bash
# Sets up a web server for deployment of web_static.

if ! command -v nginx &> /dev/null; then
    apt-get -y update
    apt-get -y install nginx
fi

mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/

echo "<html>
  <head>
  </head>
  <body>
    <p>Test HTML file for Nginx</p>
  </body>
</html>" > /data/web_static/releases/test/index.html

if [ -L /data/web_static/current ]; then
    rm /data/web_static/current
fi
ln -sf /data/web_static/releases/test/ /data/web_static/current

chown -R ubuntu:ubuntu /data/

config_file="/etc/nginx/sites-available/default"
sed -i '/^\tserver_name localhost;/a \\n\tlocation /hbnb_static {\n\t\talias /data/web_static/current/;\n\t}\n' $config_file

service nginx restart
