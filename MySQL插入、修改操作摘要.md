# MySQL增、删、改、创、操作摘要

## 数据插入

---

### 插入整行



顾名思义，INSERT 用来将行插入（或添加）到数据库表。插入有几种方式：

1. 插入完整的行；
2. 插入行的一部分；
3.  插入某些查询的结果。



```mysql
INSERT INTO Customers
VALUES('1000000006',
'Toy Land',
'123 Any Street',
'New York',
'NY',
'11111',
'USA',
NULL,
NULL);

/***
必须给每一列提供一个值。如果某列没有值，
如上面的cust_contact 和cust_email 列，
则应该使用NULL 值（假定表允许对该列指定空值）。
各列必须以它们在表定义中出现的次序填充。
***/
```

**note**

虽然这种语法很简单，但并不安全，应该尽量避免使用。

上面的SQL 语句高度依赖于表中列的定义次序

---



**更安全的插入方法**

```mysql
/***
这个例子与前一个INSERT 语句的工作完全相同，但在表名后的括号里明确给出了列名
***/
INSERT INTO Customers(cust_id,
						cust_name,
						cust_address,
						cust_city,
						cust_state,
						cust_zip,
						cust_country,
						cust_contact,
						cust_email)
VALUES('1000000006',
		'Toy Land',
		'123 Any Street',
		'New York',
		'NY',
		'11111',
		'USA',
		NULL,
		NULL);

```

其优点是，**即使表的结构改变**，这条INSERT 语句仍然能正确工作。

---

**小结**

如果不提供列名，则必须给**每个表列**提供一个值；**如果提供列名**，则必须给列出的**每个列一个值**。否则，就会产生一条错误消息，相应的行不能成功插入。



### 插入部分行

```mysql
INSERT INTO Customers(cust_id,
                    cust_name,
                    cust_address,
                    cust_city,
                    cust_state,
                    cust_zip,
                    cust_country)
VALUES('1000000006',
        'Toy Land',
        '123 Any Street',
        'New York',
        'NY',
        '11111',
        'USA');
```



**NOTE**

注意：省略列如果表的定义允许，则可以在INSERT 操作中省略某些列。省略的列必须满足以下某个条件。

1. 该列定义为允许NULL 值（无值或空值）。
2. 在表定义中给出默认值。这表示如果不给出值，将使用默认值。 



---

### 插入检索的数据

INSERT 还存在另一种形式，可以利用它将SELECT 语句的结果插入表中，这就是所谓的
INSERT SELECT。

顾名思义，它是由一条INSERT 语句和一条SELECT语句组成的。

```mysql
-- 创建新客户表CustNew
CREATE TABLE CustNew
(
  cust_id      char(10)  NOT NULL ,
  cust_name    char(50)  NOT NULL ,
  cust_address char(50)  NULL ,
  cust_city    char(50)  NULL ,
  cust_state   char(5)   NULL ,
  cust_zip     char(10)  NULL ,
  cust_country char(50)  NULL ,
  cust_contact char(50)  NULL ,
  cust_email   char(255) NULL 
);

ALTER TABLE CustNew ADD PRIMARY KEY (cust_id);

-- 插入数据
INSERT INTO CustNew(cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email)
VALUES('1000000008', 'NanTong University', 'NanJing', 'JiangSu', 'MI', '66666', 'CHINA', 'Eagle Qian', 'eagleqian321@gmail.com');

-- 从其他表导入行
INSERT INTO Customers(cust_id,
						cust_contact,
                        cust_email,
                        cust_name,
                        cust_address,
                        cust_city,
                        cust_state,
                        cust_zip,
                        cust_country)
SELECT cust_id,
		cust_contact,
		cust_email,
		cust_name,
		cust_address,
		cust_city,
		cust_state,
		cust_zip,
		cust_country
FROM	CustNew;
-- 这个例子从一个名为CustNew 的表中读出数据并插入到Customers表
```



**NOTE**

1. INSERT SELECT 中SELECT 语句可以包含WHERE 子句，以过滤插入的数据。
2. 为简单起见，这个例子在INSERT 和SELECT 语句中使用了相同的列名。但是，不一定要求列名匹配。**事实上，DBMS 一点儿也不关心SELECT返回的列名。**它使用的是列的位置，因此SELECT 中的第一列（**不管其列名**）将用来填充表列中指定的第一列，第二列将用来填充表列中指定的第二列，如此等等。
3. INSERT 通常只插入一行。要插入多行，必须执行多个INSERT 语句。INSERT SELECT 是个例外，它可以用一条INSERT 插入多行，不管SELECT语句返回多少行，都将被INSERT 插入。

---

### 从一个表复制到另一个表

有一种数据插入不使用INSERT 语句。要将**一个表的内容复制**到一个全新的表（运行中创建的表），可以使用**SELECT INTO** 语句。

```mysql
-- 从一个表复制到另一个表
CREATE TABLE CustCopy AS
SELECT * FROM Customers;
```

**NOTE**

在使用SELECT INTO 时，需要知道一些事情：

1. 任何SELECT 选项和子句都可以使用，包括WHERE 和GROUP BY；
2. 可利用联结从多个表插入数 据；
3. 不管从多少个表中检索数据，数据都只能插入到一个表中。

---

### 小结

这一课介绍如何将行插入到数据库表中。

我们学习了使用INSERT 的几种方法，为什么要明确使用列名，

1. 如何用**INSERT SELECT 从其他表中导入行**
2. 如何用SELECT INTO 将行导出到一个**新表**。



---

## 更新表格

使用UPDATE 语句非常容易，甚至可以说太容易了。基本的UPDATE 语句由三部分组成，分别是：

1. 要更新的表；
2. 列名和它们的新值；
3. 确定要更新哪些行的过滤条件。



```mysql
/***
客户1000000005 现在有了电子邮件地址，因此他的记录需要更新，语句如下：
***/

UPDATE Customers
SET cust_email = 'liuqian@163.com'
WHERE cust_id = '1000000005';

-- -----------------------------------------------------------
UPDATE Customers 
SET -- 更新多个列时，中间用逗号隔开 
    cust_contact = 'Liu Roberts',
    cust_email = 'happy@toyland.com'
WHERE
    cust_id = '1000000006';
    
-- 删除某个列的值
UPDATE Customers
SET cust_email = NULL
WHERE cust_id = '1000000005';
```

**NOTE**

UPDATE 语句以WHERE 子句结束，**它告诉DBMS 更新哪一行**。没有WHERE子句，DBMS 将会用这个电子邮件地

址**更新**Customers 表中的**所有行**，这不是我们希望的!

---



## 删除数据

从一个表中删除（去掉）数据，使用DELETE 语句。有两种使用DELETE
的方式：

1. 从表中删除**特定的行**；
2. 从表中删除**所有行**。



---



**注意：不要省略WHERE 子句**

在使用DELETE 时一定要细心。因为稍不注意，**就会错误地删除表中所有行**

```mysql
DELETE FROM Customers
WHERE cust_id = '1000000006';

-- 如果省略WHERE 子句，它将删除表中每个顾客
```



**NOTE**

1. DELETE 不需要列名或通配符。**DELETE 删除整行而不是删除列**。要删除指定的列，请使用UPDATE 语句。
2. 说明：删除表的内容而不是表DELETE 语句从表中删除行，甚至是删除表中所有行。**但是，DELETE不删除表本身。**



下面是许多SQL 程序员使用UPDATE 或DELETE 时所遵循的重要原则。

1. 除非确实打算更新和删除每一行，**否则绝对不要使用不带WHERE 子句**的UPDATE 或DELETE 语句。
2. 保证每个表都有主键尽可能像WHERE 子句那样使用它（可以指定各主键、多个值或值的范围）。
3. 在UPDATE 或DELETE 语句使用WHERE 子句前，**应该先用SELECT 进行测试**，保证它过滤的是正确的记录，以防编写的WHERE 子句不正确。
4. **使用强制实施引用完整性的数据库,这样DBMS 将不允许删除其数据与其他表相关联的行。**
5. 有的DBMS 允许数据库管理员施加约束，防止执行不带WHERE 子句的UPDATE 或DELETE 语句。如果所采用的DBMS 支持这个特性，应该使用它。



---

## 创建表

```mysql
-- 列出本摘要刚开始创建products 表的sql语句
CREATE TABLE Products
(
    prod_id CHAR(10) NOT NULL,
    vend_id CHAR(10) NOT NULL,
    prod_name CHAR(254) NOT NULL,
    prod_price DECIMAL(8,2) NOT NULL,
    prod_desc VARCHAR(1000) NULL
);
```



**NOTE:**

NULL 值就是没有值或缺值。允许NULL 值的列也允许在插入行时不给出该列的值。

**不允许NULL 值的列不接受没有列值的行**，换句话说，在插入或更新行时，该列必须有值。

**只有不允许NULL值的列可作为主键**

---

**注意：理解NULL**
不要把NULL 值与空字符串相混淆。**NULL 值是没有值，不是空字符串**。

如果指定''（两个单引号，**其间没有字符**），这在NOT NULL 列中是允许的。

**空字符串是一个有效的值，它不是无值**。NULL 值用关键字NULL而不是空字符串指定。

---



### 指定默认值



```mysql
/***
SQL 允许指定默认值，在插入行时如果不给出值，DBMS 将自动采用默认值。默认值在CREATE TABLE 语句的列定义中用关键字DEFAULT 指定。
***/
-- OrderItems 创建脚本
CREATE TABLE OrderItems
(
    order_num INTEGER NOT NULL,
    order_item INTEGER NOT NULL,
    prod_id CHAR(10) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1, -- 注意此处的 DEFAUT 1
    item_price DECIMAL(8,2) NOT NULL
);

/***
在这个例子中，这一列的描述增加了DEFAULT 1，指示DBMS，如果不给出数量则使用数量1
***/

```



默认值经常用于日期或时间戳列。例如，通过指定引用系统日期的函数或变量， 将系统日期用作默认日期。

MySQL 用户指定**DEFAULT CURRENT_DATE()**

---



**提示**：

**使用DEFAULT 而不是NULL 值**

许多数据库开发人员喜欢使用DEFAULT 值而不是NULL 列，对于用于计算或数据分组的列更是如此。

## 更新表

理想情况下，不要在表中包含数据时对其进行更新。

应该在表的设计过程中充分考虑未来可能的需求，避免今后对表的结构做大改动。

1. 所有的DBMS 都允许给现有的表增加列，不过对所增加列的数据类型（以及NULL 和DEFAULT 的使用）有所限制。
2. 许多DBMS 不允许删除或更改表中的列。
3. 多数DBMS 允许重新命名表中的列。
4. 许多DBMS 限制对已经填有数据的列进行更改，对未填有数据的列几乎没有限制。



```mysql
-- 给已有表增加列
ALTER TABLE Vendors
ADD vend_phone CHAR(20);
```

**注意**：小心使用ALTER TABLE
使用ALTER TABLE 要极为小心，应该在进行改动前做完整的**备份**（表结构和数据的备份）。

数据库表的**更改不能撤销**，如果增加了不需要的列，也许无法删除它们。

类似地，如果删除了不应该删除的列，可能会**丢失该列中的所有数据**。

---



## 删除表

```mysql
-- 删除表（删除整个表而不是其内容）非常简单，使用DROP TABLE 语句即可：
DROP TABLE CustCopy;
```

**提示**：使用关系规则防止意外删除许多DBMS 允许强制实施有关规则，防止删除与其他表相关联的表。

在实施这些规则时，如果对某个表发布一条DROP TABLE 语句，**且该表是某个关系的组成部分**，

则DBMS **将阻止**这条语句执行，直到该关系被删除为止。

如果允许，应该启用这些选项，它能**防止意外删除**有用的表。

---

**小结**

这一课介绍了几条新的SQL 语句。

CREATE TABLE 用来创建新表，ALTER TABLE 用来更改表列（或其他诸如约束或索引等对象），

而DROP TABLE用来完整地删除一个表。

这些语句必须小心使用，并且应该在备份后使用。

由于这些语句的语法在不同的DBMS 中有所不同，所以***更详细的信息请参阅相应的DBMS 文档***。