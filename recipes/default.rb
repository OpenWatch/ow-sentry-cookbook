#
# Cookbook Name:: ow_sentry
# Recipe:: default
#
# Copyright 2013, OpenWatch FPC
#
# Licensed under AGPLv3
#

ssl_dir = node['ow_webserver']['ssl_dir'] 
ssl_cert = node['ow_webserver']['ssl_cert']
ssl_key = node['ow_webserver']['ssl_key']

# Make log dir
directory node['ow_sentry']['log_dir'] do
  owner node['nginx']['user']
  group node['nginx']['group']
  recursive true
  action :create
end

# Nginx config file
template node['nginx']['dir'] + "/sites-enabled/ow_sentry.nginx" do
    source "ow_sentry.nginx.erb"
    owner node['nginx']['user']
    group node['nginx']['group']
    variables({
    :http_listen_port => node['ow_sentry']['http_listen_port'],
    :https_listen_port => node['ow_sentry']['https_listen_port'],
    :domain => node['ow_sentry']['domain'],
    :internal_port => node['ow_sentry']['internal_port'],
    :ssl_cert => ssl_dir + ssl_cert,
    :ssl_key => ssl_dir + ssl_key,
    :app_root => node['ow_sentry']['app_root'],
    :access_log => node['ow_sentry']['log_dir'] + node['ow_sentry']['access_log'],
    :error_log => node['ow_sentry']['log_dir'] + node['ow_sentry']['error_log'],
    })
    notifies :restart, "service[nginx]"
    action :create
end


users_bag = Chef::EncryptedDataBagItem.load(node['ow_sentry']['secret_databag_name'] , node['ow_sentry']['secret_databag_item_name'])
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

# node.save

include_recipe "sentry::instance"

