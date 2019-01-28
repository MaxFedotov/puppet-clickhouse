# @summary
#   Create and manage Clickhouse user.
#
# @see https://clickhouse.yandex/docs/en/operations/access_rights/
#
# @example Create Clickhouse user.
#   clickhouse::server::user { 'alice': 
#     password        => 'HelloAlice',
#     quota           => 'default',
#     profile         => 'default',
#     allow_databases => ['web', 'data'],
#     networks        => {
#       ip => ['::/0'],
#     },
#   }
#
# @param name
#   Name of the Clickhouse user. Will be also used as a file name for user configuration file in $users_dir folder.
# @param password
#   Password for Clickhouse user. Can be specified in plaintext (and later hashed using sha256) or in sha256 format.
# @param quota
#   Name of the quota for user.
# @param profile
#   Name of the profile for user.
# @param allow_databases
#   Array of databases, the user will have permissions to access.
# @param networks
#   Clickhouse::Clickhouse_networks (see types/clickhouse_networks.pp) Restrictions for ip\hosts for user.
# @param users_dir
#   Path to directory, where user configuration will be stored. Defaults to '/etc/clickhouse-server/users.d/'
# @param user_file_owner
#   Owner of the user file. Defaults to 'clickhouse'.
# @param user_file_group
#   Group of the user file. Defaults to 'clickhouse'.
# @param ensure
#   Specifies whether to create user. Valid values are 'present', 'absent'. Defaults to 'present'.
#
define clickhouse::server::user(
  Optional[String] $password                          = undef,
  String $quota                                       = 'default',
  String $profile                                     = 'default',
  Optional[Array[String]] $allow_databases            = undef,
  Optional[Clickhouse::Clickhouse_networks] $networks = undef,
  Stdlib::Unixpath $users_dir                         = $clickhouse::server::users_dir,
  String $user_file_owner                             = $clickhouse::server::clickhouse_user,
  String $user_file_group                             = $clickhouse::server::clickhouse_group,
  Enum['present', 'absent'] $ensure                   = 'present',
) {
  if $password {
    if $password =~ '%r{[A-Fa-f0-9]{64}$}' {
      $real_password = $password
    } else {
      $real_password = sha256($password)
    }
  }

  file { "${users_dir}/${title}.xml":
    ensure  => $ensure,
    owner   => $user_file_owner,
    group   => $user_file_group,
    mode    => '0664',
    content => epp("${module_name}/user.xml.epp", {
      'user'            => $title,
      'password'        => $real_password,
      'quota'           => $quota,
      'profile'         => $profile,
      'allow_databases' => $allow_databases,
      'networks'        => $networks,
    }),
  }

}
