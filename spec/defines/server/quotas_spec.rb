require 'spec_helper'

describe 'clickhouse::server::quotas' do
  let(:title) { 'quotas.xml' }
  let(:params) do
    {
      users_dir: '/etc/clickhouse-server/users.d',
      quotas_file_owner: 'clickhouse',
      quotas_file_group: 'clickhouse',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it 'with defaults' do
        quotas_defaults = "\
<yandex>
  <quotas></quotas>
</yandex>
"
        is_expected.to contain_file('/etc/clickhouse-server/users.d/quotas.xml').with_content(quotas_defaults)
      end

      it 'with quotas set' do
        params['quotas'] = {
          'web' => {
            'interval' => [
              {
                'duration'       => 3600,
                'queries'        => 2,
                'errors'         => 5,
                'result_rows'    => 1000,
                'read_rows'      => 1000,
                'execution_time' => 5000,
              },
              {
                'duration'       => 86_400,
                'queries'        => 2000,
                'errors'         => 50,
              },
            ],
          },
          'office' => {
            'interval' => [
              {
                'duration'       => 3600,
                'queries'        => 256,
                'errors'         => 50,
                'result_rows'    => 3000,
                'read_rows'      => 3000,
                'execution_time' => 5000,
              },
            ],
          },
        }
        quotas_set = "\
<yandex>
  <quotas>
    <web>
      <interval>
        <duration>3600</duration>
        <queries>2</queries>
        <errors>5</errors>
        <result_rows>1000</result_rows>
        <read_rows>1000</read_rows>
        <execution_time>5000</execution_time>
      </interval>
      <interval>
        <duration>86400</duration>
        <queries>2000</queries>
        <errors>50</errors>
      </interval>
    </web>
    <office>
      <interval>
        <duration>3600</duration>
        <queries>256</queries>
        <errors>50</errors>
        <result_rows>3000</result_rows>
        <read_rows>3000</read_rows>
        <execution_time>5000</execution_time>
      </interval>
    </office>
  </quotas>
</yandex>
"

        is_expected.to contain_file('/etc/clickhouse-server/users.d/quotas.xml').with_content(quotas_set)
      end
    end
  end
end
