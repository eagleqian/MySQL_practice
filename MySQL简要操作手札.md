# MySQL操作手札——查询篇

---

## 计算字段

---

**[自取：所用查询表的MySQL脚本下载链接](https://forta.com/wp-content/uploads/books/0672336073/TeachYourselfSQL_MySQL.zip)**

---

### 创建计算字段

```mysql
-- 创建计算字段，汇总物品的价格
mysql> SELECT prod_id,
    -> quantity,
    -> quantity*item_price AS expanded_price # 将计算字段创建别名
    -> FROM OrderItems
    -> WHERE order_num=20008;
```



```MySQL
-- 返回日期,SELECT 后没有FROM 可以简单的访问和处理表达式
mysql> SELECT now();
```



```mysql
-- 拼接字段
SELECT concat(prod_id,' (',item_price,')')
AS id_price
FROM orderItems
WHERE order_num = 20008;
```

---



### ORDER BY 子句

**在指定一条ORDER BY 子句时，应该保证它是SELECT 语句中最后一条子句。如果它不是最后的子句，将会出现错误消息。**

```mysql
-- 默认升序，若降序，需要在排序列指定DESC
SELECT prod_id, prod_price, prod_name
FROM Products
ORDER BY prod_price DESC;
```

---



##  MySQL中的函数

| 提取字符串的组成部分 | SUBSTRING() |
| -------------------- | ----------- |
| 数据类型转换         | CONVERT()   |
| 取当前日期           | CURDATE()   |

---



### 文本处理函数

```mysql
SELECT vend_name, UPPER(vend_name) AS vend_name_upcase #字符串转大写
FROM Vendors
ORDER BY vend_name;
```



| 函数      | 说明                  |
| --------- | --------------------- |
| LEFT()    | 返回字符串左边的字符  |
| LENGTH()  | 返回字符串的长度      |
| LOWER()   | 将字符串转换为小写    |
| LTRIM()   | 去掉字符串左边的空格  |
| RIGHT()   | 返回字符串右边的字符  |
| RTRIM()   | 去掉字符串右边的空格  |
| SOUNDEX() | 返回字符串的SOUNDEX值 |



```mysql
-- SOUNDEX用法
-- 使用SOUNDEX()函数进行搜索，它匹配所有发音类似于 Michael Green 的联系名：
SELECT cust_name, cust_contact
FROM Customers
WHERE SOUNDEX(cust_contact) = SOUNDEX('Michael Green'); # 注意字符串加引号
```





---



### 日期和事件处理函数

```mysql
-- YEAR() 提取年份
SELECT order_num
FROM Orders
WHERE YEAR(order_date) = 2012;
```







**不同数据库的SQL函数实现起来有很多差别，需要查阅官方文档**

---



### 聚集函数



**聚集函数主要用来汇总表格数据，而不是返回表格实际数据**



| 函数    | 说明             |
| ------- | ---------------- |
| AVG()   | 返回某列的平均值 |
| COUNT() | 某列的行数       |
| MAX()   | 某列的最大值     |
| MIN()   | 某列最小值       |
| SUM()   | 某列的值之和     |



#### AVG（）求均值

```mysql
-- avg()求均值
SELECT AVG(prod_price) AS avg_price
FROM Products;
```



**AVG()只能用来确定特定数值列的平均值，而且列名必须作为函数参数给出。为了获得多个列的平均值，必须使用多个AVG()函数。**



---



#### COUNT()计算行数

```mysql
SELECT COUNT(cust_email) AS num_cust
FROM Customers;
```



**NOTE:如果指定列名，则COUNT()函数会忽略指定列的值为空的行，但如果
COUNT()函数中用的是星号（*），则不忽略。**

---



#### 聚集不同的值(DISTINCT)

**若聚集函数只对不同的值进行计算，则指定DISTINCT**

```mysql
#DISTINCT放在指定列之前
SELECT AVG(DISTINCT prod_price) AS avg_price
FROM Products
WHERE vend_id = 'DLL01';

/*结果
avg_price
-----------
4.2400
*/
```



**如果指定列名，则DISTINCT 只能用于COUNT()。DISTINCT 不能用于COUNT(*)。类似地，DISTINCT 必须使用列名，不能用于计算或表达式。**



---

#### 组合聚集函数

**目前为止的所有聚集函数例子都只涉及单个函数。但实际上，SELECT 语句可根据需要包含多个聚集函数。请看下面的例子：**

```mysql
SELECT COUNT(*) AS num_items,
MIN(prod_price) AS price_min,
MAX(prod_price) AS price_max,
AVG(prod_price) AS price_avg
FROM Products;

```



## 分组查询



### 创建分组

```mysql
SELECT vend_id, COUNT(*) AS num_prods
FROM Products
GROUP BY vend_id;#仅计算vend_id 相同的一组内有多少个产品
```

**GROUP BY 子句指示DBMS 分组数据，然后对每个组而不是整个结果集进行聚集。**

***GROUP BY 子句必须出现在WHERE 子句之后，ORDER BY 子句之前。***

---



**NOTE: WHERE过滤行，而HAVING 过滤分组**

```mysql
/* 列出具有两个以上产品且其价格大于等于4 的供应商*/

SELECT vend_id, COUNT(*) AS num_prods
FROM Products
WHERE prod_price >= 4
GROUP BY vend_id
HAVING COUNT(*) >= 2;
```



**NOTE:**

HAVING 与WHERE 非常类似，如果不指定GROUP BY，则大多数DBMS会同等对待它们。不过，你自己要能区分这一点。使用HAVING 时应该结合GROUP BY 子句，而WHERE 子句用于标准的行级过滤。

---



### 分组和排序

**一般在使用GROUP BY 子句时，应该也给出ORDER BY 子句。这是保证数据正确排序的唯一方法。千万不要仅依赖GROUP BY 排序数据。**

```mysql
/*按照订单号进行分组，对每组进行COUNT聚集运算，
然后先按照同组订单号的数量升序排序，
接着按照订单号进行排序*/

SELECT order_num, COUNT(*) AS items
FROM OrderItems
GROUP BY order_num
HAVING COUNT(*) >= 3
ORDER BY items, order_num;
```

---

### SELECT 子句顺序

| 子句     | 说明                 | 是否必须使用             |
| -------- | -------------------- | ------------------------ |
| SELECT   | 要返回的列或者表达式 | 是                       |
| FROM     | 从中检索数据的表     | 仅在从表中选择数据时使用 |
| WHERE    | 行级过滤             | 否                       |
| GROUP BY | 分组说明             | 仅在按组计算聚集时使用   |
| HAVING   | 组级过滤             | 否                       |
| ORDER BY | 输出排序顺序         | 否                       |



## 子查询（嵌套查询）



```mysql
/***
*假如需要列出订购物品RGAN01 的所有顾客，应该怎样检索？下
*面列出具体的步骤。
*(1) 检索包含物品RGAN01 的所有订单的编号。
*(2) 检索具有前一步骤列出的订单编号的所有顾客的ID。
*(3) 检索前一步骤返回的所有顾客ID 的顾客信息
***/
SELECT cust_name,cust_contact
FROM Customers
WHERE cust_id IN (SELECT cust_id
					FROM orders
                    WHERE order_num IN (SELECT order_num
										FROM OrderItems
                                        WHERE prod_id = 'RGAN01'));
                                        
```

**作为子查询的SELECT 语句只能查询单个列。企图检索多个列将返回错误**

---

### 作为计算字段使用子查询

```mysql
/***
*假如需要显示Customers 表中
*每个顾客的订单总数。订单与相应的顾客ID 存储在Orders 表中。
***/

SELECT 
    cust_name,
    cust_state,
    (SELECT 
            COUNT(*)
        FROM
            orders
        WHERE
            orders.cust_id = customers.cust_id) AS orders
FROM
    customers
ORDER BY cust_name;

/***
该子查询对检索出的每个顾客执行一次。在此例中，该
子查询执行了5 次，因为检索出了5 个顾客。
***/

```



---



## 联结表

### 联结

```mysql
/***
在联结两个表时，实际要做的是将
第一个表中的每一行与第二个表中的每一行配对
***/

SELECT 
    vend_name, prod_name, prod_price
FROM
    Vendors,
    Products
WHERE
    Vendors.vend_id = Products.vend_id;
    
/***
没有WHERE
子句，第一个表中的每一行将与第二个表中的每一行配对，而不管它们
逻辑上是否能配在一起。
***/
-- 1、没有WHERE子句进行过滤
SELECT 
    vend_name, prod_name, prod_price
FROM
    vendors,
    products
ORDER BY vend_name;

-- 上述语句返回的数据用每个供应商匹配了每个产品，包括了供应商不正确的产品
```

---



### 内联结

**下面的SELECT 语句返回与前面例子完全相同的数据：**

```mysql
-- 联结两张表
SELECT 
    vend_name, prod_name, prod_price
FROM
    Vendors
        INNER JOIN # 与上例不同，不同表之间改用 INNER JOIN ，随后的WHERE 改成了 ON
    Products ON Vendors.vend_id = Products.vend_id;

    
-- 联结多张表
/***
这个例子显示订单20007 中的物品。订单物品存储在OrderItems 表中。
每个产品按其产品ID 存储，它引用Products 表中的产品。这些产品通
过供应商ID 联结到Vendors 表中相应的供应商，供应商ID 存储在每个
产品的记录中。这里的FROM 子句列出三个表，WHERE 子句定义这两个联
结条件，而第三个联结条件用来过滤出订单20007 中的物品。
***/
SELECT 
    prod_name, vend_name, prod_price, quantity
FROM
    OrderItems,
    Products,
    Vendors
WHERE
    Products.vend_id = Vendors.vend_id
        AND OrderItems.prod_id = Products.prod_id
        AND order_num = 20007;
        
```

**输出**

| prod_name           | vend_name       | prod_price | quantity |
| ------------------- | --------------- | ---------- | -------- |
| 18 inch teddy bear  | Bears R Us      | 11.99      | 50       |
| Fish bean bag toy   | Doll House Inc. | 3.49       | 100      |
| Bird bean bag toy   | Doll House Inc. | 3.49       | 100      |
| Rabbit bean bag toy | Doll House Inc. | 3.49       | 100      |
| Raggedy Ann         | Doll House Inc. | 4.99       | 50       |



**注意：** DBMS 在运行时关联指定的每个表，以处理联结。这种处理可能非常耗费资源，因此应该注意，不要联结不必要的表。联结的表越多，性能下降越厉害。



---

```mysql
/***
SELECT 语句返回订购产品
RGAN01 的顾客列表：
***/
SELECT 
    cust_name, cust_contact
FROM
    OrderItems,
    Orders,
    Customers
WHERE
    OrderItems.order_num = Orders.order_num
        AND Orders.cust_id = Customers.cust_id
        AND prod_id = 'RGAN01';
```



**输出**

| cust_name     | cust_contact       |
| ------------- | ------------------ |
| Fun4All       | Denise L. Stephens |
| The Toy Store | Kim Howard         |

---



### 高级联结

**表别名**

SQL 除了可以对列名和计算字段使用别名，还允许给表名起别名。这样
做有两个主要理由：

1. 缩短SQL 语句；
2. 允许在一条SELECT 语句中多次使用相同的表。 



```mysql
/***
*举例：使用别名来完成上一个查询
***/

SELECT 
    cust_name, cust_contact
FROM
    Customers AS C,
    Orders AS O,
    OrderItems AS OI
WHERE
    C.cust_id = O.cust_id
        AND O.order_num = OI.order_num
        AND prod_id = 'RGAN01';
```

**需要注意，表别名只在查询执行中使用。与列别名不一样，表别名不返回到客户端。**

---

### 自联结

**引入：假如要给与Jim Jones 同一公司的所有顾客发送一封信件。这个查询要求首先找出Jim Jones 工作的公司，然后找出在该公司工作的顾客。**

```mysql
# 法一：使用嵌套子查询
SELECT 
    cust_id, cust_name, cust_contact
FROM
    Customers
WHERE
    cust_name = (SELECT 
            cust_name
        FROM
            Customers
        WHERE
            cust_contact = 'jim Jones');
       
#法二：自联结查询
SELECT 
	-- 注意要用上表的别名，因为存在多个相同列名，不使用完全限定列名会出现模糊错误
	-- 因为名为cust_id、cust_name、cust_contact 的列各有两个
    c1.cust_id, c1.cust_name, c1.cust_contact
FROM
    Customers AS c1,
    Customers AS c2
WHERE
    c1.cust_name = c2.cust_name
		AND c2.cust_contact = 'Jim Jones';
```



**提示：使用自联结而不是子查询**

​	**自联结通常作为外部语句，用来替代从相同表中检索数据的使用子查询语句。虽然最终的结果是相同的，但许多DBMS 处理联结远比处理子查询快得多。应该试一下两种方法，以确定哪一种的性能更好。**



---

### 自然联结

**标准的联结（前一课中介绍的内联结）返回所有数据，相同的列甚至多次出现。自然联结排除多次出现，使每一列只返回一次。**

```mysql
/***
排除重复出现的列，系统不完成这项工作，自己完成。
***/

SELECT 
    C.*,# 注意这种用法，对整张表使用
    O.order_num,
    O.order_date,
    OI.prod_id,
    OI.quantity,
    OI.item_price
FROM
    Customers AS C,
    Orders AS O,
    OrderItems AS OI
WHERE
    C.cust_id = O.cust_id
        AND O.order_num = OI.order_num
        AND prod_id = 'RGAN01';
```



### 外联结

**许多联结将一个表中的行与另一个表中的行相关联，但有时候需要包含没有关联行的那些行，联结包含了那些在相关表中没有关联行的行。这种联结称为外联结。**

```mysql
-- 检索包括没有订单顾客在内的所有顾客
SELECT 
    Customers.cust_id, Orders.order_num
FROM
    Customers
        LEFT OUTER JOIN #注意关键字
    Orders ON Customers.cust_id = Orders.cust_id;

/***
在使用OUTER JOIN语法时，必须使用RIGHT或LEFT关键字指定包括其所有行的表
（RIGHT指出的OUTER JOIN右边的表，LEFT指出的OUTER JOIN左边的表）。
***/
```



**输出**

| cust_id    | order_num |
| ---------- | --------- |
| 1000000001 | 20005     |
| 1000000001 | 20009     |
| 1000000002 | NULL      |
| 1000000003 | 20006     |
| 1000000004 | 20007     |
| 1000000005 | 20008     |



```mysql
/***
上述左联结改成右联结后的结果
***/
SELECT 
    Customers.cust_id, Orders.order_num
FROM
    Customers
        RIGHT OUTER JOIN # 注意与上述LEFT OUTER JOIN 区分
    Orders ON Customers.cust_id = Orders.cust_id;
```



**输出**

| cust_id    | order_num |
| :--------- | --------- |
| 1000000001 | 20005     |
| 1000000001 | 20009     |
| 1000000003 | 20006     |
| 1000000004 | 20007     |
| 1000000005 | 20008     |

---



**外联结总结**

​	总是有两种基本的外联结形式：左外联结和右外联结。它们之间的唯一差别是所关联的表的顺序。换句话说，调整FROM 或WHERE子句中表的顺序，左外联结可以转换为右外联结。因此，这两种外联结可以互换使用，哪个方便就用哪个。

**NOTE:全外联结**

全外联结（full outer join），它检索两个表中的所有行并关联那些可以关联的行。与左外联结或右外联结包含一个表的不关联的行不同，全外联结包含两个表的不关联的行。

**但是MySQL不支持**



---

### 使用带聚集函数的联结

**聚集函数用来汇总数据**

```mysql
/***
要检索所有顾客及每个顾客所下的订单数，下面的代
码使用COUNT()函数完成此工作：
***/
SELECT 
    Customers.cust_id, COUNT(Orders.order_num) AS num_ord 
    # 对分组后的每组进行COUNT（），计算每个顾客的订单总数
FROM
    Customers
        INNER JOIN
    Orders ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;

/***
这条SELECT 语句使用INNER JOIN 将Customers 和Orders 表互相关联。
GROUP BY 子句按顾客分组数据，
***/
```

**输出**

| cust_id    | num_ord |
| ---------- | ------- |
| 1000000001 | 2       |
| 1000000003 | 1       |
| 1000000004 | 1       |
| 1000000005 | 1       |



```mysql
/***
聚集函数和左外联结一起使用，将未关联的行也纳入查询
***/
-- 聚集函数与左外联结一起使用
SELECT 
	Customers.cust_id,COUNT(Orders.order_num) AS num_ord
FROM 
	Customers
		LEFT OUTER JOIN
	Orders ON Customers.cust_id = Orders.cust_id
GROUP BY Customers.cust_id;

# 注意看下面输出结果的cust_id = 1000000002的num_ord为0
```



**输出**

| cust_id    | num_ord |
| ---------- | ------- |
| 1000000001 | 2       |
| 1000000002 | 0       |
| 1000000003 | 1       |
| 1000000004 | 1       |
| 1000000005 | 1       |

---



### 使用联结和联结条件

1. 注意所使用的联结类型。一般我们使用内联结，但使用外联结也有效。
2. 关于确切的联结语法，应该查看具体的文档，看相应的DBMS 支持何种语法（大多数DBMS 使用这两课中描述的某种语法）。
3. 保证使用正确的联结条件（不管采用哪种语法），否则会返回不正确的数据。
4. **应该总是提供联结条件，否则会得出笛卡儿积**。
5. 在一个联结中可以包含多个表，甚至可以对每个联结采用不同的联结类型。虽然这样做是合法的，一般也很有用，但应该在一起测试它们前分别测试每个联结。这会使故障排除更为简单。



---



## 组合查询

**本课讲述如何利用UNION 操作符将多条SELECT 语句组合成一个结果集。**

主要有两种情况需要使用组合查询：

1. 在一个查询中从**不同的表**返回结构数据；
2. 对一个表执行**多个查询**，按一个查询返回数据。

---

**提示：组合查询和多个WHERE 条件**
多数情况下，组合相同表的两个查询所完成的工作与具有多个WHERE子句条件的一个查询所完成的工作相同。换句话说，任何具有多个WHERE 子句的SELECT 语句都可以作为一个组合查询，在下面可以看到这一点。

```mysql
/***
假如需要Illinois、Indiana 和Michigan 等美国几个州的所有顾客的报表，还想包括不管位于哪个州的所有的Fun4All。

第一条SELECT 把Illinois、Indiana、Michigan 等州的缩写传递给IN 子句，检索出这些州的所有行。

第二条SELECT 利用简单的相等测试找出所有Fun4All。
***/


-- 单词查询
SELECT 
    cust_name, cust_contact, cust_email
FROM
    Customers
WHERE
    cust_state IN ('IL' , 'IN', 'MI');
-- 单词查询
SELECT 
    cust_name,bapug8[1/] cust_contact, cust_email
FROM
    Customers
WHERE
    cust_name = 'Fun4ALL';
    
-- 组合上面两条句子
SELECT cust_name,cust_contact,cust_email
FROM
	Customers
WHERE
	cust_state IN ('IL' , 'IN' , 'MI')
UNION # UNION 组合两次查询结果
SELECT cust_name,cust_contact,cust_email
FROM
	Customers
WHERE
	cust_name = 'Fun4ALL';

-- 使用多条WHERE 子句而不是UNION 的相同查询
SELECT 
	cust_name, cust_contact, cust_email
FROM 
	Customers
WHERE 
	cust_state IN ('IL','IN','MI')
	OR cust_name = 'Fun4All';-- 注意OR的表示
```

**输出**

| cust_name     | cust_contact       | cust_email            |
| ------------- | ------------------ | --------------------- |
| Village Toys  | John Smith         | sales@villagetoys.com |
| Fun4All       | Jim Jones          | jjones@fun4all.com    |
| The Toy Store | Kim Howard         | NULL                  |
| Fun4All       | Denise L. Stephens | dstephens@fun4all.com |



**分析**

这条语句由前面的两条SELECT 语句组成，之间**用UNION 关键字分隔**。UNION 指示DBMS 执行这两条SELECT 语句，并把输出**组合成一个查询结果集**。

---

**UNION 规则**

1. UNION 必须由**两条或两条以上的SELECT 语句组成**，语句之间用关键字UNION 分
2. NION 中的每个查询必须包含**相同的列、表达式或聚集函数**（不过，各个列不需要以相同的次序列出）。
3. 列**数据类型必须兼容**：类型不必完全相同，但必须是DBMS 可以隐含转换的类型



---



### 包含或取消重复的行

UNION 从查询结果集中自动**去除了重复的行**；

换句话说，它的行为与**一条SELECT 语句中使用多个WHERE 子句**条件一样。

因为Indiana 州有一个Fun4All 单位，所以两条SELECT 语句都返回该行。

使用UNION 时，**重复的行会被自动取消**。这是UNION 的默认行为，如果愿意也可以改变它。

事实上，如果想返回**所有的匹配行，可使用UNION ALL** 而不是UNION。

```mysql
SELECT 
    cust_name, cust_contact, cust_email
FROM
    Customers
WHERE
    cust_state IN ('IN' , 'IL', 'MI') 
UNION ALL SELECT -- 包含所有的行
    cust_name, cust_contact, cust_email
FROM
    Customers
WHERE
    cust_name = 'Fun4ALL';
```

**output**

| cust_name     | cust_contact       | cust_email            |
| ------------- | ------------------ | --------------------- |
| Village Toys  | John Smith         | sales@villagetoys.com |
| Fun4All       | Jim Jones          | jjones@fun4all.com    |
| The Toy Store | Kim Howard         | NULL                  |
| Fun4All       | Jim Jones          | jjones@fun4all.com    |
| Fun4All       | Denise L. Stephens | dstephens@fun4all.com |

---

### 对组合查询的结果进行排序

SELECT 语句的输出用ORDER BY 子句排序。在用UNION 组合查询时，

**只能使用一条ORDER BY 子句**，它必须位于**最后一条SELECT 语句之后**。

对于结果集，不存在用一种方式排序一部分，而又用另一种方式排序另一部分的情况，

因此**不允许使用多条ORDER BY 子句**。



```mysql
SELECT 
    cust_name, cust_contact, cust_email
FROM
    Customers
WHERE
    cust_state IN ('IN' , 'IL', 'MI') 
UNION ALL SELECT 
    cust_name, cust_contact, cust_email
FROM
    Customers
WHERE
    cust_name = 'Fun4ALL'
ORDER BY
	cust_name,cust_contact;
-- 只允许有一条排序语句，且出现在最后一行
```



**output**

| cust_name     | cust_contact       | cust_email            |
| ------------- | ------------------ | --------------------- |
| Fun4All       | Denise L. Stephens | dstephens@fun4all.com |
| Fun4All       | Jim Jones          | jjones@fun4all.com    |
| Fun4All       | Jim Jones          | jjones@fun4all.com    |
| The Toy Store | Kim Howard         | NULL                  |
| Village Toys  | John Smith         | sales@villagetoys.com |

虽然ORDER BY 子句似乎**只是最后一条SELECT 语句的组成部分**，但实际上DBMS 将用它来排序**所有SELECT 语句**返回的所有结果。

---



**Conclusion:**

利用UNION，可以把**多条查询的结果作为一条组合查询返回**，不管结果中有无重复。使用UNION 可极大地简化复杂的WHERE 子句,，简化从**多个表中**检索数据的工作。









