# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   clickhouse::server::dictionary { 'namevar': }
define clickhouse::server::dictionary(
  Stdlib::Unixpath $dict_dir        = $clickhouse::server::dict_dir,
  String $dict_file_owner           = $clickhouse::server::clickhouse_user,
  String $dict_file_group           = $clickhouse::server::clickhouse_group,
  Enum['present', 'absent'] $ensure = 'present',
  String $source                    = "${clickhouse::server::dict_source_folder}/${title}",
) {

  file { "${dict_dir}/${title}":
    ensure => $ensure,
    owner  => $dict_file_owner,
    group  => $dict_file_group,
    mode   => '0664',
    source => $source,
  }

}
