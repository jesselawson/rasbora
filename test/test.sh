#!/bin/bash

echo "Test: Should add short_app_name to database.yml"

SHORT_APP_NAME=my-todo-app
SHORT_APP_NAME_UPCASE=`echo $SHORT_APP_NAME | tr [a-z] [A-Z]`

cat << EOF > test.yml
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