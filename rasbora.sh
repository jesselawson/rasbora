#!/bin/bash

# Get the logged in user
CURRENT_USER=`whoami`

cat << "EOF"

                     ___            __________
                    /   \          /          \
                 __/_/_/_\________/ / / /  /   \
          ,,----'                 ------  / /   \           _
        ,/   ) ) ) ) ) ) ) ) ) ) ) ) ) ) )\/ /  /        ,/' \
    ./''  ,\  ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )\ /       /'  /  \
 ./''  O , ,\) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )------' / / / /
 (____ , , , ,|) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) )----- /
 \.  \ , , , | ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ) ----- \
   `\.   ___/ ) )_______  ) ) ) ) ) ) ) ) ) ) ) ------. \ \ \ \
      ``\..) ) ) )______\) ) ) ) ) ) ) ) ) ) /         \.  \  /
           `\..    _____/ ) ) ) ) ) ) ) ) /--__          `\._/
               ``\________________------'''\   \
                   \ \ \/           \  \  \ \  /
                    \__/             \________/ 
by Jesse Lawson                          .-'''-.                       
https://lawsonry.com/rasbora            '   _    \                     
                             /|       /   /` '.   \                    
                             ||      .   |     \  '                    
.-,.--.                      ||      |   '      |  '.-,.--.            
|  .-. |    __               ||  __  \    \     / / |  .-. |    __     
| |  | | .:--.'.         _   ||/'__ '.`.   ` ..' /  | |  | | .:--.'.   
| |  | |/ |   \ |      .' |  |:/`  '. '  '-...-'`   | |  | |/ |   \ |  
| |  '- `" __ | |     .   | /||     | |             | |  '- `" __ | |  
| |      .'.''| |   .'.'| |//||\    / '             | |      .'.''| |  
| |     / /   | |_.'.'.-'  / |/\'..' /              | |     / /   | |_ 
|_|     \ \._,\ '/.'   \_.'  '  `'-'`               |_|     \ \._,\ '/ 
         `--'  `"                                            `--'  `"  
EOF

echo -e "Hi, $CURRENT_USER! Welcome to Rasbora! The Rails app server in a box.\n"

echo -e "* * ** *** ***** ******** ************* ******** ***** *** ** * *\n"

read -n 1 -s -r -p "I'm assuming that you're running this on the box that you want to become the Ruby app server in a box. If not, please exit this script right away! Otherwise, press any key to continue."

echo -e "\n\n"

read -n 1 -s -r -p "I'm also assuming that you're running this a user with sudo rights who will be the deployer user. All apps will be deployed by/from/via this user. If not, bail out and try again! Otherwise, press any key to continue."

echo -e "\n\n"

read -p "Now I'll need the FQDN of your first app.\nExample: my-todo-app.lawsonry.com\nPlease do not use no subdomain or something like www. Instead, using something like 'myapp'.\n\nYour app: " APP_NAME

APP_NAME=${APP_NAME:-testapp}
SHORT_APP_NAME=$APP_NAME | cut -d"." -f1
SHORT_APP_NAME_UPCASE=$SHORT_APP_NAME | tr [a-z] [A-Z]

echo -e "\n\n"

echo -e "Awesome! Let's get going. This will take a few minutes."

echo "Updating system... "
apt-get update -y &>> /dev/null
echo -e "Done!\n"

echo "Upgrading system... "
apt-get upgrade -y &>> /dev/null
echo -e "Done!\n"

echo "Installing rbenv prerequisites... "
sudo apt-get install git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev postgresql postgresql-contrib libpq-dev rake -y &>> /dev/null
echo -e "Done!\n"

# TODO: Give user the option to configure different types of databases. Like this:
# Which database do you want to use?
# [1] (Default) PostgreSQL
# [2] MariaDB
# [3] MongoDB
# Please enter a number from the list above (or hit ENTER for default [1]):

echo "Installing rbenv... "
git clone git://github.com/sstephenson/rbenv.git .rbenv &>> /dev/null
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build &>> /dev/null
echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
echo -e "Done!\n"

echo "Installing Ruby via rbenv... "
RUBY_VERSION=$(`rbenv install -l | sed -n '/^[[:space:]]*[0-9]\{1,\}\.[0-9]\{1,\}\.[0-9]\{1,\}[[:space:]]*$/ h;${g;p;}'`)
echo "Found v${RUBY_VERSION}... "
rbenv install -v $RUBY_VERSION &>> /dev/null
rbenv global $RUBY_VERSION
echo "gem: --no-document" > ~/.gemrc &>> /dev/null
echo -e "Done!\n"

echo "Installing bundler... "
gem install bundler &>> /dev/null
echo -e "Done!\n"

echo "Installing Rails... "
gem install rails &>> /dev/null
rbenv rehash
echo -e "Done!\n"

echo "Installing all dependencies for Rails... "
bundle install
echo -e "Done!\n"

echo "Installing Node for any those Rails features that require it... "
add-apt-repository ppa:chris-lea/node.js &>> /dev/null
apt-get update -y &>> /dev/null
apt-get install nodejs -y &>> /dev/null
echo -e "Done!\n"

# TODO: Abstract this away from the scaffolding of the infrastructure. Users should be 
# able to create a new app without having to reinstall the infrastructure.
echo "Creating Rails application... "
rails new $SHORT_APP_NAME -d postgresql &>> /dev/null
echo -e "Done!\n"

echo "Creating database for $APP_NAME... "
cd $SHORT_APP_NAME
read -p "What username do you want to use for this app's database (Default [Enter]: ${SHORT_APP_NAME})> " DBUSER
echo -e "\n"
read -sp "What do you want for $DBUSER's password? " DBPASS
echo -e "\n"
psql -U postgres -c "CREATE USER $DBUSER WITH PASSWORD '$DBPASS';" &>> /dev/null
# TODO: Test successful creation of user
echo -e "\nFinished creating database w/ credentials!\n"

echo "Configuring Rails app database settings... "
cd ~/${SHORT_APP_NAME}

# Replace the contents of the config/database.yml file
# TODO: Replace contents based on type of database requested
# Postgresql has a specific type of setting, for which I've used the default values of a dummy rails app
# MySQL (and MariaDB) have different settings, like adding the socket: variable. 
# The next iteration needs to account for this. 

cat << EOF > config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  # For details on connection pooling, see Rails configuration guide
  # http://guides.rubyonrails.org/configuring.html#database-pooling
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV.fetch("${SHORT_APP_NAME_UPCASE}_DBUSER") %>
  password: <%= ENV.fetch("${SHORT_APP_NAME_UPCASE}_DBPASS") %>

development:
  <<: *default
  database: ${SHORT_APP_NAME}_development

test:
  <<: *default
  database: ${SHORT_APP_NAME}_test

production:
  <<: *default
  database: ${SHORT_APP_NAME}_production
EOF

echo -e "Done!\n"

# See: https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-puma-and-nginx-on-ubuntu-14-04#prerequisites

# Install rbenv-vars
echo "Installing rbenv-vars for environment variables... "
cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/rbenv-vars.git
cd ~/${SHORT_APP_NAME}
echo -e "\nGenerating secret... "
RAKE_SECRET=`rake secret`
echo -e "\nPopulating .rbenv-vars... "
cat << EOF > ~/${SHORT_APP_NAME}/.rbenv-vars
SECRET_KEY_BASE=${RAKE_SECRET}
${SHORT_APP_NAME}_DBUSER=${DBUSER}
${SHORT_APP_NAME}_DBPASS=${DBPASS}
EOF
echo -e "Done!\nThe following environment variables have been added: \n"
rbenv vars

echo "Installing puma... "
gem install puma 
echo "Starting puma... "

# start puma 
puma

echo -e "Done!\n"

echo "Installing Nginx... "
apt-get install nginx -y &>> /dev/null
echo -e "Done!\n"

echo "Configuring Nginx... "

# CRITICAL TODO: Installing puma via the Gemfile will cause the unix socket to be in a subfolder
# of the app. We need to move the socket location to a standard directory. 

cat << EOF > /etc/nginx/sites-available/$APP_NAME
upstream app {
    
    server unix:/home/$CURRENT_USER/$SHORT_APP_NAME/shared/sockets/puma.sock fail_timeout=0;
}

server {
    listen 80;
    server_name localhost;

    root /home/$CURRENT_USER/$SHORT_APP_NAME/public;

    try_files $uri/index.html $uri @app;

    location @events {
        proxy_pass http://events;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}
EOF

# This is still under construction. Use at your own risk!

