require 'spec_helper'

describe 'clickhouse::server' do
  on_supported_os.each do |_os, os_facts|
    context 'on #{_os}' do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end

    context 'with defaults' do
      let(:facts) { os_facts }

      it { is_expected.to contain_class('clickhouse::server::install') }
      it { is_expected.to contain_class('clickhouse::client') }
      it { is_expected.to contain_class('clickhouse::params') }
      it { is_expected.to contain_class('clickhouse::repo') }
      it { is_expected.to contain_class('clickhouse::server::config') }
      it { is_expected.to contain_class('clickhouse::server::resources') }
      it { is_expected.to contain_class('clickhouse::server::service') }
      it { is_expected.to contain_class('clickhouse::client::install') }
      it { is_expected.to contain_anchor('clickhouse::server::start') }
      it { is_expected.to contain_anchor('clickhouse::server::end') }
      it { is_expected.to contain_anchor('clickhouse::client::start') }
      it { is_expected.to contain_anchor('clickhouse::client::end') }
      it { is_expected.to contain_package('clickhouse-client') }
    end

    context 'with manage_repo set to false' do
      let(:facts) { os_facts }
      let(:params) { { manage_repo: false } }

      it { is_expected.not_to contain_class('clickhouse::repo') }
    end

    context 'with install_client set to false' do
      let(:facts) { os_facts }
      let(:params) { { install_client: false } }

      it { is_expected.not_to contain_class('clickhouse::client') }
      it { is_expected.not_to contain_package('clickhouse-client') }
    end

    context 'with restart set to true' do
      let(:facts) { os_facts }
      let(:params) { { restart: true } }

      it { is_expected.to contain_class('clickhouse::server::config').that_notifies('Class[clickhouse::server::service]') }
    end

    context 'clickhouse::server::install' do
      let(:facts) { os_facts }

      it { is_expected.to contain_package('clickhouse-server').with(ensure: 'present') }

      context 'with manage_package set to true' do
        let(:params) { { manage_package: true } }

        it { is_expected.to contain_package('clickhouse-server') }
      end

      context 'with manage_package set to false' do
        let(:params) { { manage_package: false } }

        it { is_expected.not_to contain_package('clickhouse-server') }
      end
    end

    context 'clickhouse::server::config' do
      let(:facts) { os_facts }

      it {
        is_expected.to contain_file('/var/lib/clickhouse/').with(
          ensure: 'directory',
          mode: '0664',
          owner: 'clickhouse',
          group: 'clickhouse',
        )
      }

      it {
        is_expected.to contain_file('/var/lib/clickhouse/tmp/').with(
          ensure: 'directory',
          mode: '0664',
          owner: 'clickhouse',
          group: 'clickhouse',
        )
      }

      it {
        is_expected.to contain_file('/etc/clickhouse-server/conf.d/').with(
          ensure: 'directory',
          mode: '0664',
          owner: 'clickhouse',
          group: 'clickhouse',
          recurse: true,
          purge: true,
        )
      }

      it {
        is_expected.to contain_file('/etc/clickhouse-server/users.d/').with(
          ensure: 'directory',
          mode: '0664',
          owner: 'clickhouse',
          group: 'clickhouse',
          recurse: true,
          purge: true,
        )
      }

      it {
        is_expected.to contain_file('/etc/clickhouse-server/dict/').with(
          ensure: 'directory',
          mode: '0664',
          owner: 'clickhouse',
          group: 'clickhouse',
          recurse: true,
          purge: true,
        )
      }

      default_config = "\
<yandex>
  <listen_host>::</listen_host>
  <dictionaries_config>/etc/clickhouse-server/dict/*.xml</dictionaries_config>
  <max_table_size_to_drop>0</max_table_size_to_drop>
  <path>/var/lib/clickhouse/</path>
  <tmp_path>/var/lib/clickhouse/tmp/</tmp_path>
</yandex>\n"

      it {
        is_expected.to contain_file('/etc/clickhouse-server/conf.d/config.xml').with(
          mode: '0664',
          owner: 'clickhouse',
          group: 'clickhouse',
        ).with_content(default_config)
      }

      context 'with manage_config set to false' do
        let(:facts) { os_facts }
        let(:params) { { manage_config: false } }

        it {
          is_expected.to contain_file('/var/lib/clickhouse/').with(
            ensure: 'directory',
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
          )
        }

        it {
          is_expected.to contain_file('/var/lib/clickhouse/tmp/').with(
            ensure: 'directory',
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
          )
        }

        it {
          is_expected.to contain_file('/etc/clickhouse-server/conf.d/').with(
            ensure: 'directory',
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
            recurse: false,
            purge: false,
          )
        }

        it {
          is_expected.to contain_file('/etc/clickhouse-server/users.d/').with(
            ensure: 'directory',
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
            recurse: false,
            purge: false,
          )
        }

        it {
          is_expected.to contain_file('/etc/clickhouse-server/dict/').with(
            ensure: 'directory',
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
            recurse: false,
            purge: false,
          )
        }

        it { is_expected.not_to contain_file('/etc/clickhouse-server/conf.d/config.xml') }
      end

      context 'with keep_default_users set to false' do
        let(:facts) { os_facts }
        let(:params) { { keep_default_users: false } }

        it {
          is_expected.to contain_file('/etc/clickhouse-server/users.xml').with(
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
          ).with_content("<yandex>\r\n\t<users>\r\n\t</users>\r\n</yandex>\r\n")
        }
      end

      context 'with dict_dir overriden' do
        let(:facts) { os_facts }
        let(:params) { { dict_dir: '/etc/clickhouse-server/dictionaries' } }

        it {
          is_expected.to contain_file('/etc/clickhouse-server/dictionaries').with(
            ensure: 'directory',
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
            recurse: true,
            purge: true,
          )
        }

        it {
          is_expected.to contain_file('/etc/clickhouse-server/conf.d/config.xml').with(
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
          ).with_content(%r{<dictionaries_config>\/etc\/clickhouse-server\/dictionaries\/\*.xml<\/dictionaries_config>$})
        }
      end

      context 'with clickhouse_datadir overriden' do
        let(:facts) { os_facts }
        let(:params) { { clickhouse_datadir: '/mnt/data/clickhouse/' } }

        it {
          is_expected.to contain_file('/mnt/data/clickhouse/').with(
            ensure: 'directory',
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
          )
        }

        it {
          is_expected.to contain_file('/etc/clickhouse-server/conf.d/config.xml').with(
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
          ).with_content(%r{<path>\/mnt\/data\/clickhouse\/<\/path>$})
        }
      end

      context 'with clickhouse_tmpdir overriden' do
        let(:facts) { os_facts }
        let(:params) { { clickhouse_tmpdir: '/mnt/data/clickhouse/tmp/' } }

        it {
          is_expected.to contain_file('/mnt/data/clickhouse/tmp/').with(
            ensure: 'directory',
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
          )
        }

        it {
          is_expected.to contain_file('/etc/clickhouse-server/conf.d/config.xml').with(
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
          ).with_content(%r{<tmp_path>\/mnt\/data\/clickhouse\/tmp\/<\/tmp_path>$})
        }
      end

      context 'with override_options' do
        let(:facts) { os_facts }
        let(:params) { { override_options: { 'compression' => { 'case' => { 'method' => 'zstd' } } } } }

        it {
          is_expected.to contain_file('/etc/clickhouse-server/conf.d/config.xml').with(
            mode: '0664',
            owner: 'clickhouse',
            group: 'clickhouse',
          ).with_content(%r{<compression>\s*<case>\s*<method>\s*zstd\s*<\/method>\s*<\/case>\s*<\/compression>})
        }
      end
    end

    context 'clickhouse::server::service' do
      let(:facts) { os_facts }

      context 'with defaults' do
        let(:facts) { os_facts }

        it { is_expected.to contain_service('clickhouse-server') }
        it { is_expected.to contain_file('/etc/clickhouse-server/conf.d/config.xml').that_comes_before('Service[clickhouse-server]') }
        it { is_expected.to contain_service('clickhouse-server').that_requires('Package[clickhouse-server]') }
      end

      context 'with manage_package set to false' do
        let(:facts) { os_facts }
        let(:params) { { manage_package: false } }

        it { is_expected.to contain_service('clickhouse-server') }
        it { is_expected.not_to contain_service('clickhouse-server').that_requires('Package[clickhouse-server]') }
      end

      context 'with service_ensure set to stopped' do
        let(:facts) { os_facts }
        let(:params) { { service_ensure: 'stopped' } }

        it { is_expected.to contain_service('clickhouse-server').with(ensure: :stopped) }
      end

      context 'with service_enabled set to false' do
        let(:facts) { os_facts }
        let(:params) { { service_enabled: false } }

        it { is_expected.to contain_service('clickhouse-server').with(enable: false) }
      end
    end

    context 'with users' do
      let(:facts) { os_facts }
      let(:params) do
        {
          users: {
            'alice' => {
              'password'        => 'helloalice',
              'allow_databases' => ['db1', 'db2'],
              'networks'        => {
                'ip'          => ['::/0', '::'],
                'host'        => ['localhost', 'host1.local'],
                'host_regexp' => ['^local.*', '^remote.*'],
              },
            },
            'bob' => {
              'password' => '2e47bc89156722a5956f8a04adad0a701344f529427f673b5d52635dd053b9b4',
              'quota'    => 'test',
              'profile'  => 'test',
            },
          },
        }
      end

      it {
        is_expected.to contain_clickhouse__server__user('alice').with(
          password: 'helloalice',
          quota: 'default',
          profile: 'default',
          users_dir: '/etc/clickhouse-server/users.d',
          user_file_owner: 'clickhouse',
          user_file_group: 'clickhouse',
          allow_databases: ['db1', 'db2'],
          networks: { 'ip' => ['::/0', '::'], 'host' => ['localhost', 'host1.local'], 'host_regexp' => ['^local.*', '^remote.*'] },
        )
      }

      it {
        is_expected.to contain_clickhouse__server__user('bob').with(
          password: '2e47bc89156722a5956f8a04adad0a701344f529427f673b5d52635dd053b9b4',
          quota: 'test',
          profile: 'test',
          users_dir: '/etc/clickhouse-server/users.d',
          user_file_owner: 'clickhouse',
          user_file_group: 'clickhouse',
        )
      }

      it { is_expected.to contain_file('/etc/clickhouse-server/users.d/alice.xml') }

      it { is_expected.to contain_file('/etc/clickhouse-server/users.d/bob.xml') }
    end

    context 'with profiles' do
      let(:facts) { os_facts }
      let(:params) do
        {
          profiles: {
            'web' => {
              'max_threads'      => 1,
              'max_rows_to_read' => 100,
            },
            'readonly' => {
              'readonly' => 1,
            },
          },
        }
      end

      it { is_expected.to contain_clickhouse__server__profiles('profiles.xml') }

      it { is_expected.to contain_file('/etc/clickhouse-server/users.d/profiles.xml') }
    end

    context 'with quotas' do
      let(:facts) { os_facts }
      let(:params) do
        {
          quotas: {
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
                  'result_rows'    => 10_000,
                  'read_rows'      => 10_000,
                  'execution_time' => 50_000,
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
          },
        }
      end

      it { is_expected.to contain_clickhouse__server__quotas('quotas.xml') }

      it { is_expected.to contain_file('/etc/clickhouse-server/users.d/quotas.xml') }
    end

    context 'with dictionaries' do
      let(:facts) { os_facts }
      let(:params) { { dictionaries: ['test.xml', 'test2.xml'] } }

      it {
        is_expected.to contain_clickhouse__server__dictionary('test.xml').with(
          source: 'puppet:///modules/clickhouse/test.xml',
        )
      }

      it {
        is_expected.to contain_clickhouse__server__dictionary('test2.xml').with(
          source: 'puppet:///modules/clickhouse/test2.xml',
        )
      }

      it { is_expected.to contain_file('/etc/clickhouse-server/dict/test.xml') }

      it { is_expected.to contain_file('/etc/clickhouse-server/dict/test2.xml') }
    end

    context 'with replication' do
      let(:facts) { os_facts }
      let(:params) do
        {
          replication: {
            'zookeeper_servers' => ['172.0.0.1:2181', '172.0.0.2:2181'],
            'macros'            => {
              'replica' => 'host.local',
              'shard'   => 1,
            },
          },
        }
      end

      it { is_expected.to contain_clickhouse__server__macros('macros.xml') }

      it { is_expected.to contain_file('/etc/clickhouse-server/conf.d/macros.xml') }

      it { is_expected.to contain_file('/etc/clickhouse-server/conf.d/zookeeper.xml') }
    end

    context 'with remote servers' do
      let(:facts) { os_facts }
      let(:params) do
        {
          remote_servers: {
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
          },
        }
      end

      it { is_expected.to contain_clickhouse__server__remote_servers('remote_servers.xml') }

      it { is_expected.to contain_file('/etc/clickhouse-server/conf.d/remote_servers.xml') }
    end
  end
end
