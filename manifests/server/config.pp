# @summary
#   Private class for Clickhouse server configuration.
#
# @api private
#
class clickhouse::server::config {

  $default_options = {
    'listen_host'            => '::',
    'dictionaries_config'    => "${clickhouse::server::dict_dir}/*.xml",
    'max_table_size_to_drop' => 0,
    'path'                   => $clickhouse::server::clickhouse_datadir,
    'tmp_path'               => $clickhouse::server::clickhouse_tmpdir,
  }

  $options = $default_options.deep_merge($clickhouse::server::override_options)

  if $clickhouse::server::manage_config {
    $recurse = true
    $purge = true
  } else {
    $recurse = false
    $purge = false
  }

  file { [ $clickhouse::server::clickhouse_datadir, $clickhouse::server::clickhouse_tmpdir ]:
      ensure => 'directory',
      mode   => '0664',
      owner  => $clickhouse::server::clickhouse_user,
      group  => $clickhouse::server::clickhouse_group,
  }

  file { [ $clickhouse::server::config_dir, $clickhouse::server::users_dir, $clickhouse::server::dict_dir ]:
      ensure  => 'directory',
      mode    => '0664',
      owner   => $clickhouse::server::clickhouse_user,
      group   => $clickhouse::server::clickhouse_group,
      recurse => $recurse,
      purge   => $purge,
  }

  if $clickhouse::server::manage_config {
    file { "${clickhouse::server::config_dir}/${clickhouse::server::config_file}":
      content => clickhouse_config($options),
      mode    => '0664',
      owner   => $clickhouse::server::clickhouse_user,
      group   => $clickhouse::server::clickhouse_group,
    }

    if !($clickhouse::server::keep_default_users) {
      file { '/etc/clickhouse-server/users.xml':
        content => "<yandex>\r\n\t<users>\r\n\t</users>\r\n</yandex>\r\n",
        mode    => '0664',
        owner   => $clickhouse::server::clickhouse_user,
        group   => $clickhouse::server::clickhouse_group,
      }
    }

    if $clickhouse::server::replication {
      file { "${clickhouse::server::config_dir}/${clickhouse::server::zookeeper_config_file}":
        owner   => $clickhouse::server::clickhouse_user,
        group   => $clickhouse::server::clickhouse_group,
        mode    => '0664',
        content => epp("${module_name}/zookeeper.xml.epp", {
          'zookeeper_servers' => $clickhouse::server::replication['zookeeper_servers'],
        }),
        require => File[$clickhouse::server::config_dir],
      }
    }
  }

}
