require 'spec_helper'

describe 'clickhouse::server::remote_servers' do
  let(:title) { 'remote_servers.xml' }
  let(:params) do
    {
      config_dir: '/etc/clickhouse-server/conf.d',
      remote_servers_file_owner: 'clickhouse',
      remote_servers_file_group: 'clickhouse',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it 'with defaults' do
        remote_servers_defaults = "\
<yandex>
  <remote_servers>
  </remote_servers>
</yandex>
"
        is_expected.to contain_file('/etc/clickhouse-server/conf.d/remote_servers.xml').with_content(remote_servers_defaults)
      end
    end

    it 'with remote server set' do
      params['remote_servers'] = {
        'replicated' => {
          'shard' => {
            'weight'               => 1,
            'internal_replication' => true,
            'replica'              => ['host1.local:9000', 'host2.local:9000'],
          },
        },
        'segmented' => {
          'shard1' => {
            'internal_replication' => true,
            'replica'              => ['host1.local:9000'],
          },
          'shard2' => {
            'internal_replication' => true,
            'replica'              => ['host2.local:9000'],
          },
        },
        'segmented_replicated' => {
          'shard1' => {
            'internal_replication' => true,
            'replica'              => ['host1.local:9000', 'host2.local:9000'],
          },
          'shard2' => {
            'internal_replication' => true,
            'replica'              => ['host3.local:9000', 'host4.local:9000'],
          },
        },
      }
      remote_servers_set = "\
<yandex>
  <remote_servers>
    <replicated>
      <shard>
        <weight>1</weight>
        <internal_replication>true</internal_replication>
        <replica>
          <host>host1.local</host>
          <port>9000</port>
        </replica>
        <replica>
          <host>host2.local</host>
          <port>9000</port>
        </replica>
      </shard>
    </replicated>
    <segmented>
      <shard>
        <internal_replication>true</internal_replication>
        <replica>
          <host>host1.local</host>
          <port>9000</port>
        </replica>
      </shard>
      <shard>
        <internal_replication>true</internal_replication>
        <replica>
          <host>host2.local</host>
          <port>9000</port>
        </replica>
      </shard>
    </segmented>
    <segmented_replicated>
      <shard>
        <internal_replication>true</internal_replication>
        <replica>
          <host>host1.local</host>
          <port>9000</port>
        </replica>
        <replica>
          <host>host2.local</host>
          <port>9000</port>
        </replica>
      </shard>
      <shard>
        <internal_replication>true</internal_replication>
        <replica>
          <host>host3.local</host>
          <port>9000</port>
        </replica>
        <replica>
          <host>host4.local</host>
          <port>9000</port>
        </replica>
      </shard>
    </segmented_replicated>
  </remote_servers>
</yandex>
"
      is_expected.to contain_file('/etc/clickhouse-server/conf.d/remote_servers.xml').with_content(remote_servers_set)
    end
  end
end
