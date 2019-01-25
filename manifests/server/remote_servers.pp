# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   clickhouse::server::remote_servers { 'namevar': }
define clickhouse::server::remote_servers(
  Stdlib::Unixpath $remote_servers_file                 = $clickhouse::server::remote_servers_file,
  String $remote_servers_file_owner                     = $clickhouse::server::clickhouse_user,
  String $remote_servers_file_group                     = $clickhouse::server::clickhouse_group,
  String $ensure                                        = 'present',
  Clickhouse::Clickhouse_remote_servers $remote_servers = {},
) {

  file { $remote_servers_file:
    ensure  => $ensure,
    owner   => $remote_servers_file_owner,
    group   => $remote_servers_file_group,
    mode    => '0664',
    content => epp("${module_name}/remote_servers.xml.epp", {
      'remote_servers' => $remote_servers,
    }),
  }

}
