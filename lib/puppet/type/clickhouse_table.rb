Puppet::Type.newtype(:clickhouse_table) do
  @doc = <<-PUPPET
    @summary
      Manages a Clickhouse Table
    @param [namevar] Table name.
    @param [ensure] Specifies whether to create table in Clickhouse. Valid values are 'present', 'absent'. Defaults to 'present'.
    @param [types] Specify the data structure of the table
    @param [engine] The engine to use for the table
    @param [partition] What to partition the table on
    @param [order] how to order the table

  PUPPET

  ensurable

  autorequire(:file) { '/root/.clickhouse-client/config.xml' }
  autorequire(:class) { 'clickhouse::server' }

  newparam(:name, namevar: true) do
    desc 'The name of the Clickhouse database to manage.'
  end

  newparam(:types) do
    desc 'The Structure of the data on the table'
  end

  newparam(:engine) do
    desc 'The engine to use for the table'
  end

  newparam(:partition) do
    desc 'What to partition the table on'
  end
  newparam(:order) do
    desc 'how to order the table'
  end
end
