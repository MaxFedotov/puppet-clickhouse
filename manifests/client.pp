# @summary
#   Installs and configures Clickhouse client.
#
# @example Install Clickhouse client
#   class { 'clickhouse::client':
#     package_name   => 'clickhouse-client',
#     package_ensure => 'present',
#   }
#
# @param manage_repo
#   Whether to install Clickhouse repository. Defaults to 'true'.
# @param package_name
#   Name of Clickhouse client package to install. Defaults to 'clickhouse-client'.
# @param package_ensure
#   Whether the Clickhouse client package should be present, absent or specific version. Valid values are 'present', 'absent' or 'x.y.z'. Defaults to 'present'.
# @param manage_package
#   Whether to manage Clickhouse client package. Defaults to 'true'.
# @param package_install_options
#   Array of install options for managed package resources. Appropriate options are passed to package manager.
#
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
