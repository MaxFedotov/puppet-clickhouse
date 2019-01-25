# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   clickhouse::server::quotas { 'namevar': }
define clickhouse::server::quotas(
  Stdlib::Unixpath $quotas_file                               = $clickhouse::server::quotas_file,
  String $quotas_file_owner                                   = $clickhouse::server::clickhouse_user,
  String $quotas_file_group                                   = $clickhouse::server::clickhouse_group,
  String $ensure                                              = 'present',
  Hash[String, Hash[String, Array[Hash[String,Any]]]] $quotas = {},
) {

  file { $quotas_file:
    ensure  => $ensure,
    content => clickhouse_config({'quotas' => $quotas}),
    mode    => '0664',
    owner   => $quotas_file_owner,
    group   => $quotas_file_group,
  }

}
