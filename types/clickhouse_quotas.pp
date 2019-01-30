# lint:ignore:2sp_soft_tabs
type Clickhouse::Clickhouse_quotas = Hash[String, Struct[{interval => Array[Struct[{Optional[duration]       => Integer,
                                                                                    Optional[queries]        => Integer,
                                                                                    Optional[errors]         => Integer,
                                                                                    Optional[result_rows]    => Integer,
                                                                                    Optional[read_rows]      => Integer,
                                                                                    Optional[execution_time] => Integer}]]}]]
# lint:endignore
