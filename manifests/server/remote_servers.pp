# @summary
#   Create and manage Clickhouse remote servers for Distributed engine.
#
# @see https://clickhouse.yandex/docs/en/operations/table_engines/distributed/
#
# @example Create three Clickhouse clusters. Replicated - one shard with two replicas, segmented - two shards without replicas, segmented_replicated - two shards, each having two replicas.
#   clickhouse::server::remote_servers { 'remote_servers.xml': 
#     remote_servers_file => '/etc/clickhouse-server/conf.d',
#     remote_servers => {
#       replicated           => {
#         shard => {
#           weight               => 1,
#           internal_replication => true,
#           replica              => ['host1.local:9000', 'host2.local:9000'],
#         }
#       },
#       segmented            => {
#         shard1 => {
#           internal_replication => true,
#           replica              => ['host1.local:9000'],
#         },
#         shard2 => {
#           internal_replication => true,
#           replica              => ['host2.local:9000'],
#         }
#       },
#       segmented_replicated => {
#         shard1 => {
#           internal_replication => true,
#           replica              => ['host1.local:9000', 'host2.local:9000'],
#         },
#         shard2 => {
#           internal_replication => true,
#           replica              => ['host3.local:9000', 'host4.local:9000'],
#         }
#       },
#     },
#   }
#
# @param name
#   Name of the file with remote servers configurations.
# @param config_dir
#   Path to Clickhouse configuration folder. Defaults to '/etc/clickhouse-server/conf.d'.
# @param remote_servers_file_owner
#   Owner of the remote servers file. Defaults to 'clickhouse'.
# @param remote_servers_file_group
#   Group of the remote servers file. Defaults to 'clickhouse'.
# @param ensure
#   Specifies whether to create remote servers file. Valid values are 'present', 'absent'. Defaults to 'present'.
# @param remote_servers
#   Remote server configurations (see types/clickhouse_remote_servers.pp for data type description).
#
define clickhouse::server::remote_servers(
  Stdlib::Unixpath $config_dir                          = $clickhouse::server::config_dir,
  String $remote_servers_file_owner                     = $clickhouse::server::clickhouse_user,
  String $remote_servers_file_group                     = $clickhouse::server::clickhouse_group,
  Enum['present', 'absent'] $ensure                     = 'present',
  Clickhouse::Clickhouse_remote_servers $remote_servers = {},
) {

  file { "${config_dir}/${title}":
    ensure  => $ensure,
    owner   => $remote_servers_file_owner,
    group   => $remote_servers_file_group,
    mode    => '0664',
    content => epp("${module_name}/remote_servers.xml.epp", {
      'remote_servers' => $remote_servers,
    }),
  }

}
