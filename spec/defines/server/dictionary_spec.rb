require 'spec_helper'

describe 'clickhouse::server::dictionary' do
  let(:title) { 'products.xml' }
  let(:params) do
    {
      dict_dir: '/etc/clickhouse-server/dict',
      dict_file_owner: 'clickhouse',
      dict_file_group: 'clickhouse',
      source: 'puppet:///modules/clickhouse/products.xml',
    }
  end

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }

      it { is_expected.to contain_file('/etc/clickhouse-server/dict/products.xml') }
    end
  end
end
