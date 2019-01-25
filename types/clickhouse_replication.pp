type Clickhouse::Clickhouse_replication = Struct[{zookeeper_servers => Array[Pattern['[^\:]+:[0-9]{1,5}']],
                                                  Optional[macros]  => Hash[String, Any]}]
