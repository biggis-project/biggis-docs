Contributing
============

We value all kinds of contributions from the community, not just actual
code. If you do like to contribute actual code in the form of bug fixes, new
features or other patches this page gives you more info on how to do it.


Git Branching Model
-------------------

The BigGIS team follows the standard practice of using the
``master`` branch as main integration branch.

Git Commit Messages
-------------------

We follow the 'imperative present tense' style for commit messages.
(e.g. "Add new EnterpriseWidgetLoader instance")

Issue Tracking
--------------

If you find a bug and would like to report it please go to the github
issue tracker of a given sub-project and file an issue.

Pull Requests
-------------

If you'd like to submit a code contribution please fork BigGIS and
send us pull request against the ``master`` branch. Like any other open
source project, we might ask you to go through some iterations of
discussion and refinement before merging.

Contributing documentation
--------------------------

In BigGIS, we use a dedicated git repository for a centralized documentation.
Additionally, each sub-project contains a ``README.md`` file with a bief
description. We use ``rst`` format for the centralized docs and ``markdown``
for everyting else. To build docs on your own machine, ensure that
``sphinx`` and ``make`` are installed.

Installing Dependencies
^^^^^^^^^^^^^^^^^^^^^^^

Ubuntu 16.04
''''''''''''

.. code:: console

   > sudo apt-get install python-sphinx python-sphinx-rtd-theme

Arch Linux
''''''''''

.. code:: console

   > sudo pacman -S python-sphinx python-sphinx_rtd_theme

MacOS
'''''

``brew`` doesn't supply the sphinx binaries, so use ``pip`` here.

Windows
'''''''''''

Install Python and pip as described `here <http://www.sphinx-doc.org/en/stable/install.html#windows-install-python-and-sphinx>`_.

Then install sphinx using ``pip`` as described below.

Pip
'''

.. code:: console

   > pip install sphinx sphinx_rtd_theme
   
.. todo:: if markdown sninppets should also be rendered, ``> pip install commonmark recommonmark`` is required.

Building the Docs
^^^^^^^^^^^^^^^^^

Assuming you've cloned the `biggis-docs repo
<https://github.com/biggis-project/biggis-docs>`__, you can now build the docs
yourself. Steps:

1. Navigate to the ``biggis-docs`` directory
2. Run ``make html``
3. View the docs in your browser by opening ``_build/html/index.html``

.. note:: Changes you make will not be automatically applied; you will have
          to rebuild the docs yourself. Luckily the docs build in about a second.


Recreating documentation on the fly
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There is a way to recreate the doc automatically when you make changes, you
need to install python package watchdog (``pip install watchdog``) and then use::

    make watch


Notes about sphinx format
^^^^^^^^^^^^^^^^^^^^^^^^^
Currently, we use `sphinx <http://sphinx-doc.org>`__ and its RST format to write the documentation.
We also tried the `mkdocs <http://mkdocs.org>`__ tool which uses Markdown as input format.
Markdown is easier and more familiar to github users than RST but it has some drawbacks.

The main showstoppers are the following:

1. PDF cannot be generated using ``mkdocs``
2. Generated HTML hosted at `readthedocs.io <http://readthedocs.io>`__ is not
   searchable which is a known bug. There are some
   `half-working workaround <https://github.com/linkedin/gobblin/blob/master/gobblin-docs/js/extra.js>`__
   used by the `Gobblin project <https://github.com/linkedin/gobblin>`__.

Since we want to generate HTML as well as PDF documents, we would like to use
images in a vector format. For HTML it is SVG that is vector-based and rendered
by new browesers. For PDF, we had to resort to PDF format due to some bug
in the sphinx tool. Luckily, we can convert all SVG files automatically using
the `figconv tool <https://github.com/vsimko/figconv>`__. Figconv converts multiple
input formats into PDF and automatically crops the output. Moreover, It only
converts changed files, therefore it can be called multiple times, e.g. before
every push to github.
