# @summary
#   Private class for applying Clickhouse resources
#
# @api private
#
class clickhouse::server::resources {

  create_resources(clickhouse::server::user, $clickhouse::server::users)

  if $clickhouse::server::profiles {
    clickhouse::server::profiles { 'clickhouse-profiles':
      profiles => $clickhouse::server::profiles,
    }
  }

  if $clickhouse::server::quotas {
    clickhouse::server::quotas { 'clickhouse-quotas':
      quotas  => $clickhouse::server::quotas,
    }
  }

  if $clickhouse::server::dictionaries {
    $clickhouse::server::dictionaries.each |$dict| {
      clickhouse::server::dictionary { $dict: }
    }
  }

  if $clickhouse::server::replication {
    if $clickhouse::server::replication['macros'] {
      clickhouse::server::macros { 'clickhouse-macros':
        macros  => $clickhouse::server::replication['macros'],
      }
    }
  }

  if $clickhouse::server::remote_servers {
    clickhouse::server::remote_servers { 'clickhouse-remote-servers':
      remote_servers => $clickhouse::server::remote_servers ,
    }
  }

}
