# @summary
#   Create and manage Clickhouse quotas. 
#
# @see https://clickhouse.yandex/docs/en/operations/quotas/
#
# @example Create two quotas (web with two intervals, office with one).
#   clickhouse::server::quotas { 'quotas.xml': 
#     config_dir   => '/etc/clickhouse-server/users.d',
#     quotas => {
#       web => {
#         interval => [
#           {
#             duration       => 3600,
#             queries        => 2,
#             errors         => 5,
#             result_rows    => 1000,
#             read_rows      => 1000,
#             execution_time => 5000,
#           },
#           {
#             duration       => 86400,
#             queries        => 2000,
#             errors         => 50,
#             result_rows    => 10000,
#             read_rows      => 10000,
#             execution_time => 50000,
#           },
#         ],
#       },
#       office => {
#         interval => [
#           {
#             duration       => 3600,
#             queries        => 256,
#             errors         => 50,
#             result_rows    => 3000,
#             read_rows      => 3000,
#             execution_time => 5000,
#           }
#         ],
#       },
#     },
#   }
#
# @param name
#   Name of the file with quotas configurations.
# @param users_dir
#   Path to Clickhouse configuration folder. Defaults to '/etc/clickhouse-server/users.d'.
# @param quotas_file_owner
#   Owner of the quotas file. Defaults to 'clickhouse'.
# @param quotas_file_group
#   Group of the quotas file. Defaults to 'clickhouse'.
# @param ensure
#   Specifies whether to create quotas file. Valid values are 'present', 'absent'. Defaults to 'present'.
# @param quotas
#   Quotas configuraion.
#
define clickhouse::server::quotas(
  Stdlib::Unixpath $users_dir           = $clickhouse::server::users_dir,
  String $quotas_file_owner             = $clickhouse::server::clickhouse_user,
  String $quotas_file_group             = $clickhouse::server::clickhouse_group,
  Enum['present', 'absent'] $ensure     = 'present',
  Clickhouse::Clickhouse_quotas $quotas = {},
) {

  file { "${users_dir}/${title}":
    ensure  => $ensure,
    content => clickhouse_config({'quotas' => $quotas}),
    mode    => '0664',
    owner   => $quotas_file_owner,
    group   => $quotas_file_group,
  }

}
