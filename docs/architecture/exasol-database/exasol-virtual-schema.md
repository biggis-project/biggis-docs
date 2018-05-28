# Exasol Virtual Schema

Virtual schemas provide a powerful abstraction to conveniently access
arbitrary data sources. Virtual schemas are a kind of read-only link
to an external source and contain virtual tables which look like
regular tables except that the actual data are not stored
locally.

After creating a virtual schema, its included tables can be used in
SQL queries and even combined with persistent tables stored directly
in Exasol, or with other virtual tables from other virtual
schemas. The SQL optimizer internally translates the virtual objects
into connections to the underlying systems and implicitly transfers
the necessary data. SQL conditions are tried to be pushed down to the
data sources to ensure minimal data transfer and optimal performance.

That's why this concept creates a kind of logical view on top of
several data sources which could be databases or other data
services. By that, you can either implement a harmonized access layer
for your reporting tools. Or you can use this technology for agile and
flexible ETL processing, since you don't need to change anything in
Exasol if you change or extend the objects in the underlying
system.

The following basic example shows you how easy it is to create and use
a virtual schema by using our JDBC adapter to connect Exasol with a
Hive system.

```sql
-- Create the schema by specifying some adapter access properties
CREATE VIRTUAL SCHEMA hive
 USING adapter.jdbc_adapter
 WITH
  CONNECTION_STRING = 'jdbc:hive://myhost:21050;AuthMech=0'
  USERNAME          = 'hive-user'
  PASSWORD          = 'secret-password'
  SCHEMA_NAME       = 'default';

-- Explore the tables in the virtual schema
OPEN SCHEMA hive;
SELECT * FROM cat;
DESCRIBE clicks;

-- Run queries against the virtual tables
SELECT count(*) FROM clicks;
SELECT DISTINCT USER_ID FROM clicks;
-- queries can combine virtual and native tables
SELECT * from clicks JOIN native_schema.users ON clicks.userid = users.id;
```

SQL Commands to manage virtual schemas:

- `CREATE VIRTUAL SCHEMA`

    Creating a virtual schema.

- `DROP VIRTUAL SCHEMA`

    Deleting a virtual schema and all contained  virtual tables.

- `ALTER VIRTUAL SCHEMA`

    Adjust the properties of an virtual schema or refresh the metadata
    using the REFRESH option.

- `EXPLAIN VIRTUAL`

    Useful to analyze which resulting queries for external systems are
    created by the Exasol compiler.

Instead of shipping just a certain number of supported connectors
(so-called adapters) to other technologies, we decided to provide
users an open, extensible framework where the connectivity logic is
shared as open source. By that, you can easily use existing adapters,
optimize them for your need or even create additional adapters to all
kinds of data sources by your own without any need to wait for a new
release from Exasol.

## Adapters and properties

If you create a virtual schema, you have to specify the corresponding
adapter - to be precise an adapter script - which implements the logic
how to access data from the external system. This varies from
technology to technology, but always includes two main task:

-  Read metadata
  
     Receive information about the objects included in the schema
     (tables, columns, types) and define the logic how to map the data
     types of the source system to the Exasol data types.
            
-  Push down query
  
     Push down parts of the Exasol SQL query into an appropriate query
     the the external system. The adapter defines what kind of logic
     Exasol can push down (e.g. filters or certain functions). The
     Exasol optimizer will then try to push down as much as possible
     and execute the rest of the query locally on the Exasol cluster.

Adapters are similar to UDF scripts. They can be implemented in one of
the supported programming languages, for example Java or Python, and
they can access the same metadata which is available within UDF
scripts. To install an adapter you simply download and execute the SQL
scripts which creates the adapter script in one of your normal
schemas.
    
The existing open source adapters provided by Exasol can be found in
our GitHub repository: https://www.github.com/exasol/virtual-schemas

A very generic implementation is our JDBC adapter with which you can
integrate nearly any data source providing a Linux JDBC driver.  For
some database systems, an appropriate dialect was already implemented
to push as much processing as possible down to the underlying
system. Please note that for using this JDBC adapter you have to
upload the corresponding in BucketFS for the access from adapter
scripts. Additionally the driver has to be installed via EXAoperation,
because the JDBC adapter executes an implicit IMPORT command).
        
SQL Commands to manage adapter scripts:

- `CREATE ADAPTER SCRIPT`

    Creating an adapter script.
    
- `DROP ADAPTER SCRIPT`

    Deleting an adapter script.
    
- `EXPLAIN VIRTUAL`

    Useful to analyze which resulting queries for external systems are
    created by the Exasol compiler.

The following example shows a shortened adapter script written in
Python.

```sql
CREATE SCHEMA adapter;
CREATE OR REPLACE PYTHON ADAPTER SCRIPT adapter.my_adapter AS
def adapter_call(request):
  # Implement your adapter here.
  # ...
  # It has to return an appropriate response.
/
```

Afterwards you can create virtual schemas by providing certain
properties which are required for the adapter script (see initial
example). These properties typically define the necessary information
to establish a connection to the external system. In the example, this
was the jdbc connection string and the credentials.
    
But properties can flexibly defined and hence contain all kinds of
auxiliary data which controls the logic how to use the data source. If
you implement or adjust your own adapter scripts, then you can define
your own properties and use them appropriately.
    
The list of specified properties of a specific virtual schema can be
seen in the system table `exa_all_virtual_schema_properties`. After
creating the schema, you can adjust these properties using the SQL
command `alter_schema_statement`.
    
After the virtual schema was created in the described way, you can use
the contained tables in the same way as the normal tables in Exasol,
and even combine them in SQL queries. And if you want to use this
technology just for simple ETL jobs, you can of course simply
materialize a query on the virtual tables:
    
```sql
CREATE VIRTUAL SCHEMA hive
 USING adapter.jdbc_adapter
 WITH
  CONNECTION_STRING = 'jdbc:hive://myhost:21050;AuthMech=0'
  USERNAME          = 'hive-user'
  PASSWORD          = 'secret-password'
  SCHEMA_NAME       = 'default';

CREATE TABLE my_schema.clicks_copy FROM 
  (SELECT * FROM hive.clicks);
```

## Grant access on virtual tables

The access to virtual data works similar to the creation of view by
simply granting the SELECT privilege for the virtual schema. In the
case of a virtual schema you can grant this right only for the schema
altogether (via GRANT SELECT ON SCHEMA). Alternatively, the user is
the owner or the schema.
    
Internally, this works similar to views since the check for privileges
is executed in the name of the script owner. By that the details are
completely encapsulated, i.e. the access to adapter scripts and the
credentials to the external system.
    

If you don't want to grant full access for a virtual schema but
selectively for certain tables, you can do that by different
alternatives:
    
- Views

    Instead of granting direct access to the virtual schema you can
    also create views on that data and provide indirect access for
    certain users.

- Logic within the adapter script

    It is possible to solve this requirement directly within the
    adapter script. E.g. in our published JDBC adapter, there exists
    the parameter `TABLE_FILTER` through which you can define a list
    of tables which should be visible (see
    https://www.github.com/exasol). If this virtual schema property is
    not defined, then all available tables are made visible.


In most cases you also need access to the connection details (actually
the user and password), because the adapter script needs a direct
connection to read the metadata from the external in case of commands
such as CREATE and REFRESH. For that purpose the special ACCESS
privilege has been introduced, because of the criticality of these
data protection relevant connection details. By the statement GRANT
ACCESS ON CONNECTION [FOR SCRIPT] you can also limit that access only
to a specific script (FOR SCRIPT clause) and ensure that the
administrator cannot access that data himself (e.g. by creating a new
script which extracts and simply returns the credentials). Of course
that user should only be allowed to execute, but not alter the script
by any means.

In the example below, the administrator gets the appropriate
privileges to create a virtual schema by using the adapter script
(`jdbc_adapter`) and a certain connection (`hive_conn`).

```sql
GRANT CREATE VIRTUAL SCHEMA TO user_hive_access;
GRANT EXECUTE ON SCRIPT adapter.jdbc_adapter TO user_hive_access;
GRANT CONNECTION hive_conn TO user_hive_access;
GRANT ACCESS ON CONNECTION hive_conn 
  FOR SCRIPT adapter.jdbc_adapter TO user_hive_access;
```

## Data Access

Every time you access data of a virtual schema, on one node of the
cluster a container of the corresponding language is started, e.g. a
JVM or a Python container. Inside this container, the code of the
adapter script will be loaded. Exasol interacts with the adapter
script using a simple request-response protocol encoded in JSON. The
database takes the active part sending the requests by invoking a
callback method.
    
In case of Python, this method is called `adapter_call` per
convention, but this can vary.
    
Let's take a very easy example of accessing a virtual table.
```sql
SELECT name FROM my_virtual_schema.users WHERE name like 'A%';
```

The following happens behind the scenes:

- Exasol determines that a virtual table is involved, looks up the
  corresponding adapter script and starts the language container on
  one single node in the Exasol cluster.

- Exasol sends a request to the adapter, asking for the capabilities
  of the adapter.

- The adapter returns a response including the supported capabilities,
  for example whether it supports specific WHERE clause filters or
  specific scalar functions.

- Exasol sends an appropriate pushdown request by considering the
  specific adapter capabilities. For example, the information for
  column projections (in the example above, only the single column
  name is necessary) or filter conditions is included.

The adapter processes this request and sends back a certain SQL query
in Exasol syntax which will be executed afterwards. This query is
typically an IMPORT statement or a SELECT statement including an
row-emitting UDF script which cares about the data processing.  The
example above could be transformed into these two alternatives (IMPORT
and SELECT):
  
```sql
SELECT name FROM ( IMPORT FROM JDBC AT ... STATEMENT
        'SELECT name from remoteschema.users WHERE name LIKE "A%"'
        );

SELECT name FROM ( SELECT
        GET_FROM_MY_DATA_SOURCE('data-source-address', 'required_column=name')
        ) WHERE name LIKE 'A%';
```

In the first alternative, the adapter can handle filter conditions and
creates an IMPORT command including a statement which is sent to the
external system. In the second alternative, a UDF script is used with
two parameters handing over the address of the data source and the
column projection, but not using any logic for the filter
condition. This would then be processed by Exasol rather than the data
source.
        
Please be aware that the examples show the fully transformed query
while only the inner statements are created by the adapter.

The received data is directly integrated into the overall query
execution of Exasol.


## Virtual Schema API

There are the following request and response types:

| Type                        | Called ...     |
| :-------------------------- | :------------- |
| **Create Virtual Schema**   | ... for each `CREATE VIRTUAL SCHEMA ...` statement |
| **Refresh**                 | ... for each `ALTER VIRTUAL SCHEMA ... REFRESH ...` statement. |
| **Set Properties**          | ... for each `ALTER VIRTUAL SCHEMA ... SET ...` statement. |
| **Drop Virtual Schema**     | ... for each `DROP VIRTUAL SCHEMA ...` statement. |
| **Get Capabilities**        | ... whenever a virtual table is queried in a `SELECT` statement. |
| **Pushdown**                | ... whenever a virtual table is queried in a `SELECT` statement. |

We describe each of the types in the following sections.

!!! note "Please note"
    To keep the documentation concise we defined the elements which are commonly in separate sections below, e.g.
    `schemaMetadataInfo` and `schemaMetadata`.

## Requests and Responses

### Create Virtual Schema

Informs the Adapter about the request to create a Virtual Schema, and asks the Adapter for the metadata (tables and
columns).

The Adapter is allowed to throw an Exception if the user missed to provide mandatory properties or in case of any other
problems (e.g. connectivity).

**Request:**

```json
{
    "type": "createVirtualSchema",
    "schemaMetadataInfo": {
        ...
    }
}
```

**Response:**

```json
{
    "type": "createVirtualSchema",
    "schemaMetadata": {
        ...
    }
}
```

!!! notes
    `schemaMetadata` is mandatory. However, it is allowed to contain no tables.


### Refresh

Request to refresh the metadata for the whole Virtual Schema, or for specified tables.

**Request:**

```json
{
    "type": "refresh",
    "schemaMetadataInfo": {
        ...
    },
    "requestedTables": ["T1", "T2"]
}
```

!!! notes
    `requestedTables` is optional. If existing, only the specified tables shall be refreshed. The specified tables
    do not have to exist, it just tell Adapter to update these tables (which might be changed, deleted, added, or
    non-existing).

**Response:**

```json
{
    "type": "refresh",
    "schemaMetadata": {
        ...
    },
    "requestedTables": ["T1", "T2"]
}
```

!!! notes
    - `schemaMetadata` is optional. It can be skipped if the adapter does not want to refresh (e.g. because he
      detected that there is no change).
    - `requestedTables` must exist if and only if the element existed in the request. The values must be the same
      as in the request (to make sure that Adapter only refreshed these tables).

### Set Properties

Request to set properties. The Adapter can decide whether he needs to send back new metadata. The Adapter is allowed to
throw an Exception if the user provided invalid properties or in case of any other problems (e.g. connectivity).

**Request:**

```json
{
    "type": "setProperties",
    "schemaMetadataInfo": {
        ...
    },
    "properties": {
        "JDBC_CONNECTION_STRING": "new-jdbc-connection-string",
        "NEW_PROPERTY": "value of a not yet existing property"
        "DELETED_PROPERTY": null
    }
}
```

**Response:**

```json
{
    "type": "setProperties",
    "schemaMetadata": {
        ...
    }
}
```

!!! notes
    - **Request:** A property set to null means that this property was asked to be deleted. Properties set to null might
      also not have existed before.
    - **Response:** `schemaMetadata` is optional. It only exists if the adapter wants to send back new metadata.
      The existing metadata are overwritten completely.


### Drop Virtual Schema

Inform the Adapter that a Virtual Schema is about to be dropped. The Adapter can update external dependencies if he has
such. The Adapter is not expected to throw an exception, and if he does, it will be ignored.

**Request:**

```json
{
    "type": "dropVirtualSchema",
    "schemaMetadataInfo": {
        ...
    }
}
```

**Response:**

```json
{
    "type": "dropVirtualSchema"
}
```


### Get Capabilities

Request the list of capabilities supported by the Adapter. Based on these capabilities, the database will collect
everything that can be pushed down in the current query and sends a pushdown request afterwards.

**Request:**

```json
{
    "type": "getCapabilities",
    "schemaMetadataInfo": {
        ...
    }
}
```

**Response:**

```json
{
    "type": "getCapabilities",
    "capabilities": [
        "ORDER_BY_COLUMN",
        "AGGREGATE_SINGLE_GROUP",
        "LIMIT",
        "AGGREGATE_GROUP_BY_TUPLE",
        "FILTER_EXPRESSIONS",
        "SELECTLIST_EXPRESSIONS",
        "SELECTLIST_PROJECTION",
        "AGGREGATE_HAVING",
        "ORDER_BY_EXPRESSION",
        "AGGREGATE_GROUP_BY_EXPRESSION",
        "LIMIT_WITH_OFFSET",
        "AGGREGATE_GROUP_BY_COLUMN",
        "FN_PRED_LESSEQUALS",
        "FN_AGG_COUNT",
        "LITERAL_EXACTNUMERIC",
        "LITERAL_DATE",
        "LITERAL_INTERVAL",
        "LITERAL_TIMESTAMP_UTC",
        "LITERAL_TIMESTAMP",
        "LITERAL_NULL",
        "LITERAL_STRING",
        "LITERAL_DOUBLE",
        "LITERAL_BOOL"
    ]
}
```

The set of capabilities in the example above would be sufficient to pushdown all aspects of the following query:
```sql
SELECT user_id, count(url) FROM VS.clicks
 WHERE user_id>1
 GROUP BY user_id
 HAVING count(url)>1
 ORDER BY user_id
 LIMIT 10;
```

The whole set of capabilities is a lot longer. The current list of supported Capabilities can be found in the sources of the JDBC Adapter:

  - [High Level Capabilities](https://github.com/EXASOL/virtual-schemas/blob/master/jdbc-adapter/virtualschema-common/src/main/java/com/exasol/adapter/capabilities/MainCapability.java)
  - [Literal Capabilities](https://github.com/EXASOL/virtual-schemas/blob/master/jdbc-adapter/virtualschema-common/src/main/java/com/exasol/adapter/capabilities/LiteralCapability.java)
  - [Predicate Capabilities](https://github.com/EXASOL/virtual-schemas/blob/master/jdbc-adapter/virtualschema-common/src/main/java/com/exasol/adapter/capabilities/PredicateCapability.java)
  - [Scalar Function Capabilities](https://github.com/EXASOL/virtual-schemas/blob/master/jdbc-adapter/virtualschema-common/src/main/java/com/exasol/adapter/capabilities/ScalarFunctionCapability.java)
  - [Aggregate Function Capabilities](https://github.com/EXASOL/virtual-schemas/blob/master/jdbc-adapter/virtualschema-common/src/main/java/com/exasol/adapter/capabilities/AggregateFunctionCapability.java)


### Pushdown

Contains an abstract specification of what to be pushed down, and requests an pushdown SQL statement from the Adapter
which can be used to retrieve the requested data.

**Request:**

Running the following query
```sql
SELECT user_id, count(url) FROM VS.clicks
 WHERE user_id>1
 GROUP BY user_id
 HAVING count(url)>1
 ORDER BY user_id
 LIMIT 10;
```
will produce the following Request, assuming that the Adapter has all required capabilities.

```json
{
    "type": "pushdown",
    "pushdownRequest": {
        "type" : "select",
        "aggregationType" : "group_by",
        "from" :
        {
            "type" : "table",
            "name" : "CLICKS"
        },
        "selectList" :
        [
            {
                "type" : "column",
                "name" : "USER_ID",
                "columnNr" : 1,
                "tableName" : "CLICKS"
            },
            {
                "type" : "function_aggregate",
                "name" : "count",
                "arguments" :
                [
                    {
                        "type" : "column",
                        "name" : "URL",
                        "columnNr" : 2,
                        "tableName" : "CLICKS"
                    }
                ]
            }
        ],
        "filter" :
        {
            "type" : "predicate_less",
            "left" :
            {
                "type" : "literal_exactnumeric",
                "value" : "1"
            },
            "right" :
            {
                "type" : "column",
                "name" : "USER_ID",
                "columnNr" : 1,
                "tableName" : "CLICKS"
            }
        },
        "groupBy" :
        [
            {
                "type" : "column",
                "name" : "USER_ID",
                "columnNr" : 1,
                "tableName" : "CLICKS"
            }
        ],
        "having" :
        {
            "type" : "predicate_less",
            "left" :
            {
                "type" : "literal_exactnumeric",
                "value" : "1"
            },
            "right" :
            {
                "type" : "function_aggregate",
                "name" : "count",
                "arguments" :
                [
                    {
                        "type" : "column",
                        "name" : "URL",
                        "columnNr" : 2,
                        "tableName" : "CLICKS"
                    }
                ]
            }
        },
        "orderBy" :
        [
            {
                "type" : "order_by_element",
                "expression" :
                {
                    "type" : "column",
                    "columnNr" : 1,
                    "name" : "USER_ID",
                    "tableName" : "CLICKS"
                },
                "isAscending" : true,
                "nullsLast" : true
            }
        ],
        "limit" :
        {
            "numElements" : 10
        }
    },
    "involvedTables": [
    {
        "name" : "CLICKS",
        "columns" :
        [
            {
                "name" : "ID",
                "dataType" :
                {
                    "type" : "DECIMAL",
                    "precision" : 18,
                    "scale" : 0
                }
            },
            {
                "name" : "USER_ID",
                "dataType" :
                {
                   "type" : "DECIMAL",
                   "precision" : 18,
                    "scale" : 0
                }
            },
            {
                "name" : "URL",
                "dataType" :
                {
                   "type" : "VARCHAR",
                   "size" : 1000
                }
            },
            {
                "name" : "REQUEST_TIME",
                "dataType" :
                {
                    "type" : "TIMESTAMP"
                }
            }
        ]
    }
    ],
    "schemaMetadataInfo": {
        ...
    }
}
```

!!! notes
    - `pushdownRequest`: Specification what needs to be pushed down. You can think of it like a parsed SQL statement.
      - `from`: The requested from clause. Currently only tables are supported, joins might be supported in future.
      - `selectList`: The requested select list elements, a list of expression. The order of the selectlist elements
        matters. If the select list is an empty list, we request at least a single column/expression, which could also
        be constant TRUE.
      - `selectList.columnNr`: Position of the column in the virtual table, starting with 0
      - `filter`: The requested filter (where clause), a single expression.
      - `aggregationType`: Optional element, set if an aggregation is requested. Either `group_by` or `single_group`,
        if a aggregate function is used but no group by.
      - `groupBy`: The requested group by clause, a list of expressions.
      - `having`: The requested having clause, a single expression.
      - `orderBy`: The requested order-by clause, a list of `order_by_element` elements. The field `expression`
        contains the expression to order by.
      - `limit` The requested limit of the result set, with an optional offset.
    - `involvedTables`: Metadata of the involved tables, encoded like in schemaMetadata.


**Response:**

Following the example above, a valid result could look like this:

```json
{
    "type": "pushdown",
    "sql": "IMPORT FROM JDBC AT 'jdbc:exa:remote-db:8563;schema=native' USER 'sys' IDENTIFIED BY 'exasol' STATEMENT 'SELECT USER_ID, count(URL) FROM NATIVE.CLICKS WHERE 1 < USER_ID GROUP BY USER_ID HAVING 1 < count(URL) ORDER BY USER_ID LIMIT 10'"
}
```

!!! note
    `sql`: The pushdown SQL statement. It must be either an `SELECT` or `IMPORT` statement.

## Embedded Commonly Used Json Elements

The following Json objects can be embedded in a request or response. They have a fixed structure.

### Schema Metadata Info

This document contains the most important metadata of the virtual schema and is sent to the adapter just "for
information" with each request. It is the value of an element called `schemaMetadataInfo`.

```json
{"schemaMetadataInfo":{
    "name": "MY_HIVE_VSCHEMA",
    "adapterNotes": {
        "lastRefreshed": "2015-03-01 12:10:01",
        "key": "Any custom schema state here"
    },
    "properties": {
        "HIVE_SERVER": "my-hive-server",
        "HIVE_DB": "my-hive-db",
        "HIVE_USER": "my-hive-user"
    }
}}
```

### Schema Metadata

This document is usually embedded in responses from the Adapter and informs the database about all metadata of the
Virtual Schema, especially the contained Virtual Tables and it's columns. The Adapter can store so called `adapterNotes`
on each level (schema, table, column), to remember information which might be relevant for the Adapter in future. In the
example below, the Adapter remembers the table partitioning and the data type of a column which is not directly
supported in EXASOL. The Adapter has these information during pushdown and can consider the table partitioning during
pushdown or can add an appropriate cast for the column.

```json
{"schemaMetadata":{
    "adapterNotes": {
        "lastRefreshed": "2015-03-01 12:10:01",
        "key": "Any custom schema state here"
    },
    "tables": [
    {
        "type": "table",
        "name": "EXASOL_CUSTOMERS",
        "adapterNotes": {
            "hivePartitionColumns": ["CREATED", "COUNTRY_ISO"]
        },
        "columns": [
        {
            "name": "ID",
            "dataType": {
                "type": "DECIMAL",
                "precision": 18,
                "scale": 0
            },
            "isIdentity": true
        },
        {
            "name": "COMPANY_NAME",
            "dataType": {
                "type": "VARCHAR",
                "size": 1000,
                "characterSet": "UTF8"
            },
            "default": "foo",
            "isNullable": false,
            "comment": "The official name of the company",
            "adapterNotes": {
                "hiveType": {
                    "dataType": "List<String>"
                }
            }
        },
        {
            "name": "DISCOUNT_RATE",
            "dataType": {
                "type": "DOUBLE"
            }
        }
        ]
    },
    {
        "type": "table",
        "name": "TABLE_2",
        "columns": [
        {
            "name": "COL1",
            "dataType": {
                "type": "DECIMAL",
                "precision": 18,
                "scale": 0
            }
        },
        {
            "name": "COL2",
            "dataType": {
                "type": "VARCHAR",
                "size": 1000
            }
        }
        ]
    }
    ]
}}
```

!!! notes
    - `adapterNotes` is an optional field which can be attached to the schema, a table or a column.
      It can be an arbitrarily nested Json document.

The following EXASOL data types are supported:

**Decimal:**

```json
{
    "name": "C_DECIMAL",
    "dataType": {
        "type": "DECIMAL",
        "precision": 18,
        "scale": 2
    }
}
```

**Double:**

```json
{
    "name": "C_DOUBLE",
    "dataType": {
        "type": "DOUBLE"
    }
}
```

**Varchar:**

```json
{
    "name": "C_VARCHAR_UTF8_1",
    "dataType": {
        "type": "VARCHAR",
        "size": 10000,
        "characterSet": "UTF8"
    }
}
```

```json
{
    "name": "C_VARCHAR_UTF8_2",
    "dataType": {
        "type": "VARCHAR",
        "size": 10000
    }
}
```

```json
{
    "name": "C_VARCHAR_ASCII",
    "dataType": {
        "type": "VARCHAR",
        "size": 10000,
        "characterSet": "ASCII"
    }
}
```

**Char:**

```json
{
    "name": "C_CHAR_UTF8_1",
    "dataType": {
        "type": "CHAR",
        "size": 3
    }
}
```

```json
{
    "name": "C_CHAR_UTF8_2",
    "dataType": {
        "type": "CHAR",
        "size": 3,
        "characterSet": "UTF8"
    }
}
```

```json
{
    "name": "C_CHAR_ASCII",
    "dataType": {
        "type": "CHAR",
        "size": 3,
        "characterSet": "ASCII"
    }
}
```

**Date:**

```json
{
    "name": "C_DATE",
    "dataType": {
        "type": "DATE"
    }
}
```

**Timestamp:**

```json
{
    "name": "C_TIMESTAMP_1",
    "dataType": {
        "type": "TIMESTAMP"
    }
}
```
```json
{
    "name": "C_TIMESTAMP_2",
    "dataType": {
        "type": "TIMESTAMP",
        "withLocalTimeZone": false
    }
}
```
```json
{
    "name": "C_TIMESTAMP_3",
    "dataType": {
        "type": "TIMESTAMP",
        "withLocalTimeZone": true
    }
}
```

**Boolean:**

```json
{
    "name": "C_BOOLEAN",
    "dataType": {
        "type": "BOOLEAN"
    }
}
```

**Geometry:**

```json
{
    "name": "C_GEOMETRY",
    "dataType": {
        "type": "GEOMETRY",
        "srid": 1
    }
}
```
**Interval:**
```json
{
    "name": "C_INTERVAL_DS_1",
    "dataType": {
        "type": "INTERVAL",
        "fromTo": "DAY TO SECONDS"
    }
}
```

```json
{
    "name": "C_INTERVAL_DS_2",
    "dataType": {
        "type": "INTERVAL",
        "fromTo": "DAY TO SECONDS",
        "precision": 3,
        "fraction": 4
    }
}
```

```json
{
    "name": "C_INTERVAL_YM_1",
    "dataType": {
        "type": "INTERVAL",
        "fromTo": "YEAR TO MONTH"
    }
}
```

```json
{
    "name": "C_INTERVAL_YM_2",
    "dataType": {
        "type": "INTERVAL",
        "fromTo": "YEAR TO MONTH",
        "precision": 3
    }
}
```


## Expressions

This section handles the expressions that can occur in a pushdown request. Expressions are consistently encoded in the
following way. This allows easy and consisting parsing and serialization.

```json
{
    "type": "<type-of-expression>",
    ...
}
```

Each expression-type can have any number of additional fields of arbitrary type. In the following sections we define the
known expressions.

### Table

This element currently only occurs in from clause

```json
{
    "type": "table",
    "name": "CLICKS"
}
```

### Column Lookup

```json
{
    "type": "column",
    "tableName": "T",
    "tablePosFromClause": 0,
    "columnNr": 0,
    "name": "ID"
}
```

!!! notes
    - **tablePosFromClause**: Position of the table in the from clause, starting with 0. Required for joins where same
      table occurs several times.
    - **columnNr**: column number in the virtual table, starting with 0

### Literal

```json
{
    "type": "literal_null"
}
```

```json
{
    "type": "literal_string",
    "value": "my string"
}
```

```json
{
    "type": "literal_double",
    "value": "1.234"
}
```

```json
{
    "type": "literal_exactnumeric",
    "value": "12345"
}
```

```json
{
    "type": "literal_bool",
    "value": true
}
```

```json
{
    "type": "literal_date",
    "value": "2015-12-01"
}
```

```json
{
    "type": "literal_timestamp",
    "value": "2015-12-01 12:01:01.1234"
}
```

```json
{
    "type": "literal_timestamputc",
    "value": "2015-12-01 12:01:01.1234"
}
```

### Predicates

Whenever there is `...` this is a shortcut for an arbitrary expression.

```json
{
    "type": "predicate_and",
    "expressions": [
        ...
    ]
}
```

The same can be used for "predicate_or".

```json
{
    "type": "predicate_not",
    "expression": {
        ...
    }
}
```

```json
{
    "type": "predicate_equals",
    "left": {
        ...
    },
    "right": {
        ...
    }
}
```

The same can be used for `predicate_notequals`, `predicate_less` and `predicate_lessequals`.

```json
{
    "type": "predicate_like",
    "expression": {
        ...
    },
    "pattern": {
        ...
    },
    "escapeChar": "%"
}
```

The same can be used for `predicate_like_regexp`

!!! notes
    - **escapeChar** is optional

```json
{
    "type": "predicate_between",
    "expression": {
        ...
    },
    "left": {
        ...
    },
    "right": {
        ...
    }
}
```

<exp> IN (<const1>, <const2>)

```json
{
    "type": "predicate_in_constlist",
    "expression": {
        ...
    }
    "arguments": [
        ...
    ]
}
```

### Scalar Functions

Single argument (consistent with multiple argument version)

```json
{
    "type": "function_scalar",
    "numArgs": 1,
    "name": "ABS",
    "arguments": [
    {
        ...
    }
    ]
}
```

Multiple arguments

```json
{
    "type": "function_scalar",
    "numArgs": 2,
    "name": "POWER",
    "arguments": [
    {
        ...
    },
    {
        ...
    }
    ]
}
```

```json
{
    "type": "function_scalar",
    "variableInputArgs": true,
    "name": "CONCAT",
    "arguments": [
    {
        ...
    },
    {
        ...
    },
    {
        ...
    }
    ]
}
```

!!! note
    **variableInputArgs**: default value is `false`. If true, `numArgs` is not defined.

Arithmetic operators have following names: ADD, SUB, MULT, FLOAT_DIV. They are defined as infix (just a hint, not
necessary)

```json
{
    "type": "function_scalar",
    "numArgs": 2,
    "name": "ADD",
    "infix": true,
    "arguments": [
    {
        ...
    },
    {
        ...
    }
    ]
}
```

**Special cases**

EXTRACT(toExtract FROM exp1) (requires scalar-function capability EXTRACT) 

```json
{
    "type": "function_scalar_extract",
    "name": "EXTRACT",
    "toExtract": "MINUTE",
    "arguments": [
    {
        ...
    }
    ],
}
```
CAST(exp1 AS dataType) (requires scalar-function capability CAST) 

```json
{
    "type": "function_scalar_cast",
    "name": "CAST",
    "dataType": 
    {
        "type" : "VARCHAR",
        "size" : 10000
    },
    "arguments": [
    {
        ...
    }
    ],
}
```

CASE (requires scalar-function capability CAST)

```sql
CASE basis WHEN exp1 THEN result1
           WHEN exp2 THEN result2
           ELSE result3
           END
```

```json
{
    "type": "function_scalar_case",
    "name": "CASE",
    "basis" :
    {
        "type" : "column",
        "columnNr" : 0,
        "name" : "NUMERIC_GRADES",
        "tableName" : "GRADES"
    },
    "arguments": [
    {        
        "type" : "literal_exactnumeric",
        "value" : "1"
    },       
    {        
        "type" : "literal_exactnumeric",
        "value" : "2"
    }
    ],
    "results": [
    {        
        "type" : "literal_string",
        "value" : "VERY GOOD"
    },       
    {        
        "type" : "literal_string",
        "value" : "GOOD"
    },
    {        
        "type" : "literal_string",
        "value" : "INVALID"
    }
    ]
}
```

!!! notes
    - `arguments`: The different cases.
    - `results`: The different results in the same order as the arguments. If present, the ELSE result
      is the last entry in the `results` array.

### Aggregate Functions

Consistent with scalar functions. To be detailed: star-operator, distinct, ...

```json
{
    "type": "function_aggregate",
    "name": "SUM",
    "arguments": [
    {
        ...
    }
    ]
}
```

```json
{
    "type": "function_aggregate",
    "name": "CORR",
    "arguments": [
    {
        ...
    },
    {
        ...
    }
    ]
}
```

**Special cases**

COUNT(exp)     (requires set-function capability COUNT)

```json
{
    "type": "function_aggregate",
    "name": "COUNT",
    "arguments": [
    {
        ...
    }
    ]
}
```

COUNT(*) (requires set-function capability COUNT and COUNT_STAR)

```json
{
    "type": "function_aggregate",
    "name": "COUNT"
}
```

COUNT(DISTINCT exp)    (requires set-function capability COUNT and COUNT_DISTINCT)

```json
{
    "type": "function_aggregate",
    "name": "COUNT",
    "distinct": true,
    "arguments": [
    {
        ...
    }
    ]
}
```

COUNT((exp1, exp2))   (requires set-function capability COUNT and COUNT_TUPLE)

```json
{
    "type": "function_aggregate",
    "name": "COUNT",
    "distinct": true,
    "arguments": [
    {
        ...
    },
    {
        ...
    }
    ]
}
```
AVG(exp)     (requires set-function capability AVG)

```json
{
    "type": "function_aggregate",
    "name": "AVG",
    "arguments": [
    {
        ...
    }
    ]
}
```

AVG(DISTINCT exp)    (requires set-function capability AVG and AVG_DISTINCT)

```json
{
    "type": "function_aggregate",
    "name": "AVG",
    "distinct": true,
    "arguments": [
    {
        ...
    }
    ]
}
```

GROUP_CONCAT(DISTINCT exp1 orderBy SEPARATOR ', ') (requires set-function capability GROUP_CONCAT)

```json
{
    "type": "function_aggregate_group_concat",
    "name": "GROUP_CONCAT",
    "distinct": true,
    "arguments": [
    {
        ...
    }
    ],
    "orderBy" : [
        {
            "type" : "order_by_element",
            "expression" :
            {
              "type" : "column",
               "columnNr" : 1,
                "name" : "USER_ID",
                "tableName" : "CLICKS"
            },
            "isAscending" : true,
            "nullsLast" : true
        }
    ],
    "separator": ", "
}
```

!!! notes
    - `distinct`: Optional. Requires set-function capability `GROUP_CONCAT_DISTINCT`.
    - `orderBy`: Optional. The requested order-by clause, a list of `order_by_element` elements.
      The field `expression` contains the expression to order by. The group-by clause of a SELECT query uses the
      same `order_by_element` element type. The clause requires the set-function capability `GROUP_CONCAT_ORDER_BY`.
    - `separator`: Optional. Requires set-function capability `GROUP_CONCAT_SEPARATOR`.
