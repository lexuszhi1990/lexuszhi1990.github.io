---
layout: post
title: "Understand mixin and activesupport better"
date: 2014-02-07 16:00:05 +0800
comments: true
categories:
- ruby
- rails
- tech
---

### mixin 是把一个模块Mixin到某个对象中，以实现实现多重继承。

`include` 方法在Module对象中定义。
```
Module.private_methods.grep /inc/
=> [:included, :include]
```

使用的ruby version
```
$ruby -v
 => ruby 2.0.0p247 (2013-06-27 revision 41674) [x86_64-darwin12.4.0]
```

<!-- more -->

###  mixin example

```
class Base; end

class MyModule < Base; end

class Child < MyModule; end

# irb> Child.ancestors
#  => [Child, MyModule, Base, Object, Kernel, BasicObject]
```

如果使用include实现：
```
module MyModule
end

class Base
end

class Child < Base
  include MyModule
end

# irb> Child.ancestors
#  => [Child, MyModule, Base, Object, Kernel, BasicObject]
```

当类去包含一个module时，该module会被插入到祖先链当中，并且位于该类的正上方。

但如果MyModule中有一个方法，当类去包含这个模块的时候，它获得的是该模块的实例方法(instance methods)，而不是类方法(class methods)。类方法存在于eigenclass之中。
```
module MyModule
  def my_method; 'hello world!'; end
end

class MyClass
  include MyModule
end

MyClass.my_method
 => NoMethodError: undefined method `my_method' for MyClass:Class
    from (irb):9
    from /Users/david/.rvm/rubies/ruby-2.0.0-p247/bin/irb:16:in `<main>'

MyClass.new.my_method
 => "hello world!"
```
解决的办法是
```
class MyClass
  class << self
    include MyMod
  end
end
```
或者是用`class_eval`方法
```
MyClass.singleton_class.class_eval do
  include MyModule
end
```
这样MyModule就被添加到Myclass得eigenclass的祖先链之中。这种技术叫做类扩展(class extension)
```
MyClass.singleton_class.ancestors
  => [MyModule, Class, Module, Object, Kernel, BasicObject]
MyClass.my_method
  => "hello world!"
```

### Modules也可以被用于extend object
```
module MyMod; end

my_obj = Object.new
my_obj.extend MyMod
my_obj.singleton_class.ancestors
 => [MyMod, Object, Kernel, BasicObject]
```

在ruby中，每个object都有一个singleten class，Object#extend 跟Module#include类似，但是在一个object的singleton class上面作用。
```
class MyClass
  extend MyModule
end

MyClass.singleton_class.ancestors
 => [MyModule, Class, Module, Object, Kernel, BasicObject]
MyClass.my_method
 => "hello world!"
```

这样把模块通过混入(mixin)到类的eigenclass 中来定义类方法，这样技术叫做对象扩展。
```
Object.methods.grep /extend/
 => [:extend]
Object.private_methods.grep /extend/
 => [:extended]
```

下面来看一个完整的例子

```
module MyMod
  def self.included(target)
    puts "included into #{target}"
  end

  def self.extended(target)
    puts "extended into #{target}"
  end
end
```

```
class MyIncludeClass
  include MyMod
end

irb> included into MyIncludeClass

irb> MyIncludeClass.ancestors
 => [MyIncludeClass, MyMod, Object, Kernel, BasicObject]
irb> MyIncludeClass.singleton_class.ancestors
 => [Class, Module, Object, Kernel, BasicObject]
```

```
class MyExtendClass
  extend MyMod
end

irb> extended into MyExtendClass

irb> MyExtendClass.ancestors
 => [MyExtendClass, Object, Kernel, BasicObject]
irb> MyExtendClass.singleton_class.ancestors
 => [MyMod, Class, Module, Object, Kernel, BasicObject]
```

### ActiveSupport::Concern
这样久而久之，像这样创建为了mixin的module渐渐变成一个common pattern ：
```ruby
module MyMod
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.extend ClassMethods
    base.class_eval do
      a_class_method
    end
  end

  module InstanceMethods
    def an_instance_method
    end
  end

  module ClassMethods
    def a_class_method
      puts "a_class_method called"
    end
  end
end

class MyClass
  include MyMod
end

2.0.0p247 :045 >
a_class_method called
 => MyClass

2.0.0p247 :046 > MyClass.ancestors
 => [MyClass, MyMod::InstanceMethods, MyMod, Object, Kernel, BasicObject]
2.0.0p247 :047 > MyClass.singleton_class.ancestors
 => [MyMod::ClassMethods, Class, Module, Object, Kernel, BasicObject]
```

可以看到，这个但单独的module添加了 instance methods, class methods, 并且直接调用了一个 `a_class_method`。
`ActiveSupport::Concern` 概况了这个模式。下面是如何用`ActiveSupport::Concern`重写这个module。

```
module MyMod
  extend ActiveSupport::Concern

  included do
    a_class_method
  end

  def an_instance_method
  end

  module ClassMethods
    def a_class_method
      puts "a_class_method called"
    end
  end
end
```

然后
```
class MyClass
  include MyMod
end

pry(main)> MyClass.ancestors
=> [MyClass,
 MyMod,
 Object,
 PP::ObjectMixin,
 ActiveSupport::Dependencies::Loadable,
 JSON::Ext::Generator::GeneratorMethods::Object,
 Kernel,
 BasicObject]
```

这样 nested InstanceMethods 被移除了，而且instence method被直接定义在module之中,这是因为MyMod已经在 ancestor chain 中。
`ActiveSupport::Concern` 去除了在模式中得一些 **boilerplate code**。不需要去定义included hook。不需要去`extend SomeTargetClass`，不需要用`class_eval`去打开一个类。


###  ActiveSupport::Concern does a lazy evaluation
如果MyModA在被included到一个Class的适合有一些其他的操作，
```
module MyModA
  def self.included(target)
    target.class_eval do
      has_many :squirrels
    end
  end
end

module MyModB
  include MyModA
end

class MyClass
  include MyModB
end

```
那么当MyModA被include进MyModB，`self.included()`会执行，但如果`has_many()` 在MyModB中没有定义，则会出错...

```
2.0.0-p247 :019 > module MyModB
2.0.0-p247 :020?>     include MyModA
2.0.0-p247 :021?>   end
NoMethodError: undefined method `has_many' for MyModB:Module
  from (irb):15:in `block in included'
  from (irb):14:in `class_eval'
  from (irb):14:in `included'
  from (irb):20:in `include'
  from (irb):20:in `<module:MyModB>'
  from (irb):19
```

`ActiveSupport::Concern`会推迟这些included hooks，直到一个module没有被included进`ActiveSupport::Concern`，并以此回避了这个问题。


```
module MyModA
  extend ActiveSupport::Concern

  included do
    has_many :squirrels
  end
end

module MyModB
  extend ActiveSupport::Concern
  include MyModA
end

class MyClass
  def self.has_many(*args)
    puts "has_many(#{args.inspect}) called"
  end

  include MyModB
end
```
这样会输出
```
has_many([:squirrels]) called
=> MyClass
```

然后再探究一下MyClass的结构
```
[10] pry(main)> MyClass.ancestors
=> [MyClass,
 MyModB,
 MyModA,
 Object,
 PP::ObjectMixin,
 ActiveSupport::Dependencies::Loadable,
 JSON::Ext::Generator::GeneratorMethods::Object,
 Kernel,
 BasicObject]
```
这样 MyModA 和MyModB 都被包含到MyClass得祖先链当中。

```
[11] pry(main)> MyClass.singleton_class.ancestors
=> [Class,
 StateMachine::MacroMethods,
 Module,
 ActiveSupport::Dependencies::ModuleConstMissing,
 Object,
 PP::ObjectMixin,
 ActiveSupport::Dependencies::Loadable,
 JSON::Ext::Generator::GeneratorMethods::Object,
 Kernel,
 BasicObject]
 ```

### conlusion

But why is ActiveSupport::Concern called “Concern”? The name Concern comes from AOP (http://en.wikipedia.org/wiki/Aspect-oriented_programming). Concerns in AOP encapsulate a “cohesive area of functionality”. Mixins act as Concerns when they provide cohesive chunks of functionality to the target class. Turns out using mixins in this fashion is a very common practice.

ActiveSupport::Concern provides the mechanics to encapsulate a cohesive chunk of functionality into a mixin that can extend the behavior of the target class by annotating the class’ ancestor chain, annotating the class’ singleton class’ ancestor chain, and directly manipulating the target class through the included() hook.

So….

Is every mixin a Concern? No. Is every ActiveSupport::Concern a Concern? No.

While I’ve used ActiveSupport::Concern to build actual Concerns, I’ve also used it to avoid writing out the boilerplate code mentioned above. If I just need to share some instance methods and nothing else, then I’ll use a bare module.

Modules, mixins and ActiveSupport::Concern are just tools in your toolbox to accomplish the task at hand. It’s up to you to know how the tools work and when to use them.


### 看一个实际的例子
如果项目中不少module都需要有有`is_active`字段，并且都是有相同的逻辑。
这可以用`ActiveSupport::Concern`来重构。
```
# app/models/has_is_active.rb
# for models with field :is_active
module HasIsActive
  extend ActiveSupport::Concern

  included do |base|
    scope :active, where(is_active: true)
  end

  module ClassMethods
    def all_active(reload = false)
      @all_active = nil if reload
      @all_active ||= active.all
    end
  end

  def active?
    is_active
  end
end
```

然后在需要的module中
```
# app/models/advertisements.rb
class Advertisement < ActiveRecord::Base
  include HasIsActive
end

Advertisement.active.count
  => 2
Advertisement.all_active.count
  => 2
Advertisement.first.active?
  => false
Advertisement.ancestors
=> [Advertisement(id: integer, is_active: boolean)
 .....
 HasIsActive,
 .....
```

###  ActiveSupport::Concern 源码

```
# lib/active_support/concern.rb
module Concern
  def self.extended(base) #:nodoc:
    base.instance_variable_set("@_dependencies", [])
  end

  def append_features(base)
    if base.instance_variable_defined?("@_dependencies")
      base.instance_variable_get("@_dependencies") << self
      return false
    else
      return false if base < self
      @_dependencies.each { |dep| base.send(:include, dep) }
      super
      base.extend const_get("ClassMethods") if const_defined?("ClassMethods")
      base.class_eval(&@_included_block) if instance_variable_defined?("@_included_block")
    end
  end

  def included(base = nil, &block)
    if base.nil?
      @_included_block = block
    else
      super
    end
  end
end
```

---------
- [ruby-mixins-activesupportconcern/](http://engineering.appfolio.com/2013/06/17/ruby-mixins-activesupportconcern/)
- [exploring-concerns-for-rails-4](http://blog.andywaite.com/2012/12/23/exploring-concerns-for-rails-4/)
- [include](http://www.ruby-doc.org/core-2.0.0/Module.html#method-i-included)
- [extent](http://www.ruby-doc.org/core-2.0.0/Module.html#method-i-extended)
