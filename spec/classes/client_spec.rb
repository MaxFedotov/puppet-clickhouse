require 'spec_helper'

describe 'clickhouse::client' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end

    context 'with defaults' do
      let(:facts) { os_facts }

      it { is_expected.to contain_package('clickhouse-client') }
      it { is_expected.to contain_class('clickhouse::repo') }
    end

    context 'with manage_package set to true' do
      let(:params) { { manage_package: true } }
      let(:facts) { os_facts }

      it { is_expected.to contain_package('clickhouse-client') }
    end

    context 'with manage_package set to false' do
      let(:params) { { manage_package: false } }
      let(:facts) { os_facts }

      it { is_expected.not_to contain_package('clickhouse-client') }
    end

    context 'with manage_repo set to false' do
      let(:params) { { manage_repo: false } }
      let(:facts) { os_facts }

      it { is_expected.not_to contain_class('clickhouse::repo') }
      it { is_expected.to contain_package('clickhouse-client') }
    end
  end
end
