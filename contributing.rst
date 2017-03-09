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

Pip
'''

.. code:: console

   > pip install sphinx sphinx_rtd_theme

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
