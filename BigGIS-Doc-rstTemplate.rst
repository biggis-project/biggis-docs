BigGIS Documenatation RST Template
====================================

Document Sectioning
-------------------

In RST sections are identified through their titles, which are marked up with adornment: "underlines" below the title text, or underlines and matching "overlines" above the title. An underline/overline is a single repeated punctuation character that begins in column 1 and forms a line extending at least as far as the right edge of the title text. Specifically, an underline/overline character may be any non-alphanumeric printable 7-bit ASCII character. When an overline is used, the length and character used must match the underline. Underline-only adornment styles are distinct from overline-and-underline styles that use the same character. There may be any number of levels of section titles [RSTSections]_.

The hierarchy of the sectioning symbols is defined during the build process of the document through their order of appearance. I suggest to restrict the hierachy in the BigGIS documentation to no more than 4 levels using the following scheme: ::

	Chapter
	=======
	
	Section
	---------

	Subsection
	...........

	Subsubsection
	*************

Please refer to the RST manual for further reading on `sections <http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#sections>`_.

Footnotes
----------

Detailed information on `footnotes <http://docutils.sourceforge.net/docs/user/rst/quickref.html#footnotes>`_.

Citation
----------

Citations are implemented as: 

.. code::

   [CITATION-LABEL]_
   
The reference details are defined like this

.. code::

   .. [CITATION-LABEL] Author details
   
Example: A lot of information in this template is taken from [RST-Doc2017]_.

Detailed information about citations in Restructured Text can be found `here <http://docutils.sourceforge.net/docs/user/rst/quickref.html#citations>`_.

Images and Figures
-------------------

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

Forumulas
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

Further information on `Code Blocks <http://docutils.sourceforge.net/docs/ref/rst/directives.html#code>`_.	  

References
-------------

.. [RSTSections] RST documentation (Sections), http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html#sections
.. [RST-Doc2017] RST documentation, http://docutils.sourceforge.net/docs/ref/rst/restructuredtext.html
