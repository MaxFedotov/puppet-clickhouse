require 'spec_helper'

describe 'clickhouse::repo' do
  context 'on Debian' do
    let(:facts) do
      {
        os: {
          family: 'Debian',
          name: 'Debian',
          release: {
            major: '9',
          },
        },
        osfamily: 'Debian',
      }
    end

    it {
      is_expected.to contain_apt__source('clickhouse-yandex').with(
        name: 'clickhouse-yandex',
        location: 'http://repo.yandex.ru/clickhouse/deb/stable/',
        release: 'main/',
        repos: '',
      )
    }
  end

  context 'on RedHat' do
    let(:facts) do
      {
        os: {
          family: 'RedHat',
          name: 'CentOS',
          release: {
            major: '7',
          },
        },
        osfamily: 'RedHat',
      }
    end

    it {
      is_expected.to contain_yumrepo('clickhouse-altinity').with(
        name: 'clickhouse-altinity',
        baseurl: 'https://packagecloud.io/altinity/clickhouse/el/$releasever/$basearch',
        enabled: 1,
        gpgcheck: 0,
        gpgkey: 'https://packagecloud.io/altinity/clickhouse/gpgkey',
      )
    }
  end
end
