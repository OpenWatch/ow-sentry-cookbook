#
# Cookbook Name:: ow_sentry
# Recipe:: default
#
# Copyright 2013, OpenWatch FPC
#
# Licensed under AGPLv3
#

users_bag = Chef::EncryptedDataBagItem.load(node['ow_sentry']['secret_databag_name'] , node['ow_sentry']['users_databag_item_name'])
secrets_bag = Chef::EncryptedDataBagItem.load(node['ow_sentry']['secret_databag_name'] , node['ow_sentry']['secrets_databag_item_name'])
users = users_bag["users"]

db_user = node['ow_sentry']['db_user']
db_port = node['ow_sentry']['db_port']
db_host = node['ow_sentry']['db_host']
db_pass = node['postgresql']['password']['postgres']
db_name = node['ow_sentry']['db_name']


# Setup postgresql database
postgresql_database db_name do
  connection ({
        :host => db_host, 
        :port => db_port, 
        :username => db_user, 
        :password => db_pass
  })
  action :create
end

node.set['sentry']['superusers'] = users

# Database settings
node.set["sentry"]["settings"]["databases"] = {
  "default" => {
    "ENGINE" => "django.db.backends.postgresql_psycopg2",
    "NAME" => "#{db_name}",
    "USER" => "#{db_user}",
    "PASSWORD" => "#{db_pass}",
    "HOST" => "#{db_host}",
    "PORT" => "#{db_port}"
  }}

domain = node['ow_sentry']['domain']

node.set["sentry"]["settings"]["prefix"] = "https://#{domain}"
node.set["sentry"]["settings"]["private_key"] = secrets_bag["private_key"]

web_settings = {
  "host" => "127.0.0.1",
  "port" => 9000,
  "options" => {
    "workers" => 3,
    #"worker_class": "gevent"
  }}
node.set["sentry"]["settings"]["web"] = web_settings
node.set["sentry"]["web"] = web_settings # Not sure why he sets it in two places

include_recipe "sentry::instance"

