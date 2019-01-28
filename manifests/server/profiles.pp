# @summary
#   Create and manage Clickhouse profiles. 
#
# @see https://clickhouse.yandex/docs/en/operations/settings/settings_profiles/
#
# @example Create two profiles (web and readonly), which will be stored in /etc/clickhouse-server/users.d/profiles.xml file.
#   clickhouse::server::profiles { 'profiles.xml':
#     config_dir    => '/etc/clickhouse-server/users.d',
#     profiles      => {
#       web      => {
#         max_threads      => 8,
#         max_rows_to_read => 1000000000,
#       },
#       readonly => {
#          readonly => 1,
#       },
#     },
#   }
#
# @param name
#   Name of the file with profiles configurations.
# @param users_dir
#   Path to Clickhouse configuration folder. Defaults to '/etc/clickhouse-server/users.d'.
# @param profiles_file_owner
#   Owner of the profiles file. Defaults to 'clickhouse'.
# @param profiles_file_group
#   Group of the profiles file. Defaults to 'clickhouse'.
# @param ensure
#   Specifies whether to create profiles file. Valid values are 'present', 'absent'. Defaults to 'present'.
# @param profiles
#   Profiles configuration.
#
define clickhouse::server::profiles(
  Stdlib::Unixpath $users_dir               = $clickhouse::server::users_dir,
  String $profiles_file_owner               = $clickhouse::server::clickhouse_user,
  String $profiles_file_group               = $clickhouse::server::clickhouse_group,
  Enum['present', 'absent'] $ensure         = 'present',
  Hash[String, Hash[String, Any]] $profiles = {},
) {

  file { "${users_dir}/${title}":
    ensure  => $ensure,
    content => clickhouse_config({'profiles' => $profiles}),
    mode    => '0664',
    owner   => $profiles_file_owner,
    group   => $profiles_file_group,
  }

}
