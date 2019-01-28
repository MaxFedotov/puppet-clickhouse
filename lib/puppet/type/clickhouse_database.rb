Puppet::Type.newtype(:clickhouse_database) do
    @doc = <<-PUPPET
      @summary
        Manage a Clickhouse database.
  
      @api private
    PUPPET
  
    ensurable
  
    autorequire(:file) { '/root/.clickhouse-client/config.xml' }
    autorequire(:class) { 'clickhouse::server' }
  
    newparam(:name, namevar: true) do
      desc 'The name of the Clickhouse database to manage.'
    end
  
  end
  