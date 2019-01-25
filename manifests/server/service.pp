# @summary 
#   Private class for managing the Clickhouse service
#
# @api private
#
class clickhouse::server::service {

  if $clickhouse::server::manage_service {
    service { $clickhouse::server::service_name:
      ensure => $clickhouse::server::service_ensure,
      enable => $clickhouse::server::service_enabled,
    }

    if $clickhouse::server::manage_package {
      Service[$clickhouse::server::service_name] {
        require => Package[$clickhouse::server::package_name],
      }
    }

    if $clickhouse::server::manage_config {
      File[$clickhouse::server::config_file] -> Service[$clickhouse::server::service_name]
    }

  }
}
