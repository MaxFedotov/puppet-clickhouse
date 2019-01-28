Puppet::Type.newtype(:clickhouse_database) do
    @doc = <<-PUPPET
      @summary
        Manages a Clickhouse database.
      @param [namevar] Database name.
      @param [ensure] Specifies whether to create database in Clickhouse. Valid values are 'present', 'absent'. Defaults to 'present'.
  
    PUPPET
  
    ensurable
  
    autorequire(:file) { '/root/.clickhouse-client/config.xml' }
    autorequire(:class) { 'clickhouse::server' }
  
    newparam(:name, namevar: true) do
      desc 'The name of the Clickhouse database to manage.'
    end
  
  end
  