require 'spec_helper_acceptance'

describe 'clickhouse class' do
  shell('/opt/puppetlabs/puppet/bin/gem install xml-simple')
  describe 'with defaults' do
    let(:pp) do
      <<-MANIFEST
        class { 'clickhouse::server': }
      MANIFEST
    end

    it_behaves_like 'a idempotent resource'
  end

  describe 'with all options' do
    let(:pp) do
      <<-MANIFEST
        class { 'clickhouse::server':
          override_options => {
            'compression' => {
                'case' => {
                  'method' => 'zstd',
                }
            },
          },
          users => {
            'alice' => {
              'password' => 'helloAlice',
              'quota'    => 'test',
              'profile'  => 'test',
              'networks' => {
                'ip' => ['::/0']
              }
            }
          },
          profiles => {
            'test' => {
              'use_uncompressed_cache'             => 0,
              'log_queries'                        => 1,
              'max_memory_usage'                   => 100,
              'max_bytes_before_external_group_by' => 100,
            },
            'readonly' => {
              'log_queries' => 1,
              'readonly'    => 1,
            },
          },
          quotas => {
            'test' => {
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
                  'duration'       => 86400,
                  'queries'        => 2000,
                  'errors'         => 50,
                  'result_rows'    => 10000,
                  'read_rows'      => 10000,
                  'execution_time' => 50000,
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
          replication => {
            'zookeeper_servers' => ['172.0.0.1:2181', '172.0.0.2:2181'],
            'macros'            => {
              'replica' => 'host.local',
              'shard'   => 1,
            },
          },
          remote_servers => {
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
        }
      MANIFEST
    end

    it_behaves_like 'a idempotent resource'
  end
end
