---
layout: post
title: "backbone Summary"
date: 2014-05-11 21:03:37 +0800
comments: true
categories: [backbone, frontend]
published: true
---

### Backbone.js MVC

Backbone.js gives structure to web applications by providing models with key-value
binding and custom events, collections with a rich API of enumerable functions, views
with declarative event handling, and connects it all to your existing API over a RESTful JSON interface.

所以backbone的特点可有由一下几点概况： MVC， EVENTS， RESTFUL。

- View 的划分将页面上的视图元素解耦，粒度细化。View 间通过事件（EVENT）和 Model 通讯，避免了 DOM 事件的滥用。
- Model 和 Restful 的通讯方式对于后端人员非常友好。
- MVC 架构清晰。可定制性较高
- Collection/Model 抽象了以前杂乱的 AJAX 请求，CRUD 请求变得非常非常方便。
- View -> Model 单向依赖

<!-- more -->

其实backbone只是对前端MVC概念的一次封装。
Backbone 其实并不是框架，而且 Backbone 特意不愿意把自己做成一个框架。建议用 Marionette 替换列
表上的 Backbone，至少 Marionette 基于 Backbone，且看起来像一个框架。[lgn21st 的意思](http://ruby-china.org/topics/14415)


### RAILS BACKBONE

GEM:
目前用得是这个[railsy_backbone gem](https://github.com/westonplatter/railsy_backbone)

它封装了一些方法,跟rails 的generate 很像。

```js
Backbone Model $ rails g backbone:model
Backbone Router $ rails g backbone:router
Backbone Scaffold $ rails g backbone:scaffold
```

### BACKBOBE `Render` FUNCTION

首先我们先说下rails 的MVC框架，`controller` 中获取数据，`model`中处理
数据逻辑，`view`负责渲染html。 其中`view`的页面逻辑清楚， `controller`
负责提取数据的调用，数据的逻辑都应该放到`model`里面去，所以有**fatter model thinner controller**
的说法。也看到过是 `controller` 里面的代码不应该超过10行的说法。

```js
# backbone/views/tasks/index_view.js.coffee

class Ezitask.Views.Tasks.IndexView extends Backbone.View
  template: JST["backbone/templates/tasks/index"]

  className: "container task_list"

  events:
    "click .setting_option" : "optionView"

  initialize: (options) =>
    # your local here before `render()`
    @collection.on "add", @addOneTask

  addAllTasks: () =>
    @collection.each(@addOneTask)

  addOneTask: (task) =>
    @task_view = new Ezitask.Views.Tasks.TaskView({model : task})
    @$("#tasks_content tbody").prepend(@task_view.render().el)

  render: =>
    @$el.html(@template(@collection.toJSON() ))
    @addAllTasks()
    @
```

这是backbone的典型的一个VIEW，当在router中定义这个view，然后render出来。它在router被实例化，

分析下`render` 这个方法。
首先 `@template(@collection.toJSON() )` 的意思就是把template 和 collection 结合起来
渲染成html的String。

`$elview.$el`  的官方解释：
A cached jQuery object for the view's element. A handy reference instead of re-wrapping
the DOM element all the time.

`@$el` 得到的是这个view的html element。 然后通过JQuery `html`。
这样el就已经有了html element框架，然后才能执行添加所以task的操作。
`@$("#tasks_content tbody")`  前面的`@`是保证元素的查找是在当前view,或者说是template里面，
而`$("#tasks_content tbody")`则是普通的JQuery 查找。
然后返回当前这个view。

```js
# backbone/views/tasks/index_view.js.coffee

  index: ->
    @indexView = new Ezitask.Views.Tasks.IndexView(collection: @tasks)
    $("#tasks_page").html(@indexView.render().el)
```

这是Router里面 `index action` 的方法，就是new一个 `IndexView`, 传进 `collection`,
`@indexView.render()` 这个方法会渲染好这个 `view` 的数据。

`$("#tasks_page").html(@indexView.render().el)` 就是直接获取已经渲染好了得View的el，然后
直接html出来。

`View.el` 的官方解释：
All views have a DOM element at all times (the el property), whether they've already been inserted into the page or not. In this fashion, views can be rendered at any time, and inserted into the DOM all at once, in order to get high-performance UI rendering with as few reflows and repaints as possible. this.el is created from the view's `tagName`, `className`, `id` and `attributes` properties, if specified. If not, el is an empty `div`.

### USE GRAPE FOR RESTFUL API

grape guide: https://github.com/intridea/grape
grape-entity: https://github.com/intridea/grape-entity

EXAMPLE MODEL:

```js task.js
# backbone/models/tasks/task.js.coffee

class Ezitask.Models.Task extends Backbone.Model
  paramRoot: 'task'

  initialize: ->
    @tracks= new Ezitask.Collections.TracksCollection(task: @)

  defaults:
    name: null
    description: null
    start_at: null
    end_at: null

class Ezitask.Collections.TasksCollection extends Backbone.Collection
  model: Ezitask.Models.Task
  url: '/api/v1/tasks'
```

collection = new Ezitask.Collections.TasksCollection
collection.fetch() # 通过api 抓取task

`Backbone.Collection` 跟数据相关的 api 有 `add`, `reset`, `remove` 等。

### EXTEND FUNTIONS FOR BACKBONE

```js

# backbone/views/_shared/calidation.js
Ezitask.Views.Shared.Validation =
  showValidationErrors: (errors) ->
    # your logic code here

# backbone/views/_shared/private_resource_rategories.js
class Ezitask.Views.PrivateResourceCategories.NewView extends Backbone.View
  # mixin
  _.extend(@prototype, Ezitask.Views.Shared.Validation)
```

当我们想要统一全站 view 的 validation 的时候，可以用 **_.extend()** 这种方法。
[more infos here...](http://hi.baidu.com/rainchen/item/a5111d01d4c58fc32e4c6b97)


### useful tips

- backbone 的 model 功能应该和 rails 里面的 model 保持一致。
- 个人建议 `url` 这个属性放在 `collection` 上面。 `model` 的创建用 `collection` 的create方法
  这样能触发 `add` 事件。 `model` 的保存用 `save` 即可。
- 使用 grape 的 Entity 方法暴露 model，不用 methods 这个方法。 e.g.
  good:
  ```
  window.router = new Ezitask.Routers.TasksRouter({tasks: <%= raw Entities::Task.represent(@tasks).to_json -%>});
  ```

  bad:
  ```
  window.router = new Ezitask.Routers.ProductServicesRouter({
    product_services: <%= @product_services.to_json(:methods => [:resource_category, :medium_icon_url, :private_list]).html_safe -%>
  });
  ```

### referenecs
- [a-comparison-of-angular-backbone-canjs-and-ember](http://www.csdn.net/article/2013-04-25/2815032-a-comparison-of-angular-backbone-canjs-and-ember)
