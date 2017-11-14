# Documentation Howto

We use **[mkdocs]** for documenting the project.
The goal is to make the documentation process as simple as possible,
to allow versioning and to use pull requests for text reviews.

The amount of formatting elements is deliberately small.
Apart from wiki, we try to keep each page self contained and to minimize
interlinking between pages because it only complicates reading of the docs.


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

!!! note
    Make sure you are using **mkdocs version 0.17.1+**

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

For the sake of simplicity, we use two-level hierarchy inside `docs/`:
 
  - **Level 1** : areas (directories) that appear in the main menu.
  - **Level 2** : pages (markdown files) that appear in the left side bar.
  - **Level 3** : headings (H1, H2, ...) that appear in the table of contents on the right
  
## Formatting examples

### Sectioning

    # Chapter
    
    ## Section
    
    ### Subsection

### Footnotes

See also https://squidfunk.github.io/mkdocs-material/extensions/footnotes/

    Some text with a footnote[^1]
    
    [^1]: Text of the footnote

### Citations, Notes

    !!! cite
        Here comes the citation including authors, title, year, doi, url ...

!!! cite
    Here comes the citation including authors, title, year, doi, url ...

---

    !!! note
        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et euismod
        nulla. Curabitur feugiat, tortor non consequat finibus, justo purus auctor
        massa, nec semper lorem quam in massa.

!!! note
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla et euismod
    nulla. Curabitur feugiat, tortor non consequat finibus, justo purus auctor
    massa, nec semper lorem quam in massa.

---  
For more options see https://squidfunk.github.io/mkdocs-material/extensions/admonition/

### Images and Figures

You can include images into the documentation in the following format:

  - **SVG** (scalable vectors).
  - **JPG** (photos)
  - **PNG** (raster graphics)

In contrast to scientific papers, it is not possible to create references to numbered figures in markdown.
See also http://www.mkdocs.org/user-guide/writing-your-docs/#images-and-media


    ![Image "alt" description](path/to/image.svg)


![Disaster Icon](scenarios/img/scen-disaster.svg)


### Tables

See also http://www.mkdocs.org/user-guide/writing-your-docs/#tables

    First Header | Second Header | Third Header
    ------------ | ------------- | ------------
    Content Cell | Content Cell  | Content Cell
    Content Cell | Content Cell  | Content Cell

First Header | Second Header | Third Header
------------ | ------------- | ------------
Content Cell | Content Cell  | Content Cell
Content Cell | Content Cell  | Content Cell


### Formulas

Formula are generated using [MathJax](https://www.mathjax.org/), which is similar to LaTeX.
See also this [quick reference][MathJaxRef].

[MathJaxRef]: https://math.meta.stackexchange.com/questions/5020/mathjax-basic-tutorial-and-quick-reference

    $$
    \frac{n!}{k!(n-k)!} = \binom{n}{k}
    $$

$$
\frac{n!}{k!(n-k)!} = \binom{n}{k}
$$


### Source Code

Code can be displayed inline like this:

    `print 1+{variable}`

Or it can be displayed in a code block with optional syntax highlighting if the language is specified.

    ```python
    def my_function():
        "just a test"
        print 8/2 
    ```

```python
def my_function():
    "just a test"
    print 8/2 
```

### Smart Symbols
See also https://facelessuser.github.io/pymdown-extensions/extensions/smartsymbols/

    Some smart symbols: -->,  <--, 1st, 2nd, 1/4
    
Some smart symbols: -->,  <--, 1st, 2nd, 1/4

### Sequence diagrams

~~~.markdown
```sequence
Title: Example sequence diagram
A->B: Sync call
B-->A: Sync return
A->C: Another sync call
C->>D: Async call
D-->>C: Async return
```
~~~

```sequence
Title: Example sequence diagram
A->B: Sync call
B-->A: Sync return
A->C: Another sync call
C->>D: Async call
D-->>C: Async return
```
