---
layout: post
title: batch insert bentchmark
date: 2015-07-22 11:43
categories: [tech, rails, activerecord, insert]
publish: true
---

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
  list_items_for_raw_insert.push "(35, '{\"City\"=>\"Washington\", \"Email\"=>\"davisd@example.com\", \"State\"=>\"aa\", \"Last 2\"=>nil, \"Last 3\"=>nil, \"First 2\"=>nil, \"First 3\"=>nil, \"Last Name\"=>\"vvv\", \"Tribe\"=>\"Apollo Group\", \"Cell Phone\"=>\"333333\", \"First Name\"=>\"david\", \"Email\"=>nil}')"
end
list_items_for_raw_insert_sql = "INSERT INTO list_items (list_id, data) VALUES #{list_items_for_raw_insert.join(", ")}"

Benchmark.ips do |x|
  x.report('create') do
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
#               create
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
#               create      0.179  (± 0.0%) i/s -      1.000  in   5.586677s
# save with validations
#                           0.158  (± 0.0%) i/s -      1.000  in   6.311747s
# save without validations
#                           0.181  (± 0.0%) i/s -      1.000  in   5.515315s
# import with model validations
#                           0.937  (± 0.0%) i/s -      5.000  in   5.335594s
# import without model validations
#                           2.061  (± 0.0%) i/s -     11.000  in   5.341723s
#           raw_insert     44.530  (± 9.0%) i/s -    220.000

# Comparison:
# raw_insert:                        44.5 i/s
# import without model validations:  2.1 i/s - 21.60x slower
# import with model validations:     0.9 i/s - 47.50x slower
# save without validations:          0.2 i/s - 245.60x slower
# create:                            0.2 i/s - 248.77x slower
# save with validations:             0.2 i/s - 281.06x slower

```

### references :
- https://github.com/seamusabshere/upsert
# https://github.com/zdennis/activerecord-import/wiki/Examples
- https://www.coffeepowered.net/2009/01/23/mass-inserting-data-in-rails-without-killing-your-performance/
- http://stackoverflow.com/questions/8505263/how-to-implement-bulk-insert-in-rails-3?lq=1
