# Puppet provider for mysql
class Puppet::Provider::Clickhouse < Puppet::Provider
  # Without initvars commands won't work.
  initvars

  # Make sure we find clickhouse commands
  ENV['PATH'] = ENV['PATH'] + ':/usr/libexec:/usr/local/libexec:/usr/local/bin'

  # rubocop:disable Style/HashSyntax
  commands :clickhouse_raw => 'clickhouse-client'

  def self.clickhouse_caller(text_of_sql)
    clickhouse_raw(['-c', '/root/.clickhouse-client/config.xml', '-q', text_of_sql].flatten.compact)
  end
end
