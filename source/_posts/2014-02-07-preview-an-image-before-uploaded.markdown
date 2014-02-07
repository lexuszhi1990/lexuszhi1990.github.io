---
layout: post
title: "preview an image before uploaded"
date: 2014-02-07 21:23:26 +0800
comments: true
categories: [tech, image preview]
---

use `simple_form` to upload a avatar

```
= f.input :avatar, :as => :file, wrapper_html: {id: 'user_avatar_upload'}
= f.label "Upload Profile Photo", id: "upload_profile_photo", class: "upload_profile_photo"
%img{id: "avatar_preview", src: "#", alt: "your avatar"}
```

<!-- more -->

custom the upload avatar photo function, preview the uploaded image

```
var bindUploadAvatarButton = function () {
  var userAvatar = $('form.new_user #user_avatar_upload');
  var avatarUploadLabel = $('form.new_user #upload_profile_photo');
  var avatarPreview = $('form.new_user #avatar_preview');

  avatarUploadLabel.on('click',function(event) {
    event.preventDefault();
    userAvatar.click();
  });

  userAvatar.on('change', function() {
    readURL(this);
  });

  // http://stackoverflow.com/questions/4459379/preview-an-image-before-it-is-uploaded
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        avatarPreview.attr('src', e.target.result);
        console.log(e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

};
```
