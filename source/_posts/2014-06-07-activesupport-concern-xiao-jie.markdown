---
layout: post
title: "ActiveSupport::Concern 小结"
date: 2014-06-07 22:23:58 +0800
comments: true
categories: [tech, rails, concern]
---

### ActiveSupport::Concern 被引入到 rails

根据这篇文章 [put-chubby-models-on-a-diet-with-concerns](http://signalvnoise.com/posts/3372-put-chubby-models-on-a-diet-with-concerns) 中这样一段话把它的意思说的很明白了：

{% blockquote %}
  This concern can then be mixed into all the models that are taggable and you’ll have a single place to update the logic and reason about it.
{% endblockquote %}

`Taggable` 是一个 `Module`，里面用来处理跟`tag`相关的逻辑。这样我们就可以把这个`Taggable`引入到跟这个相关的`models`里面。这样代码的可读性和维护性就提高了不少。

<!-- more -->

举一个简单的例子，比如一个项目中有很多model都需要有有判断这个 `model` 是否是 `active` 的。我们一般会给这个model加上一个`is_active`字段，然后再相应的model里面会有如下的方法。比如


```
class Post < ActiveRecord::Base

  # scopes
  scope :active, -> {where(is_active: true)}

  ...

  # instances methods
  def active?
    is_active
  end

  ...
end


class Advertisement < ActiveRecord::Base

  # scopes
  scope :active, -> {where(is_active: true)}

  ...

  # instances methods
  def active?
    is_active
  end

  ...
end

```

`Post` 和 `Advertisement` 都需要判断这个model 是不是 `active` 状态的，是否`active`这个逻辑属性在各个model里面的表现又是一致的，这样我们就可以通过 `ActiveSupport::Concern` 简化代码。

首先把相同的逻辑放到一个 `model` 里面去。定义scope，然后定义 `ClassMethods` 和 `instanceMethods`。

```ruby
# app/models/has_is_active.rb or app/modeles/concerns/has_is_active.rb
# for models with field :is_active

module HasIsActive
  extend ActiveSupport::Concern

  included do |base|
    scope :active, -> {where(is_active: true)}
  end

  module ClassMethods
    def all_active(reload = false)
      @all_active = nil if reload
      @all_active ||= active.all
    end
  end

  # instance methods
  def active?
    is_active
  end
end

```

然后我们把这个`model` `indclude` 到需要的model 里面去。

```ruby
class Post < ActiveRecord::Base

  # concerns
  include HasIsActive

  ...
end


class Advertisement < ActiveRecord::Base

  # concerns
  include HasIsActive

  ...
end

```

这里我们将 `has_is_active` 这个可重用的功能抽出来，然后多个model可以共用。这样就有遵循了`DRY`原则啦。

### ActiveSupport::Concern 用来规范model代码逻辑。

虽然我们主张 `fatter model, thinner controller`, 但如果`model`的代码太多，可读性和维护性则会大大下降。一个好的解决办法是把相关的逻辑代码放到 对应的 `ActiveSupport::Concern` 里面去。

```
#encoding: utf-8
class Event < ActiveRecord::Base

  # concerns
  include ApprovalRequired
  include OptionalChinese
  include TrackActivities # tracked the event action

  ...
```

一句话总结就是，使用 `ActiveSupport::Concern` 会使 model 代码简洁又好用。再次感谢[rain](http://hi.baidu.com/rainchen/item/ef36c917a23a9117e2f986f4) 悉心指导。


### ActiveSupport::Concern 由来

`mixin` 是把一个模块(Module)Mixin到某个对象中，以实现实现多重继承。那如果不用 `concern`, `HasIsActive` 这个model会写成怎么样呢？

```ruby
# app/models/has_is_active.rb or app/modeles/concerns/has_is_active.rb
# for models with field :is_active

module HasIsActive
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.extend ClassMethods
    base.class_eval do
      scope :active, where(is_active: true)
    end
  end

  module InstanceMethods
    def active?
      is_active
    end
  end

  module ClassMethods
    def all_active(reload = false)
      @all_active = nil if reload
      @all_active ||= active.all
    end
  end
end
```

这算是长久以来形成的一个 `common pattern`。使用这个钩子 `self.included` 让里面的代码在被 `include` 的时候调用。`base.send(:include, InstanceMethods)`, 用 `send` 方法 `include` `InstanceMethods`, 然后 `extend` `ClassMethods`, 就是把这些方法放到 `base` 的 `eigenclass` 里面。最后用 `class_eval` 打开这个类写 scope.

这个 `common pattern` 在不用 concern 的gem里面还是比较常见的。

### TODO: ActiveSupport::Concern 源码

##### 根据下面这篇文章研究下 源码
[activesupport-concern-digression](http://www.zhubert.com/blog/2013/06/13/activesupport-concern-digression/)

references:
-----------
- [rails 4.1 ActiveSupport::Concern](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html)
- [ihower rails 3 ActiveSupport::Concern](http://ihower.tw/blog/archives/3949)
- [ruby-mixins-activesupportconcern/](http://engineering.appfolio.com/2013/06/17/ruby-mixins-activesupportconcern/)
- [exploring-concerns-for-rails-4](http://blog.andywaite.com/2012/12/23/exploring-concerns-for-rails-4/)
