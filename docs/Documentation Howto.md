# Documentation Howto

We use **[mkdocs]** for documenting the project.

The documentation is written as a set of Markdown files within the `docs/` directory and after deployment
available as a static website: [Docs Website].


[Docs Website]: https://biggis-project.github.io/biggis-docs/
[mkdocs]: http://mkdocs.org


## Before building the docs

First of all, you need **python** and **pip** to be installed.
Using pip, you need to install the following packages:

- **mkdocs** : Provides the executable command `mkdocs`.
- **mkdocs-material** : A material design theme, see also [this page](http://squidfunk.github.io/mkdocs-material/).

You can install the packages either locally as a user into `~/.local/` or system-wide
(when omitting the `--user` parameter).

    #!sh
    pip install --user mkdocs
    pip install --user mkdocs-material

## How to edit

Before editing the documentation, start the live-reloading docs server
using `mkdocs serve` within the project root directory.
Then, open the page [http://127.0.0.1:8000](http://127.0.0.1:8000) in your browser and watch your edits being reloaded 
automatically.

    #!sh
    mkdocs serve
    
```
INFO    -  Building documentation... 
INFO    -  Cleaning site directory 
[I 171024 15:03:51 server:283] Serving on http://127.0.0.1:8000
[I 171024 15:03:51 handlers:60] Start watching changes
```    

You can now edit the markdown documents with the `docs/` directory.


## Deployment

Using the command `mkdocs gh-deploy` we can generate a static [Docs Website]
and deploy it automatically as a github page (served from `gh-pages` branch).

!!! note
    The newly deployed version appears after few seconds.

## Documentation layout

    mkdocs.yml    # The configuration file.
    docs/
      index.md    # The documentation homepage.
      ...         # Other markdown pages, images and other files.

## Formatting examples

see also

### Sectioning

    # Chapter
    
    ## Section
    
    ### Subsection


### Footnotes

!!! TODO
    Viliam

### Citations

    !!! Citation
        Here comes the citation including authors, title, year, doi, url ...

!!! Citation
    Here comes the citation including authors, title, year, doi, url ...
    
### Images and Figures

    ![Image "alt" description](path/to)

A "figure" consists of image data (including image options), an optional caption (a single paragraph), and an optional legend (arbitrary body elements). This is an example for a centered figure scaled to 50% with caption and legend.

.. figure:: images/scen-smartcity.*
	:name: my-figure
	:scale: 50 %
	:alt: smartcity symbol
	:align: center

	This is the caption of the figure (a simple paragraph).

	The legend consists of all elements after the caption. In this case, the legend consists of this paragraph

Reference to the figure :numref:`my-figure`

All images in the BigGIS documentation should be vector graphics. The sphinx builder uses different input image formats for different output formats (svg for html output, and pdf for pdflatex output). When including the image in the document use the syntax as in the example above, so that sphinx automatically includes the right format:

.. code::
   
   .. figure:: images/scen-smartcity.*

Please always provide at least the svg-Version of your image.

.. TODO: Figure enumeration and referencing (siehe http://www.sphinx-doc.org/en/stable/markup/inline.html#cross-referencing-figures-by-figure-number )

For further reading on `images <http://docutils.sourceforge.net/docs/ref/rst/directives.html#image>`_ and `figures <http://docutils.sourceforge.net/docs/ref/rst/directives.html#figure>`_ refer to the RST documentation.

Tables
---------

Grid table:

+------------+------------+-----------+ 
| Header 1   | Header 2   | Header 3  | 
+============+============+===========+ 
| body row 1 | column 2   | column 3  | 
+------------+------------+-----------+ 
| body row 2 | Cells may span columns.| 
+------------+------------+-----------+ 
| body row 3 | Cells may  | - Cells   | 
+------------+ span rows. | - contain | 
| body row 4 |            | - blocks. | 
+------------+------------+-----------+

Simple table:

=====  =====  ====== 
   Inputs     Output 
------------  ------ 
  A      B    A or B 
=====  =====  ====== 
False  False  False 
True   False  True 
False  True   True 
True   True   True 
=====  =====  ======

Further information about `tables <http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#tables>`_.

Formulas
-------------

The math syntax for RST is the same as for Latex. Details can be found `here <http://www.ams.org/publications/authors/tex/amslatex>`_. 

Inline use of mathematic terms looks this :math:`\frac{ abc}{N}`

The other option is to present formulas in an own environment using ``..math::``

.. code::
   
   .. math::
      
      \frac{ \sum_{t=0}^{N}f(t,k) }{N}
 
Which then looks like this:

.. math::
   
   \frac{ \sum_{t=0}^{N}f(t,k) }{N}
 
Further information about formulas and math in RST can be found `here <http://www.sphinx-doc.org/en/stable/ext/math.html>`_.

Source Code
------------
Code can be displayed inline like this :samp:`print 1+{variable}` 

or like this ``print 8/2``

Or it can be displayed in a code block with optional syntax highlighting if the language is specified.

.. code:: python
   
   def my_function():
      "just a test"
      print 8/2 

Further information on Code Blocks can be found `here <http://docutils.sourceforge.net/docs/ref/rst/directives.html#code>`_.	  

References
-------------

.. [RSTSections] RST documentation (Sections), http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#sections
.. [RST-Doc2017] RST documentation, http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
