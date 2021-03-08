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