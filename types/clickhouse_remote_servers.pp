type Clickhouse::Clickhouse_remote_servers = Hash[String, Hash[String,Struct[{Optional[weight]               => Integer,
                                                                              Optional[internal_replication] => Boolean,
                                                                              Optional[replication_user]     => String,
                                                                              Optional[replication_password] => String,
                                                                              replica                        => Array[Pattern['[^\:]+:[0-9]{1,5}']]}]]]
