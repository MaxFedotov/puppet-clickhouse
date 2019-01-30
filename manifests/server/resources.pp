# @summary
#   Private class for applying Clickhouse resources.
#
# @api private
#
class clickhouse::server::resources {

  if $clickhouse::server::users {
    create_resources(clickhouse::server::user, $clickhouse::server::users)
  }

  if $clickhouse::server::profiles {
    clickhouse::server::profiles { $clickhouse::server::profiles_file:
      profiles => $clickhouse::server::profiles,
    }
  }

  if $clickhouse::server::quotas {
    clickhouse::server::quotas { $clickhouse::server::quotas_file:
      quotas => $clickhouse::server::quotas,
    }
  }

  if $clickhouse::server::dictionaries {
    $clickhouse::server::dictionaries.each |$dict| {
      clickhouse::server::dictionary { $dict: }
    }
  }

  if $clickhouse::server::replication {
    if $clickhouse::server::replication['macros'] {
      clickhouse::server::macros { $clickhouse::server::macros_file:
        macros => $clickhouse::server::replication['macros'],
      }
    }
  }

  if $clickhouse::server::remote_servers {
    clickhouse::server::remote_servers { $clickhouse::server::remote_servers_file:
      remote_servers => $clickhouse::server::remote_servers,
    }
  }

}
