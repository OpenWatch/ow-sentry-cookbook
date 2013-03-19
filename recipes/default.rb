#
# Cookbook Name:: ow_sentry
# Recipe:: default
#
# Copyright 2013, OpenWatch FPC
#
# Licensed under AGPLv3
#

secrets = Chef::EncryptedDataBagItem.load(node['ow_etherpad']['secret_databag_name'] , node['ow_etherpad']['secret_databag_item_name'])

node.set['sentry']['key'] = "asdf"

node.set['sentry']['superusers'] = [{
                 "username" => "a",
                 "password" => "a",
                 "email" => "a@a.com"}]


include_recipe "sentry::instance"

