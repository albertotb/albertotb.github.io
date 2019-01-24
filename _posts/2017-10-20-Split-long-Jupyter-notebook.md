---
title: "Split long Jupyter notebook"
author: Alberto Torres Barrán
tags: python
---

The following code can be used, adapted from [here](https://blog.ouseful.info/2015/12/03/some-jupyter-notebook-nbconvert-housekeeping-hints/)

```python
#!/usr/bin/env python

import os
import sys
import IPython.nbformat as nb
import IPython.nbformat.v4.nbbase as nb4

if len(sys.argv) != 2:
    print "usage: {} NOTEBOOK".format(sys.argv[0])
    sys.exit(1)

mynb = nb.read(sys.argv[1], nb.NO_CONVERT)

basename = os.path.splitext(sys.argv[1])[0]

c=1
test=nb4.new_notebook()
for i in mynb['cells']:
    if (i['cell_type']=='markdown'):
        if ('SPLIT NOTEBOOK' in i['source']):
            nb.write(test,'{}_{}.ipynb'.format(basename, c))
            c=c+1
            test=nb4.new_notebook()
        else:
            test.cells.append(nb4.new_markdown_cell(i['source']))
    elif (i['cell_type']=='code'):
        cc=nb4.new_code_cell(i['source'])
        for o in i['outputs']:
            cc['outputs'].append(o)
        test.cells.append(cc)
nb.write(test,'{}_{}.ipynb'.format(basename, c))
```

