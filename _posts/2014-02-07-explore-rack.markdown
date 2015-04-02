---
layout: post
title: "explore rack"
date: 2014-02-07 21:30:16 +0800
comments: true
published: false
categories: [tech, rack]
---

The Rack protocol is very simple: a Rack application is simply a Ruby object with a call method. That method should accept an environment hash describing the incoming request and return a three-element array in the form of: [status, headers, body], where:
status is the HTTP status code.
headers is a hash of HTTP headers for the response.
body is the actual body of the response (e.g. the HTML you want to
display). The body must also respond to each.

<!-- more -->

```
# gems/rack-1.5.2/lib/rack/lint.rb


def _call(env)
  ## It takes exactly one argument, the *environment*
  assert("No env given") { env }
  check_env env

  env['rack.input'] = InputWrapper.new(env['rack.input'])
  env['rack.errors'] = ErrorWrapper.new(env['rack.errors'])

  ## and returns an Array of exactly three values:
  status, headers, @body = @app.call(env)
  ## The *status*,
  check_status status

  ....

end


```


### builder


Rack::Builder implements a small DSL to iteratively construct Rack applications

```
# gems/rack-1.5.2/lib/rack/builder.rb

class Builder
  def self.parse_file(config, opts = Server::Options.new)
    options = {}
    if config =~ /\.ru$/
      cfgfile = ::File.read(config)
      if cfgfile[/^#\\(.*)/] && opts
        options = opts.parse! $1.split(/\s+/)
      end
      cfgfile.sub!(/^__END__\n.*\Z/m, '')
      app = new_from_string cfgfile, config
    else
      require config
      app = Object.const_get(::File.basename(config, '.rb').capitalize)
    end
    return app, options
  end
```


### rake middlewate

从下至上的执行顺序

```
rake middleware
use Rack::Sendfile
use ActionDispatch::Static
use Rack::Lock
use #<ActiveSupport::Cache::Strategy::LocalCache::Middleware:0x007f957ddfe958>
use Rack::Runtime
use Rack::MethodOverride
use ActionDispatch::RequestId
use Rails::Rack::Logger
use ActionDispatch::ShowExceptions
use ActionDispatch::DebugExceptions
use BetterErrors::Middleware
use ActionDispatch::RemoteIp
use ActionDispatch::Reloader
use ActionDispatch::Callbacks
use ActiveRecord::Migration::CheckPending
use ActiveRecord::ConnectionAdapters::ConnectionManagement
use ActiveRecord::QueryCache
use ActionDispatch::Cookies
use ActionDispatch::Session::CookieStore
use ActionDispatch::Flash
use ActionDispatch::ParamsParser
use Rack::Head
use Rack::ConditionalGet
use Rack::ETag
use Warden::Manager
run Ezitask::Application.routes
```

### lint

在電腦科學中，lint是一種工具程式的名稱，它用來標記原始碼中，某些可疑的、不具結構性（可能造成bug）的段落。它是一種靜態程序分析工具，最早適用於C語言，在UNIX平台上開發出來。後來它成為通用術語，可用於描述在任何一種電腦程式語言中，用來標記原始碼中有疑義段落的工具。

[lint](http://zh.wikipedia.org/wiki/Lint)

```
                               url.parse(string).query
                                           |
           url.parse(string).pathname      |
                       |                   |
                       |                   |
                     ------ -------------------
http://localhost:8888/start?foo=bar&hello=world
                                ---       -----
                                 |          |
                                 |          |
              querystring(string)["foo"]    |
                                            |
                         querystring(string)["hello"]
```

references
---------
- [alony-rack-ppt](https://speakerdeck.com/alony/rack)
- [rake-wiki](https://github.com/rack/rack/wiki)
- [rake-offical](http://rack.github.io/)
- [ruby-on-rack-2-the-builder](http://m.onkey.org/ruby-on-rack-2-the-builder)

