### ipython

[ipython official site](http://ipython.org/ "aaa")


### autoreload

```
import ipy_autoreload
%autoreload 2
```

As mentioned above, you need the autoreload extension. If you want it to automatically start every time you launch ipython, you need to add it to the ipython_config.py startup file:

It may be necessary to generate one first: `ipython profile create`
Then include these lines in `~/.ipython/profile_default/ipython_config.py:`

```
c.InteractiveShellApp.exec_lines = []
c.InteractiveShellApp.exec_lines.append('%load_ext autoreload')
c.InteractiveShellApp.exec_lines.append('%autoreload 2')
```


http://ipython.org/ipython-doc/stable/config/intro.html
```
c.InteractiveShellApp.extensions = ['autoreload']
c.InteractiveShellApp.exec_lines = ['%autoreload 2']
```
