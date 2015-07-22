---
layout: post
title: add exception notification to Rails
date: 2015-07-21 12:15
categories: [tech, rails, exceptions]
---


### 1. add exception_notification gem

in Gemfile

```
# https://github.com/smartinez87/exception_notification
gem 'exception_notification', '~> 4.1.0'
```

### 2. in app/config/initialize/exception_notification.rb

```ruby
# Only send exception email on Production or Staging server
# type `LOCAL_PRODUCTION=1 rails s -e production` to trigger local production environment
# type `LOCAL_STAGING=1 rails s -e staging` to trigger local staging environment
if (Rails.env.production? || Rails.env.staging?) && !ENV['LOCAL_PRODUCTION'] && !ENV['LOCAL_STAGING']
  Rails.application.config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => Rails.application.secrets[:exception_email_prefix],
      :sender_address => '"notifier" ' + Rails.application.secrets[:exception_email_sender_address],
      :exception_recipients => Rails.application.secrets[:notification_receivers]
    }
end
```

### 3. on `config/application.rb` or other `env.rb`

```
  # https://github.com/smartinez87/exception_notification#actionmailer-configuration
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  # Config action_mailer
  config.action_mailer.smtp_settings = {
    address:        Rails.application.secrets.action_mailer_smtp_settings["address"],
    port:           587,
    user_name:      Rails.application.secrets.action_mailer_smtp_settings["user_name"],
    password:       Rails.application.secrets.action_mailer_smtp_settings["password"],
    authentication: 'plain',
    enable_starttls_auto: true
  }
```

### 4. set the config in `secrets.yml`

```
default: &DEFAULT
  notification_receivers: &notification_receivers
    - david@example.com

  action_mailer_smtp_settings:
    address: 'smtp.gmail.com'
    user_name: ''
    password: ''

  exception_email_prefix: '[Exception] '
  exception_email_sender_address: '<example@gmail.com>'
  notification_receivers:
    *notification_receivers

staging:
  <<: *DEFAULT
  secret_key_base: ''
```

