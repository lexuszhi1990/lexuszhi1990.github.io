---
layout: post
title: add jsonb extension to postgres
date: 2015-07-21 11:23:51 +0800
categories: [tech, postgres, json]
---

http://nandovieira.com/using-postgresql-and-jsonb-with-ruby-on-rails

http://guides.rubyonrails.org/active_record_postgresql.html#json

http://robertbeene.com/rails-4-2-and-postgresql-9-4/

bentch mark
https://gist.github.com/fnando/f672c9243186933b3c8e

CREATE TABLE json_tests (
  id serial not null,
  settings jsonb not null default '{}',
  preferences json not null default '{}'
);

INSERT INTO json_tests (settings) VALUES
  ('{}'),
  ('{"a": 1}'),
  ('{"a": 2, "b": ["c", "d"]}'),
  ('{"a": 1, "b": {"c": "d", "e": true}}'),
  ('{"b": 2}');


  SELECT * FROM json_tests;

  SELECT * FROM json_tests WHERE settings = '{"a":1}';
