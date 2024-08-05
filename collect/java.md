# Java 八股文面试收集


## 重载(Overloading)  重写(Overriding)

(1)方法重载是一个类中定义了多个方法名相同,而他们的参数的数量不同或数量相同而类型和次序不同,则称为方法的重载(Overloading)。

(2)方法重写是在子类存在方法与父类的方法的名字相同,而且参数的个数与类型一样,返回值也一样的方法,就称为重写(Overriding)。

`(3)方法重载是一个类的多态性表现,而方法重写是子类与父类的一种多态性表现。`

## 数据结构

下面的集合框架就是实现这些数据结构的？！


## 集合框架

`队列（Queue） Queue<String> queue = new LinkedList<>();`

`列表Lists List<String> linkedList = new LinkedList<>();`

LinkedList, PriorityQueue, ArrayDeque 区别:

`ArrayDeque：‌它是一个双端队列，‌实现为循环数组。‌ArrayDeque：‌也是双端队列，‌基于数组实现`

`LinkedList：‌它是一个双端队列，‌实现为双向链表。‌`

`PriorityQueue：‌这是一个基于优先堆实现的队列，‌其中元素的排序基于优先级。‌`

`LinkedList和ArrayDeque都是线程不安全的; PriorityQueue同样也是线程不安全的，‌但在实践中，‌由于其操作通常被视为原子操作或者通过适当的同步机制可以确保线程安全。‌`

`LinkedList适合用于需要在列表两端进行频繁插入和删除操作的场景`

`ArrayDeque适合需要快速在两端进行访问的场景，‌尽管其随机访问的性能可能不如ArrayList等基于数组的集合。‌`

`PriorityQueue适合需要根据优先级处理元素的场景，‌如任务调度、‌事件处理等`

```shell
总结
Java集合框架为程序员提供了预先包装的数据结构和算法来操纵他们。

集合是一个对象，可容纳其他对象的引用。集合接口声明对每一种类型的集合可以执行的操作。

集合框架的类和接口均在java.util包中。

任何对象加入集合类后，自动转变为Object类型，所以在取出的时候，需要进行强制类型转换。

```

```java
class Solution {

    public static void main(String[] args) {
        // 映射
        Map<String, String> map = new HashMap<>();
        map.put("1", "value1");
        map.put("2", "value2");
        map.put("3", "value3");

        Iterator<Map.Entry<String, String>> it = map.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<String, String> entry = it.next();
            System.out.println(entry.getKey() + entry.getValue());
        }
        for (Map.Entry<String, String> entry : map.entrySet()) {
            System.out.println(entry.getKey() + entry.getValue());
        }

        for (String key : map.keySet()) {
            System.out.println(key + map.get(key));
        }

        for (String v : map.values()) {
            System.out.println(v);
        }

        // 列表
        List<String> list = new ArrayList<>();
        list.add("Hello");
        list.add("World");
        list.add("HAHAHAHA");

        String[] strArray = new String[list.size()];
        list.toArray(strArray);

        Iterator<String> it2 = list.iterator();
        while (it2.hasNext()) {
            System.out.println(it2.next());
        }
        for (String str : list) {
            System.out.println(str);
        }
    }
}

```

https://blog.csdn.net/Chenhui98/article/details/126582037

## Java 基础数据类型

### Java 基础数据类型

Java 基础数据类型分为两大类：基本类型和引用类型。

基本类型包括：byte、short、int、long、float、double、boolean、char。

引用类型包括：类、接口、数组、枚举、注解、字符串。

### Java 基本数据类型的大小

| 基本类型 | 大小（字节） | 默认值 |
| --- | --- | --- |
| byte | 1 | 0 |
| short | 2 | 0 | |
| int | 4 | 0 |
| long | 8 | 0L |
| float | 4 | 0.0f |
| double | 8 | 0.0d |
| boolean | 1 | false |
| char | 2 | '\u0000' |

### Java 基本数据类型的默认值

基本数据类型的默认值是 0 或 false，具体取决于类型。

### Java 基本数据类型的转换

Java 基本数据类型的转换分为隐式转换和显式转换。隐式转换是指自动将一种类型转换为另一种类型，而显式转换是指手动将一种类型转换为另一种类型。

### Java 基本数据类型的包装类

Java 基本数据类型的包装类包括：Byte、Short、Integer、Long、Float、Double、Boolean、Character。

### Java 基本数据类型的比较

Java 基本数据类型的比较可以使用 == 运算符，也可以使用 equals() 方法。对于基本数据类型，== 运算符比较的是值，而 equals() 方法比较的是引用。

== 在基本数据类型：值内容, 引用类型时：地址
equals 重写：值内容 ， equals不重写：地址

对于equals方法，注意：equals方法不能作用于基本数据类型的变量

### Java 基本数据类型的存储

Java 基本数据类型的值存储在栈中，而引用类型的值存储在堆中。

## Java中equals与“==”的区别

> " == "在基本数据类型：值内容, 引用类型时：地址

> equals 重写：值内容 ， equals不重写：地址

## MyBatis

`mybatis是一款用于持久层的、轻量级的半自动化ORM框架，封装了所有jdbc操作以及设置查询参数和获取结果集的操作，支持自定义sql、存储过程和高级映射。`

`持久层是什么？`

框架是用来将内存中的数据写入到磁盘中的，再具体一点，就是写到数据库中。

框架用于持久层，就是说这个框架是和数据库进行交互的，用于数据库中数据操作的框架。

`轻量级什么概念？`

启动时占用的资源少、对业务代码的侵入性不强、比较容易配置、使用和部署简单、独立部署即可使用无需依赖另外的框架，这种就是轻量级框架，相反的就是重量级

`ORM什么意思？`

ORM，Object Relational Mapping， 直接翻译就是对象关系映射，我也没有更好的解释，看一下百科上是这样介绍的”用于实现面向对象编程语言里不同类型系统的数据之间的转换。从效果上说，它其实是创建了一个可在编程语言里使用的“虚拟对象数据库”。

面向对象是从软件工程基本原则（如耦合、聚合、封装）的基础上发展起来的，而关系数据库则是从数学理论发展而来的，两套理论存在显著的区别。为了解决这个不匹配的现象，对象关系映射技术应运而生”。

这里简单的可以这样理解，java中的数据类和数据库之间的类型系统不同，因此在使用java处理数据库时，需要进行对应的类型转化，而mybatis可以做这个事，可以将java中的类型一一映射到数据库的字段类型上，因此可以将其看作是一个ORM框架。

`mybatis半自动ORM框架呢？`

使用mybatis，需要手动配置pojo、sql和映射关系，用户可以自定义sql，这些sql是针对于处理数据库的，但是这些sql需要接受一些查询java类型的参数，或者是返回结果集封装到java类中，这些是需要配置的，因此mybatis是一个半自动ORM框架。

`hibernate是一个全自动的ORM框架`

因为只需要提供pojo和映射关系即可，后期可以直接根据pojo获取到数据。

`高级映射?`

可以类比数据表之间的映射关系，也就是一对一、一对多、多对多。

`在j2ee企业级应用开发中，其实并不只有mybatis，还有hibernate、ebean、jpa等其他持久层解决方案可以选择`

`hibernate是全ORM框架，mybatis是半ORM框架，需要自己写sql`

`hibernate(不需要自动维护一堆sql呀，只需要直接调用内置的方法即可),前期对象之间关系固定后，后期是不容易改变的，而转言mybatis，因为是半ORM框架，sql是自己写的，对应的映射规则也是相应维护的，因此后期如果数据模型和之间的关系改变了，mybatis改变起来更加简单`

`#{}和${}的区别是什么？`

mybatis 提供了两种支持动态 sql 的语法：#{} 以及 $ {}，其最大的区别则是#{}方式能够很大程度防止sql注入(安全)，${}方式无法防止Sql注入。

### 1、什么是Mybatis？

MyBatis是一个优秀的持久层框架，它对jdbc的操作进行了封装，使得数据库的操作不再繁琐，避免直接编写jdbc代码，能够将精力集中在sql语句上，提高开发效率。

### 2、MyBatis的优点？

1. 与JDBC相比，减少了50%以上的代码量，不需要手动设置参数类型，不需要手动封装结果集，能够自动映射结果集到java对象中。
2. MyBatis可以使用XML或注解来配置和映射原始类型、接口和Java POJO为数据库中的记录。

### 3、MyBatis的缺点？

1. SQL语句的编写工作量较大，尤其当字段多、关联表多时，对开发人员编写SQL语句的功底有一定要求。
2. SQL语句依赖于数据库，导致数据库移植性差，不能随意更换数据库。

### 4、MyBatis的缓存？

MyBatis提供了一级缓存和二级缓存。

1. 一级缓存：基于PerpetualCache的HashMap本地缓存，其存储作用域为SqlSession，当SqlSession flush或close之后，该SqlSession的缓存数据会被清空。一级缓存默认开启。
2. 二级缓存：基于PerpetualCache的HashMap本地缓存，其存储作用域为Mapper（Namespace），如果多个SqlSession之间需要共享缓存，则需要使用到二级缓存，并且二级缓存默认不开启。

### 5、MyBatis的动态SQL？

MyBatis的动态SQL是通过使用动态SQL标签（如<if>、<choose>、<when>、<otherwise>、<trim>、<foreach>等）来实现的。这些标签可以根据条件动态地生成SQL语句，从而实现灵活的查询和更新操作。

### 6、MyBatis的插件？

MyBatis的插件是通过实现Interceptor接口来实现的。插件可以在执行SQL语句之前或之后进行拦截，从而实现一些自定义的功能，如分页、性能监控等。

### 7、MyBatis的注解？

MyBatis的注解是一种简化XML配置的方式，可以通过在Java类的方法上使用注解来定义SQL语句，从而避免编写XML配置文件。常用的注解有@Select、@Insert、@Update、@Delete等。

### 8、MyBatis的延迟加载？

MyBatis的延迟加载是一种优化技术，它可以在需要时才加载关联对象，而不是在查询时就加载所有关联对象。这样可以减少数据库的访问次数，提高性能。MyBatis的延迟加载是通过使用association和collection标签来实现的。

### 9、MyBatis的逆向工程？

MyBatis的逆向工程是一种自动生成代码的工具，它可以根据数据库表的结构自动生成Java类、Mapper接口和XML配置文件。这样可以大大减少开发人员的工作量，提高开发效率。



