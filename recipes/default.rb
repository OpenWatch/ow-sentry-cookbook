#
# Cookbook Name:: ow_sentry
# Recipe:: default
#
# Copyright 2013, OpenWatch FPC
#
# Licensed under AGPLv3
#

#secrets = Chef::EncryptedDataBagItem.load(node['ow_sentry']['secret_databag_name'] , node['ow_sentry']['secret_databag_item_name'])


include_recipe "sentry::instance"

