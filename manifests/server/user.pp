# A description of what this defined type does
#
# @summary A short summary of the purpose of this defined type.
#
# @example
#   clickhouse::server::user { 'namevar': }
define clickhouse::server::user(
  Optional[String] $password                          = undef,
  String $quota                                       = 'default',
  String $profile                                     = 'default',
  Optional[Array[String]] $allow_databases            = undef,
  Optional[Clickhouse::Clickhouse_networks] $networks = undef,
  Stdlib::Unixpath $users_dir                         = $clickhouse::server::users_dir,
  String $user_file_owner                             = $clickhouse::server::clickhouse_user,
  String $user_file_group                             = $clickhouse::server::clickhouse_group,
  String $ensure                                      = 'present',
) {

  file { "${users_dir}/${title}.xml":
    ensure  => $ensure,
    owner   => $user_file_owner,
    group   => $user_file_group,
    mode    => '0664',
    content => epp("${module_name}/user.xml.epp", {
      'user'            => $title,
      'password'        => clickhouse_password($password),
      'quota'           => $quota,
      'profile'         => $profile,
      'allow_databases' => $allow_databases,
      'networks'        => $networks,
    }),
  }

}
