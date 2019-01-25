# @summary
#   Private class for Clickhouse server configuration.
#
# @api private
#
class clickhouse::server::config {

  $options = $clickhouse::server::options

  file { [$clickhouse::server::config_dir, $clickhouse::server::users_dir, $clickhouse::server::dict_dir,
          $clickhouse::server::clickhouse_datadir, $clickhouse::server::clickhouse_tmpdir]:
      ensure => 'directory',
      mode   => '0664',
      owner  => $clickhouse::server::clickhouse_user,
      group  => $clickhouse::server::clickhouse_group,
  }

  if $clickhouse::server::manage_config {
    file { $clickhouse::server::config_file:
      content => clickhouse_config($options),
      mode    => '0664',
      owner   => $clickhouse::server::clickhouse_user,
      group   => $clickhouse::server::clickhouse_group,
    }

    File[$clickhouse::server::users_dir] {
      recurse => true,
      purge   => true,
    }

    File[$clickhouse::server::config_dir] {
      recurse => true,
      purge   => true,
    }

    File[$clickhouse::server::dict_dir] {
      recurse => true,
      purge   => true,
    }

    if !($clickhouse::server::keep_default_users) {
      file { '/etc/clickhouse-server/users.xml':
        ensure => absent,
      }
    }

    if $clickhouse::server::replication {
      file { $clickhouse::server::zookeeper_config_file:
        owner   => $clickhouse::server::clickhouse_user,
        group   => $clickhouse::server::clickhouse_group,
        mode    => '0664',
        content => epp("${module_name}/zookeeper.xml.epp", {
          'zookeeper_servers' => $clickhouse::server::replication['zookeeper_servers'],
        }),
        require => File[$clickhouse::server::users_dir],
      }
    }
  }

}
