SELECT * FROM world.products;

-- simple research
SELECT vend_id
	FROM products
	WHERE vend_id = 'DLL01';

-- 仅对符合条件的顾客的记录行计数
SELECT COUNT(*) AS orders
	FROM orders
    WHERE cust_id = '1000000001';
-- -------------------------------------------------------------------------------    
-- sub_query 子查询
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
-- -------------------------------------------------------------------------------
-- 联结 

-- 1、没有WHERE子句进行过滤
SELECT 
    vend_name, prod_name, prod_price
FROM
    vendors,
    products
ORDER BY vend_name;

-- 2、联结两个表查询
SELECT 
    vend_name, prod_name, prod_price
FROM
    Vendors,
    Products
WHERE
    Vendors.vend_id = Products.vend_id;

-- 3、内联结
SELECT 
    vend_name, prod_name, prod_price
FROM
    Vendors
        INNER JOIN
    Products ON Vendors.vend_id = Products.vend_id;

-- 4、显示订单2007的物品
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
    
-- 5、返回订购产品RGAN01的顾客
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
	
-- 6、别名完成上一个操作
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

-- ---------------------------------------------------------------------------------
-- 插入操作 
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

-- 更安全的插入方法 
/***
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
***/

-- 插入部分行
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

-- 定义外键 
# ALTER TABLE Orders ADD CONSTRAINT FK_Orders_Customers FOREIGN KEY (cust_id) REFERENCES Customers (cust_id);

-- 插入新顾客表记录 
INSERT INTO CustNew(cust_id, cust_name, cust_address, cust_city, cust_state, cust_zip, cust_country, cust_contact, cust_email)
VALUES('1000000008', 'NanTong University', 'NanJing', 'JiangSu', 'MI', '66666', 'CHINA', 'Eagle Qian', 'eagleqian321@gmail.com');

-- 插入查询结果
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


-- 创建新表 
-- 创建新客户表CustNew
/***
CREATE TABLE CustCopy
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

ALTER TABLE Custcopy ADD PRIMARY KEY (cust_id);
***/

-- 从一个表复制到另一个表
CREATE TABLE CustCopy AS
SELECT * FROM Customers;


-- ----------------------------------------------------------------------------------
-- 更新或删除数据 
UPDATE Customers 
SET 
    cust_email = 'liuqian@163.com'
WHERE
    cust_id = '1000000005';


UPDATE Customers 
SET -- 更新多个列时，中间用逗号隔开 
    cust_contact = 'Liu Roberts',
    cust_email = 'happy@toyland.com'
WHERE
    cust_id = '1000000006';

-- 删除某个列的值 
UPDATE Customers 
SET 
    cust_email = NULL
WHERE
    cust_id = '1000000005';
    
-- 删除行 
DELETE FROM Customers
WHERE cust_id = '1000000006';

-- 增加列 
ALTER TABLE Vendors
ADD vend_phone CHAR(20);

-- 删除表
DROP TABLE CustCopy;