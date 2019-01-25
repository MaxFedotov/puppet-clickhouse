# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   clickhouse::server::macros { 'namevar': }
define clickhouse::server::macros(
  Stdlib::Unixpath $macros_file = $clickhouse::server::macros_file,
  String $macros_file_owner     = $clickhouse::server::clickhouse_user,
  String $macros_file_group     = $clickhouse::server::clickhouse_group,
  String $ensure                = 'present',
  Hash[String, Any] $macros     = {},
) {

  file { $macros_file:
    ensure  => $ensure,
    content => clickhouse_config({'macros' => $macros}),
    mode    => '0664',
    owner   => $macros_file_owner,
    group   => $macros_file_group,
  }

}
