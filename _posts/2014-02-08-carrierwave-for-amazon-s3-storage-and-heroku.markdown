---
layout: post
title: "Carrierwave for Amazon S3 Storage and Heroku"
date: 2014-02-08 20:59:13 +0800
comments: true
categories: [tech, carrierwave, rails]
---
### add gems to `Gemfile`
```
# https://gist.github.com/cblunt/1303386
# mini replacement for RMagick
# https://github.com/probablycorey/mini_magick
gem "mini_magick", "~> 3.6.0"
gem "carrierwave", "~> 0.9.0" # Otc 10, 2013
# https://github.com/carrierwaveuploader/carrierwave#using-amazon-s3
gem "fog", "~> 1.3.1" # Otc 10, 2013
```

###rails4 params issue for devise

`
$rails g migration add_avatar_to_users avatar:string
`
when generate a avatar for user, we should add `:avatar` to whitelist because of stronger parameters.

<!-- more -->

```
# controllers/registrations_controller.rb

class RegistrationsController < Devise::RegistrationsController
  ...

  private
    # https://gist.github.com/bluemont/e304e65e7e15d77d3cb9
    # fix strong paramter for avater
    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:name, :heard_how, :email, :password, :password_confirmation)
      end
      devise_parameter_sanitizer.for(:account_update) do |u| u.permit(:name, :email, :password, :password_confirmation, :current_password, :avatar)
      end
    end
end
```

###carrierwave config for amazon S3
```
# config/initializers/carrierwave.rb

CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider              => 'AWS',
    :aws_access_key_id     => ENV['S3_KEY'],
    :aws_secret_access_key => ENV['S3_SECRET'],
    :region                => ENV['S3_REGION']
    # :host                  => 's3.amazonaws.com'
    # :endpoint               => 'https://s3.example.com:8080'
  }
  config.fog_directory = ENV['S3_BUCKET_NAME']
  config.fog_public = false
end
```

generate an uploader
`rails generate uploader Base`

```ruby
# Rails.root/uploader/base_uploader.rb
# encoding: utf-8

class BaseUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  # storage :fog
  # storage :file

  include CarrierWave::MimeTypes
  process :set_content_type

  # Override the directory where uploaded files will be stored.
  # e.g.: "uploads/venue/photo/000/000/003/thumb_Limoni_-_overall-resized-1.jpg"
  def store_dir
    "#{base_store_dir}/#{model_id_partition}"
  end

  def base_store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end

  # e.g.: 1234 => "000/001/234"
  def model_id_partition
    ("%09d" % model.id).scan(/\d{3}/).join("/")
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
```
### setup graphicmagics(:gm) on heroku.
graphicmagics is not supported by heroku, so `MiniMagick.processor = :gm` doesn't work on heroku.
so add this to `Rails.root/uploader/base_uploader.rb`
```
# https://github.com/mcollina/heroku-buildpack-graphicsmagick
if !Rails.env.production?
  MiniMagick.processor = :gm
end
```

###use [rails_config](https://github.com/railsjedi/rails_config) gem to setup s3 account

references
----------

- [carrierwave-foramazon](https://github.com/carrierwaveuploader/carrierwave#using-amazon-s3)
- [ Configuration and Config Vars](https://devcenter.heroku.com/articles/config-vars)
- [test carrierwave with fog](http://www.zlu.me/blog/2012/07/17/testing-carrierwave-with-fog/)
- should test with [fog](http://fog.io/storage/) at first to make sure the account key and secret both work ok.
- [fog-aws-s3](http://rubydoc.info/github/stesla/fog/Fog/AWS/S3)
- [testing-carrierwave-with-fog/](http://www.zlu.me/blog/2012/07/17/testing-carrierwave-with-fog/)
- [example-app](https://github.com/laserlemon/figaro#how-does-it-work-with-heroku)
