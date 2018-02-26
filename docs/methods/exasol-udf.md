# Exasol UDF framework

UDF scripts provides you the ability to program your own analyses,
processing or generation functions and execute them in parallel inside
Exasol's high performance cluster (In Database Analytics). Through
this principle many problems can be solved very efficiently which were
not possible with SQL statements. Via UDF scripts you therefore get a
highly flexible interface for implementing nearly every
requirement. Hence you become a HPC developer without the need for
certain previous knowledge.

With UDF scripts you can implement the following extensions:

- Scalar functions
- Aggregate functions
- Analytical functions
- MapReduce algorithms
- User-defined ETL processes

To take advantage of the variety of UDF scripts, you only need to
create a script and use this script afterwards within a SELECT
statement. By this close embedding within SQL you can achieve ideal
performance and scalability.
    
Exasol supports multiple programming languages (Java, Lua, Python, R)
to simplify your start. Furthermore the different languages provide
you different advantages due to their respective focus
(e.g. statistical functions in R) and the different delivered
libraries (XML parser, etc.). Thus, please note the next chapters in
which the specific characteristics of each language is described.
    
The actual versions of the scripting languages can be listed with
corresponding metadata functions.
      
Within the `CREATE SCRIPT STATEMENT` command, you have to define the
type of input and output values. You can e.g. create a script which
generates multiple result rows out of a single input row
(`SCALAR ... EMITS`).
    
- Input values:

    - SCALAR
    
         The keyword SCALAR specifies that the script processes single
         input rows. It's code is therefore called once per input row.
            
    - SET

         If you define the option SET, then the processing refers to a
         set of input values. Within the code, you can iterate through
         those values.

- Output values:

    - RETURNS

         In this case the script returns a single value.

    - EMITS

         If the keyword EMITS was defined, the script can create
         (emit) multiple result rows (tuples). In case of input type
         SET, the EMITS result can only be used alone, thus not be
         combined with other expressions. However you can of course
         nest it through a subselect to do further processing of those
         intermediate results.

The data types of input and output parameters can be defined to
specify the conversion between internal data types and the database
SQL data types. If you don't specify them, the script has to handle
that dynamically (see details and examples below).
    
Please note that input parameters of scripts are always treated
case-sensitive, similar to the script code itself. This is different
to SQL identifiers which are only treated case-sensitive when being
delimited.
      
Scripts must contain the main function `run()`. This function is
called with a parameter providing access to the input data of
Exasol. If your script processes multiple input tuples (thus a SET
script), you can iterate through the single tuples by the use of this
parameter.
    
Please note the information in the following table:

- Internal processing

    During the processing of an SELECT statement, multiple virtual
    machines are started for each script and node, which process the
    data independently.
            
    For scalar functions, the input rows are distributed across those
    virtual machines to achieve a maximal parallelism.

    In case of SET input tuples, the virtual machines are used per
    group (if you specify a GROUP BY clause). If no GROUP BY clause is
    defined, then only one group exists and therefore only one node
    and virtual machine can process the data.

- `ORDER BY`

    Either when creating a script or when calling it you can specify
    an ORDER BY clause which leads to a sorted processing of the
    groups of SET input data. For some algorithms, this can be
    reasonable. But if it is necessary for the algorithm, then you
    should already specify this clause during the creation to avoid
    wrong results due to misuse.
            
- Performance

    The performance of the different languages can hardly be compared,
    since the specific elements of the languages can have different
    capacities. Thus a string processing can be faster in one
    language, while the XML parsing is faster in the other one.

    However, we generally recommend to use Lua if performance is the
    most important criteria. Due to technical reasons, Lua is
    integrated in Exasol in the most native way and therefore has the
    smallest process overhead.

## Introducing examples

In this chapter we provide some introducing Lua examples to give you a
general idea about the functionality of user defined scripts. Examples
for the other programming languages can be found in the later chapters
explaining the details of each language.
    
### Scalar functions

User defined scalar functions (keyword `SCALAR`) are the simplest case
of user defined scripts, returning one scalar result value (keyword
`RETURNS`) or several result tuples (keyword `SET`) for each input
value (or tuple).
      
Please note that scripts have to implement a function `run()` in which
the processing is done. This function is called during the execution
and gets a kind of context as parameter (has name _data_ in the
examples) which is the actual interface between the script and the
database.
      
In the following example, a script is defined which returns the
maximum of two values. This is equivalent to the `CASE` expression `CASE WHEN x>=y THEN x WHEN
x<y THEN y ELSE NULL`. The ending slash (`/`) is only required
when using EXAplus.


```sql
CREATE LUA SCALAR SCRIPT my_maximum (a DOUBLE, b DOUBLE) 
           RETURNS DOUBLE AS
function run(ctx)
    if ctx.a == null or ctx.b == null
        then return null
    end
    if ctx.a > ctx.b 
        then return ctx.a
        else return ctx.b      
    end
end 
/

SELECT x,y,my_maximum(x,y) FROM t;

X                 Y                 MY_MAXIMUM(T.X,T.Y) 
----------------- ----------------- -------------------
                1                 2                   2
                2                 2                   2
                3                 2                   3
```


### Aggregate and analytical functions

UDF scripts get essentially more interesting if the script processes
multiple data at once. Hereby you can create any kind of aggregate or
analytical functions. By defining the keyword `SET` you specify that
multiple input tuples are processed.  Within the `run()` method, you
can iterate through this data (by the method` next()`).
      
Furthermore, scripts can either return a single scalar value (keyword
`RETURNS`) or multiple result tuples (keyword `EMITS`).
      
The following example defines two scripts: the aggregate function
`my_average` (simulates `AVG`) the
analytical function `my_sum` which creates three values per input row
(one sequential number, the current value and the sum of the previous
values). The latter one processes the input data in sorted order due
to the `ORDER BY` clause.

```sql
CREATE LUA SET SCRIPT my_average (a DOUBLE) 
           RETURNS DOUBLE AS
function run(ctx)
    if ctx.size() == 0
        then return null
    else
        local sum = 0
        repeat
            if ctx.a ~= null then 
                sum = sum + ctx.a
            end
        until not ctx.next()
        return sum/ctx.size()
    end
end 
/

SELECT my_average(x) FROM t;

MY_AVERAGE(T.X)     
-----------------
             7.75

CREATE LUA SET SCRIPT my_sum (a DOUBLE) 
           EMITS (count DOUBLE, val DOUBLE, sum DOUBLE) AS
function run(ctx)
    local sum   = 0
    local count = 0
    repeat
        if ctx.a ~= null then 
            sum = sum + ctx.a
            count = count + 1
            ctx.emit(count,ctx.a,sum)
        end
    until not ctx.next()
end 
/

SELECT my_sum(x ORDER BY x) FROM t;

COUNT             VAL               SUM              
----------------- ----------------- -----------------
                1                 4                 4
                2                 7                11
                3                 9                20
                4                11                31
```


### Dynamic input and output parameters

Instead of statically defining input and output parameters, you can
use the syntax `(...)` within `CREATE SCRIPT` to create extremely
flexible scripts with dynamic parameters. The same script can then be
used for any input data type (e.g. a maximum function independent of
the data type) and for a varying number of input columns.  Similarly,
if you have an EMITS script, the number of output parameters and their
type can also be made dynamic.
      
In order to access and evaluate dynamic input parameters in UDF
      scripts, extract the number of input parameters and their types from the
      metadata and then access each parameter value by its index. For
      instance, in Python the number of input parameters is stored in the
      variable `exa.meta.input_column_count`.
      
If the UDF script is defined with dynamic output parameters, the
      actual output parameters and their types are determined dynamically
      whenever the UDF is called. There are three possibilities:
      
- You can specify the output parameters directly in the query
          after the UDF call using the `EMITS` keyword followed by
          the names and types the UDF shall output in this specific
          call.

- If the UDF is used in the top level `SELECT` of an
          `INSERT INTO SELECT` statement, the columns of the target
          table are used as output parameters.

- If neither `EMITS` is specified, nor `INSERT
          INTO SELECT` is used, the database tries to call the function
          `default_output_columns()` (the name varies, here for
          Python) which returns the output parameters dynamically, e.g. based
          on the input parameters. This method can be implemented by the user.


In the example below you can see all three possibilities.

```sql
-- Define a pretty simple sampling script where the last parameter defines 
-- the percentage of samples to be emitted. 
CREATE PYTHON SCALAR SCRIPT sample_simple (...) EMITS (...) AS
from random import randint, seed
seed(1001)
def run(ctx):
  percent = ctx[exa.meta.input_column_count-1]
  if randint(0,100) <= percent:
    currentRow = [ctx[i] for i in range(0, exa.meta.input_column_count-1)]
    ctx.emit(*currentRow)
/
 
-- This is the same UDF, but output arguments are generated automatically 
-- to avoid explicit EMITS definition in SELECT.
-- In default_output_columns(), a prefix 'c' is added to the column names 
-- because the input columns are autogenerated numbers
CREATE PYTHON SCALAR SCRIPT sample (...) EMITS (...) AS
from random import randint, seed
seed(1001)
def run(ctx):
  percent = ctx[exa.meta.input_column_count-1]
  if randint(0,100) <= percent:
    currentRow = [ctx[i] for i in range(0, exa.meta.input_column_count-1)]
    ctx.emit(*currentRow)
def default_output_columns():
  output_args = list()
  for i in range(0, exa.meta.input_column_count-1):
    name = exa.meta.input_columns[i].name
    type = exa.meta.input_columns[i].sql_type
    output_args.append("c" + name + " " + type)
  return str(", ".join(output_args))
/

-- Example table
ID       USER_NAME PAGE_VISITS
-------- --------- -----------
       1 Alice              12
       2 Bob                 4
       3 Pete                0
       4 Hans              101
       5 John               32
       6 Peter              65
       7 Graham             21
       8 Steve               4
       9 Bill               64
      10 Claudia           201 


-- The first UDF requires to specify the output columns via EMITS.
-- Here, 20% of rows should be extracted randomly.

SELECT sample_simple(id, user_name, page_visits, 20)
 EMITS (id INT, user_name VARCHAR(100), PAGE_VISITS int)
 FROM people;

ID       USER_NAME PAGE_VISITS
-------- --------- -----------
       2 Bob                 4
       5 John               32

-- The second UDF computes the output columns dynamically
SELECT SAMPLE(id, user_name, page_visits, 20)
  FROM people;

C0       C1        C2
-------- --------- -----------
       2 Bob                 4
       5 John               32

-- In case of INSERT INTO, the UDF uses the target types automatically
CREATE TABLE people_sample LIKE people;
INSERT INTO people_sample
  SELECT sample_simple(id, user_name, page_visits, 20) FROM people;

```

### MapReduce programs

Due to its flexibility, the UDF scripts framework is able to
      implement any kind of analyses you can imagine. To show you it's power,
      we list an example of a MapReduce program which calculates the frequency
      of single words within a text - a problem which cannot be solved with
      standard SQL.
      
In the example, the script `map_words` extracts single
      words out of a text and emits them. This script is integrated within a
      SQL query without having the need for an additional aggregation script
      (the typical Reduce step of MapReduce), because we can use the built-in
      SQL function `COUNT`. This reduces the
      implementation efforts since a whole bunch of built-in SQL functions are
      already available in Exasol. Additionally, the performance can be
      increased by that since the SQL execution within the built-in functions
      is more native.

```sql
CREATE LUA SCALAR SCRIPT map_words(w varchar(10000))
EMITS (words varchar(100)) AS
function run(ctx)
    local word = ctx.w
    if (word ~= null)
    then
        for i in unicode.utf8.gmatch(word,'([%w%p]+)')
        do
            ctx.emit(i)
        end
    end
end
/

SELECT words, COUNT(*) FROM 
    (SELECT map_words(l_comment) FROM tpc.lineitem) 
GROUP BY words ORDER BY 2 desc LIMIT 10;

WORDS                       COUNT(*)           
--------------------------- -------------------
the                                     1376964
slyly                                    649761
regular                                  619211
final                                    542206
carefully                                535430
furiously                                534054
ironic                                   519784
blithely                                 450438
even                                     425013
quickly                                  354712
```


### Access to external services

Within scripts you can exchange data with external services which
      increases your flexibility significantly.
      
In the following example, a list of URLs (stored in a table) is
      processed, the corresponding documents are read from the webserver and
      finally the length of the documents is calculated. Please note that
      every script language provides different libraries to connect to the
      internet.

```sql
CREATE LUA SCALAR SCRIPT length_of_doc (url VARCHAR(50)) 
           EMITS (url VARCHAR(50), doc_length DOUBLE) AS
http = require("socket.http")
function run(ctx) 
    file = http.request(ctx.url)
    if file == nil then error('Cannot open URL ' .. ctx.url) end
    ctx.emit(ctx.url, unicode.utf8.len(file))
end
/

SELECT length_of_doc(url) FROM t;

URL                                                DOC_LENGTH           
-------------------------------------------------- -----------------
http://en.wikipedia.org/wiki/Main_Page.htm                     59960
http://en.wikipedia.org/wiki/Exasol                            30007

```


### User-defined ETL using UDFs

UDF scripts can also be used to implement very flexible ETL
      processes by defining how to extract and convert data from external data
      sources.


## BucketFS

When scripts are executed in parallel on the Exasol cluster, there
    exist some use cases where all instances have to access the same external
    data. Your algorithms could for example use a statistical model or weather
    data. For such requirements, it's obviously possible to use an external
    service (e.g. a file server). But in terms of performance, it would be
    quite handy to have such data available locally on the cluster
    nodes.
    
The Exasol BucketFS file system has been developed for such use
    cases, where data should be stored synchronously and replicated across the
    cluster. But we will also explain in the following sections how this
    concept can be used to extend script languages and even to install
    completely new script languages on the Exasol cluster.
    

### What is BucketFS?

The BucketFS file system is a synchronous file system which is
      available in the Exasol cluster. This means that each cluster node can
      connect to this service (e.g. through the http interface) and will see
      exactly the same content.

The data is replicated locally on every server and automatically
        synchronized. Hence, you shouldn't store large amounts of data
        there.

The data in BucketFS is not part of the database backups and has
        to be backed up manually if necessary.

One BucketFS service contains any number of so-called buckets, and
      every bucket stores any number of files. Every bucket can have different
      access privileges as we will explain later on. Folders are not supported
      directly, but if you specify an upload path including folders, these
      will be created transparently if they do not exist yet. If all files
      from a folder are deleted, the folder will be dropped
      automatically.

Writing data is an atomic operation. There don't exist any locks
      on files, so the latest write operation will finally overwrite the file.
      In contrast to the database itself, BucketFS is a pure file-based system
      and has no transactional semantic.

### Setting up BucketFS and creating buckets

On the left part of the EXAoperation administration interface,
      you'll find the link to the BucketFS configuration. You will find a
      pre-installed default BucketFS service for the configured data disk. If
      you want to create additional file system services, you need to specify
      only the data disk and specify ports for http(s).

If you follow the link of an BucketFS Id, you can create and
      configure any number of buckets within this BucketFS. Beside the bucket
      name, you have to specify read/write passwords and define whether the
      bucket should be public readable, i.e. accessible for everyone.

A default bucket already exists in the default BucketFS which
        contains the pre-installed script languages (Java, Python, R).
        However, for storing larger user data we highly recommend to create a
        separate BucketFS instance on a separate partition.


### Access and access control

From outside the cluster, it is possible to access the buckets and
      the contained files through http(s) clients such as
      <productname>curl. You only have to use one of the
      database servers' IP address, the specified port and the bucket name,
      and potentially adjust your internal firewall configuration.

For accessing a bucket through http(s) the users `r`
        and `w` are always configured and are associated with the
        configured read and write passwords.

In the following example the http client `curl` is used
      to list the existing buckets, upload the files `file1` and
      `tar1.tgz` into the bucket `bucket`1 and finally
      display the list of contained files in this bucket. The relevant
      parameters for our example are the port of the BucketFS
      (`1234`), the name of the bucket (`bucket`1) and
      the passwords (`readpw` and `writepw`).

```sql
$> curl http://192.168.6.75:1234
default
bucket1
$> curl -X PUT -T file1 http://w:writepw@192.168.6.75:1234/bucket1/file1
$> curl -X PUT -T tar1.tgz \
http://w:writepw@192.168.6.75:1234/bucket1/tar1.tgz
$> curl http://r:readpw@192.168.6.75:1234/bucket1
file1
tar1.tgz
```

From scripts running on the Exasol cluster, you can access the
      files locally for simplification reasons. You don't need to define any
      IP address and can be sure that the data is used from the local node.
      The corresponding path for a bucket can be found in EXAoperation in the
      overview of a bucket.
      
The access control is organized by using a database CONNECTION
      object,
      because for the database, buckets look similar to normal external data
      sources. The connection contains the path to the bucket and the read
      password. After granting that connection to someone using the `GRANT` command, the bucket becomes
      visible/accessible for that user. If you want to allow all users to
      access a bucket, you can define that bucket in EXAoperation as
      _public_.

Similar to external clients, write access from scripts is only
        possible via http(s), but you still would have to be careful with the
        parallelism of script processes.

In the following example, a connection to a bucket is defined and
      granted. Afterwards, a script is created which lists the files from a
      local path. You can see in the example that the equivalent local path
      for the previously created bucket `bucket`1 is
      `/buckets/bfsdefault/bucket`1.

```sql
CREATE CONNECTION my_bucket_access TO 'bucketfs:bfsdefault/bucket1' 
  IDENTIFIED BY 'readpw';

GRANT CONNECTION my_bucket_access TO my_user;

CREATE PYTHON SCALAR SCRIPT ls(my_path VARCHAR(100)) 
EMITS (files VARCHAR(100)) AS
import subprocess

def run(c):
    try:
        p = subprocess.Popen('ls '+c.my_path, 
                             stdout    = subprocess.PIPE, 
                             stderr    = subprocess.STDOUT, 
                             close_fds = True, 
                             shell     = True)
        out, err = p.communicate()
        for line in out.strip().split('\n'):
            c.emit(line)
    finally:
        if p is not None:
            try: p.kill()
            except: pass
/

SELECT ls('/buckets/bfsdefault/bucket1');

FILES                                                                                                
---------------------
file1
tar1

SELECT ls('/buckets/bfsdefault/bucket1/tar1/');

FILES                                                                                                
---------------------
a
b        
```
As you might have recognized in the example, archives
      (`.zip`, `.tar`, `.tar.gz` or
      `.tgz`) are always extracted for the script access on the
      local file system. From outside (e.g. via `curl`) you see the
      archive while you can locally use the extracted files from within the
      scripts.
<note>If you store archives (`.zip`, `.tar`,
        `.tar.gz` or `.tgz`) in the BucketFS, both the
        original files and the extracted files are stored and need therefore
        storage space twice.

<tip>If you want to work on an archive directly, you can avoid the
        extraction by renaming the file extension (e.g. `.zipx`
        instead of `.zip`).



## Expanding script languages using BucketFS

If Exasol's preconfigured set of script languages is sufficient for
    your needs, you don't need to consider this chapter. But if you want to
    expand the script languages (e.g. installing additional R packages) or
    even integrate completely new languages into the script framework, you can
    easily do that using BucketFS.
    
### Expanding the existing script languages

The first option is to expand the existing languages by adding
      further packages. The corresponding procedure differs for every language
      and will therefore be explained in the following sections.

The script language Lua is not expandable, because it is
        natively compiled into the Exasol database software.

#### Java files (.jar)

For Java, you can integrate`.jar` files in Exasol
        easily. You only have to save the file in a bucket and reference the
        corresponding path directly in your Java script.
        
If you for instance want to use Google's library to process
        telephone numbers (http://mavensearch.io/repo/com.googlecode.libphonenumber/libphonenumber/4.2),
        you could upload the file similarly to the examples above in the
        bucket named `javalib`. The corresponding local bucket path
        would look like the following:
        `/buckets/bfsdefault/javalib/libphonenumber-4.2.jar`.
        
In the script below you can see how this path is specified to be
        able to import the library.

```sql
CREATE JAVA SCALAR SCRIPT jphone(num VARCHAR(2000))
RETURNS VARCHAR(2000) AS
%jar /buckets/bfsdefault/javalib/libphonenumber-4.2.jar;

import com.google.i18n.phonenumbers.PhoneNumberUtil;
import com.google.i18n.phonenumbers.NumberParseException;
import com.google.i18n.phonenumbers.Phonenumber.PhoneNumber;

class JPHONE {
  static String run(ExaMetadata exa, ExaIterator ctx) throws Exception {
    PhoneNumberUtil phoneUtil = PhoneNumberUtil.getInstance();
    try {
      PhoneNumber swissNumberProto = phoneUtil.parse(ctx.getString("num"),
                                                     "DE");
      return swissNumberProto.toString();
    } catch (NumberParseException e) {
      System.err.println("NumberParseException thrown: " + e.toString());
    }
    return "failed";
  }
}
/ 
```

#### Python libraries

Python libraries are often provided in the form of
        `.whl` files. You can easily integrate such libraries into
        Exasol by uploading the file to a bucket and extend the Python search
        path appropriately.

If you for instance want to use Google's library for processing
        phone numbers (https://pypi.python.org/pypi/phonenumbers), you could
        upload the file into the bucket named `pylib`. The
        corresponding local path would look like the following:
        `/buckets/bfsdefault/pylib/phonenumbers-7.7.5-py2.py3-none-any.whl`.

In the script below you can see how this path is specified to be
        able to import the library.

```sql
CREATE PYTHON SCALAR SCRIPT phonenumber(phone_number VARCHAR(2000)) 
RETURNS VARCHAR(2000) AS
import sys
import glob

sys.path.extend(glob.glob('/buckets/bfsdefault/pylib/*'))
import phonenumbers

def run(c):
   return str(phonenumbers.parse(c.phone_number,None))
/

SELECT phonenumber('+1-555-2368') AS ghost_busters;

GHOST_BUSTERS
-----------------------------------------
Country Code: 1 National Number: 55552368
```

#### R packages

The installation of R packages is a bit more complex because
        they have to be compiled using the c compiler. To manage that, you can
        download the existing Exasol Linux container, compile the package in
        that container and upload the resulting package into BucketFS. Details
        about the Linux container will be explained in the following
        chapter.
        
A simple method is using Docker as described in the following
        example.

```
$> bucketfs = http://192.168.6.75:1234
$> cont = /default/EXAClusterOS/ScriptLanguages-2016-10-21.tar.gz
$> docker $bucketfs$cont import my_dock
$> mkdir r_pkg
$> docker run -v `pwd`/r_pkg:/r_pkg --name=my_dock -it my_dock /bin/bash
```

Again we want to use an existing package for processing phone
        numbers, this time from Steve Myles (https://cran.r-project.org/web/packages/phonenumber/index.html).

Within the Docker container, you can start R and install
        it:

```
# export R_LIBS="/r_pkg/"
# R
> install.packages('phonenumber', repos="http://cran.r-project.org")
Installing package into '/r_pkg'
(as 'lib' is unspecified)
trying URL 'http://cran.r-project.org/src/contrib/phonenumber_0.2.2.tar.gz'
Content type 'application/x-gzip' length 10516 bytes (10 KB)
==================================================
downloaded 10 KB
```

The first line installs the package from the Linux container
        into the subfolder `r_pkg` which can be accessed outside
        the Docker container.

Afterwards, the resulting tgz archive is uploaded into the
        bucket named `rlib`:

```sql
$> bucketfs = http://w:writepw@192.168.6.75:1234
$> curl -vX PUT -T r_pkg.tgz $bucketfs/rlib/r_pkg.tgz
```
In the following script you can see how the resulting local path
        (`/buckets/bfsdefault/rlib/r_pkg`) is specified to be able
        to use the library.

```sql
CREATE R SCALAR SCRIPT tophone(letters VARCHAR(2000)) RETURNS INT AS
.libPaths( c( .libPaths(), "/buckets/bfsdefault/rlib/r_pkg") )
library(phonenumber)

run <- function(ctx) {
   letterToNumber(ctx$letters, qz = 1)
}
/
```


### Installing new script languages

Due to Exasol's open script framework it is simply possible to
      integrate completely new script languages into Exasol, following these 3
      steps:
      
- Creating a functioning language client
- Upload the resulting client into a bucket
- Define a script language alias

The language has to be expanded by some small
      APIs which implement the communication between Exasol and the language.
      Afterwards the client is compiled for the usage in the pre-installed
      Exasol Linux Container, so that it can be started within a secure
      process on the Exasol cluster.
      
The last step creates a link between the language client and
      Exasol's SQL language, actually the `CREATE SCRIPT` command. This facilitates many
      options to try out new versions of a language or completely new
      languages and finally replace them completely.
      
If you for instance plan to migrate from Python 2 to Python 3, you
      could upload a new client and link the alias `PYTHON`
      temporarily to the new version via `ALTER SESSION`. After a thorough testing phase,
      you can finally switch to the new version for all users via the `ALTER SYSTEM` statement.
      
On the other side, it is also possible to use both language
      versions in parallel by defining two aliases separately (e.g.
      `PYTHON2` and `PYTHON3`).
      
### Creating a script client

The main task of installing new languages is developing the
        script client. If you are interested in a certain language, you should
        first check whether the corresponding client has already been
        published in our open source repository (see https://github.com/exasol/script-languages). Otherwise
        we would be very happy if you would contribute self-developed clients
        to our open source community.
        
A script client is based on a Linux container which is stored in
        BucketFS. The pre-installed script client for languages Python, Java
        and R is located in the default bucket of the default BucketFS. Using
        the Linux container technology, an encapsulated virtual machine is
        started in a safe environment whenever an SQL query contains script
        code. The Linux container includes a complete Linux distribution and
        starts the corresponding script client for executing the script code.
        In general, you could also upload your own Linux container and combine
        it with your script client.
        
The script client has to implement a certain protocol that
        controls the communication between the scripts and the database. For
        that purpose, the established technologies ZeroMQ
    and Google's Protocol Buffers are used. Because
        of the length, the actual protocol definition is not included in this
        user manual. For details, please have a look into our open source
        repository where
        you'll find the following:
        

### Script aliases for the integration into SQL

After building and uploading a script client, you have to
        configure an alias within Exasol. The database then knows where each
        script language has been installed.
You can change the script aliases via the commands `ALTER SESSION` and `ALTER SYSTEM`, either session-wide or
        system-wide. This is handy especially for using several language
        versions in parallel, or migrating from one version to another.
The current session and system parameters can be found in `EXA_PARAMETERS`. The scripts aliases are defined via the
        parameter `SCRIPT_LANGUAGES`:

```sql
SELECT session_value FROM exa_parameters 
WHERE parameter_name='SCRIPT_LANGUAGES';

PARAMETER_NAME
---------------------------------------------------
PYTHON=builtin_python R=builtin_r JAVA=builtin_java
```
These values are not very meaningful since they are just
        internal macros to make that parameter compact and to dynamically use
        the last installed version. Written out, the alias for Java would look
        like the following:
`JAVA=localzmq+protobuf:///bfsdefault/default/EXAClusterOS/ScriptLanguages-2016-10-21/?lang=java#buckets/bfsdefault/default/EXASolution-6.0.0/exaudfclient`

That alias means that for all `CREATE JAVA SCRIPT`
        statements, the Exasol database will use the script client
        `exaudfclient` from local path
        `buckets/bfsdefault/default/EXASolution-2016-10-21/`,
        started within the Exasol Linux container from path
        `bfsdefault/default/EXAClusterOS/ScriptLanguages-2016-10-21`.
        The used communication protocol is `localzmq+protobuf`
        (this is the only supported protocol so far).
        
For the three pre-installed languages (Python, R, Java), Exasol
        uses one single script client which evaluates the parameter
        `lang=java` to differentiate between these languages.
        That's why the internal macro for the Python alias looks nearly
        identical. Script clients implemented by users can of course define
        and evaluate such optional parameters individually.
        
In general, a script alias contains the following
        elements:
```        
<alias>=localzmq+protobuf:///<path_to_linux-container>/[?<client_param_list>]#<path_to_client>
```

Please note that a script alias may not contain
            spaces.


Maybe you have noticed in the Java alias that the path of the
        Linux container begins with the BucketFS while the client path
        contains the prefix `buckets/`. The reason for that is that
        the client is started in a secure environment within the Linux
        container and may only access the existing (and visible) buckets.
        Access is granted just to the embedded buckets (via
        `mount`), but not to the real server's underlying file
        system. The path `/buckets/` can be used read-only from
        within scripts as described in the previous chapter.
        
You can define or rename any number of aliases. As mentioned
        before, we recommend to test such adjustments at first in your own
        session before making that change globally visible via `ALTER SYSTEM`.




