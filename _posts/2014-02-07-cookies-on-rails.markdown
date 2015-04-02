---
layout: post
title: "cookies on rails"
date: 2014-02-07 21:31:45 +0800
comments: true
published: false
categories: [tech, cookies]
---
content = "BAh7CkkiD3Nlc3Npb25faWQGOgZFRkkiJWI3MDQwY2ZmZmIyYjVkNGFhNzQ4NDNlZTZkZTg2MzE0BjsAVEkiEXByZXZpb3VzX3VybAY7AEYiBi9JIhBfY3NyZl90b2tlbgY7AEZJIjFRSHFJM2pWbDBOcSt6OVlKWGRCVFBjVFJydXVxOWR2a25qQnFkSUIvWjFVPQY7AEZJIhN1c2VyX3JldHVybl90bwY7AEYiCy9hZG1pbkkiGXdhcmRlbi51c2VyLnVzZXIua2V5BjsAVFsISSIJVXNlcgY7AEZbBmkC2gRJIiIkMmEkMTAkc2REOXJEbmdRZENSL0w0emZ3S01qZQY7AFQ%3D--eef41ffd2cc354853ca0105af51b9f8bbca07b18"

unescaped_content = URI.unescape(content)
data, digest = unescaped_content.split('--')
Marshal.load(::Base64.decode64(data))

references
----------
- [cookies-on-rails](http://blog.bigbinary.com/2013/03/19/cookies-on-rails.html)
- [chrome-cookie-plugin](https://chrome.google.com/webstore/detail/edit-this-cookie/fngmhnnpilhplaeedifhccceomclgfbg)
