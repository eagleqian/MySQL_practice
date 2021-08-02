## DBCP-C3P0连接池

## 池化技术

**原始：连接--执行--释放**

**池化技术**：预先准备连接好的资源，直接使用池里的连接资源



**常用连接数** ==**最小连接数**

**业务最高承载上限**==**最大连接数**

**等待超时**



1. 编写连接池，实现一个接口 DataSource



2. 开源数据源实现：DBCP\C3P0\Druid； 使用这些数据库连接池后，在项目开发中就不需要编写连接数据库的代码





## 编写工具类

```java
package com.eagle.jdbc.utils;

import org.apache.commons.dbcp2.BasicDataSourceFactory;

import javax.sql.DataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class DBCPUtils {
    private static DataSource dataSource = null;

    //构建一个工具类
    static {
        try {
            InputStream resourceAsStream = JDBCUtils.class.getClassLoader().getResourceAsStream("dbcpconfig.properties");
            //创建properties对象
            Properties properties = new Properties();
            //加载流进入properties：将上述文件类的信息读入该对象
            properties.load(resourceAsStream);

            dataSource = BasicDataSourceFactory.createDataSource(properties);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //obtain the connection
    public static Connection getConnection() throws SQLException {
        //连接数据库，获取connection对象
        return dataSource.getConnection();
    }

    //close the connection
    public static void releaseConnection(ResultSet resultSet, Statement statement, Connection connection) throws SQLException {
        if (resultSet != null) {
            resultSet.close();
        }
        if (statement != null) {
            statement.close();
        }
        if (connection != null) {
            connection.close();
        }
    }
}

```





## 测试用例

```java
package com.eagle.jdbc;

import com.eagle.jdbc.utils.DBCPUtils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBCPTestDemo01 {
    public static void main(String[] args) throws SQLException {
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            //use the static method --getConnection to obtain the connection
            connection = DBCPUtils.getConnection();

            //the remaining steps is similar as Demo1
            statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);

            //注意：打印出所有的查找记录需要接在查询操作之后，否则会报错：两者中间执行更新操作会提前关闭resultSet!
            //查询记录
            String sql = "SELECT * FROM sakila.language;";
            resultSet = statement.executeQuery(sql);


            if (resultSet.next()) {
                //move the cursor to the first：保证读取全部数据
                resultSet.previous();
                //traverse the resultSet
                while (resultSet.next()) {
                    System.out.println("language_id= " + resultSet.getObject("language_id"));
                    System.out.println("name= " + resultSet.getObject("name"));
                    System.out.println("last_update= " + resultSet.getObject("last_update"));
                }
            } else {
                System.out.println("resultSet is null!");
            }


        } catch (
                SQLException e) {
            e.printStackTrace();
        } finally {
            DBCPUtils.releaseConnection(resultSet, statement, connection);
        }
    }

}

```





## C3P0测试用例



**编写xml配置文件**



```xml
<c3p0-config>
    <!--    default config -->
    <default-config>
        <property name="driverClass">com.mysql.cj.jdbc.Driver</property>
        <property name="jdbcUrl">jdbc:mysql://localhost:3306/sakila?useUnicode=true&amp;characterEncoding=utf8&amp;useSSL=true
        </property>
        <property name="user">root</property>
        <property name="password">KO13813073617</property>

        <property name="acquireIncrement">5</property>
        <property name="initialPoolSize">10</property>
        <property name="minPoolSize">5</property>
        <property name="maxPoolSize">20</property>

    </default-config>

    <!--    initial Object with this config by using name "MySQL"-->
    <name-config name="MySQL">
        <property name="driverClass">com.mysql.cj.jdbc.Driver</property>
        <property name="jdbcUrl">jdbc:mysql://localhost:3306/sakila?useUnicode=true&amp;characterEncoding=utf8&amp;useSSL=true
        </property>
        <property name="user">root</property>
        <property name="password">KO13813073617</property>

        <property name="acquireIncrement">5</property>
        <property name="initialPoolSize">10</property>
        <property name="minPoolSize">5</property>
        <property name="maxPoolSize">20</property>
    </name-config>
</c3p0-config>
```



**工具类**

```java
package com.eagle.jdbc.utils;

import com.mchange.v2.c3p0.ComboPooledDataSource;
import org.apache.commons.dbcp2.BasicDataSourceFactory;

import javax.sql.DataSource;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class C3P0Utils {
    private static ComboPooledDataSource dataSource = null;

    //构建一个工具类
    static {
        try {

            // 配置文件的写法：use the default config
            dataSource = new ComboPooledDataSource();

            //代码版配置
//            dataSource.setDriverClass("com.mysql.cj.jdbc.Driver");
//            dataSource.setUser("root");
//            dataSource.setPassword("KO13813073617");
//            dataSource.setJdbcUrl("jdbc:mysql://localhost:3306/sakila");
//
//
//            dataSource.setMaxPoolSize(20);
//            dataSource.setMinPoolSize(5);
//            dataSource.setAcquireIncrement(5);
//            dataSource.setInitialPoolSize(10);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //obtain the connection
    public static Connection getConnection() throws SQLException {
        //连接数据库，获取connection对象
        return dataSource.getConnection();
    }

    //close the connection
    public static void releaseConnection(ResultSet resultSet, Statement statement, Connection connection) throws SQLException {
        if (resultSet != null) {
            resultSet.close();
        }
        if (statement != null) {
            statement.close();
        }
        if (connection != null) {
            connection.close();
        }
    }
}

```



**测试类**

```Java
package com.eagle.jdbc;

import com.eagle.jdbc.utils.C3P0Utils;
import com.eagle.jdbc.utils.DBCPUtils;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class C3P0TestDemo01 {
    public static void main(String[] args) throws SQLException {
        Connection connection = null;
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            //use the static method --getConnection to obtain the connection
            connection = C3P0Utils.getConnection();

            //the remaining steps is similar as Demo1
            statement = connection.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);

            //注意：打印出所有的查找记录需要接在查询操作之后，否则会报错：两者中间执行更新操作会提前关闭resultSet!
            //查询记录
            String sql = "SELECT * FROM sakila.language;";
            resultSet = statement.executeQuery(sql);


            if (resultSet.next()) {
                //move the cursor to the first：保证读取全部数据
                resultSet.previous();
                //traverse the resultSet
                while (resultSet.next()) {
                    System.out.println("language_id= " + resultSet.getObject("language_id"));
                    System.out.println("name= " + resultSet.getObject("name"));
                    System.out.println("last_update= " + resultSet.getObject("last_update"));
                }
            } else {
                System.out.println("resultSet is null!");
            }


        } catch (
                SQLException e) {
            e.printStackTrace();
        } finally {
            C3P0Utils.releaseConnection(resultSet, statement, connection);
        }
    }

}

```

