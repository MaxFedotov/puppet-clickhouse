# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   clickhouse::server::profiles { 'namevar': }
define clickhouse::server::profiles(
  Stdlib::Unixpath $profiles_file           = $clickhouse::server::profiles_file,
  String $profiles_file_owner               = $clickhouse::server::clickhouse_user,
  String $profiles_file_group               = $clickhouse::server::clickhouse_group,
  Enum['present', 'absent'] $ensure         = 'present',
  Hash[String, Hash[String, Any]] $profiles = {},
) {

  file { $profiles_file:
    ensure  => $ensure,
    content => clickhouse_config({'profiles' => $profiles}),
    mode    => '0664',
    owner   => $profiles_file_owner,
    group   => $profiles_file_group,
  }

}
