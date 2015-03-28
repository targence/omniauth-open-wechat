require 'spec_helper'

describe OmniAuth::Strategies::OpenWechat do
  let(:request) { double('Request', :params => {}, :cookies => {}, :env => {}, :scheme=>"http", :url=>"example.com") }
  let(:app) { ->{[200, {}, ["Hello."]]}}
  let(:client){OAuth2::Client.new('appid', 'secret')}

  subject do
    OmniAuth::Strategies::OpenWechat.new(app, 'appid', 'secret', @options || {}).tap do |strategy|
      allow(strategy).to receive(:request) {
        request
      }
    end
  end

  before do
    OmniAuth.config.test_mode = true
  end

  after do
    OmniAuth.config.test_mode = false
  end

  describe '#client_options' do
    it 'has site' do
      expect(subject.client.site).to eq('https://api.weixin.qq.com')
    end

    it 'has authorize_url' do
      expect(subject.client.options[:authorize_url]).to eq('https://open.weixin.qq.com/connect/qrconnect#wechat_redirect')
    end

    it 'has token_url' do
      expect(subject.client.options[:token_url]).to eq('/sns/oauth2/access_token')
    end
  end

  describe "#authorize_params" do
    it "default scope is snsapi_userinfo" do
      expect(subject.authorize_params[:scope]).to eq("snsapi_login")
    end
  end

  describe "#token_params" do
    it "token response should be parsed as json" do
      expect(subject.token_params[:parse]).to eq(:json)
    end
  end

  describe 'state' do
    it 'should set state params for request as a way to verify CSRF' do
      expect(subject.authorize_params['state']).not_to be_nil
      expect(subject.authorize_params['state']).to eq(subject.session['omniauth.state'])
    end
  end


  describe "#request_phase" do
    it "redirect uri includes 'appid', 'redirect_uri', 'response_type', 'scope', 'state' and 'wechat_redirect' fragment " do
      callback_url = "http://exammple.com/callback"

      allow(subject).to receive(:callback_url).and_return(callback_url)
      expect(subject).to receive(:redirect) { |redirect_url|
        uri = URI.parse(redirect_url)
        expect(uri.fragment).to eq("wechat_redirect")
        params = CGI::parse(uri.query)
        expect(params["appid"]).to eq(['appid'])
        expect(params["redirect_uri"]).to eq([callback_url])
        expect(params["response_type"]).to eq(['code'])
        expect(params["scope"]).to eq(['snsapi_login'])
        expect(params["state"]).to eq([subject.session['omniauth.state']])
      }

      subject.request_phase
    end
  end

  describe "#build_access_token" do
    it "request includes 'appid', 'secret', 'code', 'grant_type' and will parse response as json"do
      allow(subject).to receive(:client) { client }
      allow(subject).to receive(:request) { double("request", params:{"code"=>"server_code"}) }
      expect(client).to receive(:get_token).with({
        "appid" => "appid",
        "secret" => "secret",
        "code" => "server_code",
        "grant_type" => "authorization_code",
        :parse => :json
      },{})
      subject.send(:build_access_token)
    end
  end
end
