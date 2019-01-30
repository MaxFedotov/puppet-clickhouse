require 'spec_helper'

describe 'clickhouse::server::profiles' do
  let(:title) { 'profiles.xml' }
  let(:params) do
    {
      users_dir: '/etc/clickhouse-server/users.d',
      profiles_file_owner: 'clickhouse',
      profiles_file_group: 'clickhouse',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it 'with defaults' do
        profiles_defaults = "\
<yandex>
  <profiles></profiles>
</yandex>
"
        is_expected.to contain_file('/etc/clickhouse-server/users.d/profiles.xml').with_content(profiles_defaults)
      end

      it 'with profiles set' do
        params['profiles'] = {
          'web' => {
            'max_threads'      => 1,
            'max_rows_to_read' => 100,
          },
          'readonly' => {
            'readonly' => 1,
          },
        }
        profiles_set = "\
<yandex>
  <profiles>
    <web>
      <max_threads>1</max_threads>
      <max_rows_to_read>100</max_rows_to_read>
    </web>
    <readonly>
      <readonly>1</readonly>
    </readonly>
  </profiles>
</yandex>
"

        is_expected.to contain_file('/etc/clickhouse-server/users.d/profiles.xml').with_content(profiles_set)
      end
    end
  end
end
