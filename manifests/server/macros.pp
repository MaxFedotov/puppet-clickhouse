# @summary
#   Create and manage Clickhouse macros file for replication. 
#
# @see https://clickhouse.yandex/docs/en/operations/table_engines/replication/
#
# @example Create macros file /etc/clickhouse-server/conf.d/macros.xml with substitutions for cluster, replica and shard
#   clickhouse::server::macros { 'macros.xml':
#       config_folder => '/etc/clickhouse-server/conf.d',
#       macros        => {
#         cluster => 'Clickhouse_cluster',
#         replica => 'myhost.local',
#         shard   => '1',
#       },
#   }
#
# @param name
#   Name of the file with macros configurations.
# @param config_dir
#   Path to Clickhouse configuration folder. Defaults to '/etc/clickhouse-server/conf.d'.
# @param macros_file_owner
#   Owner of the macros file. Defaults to 'clickhouse'.
# @param macros_file_group
#   Group of the macros file. Defaults to 'clickhouse'.
# @param ensure
#   Specifies whether to create macros file. Valid values are 'present', 'absent'. Defaults to 'present'.
# @param macros
#   Substitions in macros file.
#
define clickhouse::server::macros(
  Stdlib::Unixpath $config_dir      = $clickhouse::server::config_dir,
  String $macros_file_owner         = $clickhouse::server::clickhouse_user,
  String $macros_file_group         = $clickhouse::server::clickhouse_group,
  Enum['present', 'absent'] $ensure = 'present',
  Hash[String, Any] $macros         = {},
) {

  file { "${config_dir}/${title}":
    ensure  => $ensure,
    content => clickhouse_config({'macros' => $macros}),
    mode    => '0664',
    owner   => $macros_file_owner,
    group   => $macros_file_group,
  }

}
