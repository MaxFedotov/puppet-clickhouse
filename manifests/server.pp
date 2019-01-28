# @summary
#   Installs and configures Clickhouse server.
#
# @example Install Clickhouse Server.
#   class { 'clickhouse::server':
#     package_name   => 'clickhouse-server',
#     package_ensure => '19.1.6-1.el7',
#   }
#
# @param manage_repo
#   Whether to install Clickhouse repository. Defaults to 'true'.
# @param package_name
#   Name of Clickhouse Server package to install. Defaults to 'clickhouse-server'.
# @param package_ensure
#   Whether the Clickhouse Server package should be present, absent or specific version. Valid values are 'present', 'absent' or 'x.y.z'. Defaults to 'present'.
# @param manage_package
#   Whether to manage Clickhouse Server package. Defaults to 'true'.
# @param package_install_options
#   Array of install options for managed package resources. Appropriate options are passed to package manager.
# @param manage_config
#   Whether the Clickhouse Server configurations files should be managd. Defaults to 'true'.
# @param config_dir
#   Directory where Clickhouse Server configuration files will be stored. Defaults to '/etc/clickhouse-server/conf.d'.
# @param users_dir
#   Directory where Clickhouse Server user configuration files will be stored. Defaults to '/etc/clickhouse-server/users.d'.
# @param dict_dir
#   Directory where Clickhouse Server dictionaries will be stored. Defaults to '/etc/clickhouse-server/dict'.
# @param clickhouse_datadir
#   Directory where Clickhouse Server database files will be stored. Defaults to '/var/lib/clickhouse/'.
# @param clickhouse_tmpdir
#   Directory where Clickhouse Server tmp files will be stored. Defaults to '/var/lib/clickhouse/tmp/'.
# @param clickhouse_user
#   Owner for Clickhouse Server configuration and data directories. Defaults to 'clickhouse'.
# @param clickhouse_group
#   Group for Clickhouse Server configuration and data directories. Defaults to 'clickhouse'.
# @param keep_default_users
#   Specifies whether to automatically remove default users, which are specified in users.xml file. Defaults to 'false'.
# @param override_options
#   Hash[String, Any] of override options to pass to Clickhouse Server configuration file. 
# @param config_file
#   Name of the file, where Clickhouse Server configuration will be stored. See https://clickhouse.yandex/docs/en/operations/configuration_files/. Defaults to 'config.xml'
# @param profiles_file
#   Name of the file, where Clickhouse Server profiles configuration will be stored. See https://clickhouse.yandex/docs/en/operations/settings/settings_profiles/. Defaults to '$profiles.xml'.
# @param quotas_file
#   Name of the file, where Clickhouse Server quotas configuration will be stored. See https://clickhouse.yandex/docs/en/operations/quotas/.  Defaults to 'quotas.xml'.
# @param macros_file
#   Name of the file, where Clickhouse Server macros configuration for replication will be stored. See https://clickhouse.yandex/docs/en/operations/table_engines/replication/. Defaults to '$macros.xml'.
# @param zookeeper_config_file
#   Name of the file, where Clickhouse Server zookeeper configuration will be stored. See https://clickhouse.yandex/docs/en/operations/table_engines/replication/.  Defaults to 'zookeeper.xml'.
# @param remote_servers_file
#   Name of the file, where Clickhouse Server remote servers configuration for Distributed table engine will be stored. See https://clickhouse.yandex/docs/en/operations/table_engines/distributed/. Defaults to 'remote_servers.xml'.
# @param dict_source_folder
#   Path to a 'files' folder in puppet, where dictionary file are located. Defaults to 'puppet:///modules/${module_name}'.
# @param install_client
#   Specifies whether to install Clickhouse Client package. Defaults to 'true'.
# @param service_name
#   Name of the Clickhouse Server service. Defaults to 'clickhouse-server'.
# @param service_ensure
#   Specifies whether Clickhouse Server service should be running. Defaults to 'running'.
# @param service_enabled
#   Specifies whether Clickhouse Server service should be enabled. Defaults to 'true'.
# @param manage_service
#   Specifies whether Clickhouse Server service should be managed. Defaults to 'true'.
# @param restart
#   Specifies whether Clickhouse Server service should be restated when configuration changes. Defaults to 'false'.
# @param users
#   Users, which are passed to clickhouse::server::user (see types/clickhouse_users.pp for data type description). See https://clickhouse.yandex/docs/en/operations/access_rights/.
# @param profiles
#   Profiles configuration, which are passed to clickhouse::server::profiles. See https://clickhouse.yandex/docs/en/operations/settings/settings_profiles/.
# @param quotas
#   Quotas configuration, which are passed to clickhouse::server::quotas. See https://clickhouse.yandex/docs/en/operations/quotas/.
# @param dictionaries
#   Dictionaries configuration, which are passed to clickhouse::server::dictionary. See https://clickhouse.yandex/docs/en/query_language/dicts/external_dicts/.
# @param replication
#   Replication configuration parameters (see types/clickhouse_replication.pp for data type description). See https://clickhouse.yandex/docs/en/operations/table_engines/replication/.
# @param remote_servers
#   Remote server configuration parameters for Distributed engine (see types/clickhouse_remote_servers.pp for data type description), which are passed to clickhouse::server::remote_servers. See https://clickhouse.yandex/docs/en/operations/table_engines/distributed/.
#
class clickhouse::server (
# Repository
  Boolean $manage_repo = $clickhouse::params::manage_repo,

# Server package
  String $package_name                   = $clickhouse::params::package_name,
  String $package_ensure                 = $clickhouse::params::package_ensure,
  Boolean $manage_package                = $clickhouse::params::manage_package,
  Array[String] $package_install_options = $clickhouse::params::package_install_options,

# Configuration
  Boolean $manage_config                        = $clickhouse::params::manage_config,
  Stdlib::Unixpath $config_dir                  = $clickhouse::params::config_dir,
  Stdlib::Unixpath $users_dir                   = $clickhouse::params::users_dir,
  Stdlib::Unixpath $dict_dir                    = $clickhouse::params::dict_dir,
  Stdlib::Unixpath $clickhouse_datadir          = $clickhouse::params::clickhouse_datadir,
  Stdlib::Unixpath $clickhouse_tmpdir           = $clickhouse::params::clickhouse_tmpdir,
  String $clickhouse_user                       = $clickhouse::params::clickhouse_user,
  String $clickhouse_group                      = $clickhouse::params::clickhouse_group,
  Boolean $keep_default_users                   = $clickhouse::params::keep_default_users,
  Optional[Hash[String, Any]] $override_options = {},
  String $config_file                           = $clickhouse::params::config_file,
  String $profiles_file                         = $clickhouse::params::profiles_file,
  String $quotas_file                           = $clickhouse::params::quotas_file,
  String $macros_file                           = $clickhouse::params::macros_file,
  String $zookeeper_config_file                 = $clickhouse::params::zookeeper_config_file,
  String $remote_servers_file                   = $clickhouse::params::remote_servers_file,
  String $dict_source_folder                    = $clickhouse::params::dict_source_folder,
  Boolean $install_client                       = $clickhouse::params::install_client,

# Service
  String $service_name                    = $clickhouse::params::service_name,
  Stdlib::Ensure::Service $service_ensure = $clickhouse::params::service_ensure,
  Boolean $service_enabled                = $clickhouse::params::service_enabled,
  Boolean $manage_service                 = $clickhouse::params::manage_service,
  Boolean $restart                        = $clickhouse::params::restart,

# Additional configuration
  Optional[Clickhouse::Clickhouse_users] $users                             = undef,
  Optional[Hash[String, Hash[String, Any]]] $profiles                       = undef,
  Optional[Hash[String, Hash[String, Array[Hash[String,Integer]]]]] $quotas = undef,
  Optional[Array[String]] $dictionaries                                     = undef,
  Optional[Clickhouse::Clickhouse_replication] $replication                 = undef,
  Optional[Clickhouse::Clickhouse_remote_servers] $remote_servers           = undef,
) inherits clickhouse::params {

  $options = $clickhouse::params::default_options.deep_merge($override_options)

  if $manage_repo {
    include clickhouse::repo
  }

  if $install_client {
    include clickhouse::client
  }

  if $restart {
    Class['clickhouse::server::config']
    ~> Class['clickhouse::server::service']
  }

  anchor { 'clickhouse::server::start': }
  -> class { 'clickhouse::server::install': }
  -> class { 'clickhouse::server::config': }
  -> class { 'clickhouse::server::resources': }
  -> class { 'clickhouse::server::service': }
  -> anchor { 'clickhouse::server::end': }

}
