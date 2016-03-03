#Code Conventions for SQL 

##SQL commands and keywords should be in all CAPS

###Example
```
	SELECT, CREATE, PRIMARY KEY, FOREIGN KEY, INSERT INTO [table name] VALUES
```

##Table names should have the first letter of each word capitazlied and 
##underscores for spaces

###Example

```
	Users, Products, User_Purchased, 
```

##Column names should be in all lower case, 
##and each word should be separated by a space

```
	username, password, user_id, product_id

```


###Full Example

```
SELECT user_id, emamil, first_name, last_name, (price * 10) 
FROM Users
WHERE 

```


