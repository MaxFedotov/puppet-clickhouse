# @summary
#   Private class for setting default Clickhouse parameters.
#
# @api private
#
class clickhouse::params {

# Repository
  $manage_repo = true

# Server package
  $manage_package          = true
  $package_ensure          = 'present'
  $package_install_options = []
  $package_name            = 'clickhouse-server'

# Client package
  $client_manage_package          = true
  $client_package_ensure          = 'present'
  $client_package_install_options = []
  $client_package_name            = 'clickhouse-client'

# Configuration
  $manage_config         = true
  $config_dir            = '/etc/clickhouse-server/conf.d'
  $users_dir             = '/etc/clickhouse-server/users.d'
  $dict_dir              = '/etc/clickhouse-server/dict'
  $clickhouse_user       = 'clickhouse'
  $clickhouse_group      = 'clickhouse'
  $clickhouse_datadir    = '/var/lib/clickhouse/'
  $clickhouse_tmpdir     = '/var/lib/clickhouse/tmp/'
  $default_options       = {
                            'listen_host'            => '::',
                            'dictionaries_config'    => "${dict_dir}/*.xml",
                            'max_table_size_to_drop' => 0,
                            'path'                   => $clickhouse_datadir,
                            'tmp_path'               => $clickhouse_tmpdir,
  }
  $keep_default_users    = true
  $config_file           = 'config.xml'
  $profiles_file         = 'profiles.xml'
  $quotas_file           = 'quotas.xml'
  $macros_file           = 'macros.xml'
  $zookeeper_config_file = 'zookeeper.xml'
  $remote_servers_file   = 'remote_servers.xml'
  $dict_source_folder    = "puppet:///modules/${module_name}"
  $install_client        = true

# Service
  $service_name    = 'clickhouse-server'
  $service_ensure  = 'running'
  $service_enabled = true
  $manage_service  = true
  $restart         = false

}
