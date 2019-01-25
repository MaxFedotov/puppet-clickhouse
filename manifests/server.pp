# @summary
#   Installs and configures Clickhouse server.
#
# @example
#   include clickhouse::server
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
  Optional[Hash[String, Any]] $override_options = undef,
  String $config_file                           = $clickhouse::params::config_file,
  String $profiles_file                         = $clickhouse::params::profiles_file,
  String $quotas_file                           = $clickhouse::params::quotas_file,
  String $macros_file                           = $clickhouse::params::macros_file,
  String $zookeeper_config_file                 = $clickhouse::params::zookeeper_config_file,
  String $remote_servers_file                   = $clickhouse::params::remote_servers_file,
  String $dict_source_folder                    = $clickhouse::params::dict_source_folder,
  Boolean $install_client                       = $clickhouse::params::install_client,

# Service
  String $service_name     = $clickhouse::params::service_name,
  String $service_ensure   = $clickhouse::params::service_ensure,
  Boolean $service_enabled = $clickhouse::params::service_enabled,
  Boolean $manage_service  = $clickhouse::params::manage_service,
  Boolean $restart         = $clickhouse::params::restart,

# Additional configuration
  Optional[Clickhouse::Clickhouse_users] $users                             = undef,
  Optional[Hash[String, Hash[String, Any]]] $profiles                       = undef,
  Optional[Hash[String, Hash[String, Array[Hash[String,Integer]]]]] $quotas = undef,
  Optional[Array[String]] $dictionaries                                     = undef,
  Optional[Clickhouse::Clickhouse_replication] $replication                 = undef,
  Optional[Clickhouse::Clickhouse_remote_servers] $remote_servers           = undef,
) inherits clickhouse::params {

  if $override_options {
    $options = $clickhouse::params::default_options.deep_merge($override_options)
  } else {
    $options = $clickhouse::params::default_options
  }

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

# These parameters don't require server restart, so are configured in server class
  if $users {
    $users.each |$user, $user_config| {
      clickhouse::server::user { $user:
        *       => $user_config,
        require => Class['clickhouse::server::service'],
      }
    }
  }

  if $profiles {
    clickhouse::server::profiles { 'clickhouse-profiles':
      profiles => $profiles,
      require  => Class['clickhouse::server::service'],
    }
  }

  if $quotas {
    clickhouse::server::quotas { 'clickhouse-quotas':
      quotas  => $quotas,
      require => Class['clickhouse::server::service'],
    }
  }

  if $dictionaries {
    $dictionaries.each |$dict| {
      clickhouse::server::dictionary { $dict:
        require  => Class['clickhouse::server::service'],
      }
    }
  }

  if $replication {
    if $replication['macros'] {
      clickhouse::server::macros { 'clickhouse-macros':
        macros  => $replication['macros'],
        require => Class['clickhouse::server::service'],
      }
    }
  }

  if $remote_servers {
    clickhouse::server::remote_servers { 'clickhouse-remote-servers':
      remote_servers => $remote_servers ,
      require        => Class['clickhouse::server::service'],
    }
  }

  anchor { 'clickhouse::server::start': }
  -> class { 'clickhouse::server::install': }
  -> class { 'clickhouse::server::config': }
  -> class { 'clickhouse::server::service': }
  -> anchor { 'clickhouse::server::end': }

}
