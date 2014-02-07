---
layout: post
title: "Eigenclass and methods in Ruby"
date: 2014-02-07 16:04:47 +0800
comments: true
categories:
- ruby
- tech
---

首先创建一个MyClass类，和它的对象 my_object
```
class MyClass
  def say
    "hello world"
  end

  def MyClass.a_singleton_method
    "a singleton method"
  end
end

my_object = MyClass.new # create a instance object

```

Ruby有一种特殊的基础Class关键字的语法，它可以让你进入该eigenclass的作用域
```
class << my_object
  // your code here.
end
```
所以, `a_singleton_method`也用如下方式定义：
```
class MyClass
  class << self
    def a_singleton_method
      "a singleton method"
    end
  end
end
```

每个对象都有自己“真正的类“，要么是普通类，或者是eigenclass。
```
object_singleton_class = my_object.singleton_class
 => #<Class:#<MyClass:0x007fbb84c652b8>>
class_singleton_class = MyClass.singleton_class
 => #<Class:MyClass>
```

一个对象的eigenclass的超类是这个对象的类
```
my_object.class
 => MyClass
my_object.singleton_class.superclass
 => MyClass
```

一个类的eigenclass的超类是这个类的超类的eigenclass
```
MyClass.singleton_class.superclass
 => #<Class:Object>
MyClass.superclass.singleton_class
 => #<Class:Object>
```

### singleton methods
Ruby允许给单个对象增加一个方法。比如给my_object 添加一个 hello 方法。
```
def my_object.hello
  "hello" + self.to_s
end

my_object.hello
 => "hello#<MyClass:0x007fbb84c652b8>"
```
对比一下类方法和单件方法
```
def my_object.hello; "hello" + self.to_s; end
def Myclass.a_singleton_method; "a singleton method"; end
```

如果是在类定义中写入代码，那么`self`就是类本身，所以可以利用`self`替换类名来定义类方法。
```
def self.a_singleton_method; "a singleton method"; end
```

```
def Object.method
  # my method here
end
```
这里的`Object`可以是对象引用，常量名，或`self`。

###method dispath
对象的方法存在于对象所属的类中（从类的角度来说，叫做实例方法`instance method`）。
当调用一个方法时候，Ruby会先向右一步来到接收者所属的类，然后一直向上查找祖先链，直到找到该方法或到链的顶端为止。

```
MyClass.ancestors
 => [MyClass, Object, Kernel, BasicObject]
MyClass.instance_methods.grep /say/
 => [:say]
my_object.say
 => "hello world"

BasicObject.instance_methods
 => [:==, :equal?, :!, :!=, :instance_eval, :instance_exec, :__send__, :__id__]
my_object != Class
 => true
```

当一个对象调用`singleton methods`，会爆出`NoMethodError`错误。
```
my_object.a_singleton_method
 => NoMethodError: undefined method `a_singleton_method' for #<MyClass:0x007fbb84c652b8>
```
因为这个方法是存放在Myclass的eigenclass之中的。
```
MyClass.a_singleton_method
 => "a singleton method"
```

那现在就获取祖先链对象的eigenclass。
```
Object.singleton_class
 => #<Class:Object>
Kernel.singleton_class
 => #<Class:Kernel>
BasicObject.singleton_class
 => #<Class:BasicObject>
BasicObject.singleton_class.class
 => Class
```

则会如下一张结构图
```
                                                  Class
                                                    |
                                                    |S
                                                    |
                                    E
                   BasicObject--------------> #<Class:BasicObject>
                      ^                             ^
                      |                             |
                      |S                            |S
                      |                             |
                                    E
                   Kernel     --------------> #<Class:Kernel>
                      ^                             ^
                      |                             |
                      |S                            |S
                      |                             |
                                    E
                   Object     --------------> #<Class:Object>
                      ^                             ^
                      |                             |
                      |S                            |S
                      |                             |
                                    E
    C ------->     MyClass     --------------> #<Class:MyClass>
     |        ----------------              ----------------
     |        methods: [:say]               methods: [:a_singleton_method]
     |                ^
     |                |
     |                | S
     |                |
     |     E
my_object--->    #my_object(#<Class:#<MyClass:0x007fbb84c652b8>>)
              ----------------
              methods: [:hello]
                                               C = Class
                                               E = eigenclass
                                               S = Supernclass
```

可以看出，出来BasicObject之外，每个类有且只有一个超类。这就意味着任何类有且只有一条向上到BasicObject的祖先链。
方法查找是通过深入向右一步，然后向上查找依次查找该方法。`my_object.say`向右一步，进入这个接受者真正的类`#my_object`，然后从`#my_object`向上查找。`MyClass.a_singleton_method`向右一步，进入这个接受者真正的类`#<Class:MyClass>`,然后开始查找。
当调用一个方法，接受者会扮演`self`角色。当没有明确指定接收的方法调(`define_method`)用，都当成是调用`self`的方法。当定义一个module或class时，该module扮演`self`的角色。

### more tips
1. 对象是由一组实例变量和一个类的引用组成。这个对象要么是普通对象，要么是模块。
2. 只有一种module，可以是普通module，class，eigenclass，或代理类。
3. 只有一种方法，存在于一种module中。一个module基本是有一组方法组成。
4. 类本身是class类的对象。类的名字不过是一个常量而已。常量像文件系统一样，按照树形结构组织。module和class的名字扮演目录的角色，其他普通常量扮演文件的角色。
5. Class是Module的子类。类可以被(new()方法)实体化，并被组织成层次结构(superclass()方法)。
6. 实例变量用于都被认定为`self`的实例变量。

### Ruby Dynamic Features

#### before work
`class Dragon; end`

#### Dynamic define **`Drango.foo`**

`instance_eval`用与修改self，`class_eval`用于修改`self`和当前类
程序会再三个地方关闭一个旧的作用域，并打开一个新的作用域：

1. 类定义 => `class`
2. 模块定义 => `module`
3. 方法定义 => `def`

`class`关键字会打卡一个新的作用域，这样将丧失当前绑定的可见性。所以使用`class_eval`即可扁平作用域
类方法的实质是一个类的单件方法。
当向一个对象搜索它的类时候，都会有一个特有的隐藏类。这个类成为对象的eigenclass。

```ruby
# 使用 `self.method` define class method
Dragon.class_eval do
  def self.foo
    puts "bar"
  end
end
Dragon.foo # bar
```

have access to local variables outside of the block.
```ruby
Dragon.instance_eval do
  def foo
    puts "bar"
  end
end
Dragon.foo # bar
```

```ruby
metaclass = (class << Dragon; self; end)
metaclass.instance_eval do # 用 class_eval 也可以
    define_method("foo") { puts "bar" }
end
Dragon.foo # bar

singletonclass = Dragon.singleton_class # get the sinleton_class
singletonclass => `#<Class:Dragon>`
metaclass      => `#<Class:Dragon>`
```

```ruby
Dragon.singleton_class.instance_eval do
  define_method("foo2") {puts "bar2"}
end

Dragon.foo2 # bar2
```

```ruby
Dragon.class.instance_eval do # 這裡用 class_eval 也可以。Dragon.class => Class
    define_method("foo") { puts "bar" }
end
Dragon.foo # bar
String.foo # bar，所有類別都被污染啦!! bad idea!!
```

- "def method_name" define instance method for current class
- "define_method" defind instance method for self (must be class object)
- "def object.method_name" defines instance method for current object's eigenclass

```
mechanism                 self(current object)    method definition(current class)    new scope?
class Dragon                    Dragon                Dragon                              yes
class << Dragon’s eigenclass    Dragon’s eigenclass   Dragon’s eigenclass               yes
Dragon.class_eval             Dragon                Dragon                              no
Dragon.instance_eval          Dragon                Dragon’s eigenclass                 no
```

class_eval 和 instance_eval 的一个重要区别是前者的 current class 是 receiver ，而后者的 current class 是 receiver 的 eigen class

references
----------
- [how-ruby-method-dispatch-works](http://blog.jcoglan.com/2013/05/08/how-ruby-method-dispatch-works/)
- [ruby module](http://ruby-doc.org/core-2.0.0/Module.html)
- [ruby object](http://ruby-doc.org/core-2.0.0/Object.html)
- [ruby class](http://www.ruby-doc.org/core-2.0.0/Class.html)
- [ruby methods doc](http://www.ruby-doc.org/core-2.0.0/doc/syntax/methods_rdoc.html)
- [ruby-mixins-activesupportconcern](http://engineering.appfolio.com/2013/06/17/ruby-mixins-activesupportconcern/)
- [Ruby Dynamic Features](http://ihower.tw/blog/archives/1698)
- [self, current class, class_eval, instance_eval](https://gist.github.com/ihower/366372)
