# @summary 
#   Private class for managing Clickhouse client package.
#
# @api private
#
class clickhouse::client::install {

  if $clickhouse::client::manage_package {

    package { 'clickhouse-client':
      ensure          => $clickhouse::client::package_ensure,
      install_options => $clickhouse::client::package_install_options,
      name            => $clickhouse::client::package_name,
    }
  }

}
