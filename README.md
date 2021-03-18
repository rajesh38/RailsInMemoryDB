# Rails Hybrid (In Memory + Persistent) Database

This system deals with creation of a hybrid database system which is a mix of both an in memory and persistent storage. The mode of storage depends on the end user. 

* In Memory Storage

This storage will be useful for short lived data which will be there only while the server is up. Once the server shuts down the data gets wiped out. This storage is very fast as it avoids reading data from disk.

* Persistent(Disk) Storage

This storage is useful when data needs to be store permanently i.e. in disk. This storage comes with benefit of long lasting storage but also has its problems with data access speed which is significantly lesser than primary memory(RAM).

As explained that the persistent storage is only good for storing data for a considerably longer timeline but the data retrieval speed is not that great. Hence This system will keep an in memory version of the same data that is stored in disk. How this works is that the data is written in memory irrespective of the persistence value. Now if the persistence is set as true then a version of the same data will also be propagated and saved in disk. This is how this system will be able to make the reads always fast irrespective of whether the data is in memory or persistent.

# Steps
* **Database Creation**

```
db = DatabaseService.create_db(db_name: "Organization", persistent: true)
```

This will create a database named **Organization** as a persistent object as persistent flag is true

* **Database Find**

```
db = DatabaseService.find_db(db_name: "Organization")
```

This command is to find a database named **Organization**

* **Table Creation**

```
table = DatabaseService.create_table(db_name: "Organization", table_entity:{name: "Employee", columns: [{name: "name", type: "string", required: true}, {name: "id", type: "int", required: false}]}, persistent: true)
```

This command is to create a table named **Employee** under the database: **Organization**

* **Drop Database**

```
DatabaseService.drop_db(db_name: "Organization")
```

This commamnd will drop the database: **Organization**
