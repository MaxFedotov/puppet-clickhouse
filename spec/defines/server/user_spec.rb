require 'spec_helper'

describe 'clickhouse::server::user' do
  let(:title) { 'alice' }
  let(:params) do
    {
      users_dir: '/etc/clickhouse-server/users.d',
      user_file_owner: 'clickhouse',
      user_file_group: 'clickhouse',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it 'with defaults' do
        alice_defaults = "\
<yandex>
  <users>
    <alice>
      <quota>default</quota>
      <profile>default</profile>
    </alice>
  </users>
</yandex>
"
        is_expected.to contain_file('/etc/clickhouse-server/users.d/alice.xml').with_content(alice_defaults)
      end

      alice_password = "\
<yandex>
  <users>
    <alice>
      <password_sha256_hex>21597f1f8d7874eeb0d08e485c146c3067dc502512c6edaa38e0eabb3c4280a6</password_sha256_hex>
      <quota>default</quota>
      <profile>default</profile>
    </alice>
  </users>
</yandex>
"

      it 'with cleartext password' do
        params['password'] = 'helloAlice'
        is_expected.to contain_file('/etc/clickhouse-server/users.d/alice.xml').with_content(alice_password)
      end

      it 'with sha256 password' do
        params['password'] = '21597f1f8d7874eeb0d08e485c146c3067dc502512c6edaa38e0eabb3c4280a6'
        is_expected.to contain_file('/etc/clickhouse-server/users.d/alice.xml').with_content(alice_password)
      end

      it 'with allow_databases' do
        params['allow_databases'] = ['db1', 'db2']
        alice_databases = "\
<yandex>
  <users>
    <alice>
      <quota>default</quota>
      <profile>default</profile>
      <allow_databases>
        <database>db1</database>
        <database>db2</database>
      </allow_databases>
    </alice>
  </users>
</yandex>
"
        is_expected.to contain_file('/etc/clickhouse-server/users.d/alice.xml').with_content(alice_databases)
      end

      it 'with profile override' do
        params['profile'] = 'test'
        alice_profile = "\
<yandex>
  <users>
    <alice>
      <quota>default</quota>
      <profile>test</profile>
    </alice>
  </users>
</yandex>
"
        is_expected.to contain_file('/etc/clickhouse-server/users.d/alice.xml').with_content(alice_profile)
      end

      it 'with quota override' do
        params['quota'] = 'test'
        alice_profile = "\
<yandex>
  <users>
    <alice>
      <quota>test</quota>
      <profile>default</profile>
    </alice>
  </users>
</yandex>
"
        is_expected.to contain_file('/etc/clickhouse-server/users.d/alice.xml').with_content(alice_profile)
      end

      it 'with networks' do
        params['networks'] = {
          'ip'          => ['::/0', '::'],
          'host'        => ['localhost', 'host1.local'],
          'host_regexp' => ['^local.*', '^remote.*'],
        }
        alice_networks = "\
<yandex>
  <users>
    <alice>
      <quota>default</quota>
      <profile>default</profile>
      <networks>
        <ip>::/0</ip>
        <ip>::</ip>
        <host>localhost</host>
        <host>host1.local</host>
        <host_regexp>^local.*</host_regexp>
        <host_regexp>^remote.*</host_regexp>
      </networks>
    </alice>
  </users>
</yandex>
"
        is_expected.to contain_file('/etc/clickhouse-server/users.d/alice.xml').with_content(alice_networks)
      end
    end
  end
end
