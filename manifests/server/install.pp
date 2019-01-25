# @summary 
#   Private class for managing Clickhouse server package.
#
# @api private
#
class clickhouse::server::install {

  if $clickhouse::server::manage_package {
    package { $clickhouse::server::package_name:
      ensure          => $clickhouse::server::package_ensure,
      install_options => $clickhouse::server::package_install_options,
    }
  }

}
