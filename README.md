# OmniauthOpenWechat

微信开放平台 OAuth2 策略, 用于 PC 端网站扫一扫登录的实现.

使用前, 你需要到微信开放平台拿到你的 API KEY 与 API SECRET: <https://open.weixin.qq.com/>

微信开放平台资源地址: [开放平台规范说明](https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&lang=zh_CN&token=e0c21a47a4d714c8a1d6502e01c0962cb670e824)

## Installation

```ruby
gem 'omniauth-open-wechat'
```

    $ bundle

## Usage

在 `config/initializers/omniauth.rb`:
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :'open-wechat', ENV["WECHAT_APP_ID"], ENV["WECHAT_APP_SECRET"]
end
```

现在可以直接访问 `/auth/open-wechat`

## Auth Hash

```ruby
{
    :provider => "wechat",
    :uid => "123456789",
    :info => {
      nickname:   "Nickname",
      sex:        1,
      province:   "Changning",
      city:       "Shanghai",
      country:    "China",
      headimgurl: "http://image_url"
    },
    :credentials => {
        :token => "token",
        :refresh_token => "another_token",
        :expires_at => 7200,
        :expires => true
    },
    :extra => {
        :raw_info => {
          openid:     "openid"
          nickname:   "Nickname",
          sex:        1,
          province:   "Changning",
          city:       "Shanghai",
          country:    "China",
          headimgurl: "http://image_url"
        }
    }
}
```

## Contributing

1. Fork it ( https://github.com/windy/omniauth-open-wechat/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
