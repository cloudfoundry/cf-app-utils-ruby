require 'spec_helper'

describe CF::App::Credentials do
  let(:vcap_services_v1) do
    {
        'cleardb-n/a' => [
            {
                'name' => 'master-db',
                'label' => 'cleardb-n/a',
                'tags' => [
                    'mysql',
                    'relational'
                ],
                'plan' => 'scream',
                'credentials' => {
                    'jdbcUrl' => 'jdbc:mysql://640cd7d903851807:cc89b00738b95a69@cleardb.example.com:3306/db_29098221a2dc0c59',
                    'uri' => 'mysql://640cd7d903851807:cc89b00738b95a69@cleardb.example.com:3306/db_29098221a2dc0c59?reconnect=true',
                    'name' => 'db_29098221a2dc0c59',
                    'hostname' => 'cleardb.example.com',
                    'port' => '3306',
                    'username' => '640cd7d903851807',
                    'password' => 'cc89b00738b95a69'
                }
            },
            {
                'name' => 'slave-db',
                'label' => 'cleardb-n/a',
                'tags' => [
                    'mysql',
                    'relational'
                ],
                'plan' => 'scream',
                'credentials' => {
                    'jdbcUrl' => 'jdbc:mysql://1b66152fc013c97e:7276a72689ddf6f3@cleardb.example.com:3306/db_f542acb65cfc54a1',
                    'uri' => 'mysql://1b66152fc013c97e:7276a72689ddf6f3@cleardb.example.com:3306/db_f542acb65cfc54a1?reconnect=true',
                    'name' => 'db_f542acb65cfc54a1',
                    'hostname' => 'cleardb.example.com',
                    'port' => '3306',
                    'username' => '1b66152fc013c97e',
                    'password' => '7276a72689ddf6f3'
                }
            }
        ],

        'rediscloud-dev-n/a' => [
            {
                'name' => 'queue',
                'label' => 'rediscloud-dev-n/a',
                'tags' => [
                    'redis',
                    'key-value'
                ],
                'plan' => '100mb',
                'credentials' => {
                    'port' => '17345',
                    'hostname' => 'garantiadata.example.com',
                    'password' => '3a9c2eb0ed895ab1'
                }
            }
        ]
    }
  end

  let(:vcap_services_v2) do
    {
        'cleardb' => [
            {
                'name' => 'master-db',
                'label' => 'cleardb',
                'tags' => [
                    'mysql',
                    'relational'
                ],
                'plan' => 'scream',
                'credentials' => {
                    'jdbcUrl' => 'jdbc:mysql://640cd7d903851807:cc89b00738b95a69@cleardb.example.com:3306/db_29098221a2dc0c59',
                    'uri' => 'mysql://640cd7d903851807:cc89b00738b95a69@cleardb.example.com:3306/db_29098221a2dc0c59?reconnect=true',
                    'name' => 'db_29098221a2dc0c59',
                    'hostname' => 'cleardb.example.com',
                    'port' => '3306',
                    'username' => '640cd7d903851807',
                    'password' => 'cc89b00738b95a69'
                }
            },
            {
                'name' => 'slave-db',
                'label' => 'cleardb',
                'tags' => [
                    'mysql',
                    'relational'
                ],
                'plan' => 'scream',
                'credentials' => {
                    'jdbcUrl' => 'jdbc:mysql://1b66152fc013c97e:7276a72689ddf6f3@cleardb.example.com:3306/db_f542acb65cfc54a1',
                    'uri' => 'mysql://1b66152fc013c97e:7276a72689ddf6f3@cleardb.example.com:3306/db_f542acb65cfc54a1?reconnect=true',
                    'name' => 'db_f542acb65cfc54a1',
                    'hostname' => 'cleardb.example.com',
                    'port' => '3306',
                    'username' => '1b66152fc013c97e',
                    'password' => '7276a72689ddf6f3'
                }
            }
        ],

        'rediscloud-dev' => [
            {
                'name' => 'queue',
                'label' => 'rediscloud-dev',
                'tags' => [
                    'redis',
                    'key-value'
                ],
                'plan' => '100mb',
                'credentials' => {
                    'port' => '17345',
                    'hostname' => 'garantiadata.example.com',
                    'password' => '3a9c2eb0ed895ab1'
                }
            }
        ],

        'github-repo-2' => [
            {
                'name' => 'github-repository',
                'label' => 'github-repo-2',
                'tags' => [
                    'github'
                ],
                'plan' => 'free',
                'credentials' => {
                    'username' => 'octocat',
                    'access_token' => 'some-token'
                }
            }
        ]
    }
  end

  describe 'v1 format' do
    let(:vcap_services) { vcap_services_v1 }

    before :each do
      ENV['VCAP_SERVICES'] = JSON.dump(vcap_services_v1)
      CF::App::Service.instance_variable_set :@services, nil
    end

    describe '.find_by_service_name' do
      it 'returns credentials for the service with the given name' do
        expect(CF::App::Credentials.find_by_service_name('master-db')).to eq(vcap_services['cleardb-n/a'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_name('slave-db')).to eq(vcap_services['cleardb-n/a'][1]['credentials'])
        expect(CF::App::Credentials.find_by_service_name('queue')).to eq(vcap_services['rediscloud-dev-n/a'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_name('non-existent')).to be_nil
      end
    end

    describe '.find_by_service_tag' do
      it 'returns credentials for the service with the given tag' do
        expect(CF::App::Credentials.find_by_service_tag('mysql')).to eq(vcap_services['cleardb-n/a'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_tag('relational')).to eq(vcap_services['cleardb-n/a'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_tag('redis')).to eq(vcap_services['rediscloud-dev-n/a'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_tag('non-existent')).to be_nil
      end
    end

    describe '.find_by_service_label' do
      it 'returns credentials for the service with the given label' do
        expect(CF::App::Credentials.find_by_service_label('cleardb')).to eq(vcap_services['cleardb-n/a'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_label('rediscloud-dev')).to eq(vcap_services['rediscloud-dev-n/a'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_label('redis')).to be_nil
        expect(CF::App::Credentials.find_by_service_label('non-existent')).to be_nil
      end
    end
  end

  describe 'v2 format' do
    let(:vcap_services) { vcap_services_v2 }

    before :each do
      ENV['VCAP_SERVICES'] = JSON.dump(vcap_services_v2)
      CF::App::Service.instance_variable_set :@services, nil
    end

    describe '.find_by_service_name' do
      it 'returns credentials for the service with the given name' do
        expect(CF::App::Credentials.find_by_service_name('master-db')).to eq(vcap_services['cleardb'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_name('slave-db')).to eq(vcap_services['cleardb'][1]['credentials'])
        expect(CF::App::Credentials.find_by_service_name('queue')).to eq(vcap_services['rediscloud-dev'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_name('non-existent')).to be_nil
      end
    end

    describe '.find_by_service_tag' do
      it 'returns credentials for the service with the given tag' do
        expect(CF::App::Credentials.find_by_service_tag('mysql')).to eq(vcap_services['cleardb'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_tag('relational')).to eq(vcap_services['cleardb'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_tag('redis')).to eq(vcap_services['rediscloud-dev'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_tag('non-existent')).to be_nil
      end
    end

    describe '.find_by_service_label' do
      it 'returns credentials for the service with the given label' do
        expect(CF::App::Credentials.find_by_service_label('cleardb')).to eq(vcap_services['cleardb'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_label('rediscloud-dev')).to eq(vcap_services['rediscloud-dev'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_label('github')).to eq(vcap_services['github-repo-2'][0]['credentials'])
        expect(CF::App::Credentials.find_by_service_label('redis')).to be_nil
        expect(CF::App::Credentials.find_by_service_label('non-existent')).to be_nil
      end
    end
  end
end


