---
title: 数据库批量导入性能测试
categories:
  - dev
tags:
  - rails
  - activerecord
  - insert
published: true
date: 2015-07-22 11:43:00
---


ActiveRecord虽然让DB的操作非常简单，提供了validate，callback等非常有用的方法。但由于项目需要，有时候项目导入一下就有10K左右的record要往里面的塞，一个一个的create则消耗非常大，所以用原生的create方法则基本不适用了。

<!-- more -->

### 使用 transactions

Instead of

```
1000.times { Model.create(options) }
```

You want:

```
ActiveRecord::Base.transaction do
  1000.times { Model.create(options) }
end
```

### 使用 **Model batch create**

e.g. `Modle.create([all the objects you want create])

### 使用原生的sql一次性insert

```ruby
2000.times do
  list_items_for_raw_insert.push "(35, '{\"City\"=>\"guangzhou\", \"Email\"=>\"david@example.com\", \"State\"=>\"aa\", \"Last 2\"=>nil, \"Last 3\"=>nil, \"First 2\"=>nil, \"First 3\"=>nil, \"Last Name\"=>\"vvv\", \"Tribe\"=>\"CCC\", \"Cell Phone\"=>\"333333\", \"First Name\"=>\"david\", \"Email\"=>nil}')"
end
list_items_for_raw_insert_sql = "INSERT INTO list_items (list_id, data) VALUES #{list_items_for_raw_insert.join(", ")}"

ActiveRecord::Base.connection.execute(list_items_for_raw_insert_sql, :skip_logging)
```

### 使用 ActiveRecord::Extensions

找到的比较好的有两个gem

- [activerecord-import](https://github.com/zdennis/activerecord-import)，基于ActiveRecord

- [upsert](https://github.com/seamusabshere/upsert)，可以独立使用

以下是准备数据，并使用benchmark/ips这个来做benchmark，一次insert的records是2000。

```ruby

require 'benchmark/ips'
require 'activerecord-import'

# :debug, :info, :warn, :error, :fatal, which correspond to the integers 0-5.
# ActiveRecord::Base.logger = 0
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil # disable the log of sql

example_list = List.find 30
list_items_columns = ["list_id", "data"]
list_item_count = 2000

list_items_for_create = [];
list_items_for_save = [];
list_items_for_import = [];
list_items_for_raw_insert=[];

example_list.list_items.take(list_item_count).each do |x|
  list_items_for_save << {list_id: x.list_id, data: x.data}
  list_items_for_create << [list_id: x.list_id, data: x.data]
  list_items_for_import << [x.list_id, x.data]
end

list_item_count.times do
  list_items_for_raw_insert.push "(35, '{\"City\"=>\"guangzhou\", \"Email\"=>\"david@example.com\", \"State\"=>\"aa\", \"Last 2\"=>nil, \"Last 3\"=>nil, \"First 2\"=>nil, \"First 3\"=>nil, \"Last Name\"=>\"vvv\", \"Tribe\"=>\"CCC\", \"Cell Phone\"=>\"333333\", \"First Name\"=>\"david\", \"Email\"=>nil}')"
end
list_items_for_raw_insert_sql = "INSERT INTO list_items (list_id, data) VALUES #{list_items_for_raw_insert.join(", ")}"

Benchmark.ips do |x|
  x.report('batch create') do
    ListItem.create list_items_for_create
  end

  x.report('save with validations') do
    list_items_for_save.each do |li|
      list_item = ListItem.new li
      list_item.save validate: true
    end
  end

  x.report('save without validations') do
    list_items_for_save.each do |li|
      list_item = ListItem.new li
      list_item.save validate: false
    end
  end

  x.report("import with model validations") do
    ListItem.import list_items_columns, list_items_for_import, :validate => true
  end

  x.report("import without model validations") do
    ListItem.import list_items_columns, list_items_for_import, :validate => false
  end

  x.report("raw_insert") do
    ActiveRecord::Base.connection.execute(list_items_for_raw_insert_sql, :skip_logging)
  end

  x.compare!
end

ActiveRecord::Base.logger = old_logger

# https://github.com/evanphx/benchmark-ips/blob/master/README.md
# Benchmark/ips will report the number of iterations per second for a given block of code.
# When analyzing the results, notice the percent of standard deviation which tells us how spread out our measurements are from the average.
# A high standard deviation could indicate the results having too much variability.

# Calculating -------------------------------------
#               batch create
#                          1.000  i/100ms
# save with validations
#                          1.000  i/100ms
# save without validations
#                          1.000  i/100ms
# import with model validations
#                          1.000  i/100ms
# import without model validations
#                          1.000  i/100ms
#           raw_insert     4.000  i/100ms
# -------------------------------------------------
#         batch create      0.179  (± 0.0%) i/s -      1.000  in   5.586677s
# save with validations
#                           0.158  (± 0.0%) i/s -      1.000  in   6.311747s
# save without validations
#                           0.181  (± 0.0%) i/s -      1.000  in   5.515315s
# import with model validations
#                           0.937  (± 0.0%) i/s -      5.000  in   5.335594s
# import without model validations
#                           2.061  (± 0.0%) i/s -      11.000  in   5.341723s
#           raw_insert     44.530  (± 9.0%) i/s -      220.000
```

### Comparison:

|方法                                | 每秒执行的次数 | 相差的倍数       |
| :-------------------------------- | :----------- | :------------- |
|raw_insert:                        | 44.5 i/s     |                |
|import without model validations:  | 2.1 i/s      | - 21.60x slower|
|import with model validations:     | 0.9 i/s      | - 47.50x slower|
|save without validations:          | 0.2 i/s      | - 245.60x slower|
|batch create:                      | 0.2 i/s      | - 248.77x slower|
|save with validations:             | 0.2 i/s      | - 281.06x slower|

毫无疑问，raw insert 用原生的sql是最快的，但安全性，可维护性都不高。**save with validations**是最低的，因为要对每个object经行validate检测。**batch create** 和 **save without validations**差不多，相对原生的sql要慢200多倍，用**activerecord-import**这个gem确实会提高很多，**import with model validations** 相对于**batch create** 要提高5倍，而**import without model validations**则可以达到10倍左右。

### references :
- https://github.com/seamusabshere/upsert
- https://github.com/zdennis/activerecord-import/wiki/Examples
- https://www.coffeepowered.net/2009/01/23/mass-inserting-data-in-rails-without-killing-your-performance/
- http://stackoverflow.com/questions/8505263/how-to-implement-bulk-insert-in-rails-3?lq=1
