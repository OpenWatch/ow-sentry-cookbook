# Sentry
default['ow_sentry']['secret_databag_name'] = "sentry"
default['ow_sentry']['secret_databag_item_name'] = "users"
default['ow_sentry']['db_host'] = "127.0.0.1"
default['ow_sentry']['db_user'] = "postgres"
default['ow_sentry']['db_port'] = 5432
default['ow_sentry']['db_name'] = 'sentry'
default['ow_python']['log_dir'] = "/var/log/ow/"

#Nginx
default['ow_sentry']['http_listen_port'] = 80
default['ow_sentry']['https_listen_port'] = 443
default['ow_sentry']['domain'] = 'sentry.openwatch.net'
default['ow_sentry']['access_log'] = 'ow_sentry_nginx_access'
default['ow_sentry']['error_log'] = 'ow_sentry_nginx_error'