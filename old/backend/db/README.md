#Code Conventions for SQL 

###Columns should be prefixed by their table names
```sql
	Users.user_id, Products.user_id, Products.product_name
```

###SQL commands and keywords should be in all CAPS

```sql

	SELECT, CREATE TABLE, PRIMARY KEY, FOREIGN KEY, INSERT INTO [table name] VALUES

```


###Table names should have the first letter of each word capitazlied and underscores for spaces


```sql

	Users, Products, User_Purchased, 

```

##Column names should be in all lower case, and each word should be separated by a space

```sql

	username, password, user_id, product_id

```


###Full Example

```sql

SELECT Users.user_id, Users.email, Users.first_name, Users.last_name
FROM Users
WHERE Users.email LIKE '%@bu.edu';

```


