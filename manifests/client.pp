# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include clickhouse::client
class clickhouse::client (
  Boolean $manage_repo                   = $clickhouse::params::manage_repo,
  String $package_name                   = $clickhouse::params::client_package_name,
  String $package_ensure                 = $clickhouse::params::client_package_ensure,
  Boolean $manage_package                = $clickhouse::params::client_manage_package,
  Array[String] $package_install_options = $clickhouse::params::client_package_install_options,
) inherits clickhouse::params{

  if $manage_repo {
    include clickhouse::repo
  }

  anchor { 'clickhouse::client::start': }
  -> class { 'clickhouse::client::install':}
  -> anchor { 'clickhouse::client::end': }

}
