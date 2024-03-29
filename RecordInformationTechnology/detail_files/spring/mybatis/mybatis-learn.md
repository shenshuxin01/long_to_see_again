内部封装了通过JDBC访问数据库的操作，通过SQL和数据库交互。

ORM（Object/Relational Mapping）即对象关系映射，是一种数据持久化技术。它在对象模型和关系型数据库直接建立起对应关系，并且提供一种机制，通过JavaBean对象去操作数据库表的数据。 MyBatis通过简单的XML或者注解的方式进行配置和原始映射，将实体类和SQL语句之间建立映射关系，是一种半自动（之所以说是半自动，因为我们要自己写SQL）的ORM实现。

# Mybatis的一级、二级缓存
对于缓存数据更新机制，当某一个作用域(一级缓存 Session/二级缓存Namespaces)的进行了C/U/D 操作后，默认该作用域下所有 select 中的缓存将被 clear。
- 一级缓存: 基于 PerpetualCache 的 HashMap 本地缓存，其存储作用域为 Session（session生命周期就是每个请求线程创建一个新的session，线程之间不共享，请求结束session也销毁），当 Session flush 或 close 之后，该 Session 中的所有 Cache 就将清空，默认打开一级缓存。
- 二级缓存与一级缓存其机制相同，默认也是采用 PerpetualCache，HashMap 存储，不同在于其存储作用域为 Mapper(Namespace)，并且可自定义存储源，如 Ehcache。默认不打开二级缓存，要开启二级缓存，使用二级缓存属性类需要实现Serializable序列化接口(可用来保存对象的状态),可在它的映射文件中配置 ；

# mybatis分页
- pageHelper
- 基于不同的数据库自己在sql实现，oracle使用三层rownum，mysql使用limit

# 自定义mybatis插件
![自定义mybatis插件](1680158737136.jpg)

# mybatis-plus使用
1. 自定义实体类 数据库映射对象
2. 创建Mapper注解接口继承 BaseMapper<实体类>。此接口有curd方法
3. 逻辑代码中操作mapper对象即可

![mybatis-plus使用](./1680158798660.jpg)

# 一对多查询xml
## 实体类
```java
public class Order {
    private Integer id;

    private String orderNo;

    private Date orderTime;

    private Date payTime;

    private String remark;
    /**订单详情*/
    private List<OrderDetail> orderDetailList;
    //省略get、set
```
## 接口Mapper
```java
List<Order> queryOrderList(Map map);
```
## mybatis.xml
```xml
<resultMap id="BaseResultMap" type="com.chouxiaozi.mybatisdruid.entity.Order" >
    <id column="id" property="id" jdbcType="INTEGER" />
    <result column="order_no" property="orderNo" jdbcType="VARCHAR" />
    <result column="order_time" property="orderTime" jdbcType="TIMESTAMP" />
    <result column="pay_time" property="payTime" jdbcType="TIMESTAMP" />
    <result column="remark" property="remark" jdbcType="VARCHAR" />
    <collection property="orderDetailList" ofType="com.chouxiaozi.mybatisdruid.entity.OrderDetail">
      <id column="d_id" property="id" jdbcType="INTEGER" />
      <result column="d_order_no" property="orderNo" jdbcType="VARCHAR" />
      <result column="good_name" property="goodName" jdbcType="VARCHAR" />
      <result column="good_id" property="goodId" jdbcType="INTEGER" />
      <result column="good_count" property="goodCount" jdbcType="INTEGER" />
    </collection>
  </resultMap>
  
<select id="queryOrderList" resultMap="BaseResultMap">
    SELECT
      o.*, d.id as d_id,d.order_no as d_order_no,d.good_name,d.good_id,d.good_count
    FROM
      tbl_order o
        LEFT JOIN tbl_order_detail d ON d.order_no = o.order_no
    where 1=1
    <if test="orderNo != null and orderNo != ''">
      and o.order_no = #{orderNo}
    </if>
    ORDER BY o.order_time desc
  </select>
```

## 查询结果
```json
[
  {
    "id": 2,
    "orderNo": "DD000002",
    "orderTime": "2021-05-09 12:25:57",
    "payTime": "2021-05-09 12:25:59",
    "remark": "2号订单",
    "orderDetailList": [
      {
        "id": 5,
        "orderNo": "DD000002",
        "goodName": "耳机",
        "goodId": 5,
        "goodCount": 1
      },
      {
        "id": 4,
        "orderNo": "DD000002",
        "goodName": "手机",
        "goodId": 4,
        "goodCount": 1
      }
    ]
  },
  {
    "id": 1,
    "orderNo": "DD000001",
    "orderTime": "2021-05-09 12:25:37",
    "payTime": "2021-05-09 12:25:41",
    "remark": "1号订单",
    "orderDetailList": [
      {
        "id": 2,
        "orderNo": "DD000001",
        "goodName": "饮料",
        "goodId": 2,
        "goodCount": 2
      },
      {
        "id": 1,
        "orderNo": "DD000001",
        "goodName": "瓜子",
        "goodId": 1,
        "goodCount": 1
      },
      {
        "id": 3,
        "orderNo": "DD000001",
        "goodName": "矿泉水",
        "goodId": 3,
        "goodCount": 2
      }
    ]
  }
]

```

# mybatis参数查询多个参数，不同类型，参数方法查询
## 接口类
```java
Map<String,Object> querySome(@Param("pojo") SomePOJOBean pojo,@Param("listA") List list,@Param("name") String name);
```
## xml文件
```xml
<select id="querySome" parameterType="BaseResultMap">
    SELECT
      1
    FROM
      table_name
    where 1=1
    <if test="name != null">
      and col_1 = #{name}
    </if>
    and col_2 = #{pojo.xxx}
    <if test="listA!=null and listA.size()>0 and !listA.isEmpty()">
      and col_3 in
      <foreach collection="listA" open="(" close=")" item="i" separator="," >
        #{i}
      </foreach>
    </if>
    <!-- 注意 !listA.isEmpty() 调用的是java.util.List的方法，由此可知这里可以直接调用对象的方法 -->
</select>
```

# choose标签
```xml
<select id="dynamicChooseTest" parameterType="Blog" resultType="Blog">
    select * from t_blog where 1 = 1 
    <choose>
        <when test="title != null">
            and title = #{title}
        </when>
        <when test="content != null">
            and content = #{content}
        </when>
        <otherwise>
            and owner = "owner1"
        </otherwise>
    </choose>
</select>
```
when元素表示当 when 中的条件满足的时候就输出其中的内容，跟 JAVA 中的 switch 效果差不多的是按照条件的顺序，***当 when 中有条件满足的时候，就会跳出 choose，***即所有的 when 和 otherwise 条件中，只有一个会输出，当所有的我很条件都不满足的时候就输出 otherwise 中的内容。所以上述语句的意思非常简单， 当 title!=null 的时候就输出 and titlte = #{title}，不再往下判断条件，当title为空且 content!=null 的时候就输出 and content = #{content}，当所有条件都不满足的时候就输出 otherwise 中的内容。









