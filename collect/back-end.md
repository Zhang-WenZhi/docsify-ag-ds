## https://github.com/Neonuu/spring-cloud-alibaba

## jmeter+sentinel 流量控制 限流测试

## sentinel java -jar xxx.jar 端口默认8080

下载jar包
https://github.com/alibaba/Sentinel/releases

2022.0.0.0-RC1对应1.8.6
```shell
<!-- https://mvnrepository.com/artifact/com.alibaba.cloud/spring-cloud-alibaba-dependencies -->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-alibaba-dependencies</artifactId>
    <version>2022.0.0.0-RC1</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>
```

2023.0.1.2对应1.8.8 ? Jul 12, 2024 spring boot 3.3.3
```shell
<!-- https://mvnrepository.com/artifact/com.alibaba.cloud/spring-cloud-alibaba-dependencies -->
<dependency>
    <groupId>com.alibaba.cloud</groupId>
    <artifactId>spring-cloud-alibaba-dependencies</artifactId>
    <version>2023.0.1.2</version>
    <type>pom</type>
</dependency>

```

## settings.xml idea 配置

```shell
/Users/zhangwenzhi/WenzhiInstalledSoft/apache-maven-3.8.3
/Users/zhangwenzhi/WenzhiInstalledSoft/apache-maven-3.8.3/conf/settings.xml
/Users/zhangwenzhi/WenzhiInstalledSoft/MavenDownload/respository
```


## nacos 启动 MacOS

https://developer.aliyun.com/article/1498873

```shell
### The default token(Base64 String):
nacos.core.auth.default.token.secret.key=VGhpc0lzTXlDdXN0b21TZWNyZXRLZXkwMTIzNDU2Nzg=

### 2.1.0 版本后
nacos.core.auth.plugin.nacos.token.secret.key=VGhpc0lzTXlDdXN0b21TZWNyZXRLZXkwMTIzNDU2Nzg=
```

```shell
# 2.4.1 版本 运行不起来，要用2.4.0.1版本，这两个版本下载都还比较快，2.2.1等版本的，简直了，可以说慢得直接放弃
cd  nacos/bin
sh startup.sh -m standalone
# 进入可视化页面，账号密码都是nacos，进行登录即可，nacos的端口为8848
# （如果想要关闭nacos，输入 sh shutdown.sh   但发现关闭后，仍然能在可视化页面连接nacos，所以需要杀死8848端口的进程,可以输入 lsof-i:8848       kill -9 进程号）
# 使用tail -f start.out 查看日志，如果看到如下日志，说明服务启动成功。
tail -f start.out
localhost:8848/nacos
http://127.0.0.1:8848/nacos
sh shutdown.sh
lsof -i:8848 
kill -9 进程号
```

```shell
21:14:36.609 [restartedMain] ERROR org.springframework.boot.diagnostics.LoggingFailureAnalysisReporter -- 

***************************
APPLICATION FAILED TO START
***************************

Description:

No spring.config.import property has been defined

Action:

Add a spring.config.import=nacos: property to your configuration.
	If configuration is not required add spring.config.import=optional:nacos: instead.
	To disable this check, set spring.cloud.nacos.config.import-check.enabled=false.
```

配置文件里，需要配置
```yml
  config:
    import: nacos:order-service-dev.yml
```

如果你不确定 Nacos 配置是否存在，或者希望在 Nacos 配置不存在时应用仍能启动，可以使用 optional: 前缀：
```yml
spring:
  config:
    import: optional:nacos:

```

如果你不希望进行导入检查，可以设置 spring.cloud.nacos.config.import-check.enabled=false：
```yml
spring:
  cloud:
    nacos:
      config:
        import-check:
          enabled: false

```

以下是一个完整的 application.yml 示例，包含了 spring.config.import 属性的添加：
```yml
server:
  port: 9080

spring:
  application:
    name: order-service
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
  config:
    import: nacos:

```

或者，如果你选择禁用导入检查：
```yml
server:
  port: 9080

spring:
  application:
    name: order-service
  cloud:
    nacos:
      discovery:
        server-addr: localhost:8848
      config:
        import-check:
          enabled: false

```



```shell
***************************
APPLICATION FAILED TO START
***************************

Description:

No spring.config.import property has been defined

Action:

Add a spring.config.import=nacos: property to your configuration.
	If configuration is not required add spring.config.import=optional:nacos: instead.
	To disable this check, set spring.cloud.nacos.config.import-check.enabled=false.

```

`空格也会影响启动`
可以：
```shell
  config:
    import:
      nacos:point-service-dev.yml
```

`有空格，报错`
```shell
  config:
    import:
      nacos: point-service-dev.yml
```

## 阿里Nacos下载、安装 [使用克隆再编译->不行报错，最终还是通过zip包下载] MacOS 

https://blog.csdn.net/Aaaaaaatwl/article/details/140091243

git clone -b master http://gitslab.yiqing.com/declare/about.git

```shell
# 新打开终端，再敲mvn -v，发现又报：zsh: command not found: mvn。重新敲source ~/.bash_profile后，恢复正常。
source ~/.bash_profile // vim ~/.zshrc // 文件末尾追加如下内容: source ~/.bash_profile

mvn -v
```

mvn -Prelease-nacos -Dmaven.test.skip=true clean install -U  

## Github加速访问教程 windows居多

https://zhuanlan.zhihu.com/p/364453651

## spring boot

- [Spring Boot 官方文档](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/)
- [Spring Boot 中文文档](https://docs.spring.io/spring-boot/docs/current/reference/html/zh/index.html)
- [Spring Boot 官方示例](https://github.com/spring-projects/spring-boot/tree/master/spring-boot-samples)
- [Spring Boot 官方示例中文版](https://github.com/ityouknow/spring-boot-examples)


## https://codeease.top/blog/  以 Java 后端为主的技术知识库

[codeeasse.top/blog](https://codeease.top/blog/)

## SpringBoot请求日志，如何优雅地打印 接口的入参出参

https://codeease.top/blog/pages/40decd/

平稳运行半年的系统宕机了，记录一次排错调优的全过程！
https://codeease.top/blog/pages/737be8

## curl 

- [curl 命令详解](https://www.cnblogs.com/duhuo/p/5695256.html)

curl -X POST -H "Content-Type: application/json" -d '{"name":"zhangsan","age":18}' http://localhost:8080/user/add

## 抓取了应用服务器在高并发时的网络包 tcpdump（Wireshark的命令行版本）/Wireshark tshark

抓取应用服务器在高并发时的网络包通常是为了分析和诊断性能问题、网络瓶颈或潜在的安全问题。以下是一些常用的工具和步骤，用于抓取和分析网络包：

工具
Wireshark：一个强大的网络协议分析工具，可以捕获和分析网络数据包。
tcpdump：一个命令行工具，用于捕获网络数据包。
tshark：Wireshark的命令行版本，功能与Wireshark类似。
步骤
安装工具：

对于Wireshark和tshark，可以从其官方网站下载并安装。
对于tcpdump，可以使用包管理器安装，例如在Ubuntu上使用sudo apt-get install tcpdump。
捕获数据包：

使用tcpdump：
```shell
sudo tcpdump -i eth0 -w output.pcap
```

其中eth0是网络接口名称，output.pcap是输出文件名。
使用tshark：
```shell
sudo tshark -i eth0 -w output.pcap
```

分析数据包：

使用Wireshark打开捕获的.pcap文件，进行详细分析。
使用tshark进行命令行分析：
```shell
tshark -r output.pcap
```

注意事项
权限：捕获网络数据包通常需要管理员权限。
性能影响：在高并发情况下捕获数据包可能会对服务器性能产生一定影响，建议在测试环境中进行或选择合适的时机。
数据敏感性：捕获的数据包可能包含敏感信息，确保在安全的环境中处理和存储这些数据。
通过上述步骤，你可以捕获并分析应用服务器在高并发时的网络包，从而更好地理解和解决相关问题。

## 检查线程堆栈信息 (命令)

jstack -l 8385 > /Users/zhengyuxiang/Desktop/stack.txt

在不同的操作系统和环境中，检查线程堆栈信息的命令有所不同。以下是一些常见操作系统和工具中检查线程堆栈信息的方法：
`Linux`
1. pstack
pstack命令可以打印正在运行的进程的堆栈跟踪信息。使用方法如下：
```shell
pstack <pid>

```

其中，<pid>是要检查的进程ID。

2. gdb
GNU调试器（GDB）也可以用来检查线程堆栈信息。首先，附加到目标进程：
```shell
gdb -p <pid>

```

然后在GDB提示符下，输入以下命令来打印所有线程的堆栈信息：
```shell
thread apply all bt

```

3. jstack
如果是在Java环境中，可以使用jstack工具来打印Java进程的堆栈信息：
```shell
jstack <pid>

```

`Windows`
1. procdump
procdump是Sysinternals工具套件中的一个工具，可以用来生成进程的转储文件，然后可以使用调试器分析这些转储文件。使用方法如下：
```shell
procdump -ma <pid>

```

生成的转储文件可以使用WinDbg或Visual Studio进行分析。

2. cscript
在Windows中，可以使用cscript和ps.vbs脚本来获取进程的堆栈信息。首先，创建一个名为ps.vbs的脚本文件，内容如下：
```shell
Set objWMIService = GetObject("winmgmts:\\.\root\cimv2")
Set colProcesses = objWMIService.ExecQuery("Select * from Win32_Thread")

For Each objProcess in colProcesses
    Wscript.Echo "Thread ID: " & objProcess.ThreadID
    Wscript.Echo "Stack Trace: " & objProcess.StackTrace
Next

```

然后运行以下命令：
```shell
cscript ps.vbs

```

`macOS`
1. lldb
LLDB是macOS上的调试器，可以用来检查线程堆栈信息。首先，附加到目标进程：
```shell
lldb -p <pid>

```

然后在LLDB提示符下，输入以下命令来打印所有线程的堆栈信息：
```shell
thread backtrace all

```

## 检查线程堆栈信息(编程语言)

在编程中，检查线程堆栈信息可以帮助开发者了解线程当前的状态和执行路径，这对于调试多线程程序非常有用。以下是一些常见编程语言中检查线程堆栈信息的方法：

`Java`
在Java中，可以使用Thread类的dumpStack方法来打印当前线程的堆栈信息：
```java
public class Main {
    public static void main(String[] args) {
        Thread.currentThread().dumpStack();
    }
}

```

或者，可以使用Throwable类的printStackTrace方法来获取更详细的堆栈信息：
```java
public class Main {
    public static void main(String[] args) {
        new Throwable().printStackTrace();
    }
}

```

`Python`
在Python中，可以使用traceback模块来打印当前线程的堆栈信息：
```python
import traceback

def main():
    traceback.print_stack()

if __name__ == "__main__":
    main()

```

`C++`
在C++中，可以使用第三方库如backward-cpp来获取堆栈信息。首先需要安装该库，然后在代码中使用：

```C++
#include "backward.hpp"

int main() {
    backward::StackTrace st;
    st.load_here(32);  // 最多加载32个堆栈帧
    backward::Printer p;
    p.print(st);
    return 0;
}

```


`Go`
在Go语言中，可以使用runtime/debug包来打印堆栈信息：


```go
package main

import (
    "runtime/debug"
)

func main() {
    debug.PrintStack()
}

```

`JavaScript (Node.js)`
在Node.js中，可以使用Error对象的stack属性来获取堆栈信息：
```javascript
function main() {
    const err = new Error();
    console.log(err.stack);
}

main();

```

这些方法可以帮助你在不同的编程语言中检查线程的堆栈信息，从而更好地进行调试和问题排查。

## 检查数据库连接池(编程语言)

检查数据库连接池是确保应用程序与数据库之间连接稳定和高效的重要步骤。以下是一些常见数据库连接池的检查方法和工具：

`Java` (使用HikariCP)
HikariCP是一个高性能的JDBC连接池库。可以通过以下方式检查HikariCP连接池的状态：

获取连接池配置信息
```java
HikariDataSource dataSource = (HikariDataSource) dataSource();
System.out.println("Pool Name: " + dataSource.getPoolName());
System.out.println("Minimum Idle: " + dataSource.getMinimumIdle());
System.out.println("Maximum Pool Size: " + dataSource.getMaximumPoolSize());
System.out.println("Idle Timeout: " + dataSource.getIdleTimeout());

```

获取连接池统计信息
```java
HikariPoolMXBean poolMXBean = dataSource.getHikariPoolMXBean();
System.out.println("Active Connections: " + poolMXBean.getActiveConnections());
System.out.println("Idle Connections: " + poolMXBean.getIdleConnections());
System.out.println("Total Connections: " + poolMXBean.getTotalConnections());
System.out.println("Threads Awaiting Connection: " + poolMXBean.getThreadsAwaitingConnection());

```

`Python` (使用SQLAlchemy)
SQLAlchemy是一个流行的Python ORM库，可以使用sqlalchemy.pool模块来检查连接池的状态。

获取连接池配置信息
```python
from sqlalchemy import create_engine
from sqlalchemy.pool import QueuePool

engine = create_engine('sqlite:///example.db')
pool = engine.pool

print("Pool Size: ", pool.size())
print("Overflow: ", pool.overflow())
print("Checkedout: ", pool.checkedout())

```

获取连接池统计信息
```python
from sqlalchemy import event

@event.listens_for(engine, 'connect')
def connect(dbapi_connection, connection_record):
    print("Connection established")

@event.listens_for(engine, 'checkout')
def checkout(dbapi_connection, connection_record, connection_proxy):
    print("Connection checked out")

@event.listens_for(engine, 'checkin')
def checkin(dbapi_connection, connection_record):
    print("Connection checked in")

```

`Go` (使用database/sql和sqlx)
在Go语言中，可以使用database/sql包和第三方库如sqlx来管理数据库连接池。可以通过以下方式检查连接池的状态：

获取连接池配置信息
```go
import (
    "database/sql"
    _ "github.com/lib/pq"
)

db, err := sql.Open("postgres", "postgres://user:password@localhost/dbname?sslmode=disable")
if err != nil {
    log.Fatal(err)
}

fmt.Println("Max Open Connections: ", db.Stats().MaxOpenConnections)
fmt.Println("Open Connections: ", db.Stats().OpenConnections)
fmt.Println("In Use: ", db.Stats().InUse)
fmt.Println("Idle: ", db.Stats().Idle)

```

## 检查垃圾回收情况

`Java`
在Java中，可以使用JVM工具来检查垃圾回收情况。例如，可以使用jstat命令来查看垃圾回收统计信息：
```bash
jstat -gc <pid> <interval> <count>
```
其中，`<pid>`是Java进程的ID，`<interval>`是采样间隔（以毫秒为单位），`<count>`是采样次数。

另外，可以使用VisualVM等图形化工具来查看和分析垃圾回收情况。


`Java`
在Java中，可以使用jstat工具来监控JVM的垃圾回收情况。首先，找到Java进程的PID，然后使用jstat命令：

```shell
jstat -gc <pid> 1000 5

```
这个命令会每秒打印一次垃圾回收统计信息，共打印5次。输出包括年轻代和老年代的内存使用情况、垃圾回收次数和时间等。

此外，可以使用jconsole或VisualVM等图形化工具来监控垃圾回收情况。


`YGC`

YGC 是 "Young Generation Garbage Collection" 的缩写，中文通常翻译为“年轻代垃圾回收”。这是在Java虚拟机（JVM）中垃圾回收机制的一部分，主要负责回收年轻代（Young Generation）中的对象。

年轻代（Young Generation）
在JVM的内存结构中，堆（Heap）被分为年轻代和老年代（Old Generation 或 Tenured Generation）。年轻代进一步分为三个部分：

Eden Space：新创建的对象首先被分配到这里。
Survivor Space 0 (S0)：从Eden Space经过垃圾回收后存活下来的对象会被移动到这里。
Survivor Space 1 (S1)：从S0经过垃圾回收后存活下来的对象会被移动到这里。
年轻代垃圾回收（YGC）
年轻代垃圾回收通常采用复制算法（Copying Algorithm），具体过程如下：

标记阶段：垃圾回收器首先标记所有存活的对象。
复制阶段：将Eden Space和Survivor Space（S0或S1）中存活的对象复制到另一个Survivor Space（S1或S0）中。
清理阶段：清空Eden Space和原来的Survivor Space。
经过多次年轻代垃圾回收后，如果对象仍然存活，它们会被晋升（Promote）到老年代。

监控YGC
```shell
jstat -gc <pid> 1000 5

```
这个命令会每秒打印一次垃圾回收统计信息，共打印5次。输出包括年轻代和老年代的内存使用情况、垃圾回收次数和时间等。

YGC 是Java虚拟机中负责年轻代垃圾回收的过程，主要目的是回收年轻代中的对象。通过监控YGC的频率和时间，可以了解应用程序的内存使用和垃圾回收性能，从而进行优化。


## docker镜像封杀 镜像代理配置 可用的镜像


可用的镜像：
https://cloud.tencent.com/developer/article/2428707

镜像代理配置：
https://learnku.com/articles/87396#

## mysql中DECIMAL(18,2) 什么意思?

`codegeex`

在MySQL中，`DECIMAL(18,2)` 是一种数据类型，用于存储精确的小数值。这种数据类型由两部分组成：

- 整数部分：最多可以存储18位数字。
- 小数部分：最多可以存储2位数字。

因此，`DECIMAL(18,2)` 可以存储的最大值是999999999999999999.99，最小值是-999999999999999999.99。

这种数据类型通常用于需要精确计算的场景，例如财务数据、科学计算等。与浮点数类型（如FLOAT或DOUBLE）相比，DECIMAL类型可以避免浮点数运算中的精度丢失问题。

例如，如果你有一个名为`price`的列，其数据类型为`DECIMAL(18,2)`，你可以插入一个精确的小数值，如`10.50`，MySQL会将其存储为`10.50`，而不是`10.499999999999999`。

```sql
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(255),
    price DECIMAL(18,2)
);

INSERT INTO products (id, name, price) VALUES (1, 'Product 1', 10.50);
```

在这个例子中，`price`列的数据类型为`DECIMAL(18,2)`，因此可以存储精确的小数值。


`fittencode`

在MySQL中，DECIMAL(18,2) 是一种数据类型，用于存储固定精度的十进制数。具体来说，DECIMAL(18,2) 的含义如下：

18 表示数字的总位数（包括小数点前后的所有数字）。
2 表示小数点后的位数。
因此，DECIMAL(18,2) 可以存储最多18位数字，其中小数点后有2位。例如，1234567890123456.78 是一个符合 DECIMAL(18,2) 类型的数值。

这种数据类型通常用于需要精确计算的场景，比如财务数据，因为它避免了浮点数运算中可能出现的精度问题。

`如果存入一个不符合的数据时会怎么样?`
在MySQL中，如果你尝试将一个不符合 DECIMAL(18,2) 定义的数据存入该类型的字段，MySQL会根据具体情况采取不同的处理方式：

超出总位数（包括小数点）：

如果存入的数值总位数超过了18位，MySQL会抛出一个错误，拒绝插入该数据。例如，尝试插入 12345678901234567.89（19位）会失败。
小数位数超出：

如果存入的数值小数位数超过了2位，MySQL会自动进行四舍五入。例如，尝试插入 1234567890123456.785 会被四舍五入为 1234567890123456.79。
负数和小数点前位数超出：

如果存入的数值是负数，负号会占用一位。例如，DECIMAL(18,2) 可以存储的最大正数是 9999999999999999.99，而最大负数是 -9999999999999999.99。
非数值数据：

如果尝试插入非数值数据（如字符串），MySQL会抛出一个错误，拒绝插入该数据。
总结来说，MySQL在处理不符合 DECIMAL(18,2) 定义的数据时，会根据具体情况进行四舍五入或抛出错误，以确保数据的完整性和一致性。

## Mysql中如何存储金额?

在Mysql中，可以用`decimal字段`记录金额：

```sql
`money` DECIMAL(18,2) not null comment '金额'
```

同时也能用`varchar以字符串的方式`保存

或者通过`int或者bigint来存储以分为单位`的金额。

具体如何选择，还是要看项目中如何使用。

## @Transactional 受检异常和非受检异常 事物控制

受检异常和非受检异常

在Java中，异常可以分为受检异常（Checked Exception）和非受检异常（Unchecked Exception）。

`受检异常`：受检异常是在`编译时`必须处理的异常，例如IOException、SQLException等。如果一个方法抛出了受检异常，那么调用该方法的方法`必须显式`地捕获该异常或者声明抛出该异常。否则，编译器会报错。受检异常通常用于表示程序运行时可能发生的错误，例如文件不存在、数据库连接失败等。

`非受检异常`：非受检异常是在`运行时`可能发生的异常，例如NullPointerException、ArrayIndexOutOfBoundsException等。非受检异常不需要在方法签名中声明，也不需要在调用方法时显式地捕获。非受检异常通常用于表示程序运行时的错误，例如空指针引用、数组越界等。

在Spring的事务管理中，默认情况下，受检异常和非受检异常都会导致事务回滚。这是因为`Spring的事务管理器会将受检异常和非受检异常都视为运行时异常`，从而触发事务回滚。

但是，有时候我们可能希望某些受检异常不触发事务回滚，或者某些非受检异常触发事务回滚。这时，我们可以通过在@Transactional注解中使用`rollbackFor`和`noRollbackFor`属性来指定哪些异常触发事务回滚，哪些异常不触发事务回滚。

例如，我们可以这样使用@Transactional注解：

```java
@Transactional(rollbackFor = Exception.class, noRollbackFor = IOException.class)
public void doSomething() {
    // ...
}
```

上面的代码表示，当doSomething方法抛出Exception异常时，事务会回滚；当doSomething方法抛出IOException异常时，事务不会回滚。

需要注意的是，`rollbackFor`和`noRollbackFor`属性可以接受一个Class类型的数组，表示多个异常类型。例如：

```java
@Transactional(rollbackFor = {Exception.class, IOException.class})
public void doSomething() {
    // ...
}
```

上面的代码表示，当doSomething方法抛出Exception异常或IOException异常时，事务都会回滚。

总结：在Spring的事务管理中，默认情况下，受检异常和非受检异常都会导致事务回滚。但是，我们可以通过在@Transactional注解中使用`rollbackFor`和`noRollbackFor`属性来指定哪些异常触发事务回滚，哪些异常不触发事务回滚。

`rollbackFor默认只会针对运行时异常和错误进行回滚，Exception为受检异常，用它回滚不了（除非在rollbackFor里申明Exception要回滚），要抛运行时异常，CustomException为运行时异常`

`自定义异常`CustomException继承了RunTimeException,代码里throw new CustomException() 抛运行时异常就不需要在方法上写throws声明该异常了,接口/controller层方法也都不用声明该异常了`


## 动态sql不能乱用

mapper 接口
```xml
// 删除/更新 操作
<where>
    // 动态sql
    <if test="id != null">
        id = #{id}
    </if>
</where>

```
更新和删除，这些重要的操作，一定不能用动态sql,上面没传id时，动态sql就会更新整张表，删除整张表，这是非常危险的


修改为：
```xml
// 删除/更新 操作
where id = #{id}
```

## mybatis mapper模板 mapper.xml

```xml
<sql id="Base_Column_List">
    id, name, age, gender, phone, email, address, create_time, update_time
</sql>

<sql id="Base_Where_Clause">
    <where>
        <if test="id != null">
            id = #{id}
        </if>
        <if test="name != null and name != ''">
            AND name = #{name}
        </if>
        <if test="age != null">
            AND age = #{age}
        </if>
        <if test="gender != null"><!--        AND gender = #{gender}-->
            AND gender = #{gender,jdbcType=VARCHAR}
        </if>
        <if test="phone != null and phone != ''">
            AND phone = #{phone}
        </if>
        <if test="email != null and email != ''">
            AND email = #{email}
        </if>
        <if test="address != null and address != ''">
            AND address = #{address}
        </if>
        <if test="createTime != null">
            AND create_time = #{createTime}
        </if>
        <if test="updateTime != null">
            AND update_time = #{updateTime}
        </if>
    </where>
</sql>

<select id="selectList" parameterType="com.example.demo.entity.User" resultType="com.example.demo.entity.User">
    SELECT
    <include refid="Base_Column_List"/>
    FROM user
    <include refid="Base_Where_Clause"/>
</select>

<select id="selectById" parameterType="java.lang.Long" resultType="com.example.demo.entity.User">
    SELECT
    <include refid="Base_Column_List"/>
    FROM user WHERE id = #{id}
</select>
```

`mybatis mapper 增删改查模板`

以下是一个简单的 MyBatis Mapper 接口模板，包含基本的增删改查操作：
```java
package com.wenzhi.leetcode.mapper;

import com.wenzhi.leetcode.model.User;
import org.apache.ibatis.annotations.*;

import java.util.List;

public interface UserMapper {

    // 插入用户
    @Insert("INSERT INTO users(name, email) VALUES(#{name}, #{email})")
    void insertUser(User user);

    // 删除用户
    @Delete("DELETE FROM users WHERE id = #{id}")
    void deleteUser(int id);

    // 更新用户
    @Update("UPDATE users SET name = #{name}, email = #{email} WHERE id = #{id}")
    void updateUser(User user);

    // 查询单个用户
    @Select("SELECT * FROM users WHERE id = #{id}")
    User getUserById(int id);

    // 查询所有用户
    @Select("SELECT * FROM users")
    List<User> getAllUsers();
}

```

同时，你需要在 MyBatis 的配置文件中配置这个 Mapper 接口。例如，在 mybatis-config.xml 中添加如下配置：
```xml
<mappers>
    <mapper class="com.wenzhi.leetcode.mapper.UserMapper"/>
</mappers>

```

`用.xml文件写`

以下是一个使用 XML 文件配置的 MyBatis Mapper 示例，包含基本的增删改查操作：
首先，创建一个 XML 文件，例如 UserMapper.xml，内容如下：
```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.wenzhi.leetcode.mapper.UserMapper">

    <!-- 插入用户 -->
    <insert id="insertUser" parameterType="com.wenzhi.leetcode.model.User">
        INSERT INTO users(name, email) VALUES(#{name}, #{email})
    </insert>

    <!-- 删除用户 -->
    <delete id="deleteUser" parameterType="int">
        DELETE FROM users WHERE id = #{id}
    </delete>

    <!-- 更新用户 -->
    <update id="updateUser" parameterType="com.wenzhi.leetcode.model.User">
        UPDATE users SET name = #{name}, email = #{email} WHERE id = #{id}
    </update>

    <!-- 查询单个用户 -->
    <select id="getUserById" parameterType="int" resultType="com.wenzhi.leetcode.model.User">
        SELECT * FROM users WHERE id = #{id}
    </select>

    <!-- 查询所有用户 -->
    <select id="getAllUsers" resultType="com.wenzhi.leetcode.model.User">
        SELECT * FROM users
    </select>

</mapper>

```

接下来，在 MyBatis 的配置文件 mybatis-config.xml 中配置这个 Mapper XML 文件：
```xml
<configuration>
    <!-- 其他配置项 -->

    <mappers>
        <mapper resource="com/wenzhi/leetcode/mapper/UserMapper.xml"/>
    </mappers>
</configuration>

```

最后，确保你的 User 类定义正确，例如：
```java
package com.wenzhi.leetcode.model;

public class User {
    private int id;
    private String name;
    private String email;

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
}

```

## Lombok 和 logback 区别

`logback `
SpringBoot中默认使用slf4j作为日志门面，使用logback作为日志的实现。

`Lombok 插件用法`
Lombok 是一个 Java 库，它通过注解的方式帮助开发者减少样板代码（如 getter、setter、toString 等方法）的编写。以下是 Lombok 插件的一些常见用法：

1. 安装 Lombok 插件
首先，你需要在你的 IDE 中安装 Lombok 插件。以 IntelliJ IDEA 为例：

打开 IntelliJ IDEA。
进入 File -> Settings（或 Preferences） -> Plugins。
搜索 Lombok 并安装。
安装完成后，重启 IDE。
2. 添加 Lombok 依赖
在你的项目中添加 Lombok 依赖。如果你使用的是 Maven，可以在 pom.xml 中添加以下依赖：
```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.20</version>
    <scope>provided</scope>
</dependency>

```

如果你使用的是 Gradle，可以在 build.gradle 中添加以下依赖：
```xml
dependencies {
    compileOnly 'org.projectlombok:lombok:1.18.20'
    annotationProcessor 'org.projectlombok:lombok:1.18.20'
}

```

3. 使用 Lombok 注解
以下是一些常用的 Lombok 注解及其用法：

@Getter 和 @Setter
自动生成类的 getter 和 setter 方法。
```java
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class User {
    private String name;
    private int age;
}

```

@ToString
自动生成 toString 方法。
```java
import lombok.ToString;

@ToString
public class User {
    private String name;
    private int age;
}

```

@EqualsAndHashCode
自动生成 equals 和 hashCode 方法。
```java
import lombok.EqualsAndHashCode;

@EqualsAndHashCode
public class User {
    private String name;
    private int age;
}

```

@NoArgsConstructor, @AllArgsConstructor, @RequiredArgsConstructor
自动生成无参构造函数、全参构造函数和包含所有 final 字段的构造函数。
```java
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.RequiredArgsConstructor;

@NoArgsConstructor
@AllArgsConstructor
@RequiredArgsConstructor
public class User {
    private String name;
    private int age;
}

```

@Data
@Data 是一个组合注解，包含了 @ToString, @EqualsAndHashCode, @Getter, @Setter 和 @RequiredArgsConstructor。
```java
import lombok.Data;

@Data
public class User {
    private String name;
    private int age;
}

```

@Builder
自动生成构建器模式。
```java
import lombok.Builder;

@Builder
public class User {
    private String name;
    private int age;
}

```

4. 使用示例
```java
public class Main {
    public static void main(String[] args) {
        User user = User.builder()
                        .name("John")
                        .age(30)
                        .build();
        System.out.println(user);
    }
}

```


## 大流量、高并发下解决系统卡死的最有效方案就是加资源，做降级，利用缓存，极致优化请求

1. 限流
限流是应对高并发的一种常见手段，通过限制请求的速率来保证系统的稳定性和可靠性。常见的限流算法有令牌桶算法和漏桶算法。

2. 降级
降级是指当系统负载过高时，为了保障核心功能的正常运行，临时关闭或降低非核心功能的处理能力。常见的降级策略有熔断降级、限流降级和开关降级。

3. 缓存
缓存是一种常用的提高系统性能的技术，通过将数据存储在内存中，减少对数据库的访问，从而提高系统的响应速度。常见的缓存技术有Redis、Memcached等。

4. 优化请求
优化请求是指通过优化请求的流程和结构，减少不必要的请求和数据处理，从而提高系统的性能。常见的优化策略有异步处理、批量处理、合并请求等。

5. 数据库优化
数据库是系统的重要组成部分，通过优化数据库的查询和索引，可以提高系统的响应速度和可靠性。常见的数据库优化策略有索引优化、查询优化、分库分表等。

`fittencode`
在流量高并发的情况下，系统卡死是一个常见的问题。为了有效解决这个问题，可以采取以下几种策略：

增加资源：
垂直扩展：增加单个服务器的硬件资源，如CPU、内存、磁盘I/O等。
水平扩展：增加服务器的数量，通过负载均衡将请求分发到多个服务器上。

降级处理：
服务降级：在高并发情况下，暂时关闭或简化一些非核心服务，以保证核心服务的稳定运行。
限流：设置请求速率限制，防止过多的请求涌入系统，导致系统崩溃。

利用缓存：
应用层缓存：使用Redis、Memcached等缓存技术，减少对数据库的直接访问，提高响应速度。
数据库缓存：利用数据库的查询缓存机制，减少重复查询的开销。

极致优化请求：
异步处理：将一些耗时的操作（如文件上传、数据处理）放到后台异步处理，减少对主线程的阻塞。
批量处理：合并多个小请求为一个大的请求，减少网络开销和系统调用次数。
代码优化：优化代码逻辑，减少不必要的计算和I/O操作，提高代码执行效率。

监控和预警：
实时监控：部署监控系统，实时监控系统的运行状态，及时发现并解决问题。
预警机制：设置预警阈值，当系统资源使用率达到一定阈值时，自动触发预警，提前采取措施。

通过上述策略的综合应用，可以有效提升系统在高并发环境下的稳定性和性能。

## dubbo接口取1000条数据 写一份代码示例 springboot

`dubbo接口调用`时设置了每次的调用大小，于是上`nacos`检查配置，果然dubbo接口设置了16M的大小，这一下就定位到问题了。每次从dubbo接口取1000条数据在某些数据量比较大的情况下超过了16M，返回了一个OutOfMemory Error。

解决方案也就简单了，首先根据实际情况调整dubbo接口的消费者和生产者限制大小，其次将每次调用1000次修改略微小一点。再者按照原来的设计1000条数据是不会超过16M的，于是检查了数据，发现有的数据单条就超过了2M，这类数据的使用价值不大，因此在产品上考虑是否过滤掉这些数据。

使用Spring Boot来实现Dubbo服务提供方和消费方会更加简洁和方便。下面是一个完整的示例，包括服务提供方和消费方的实现。

`服务提供方（Provider）`
首先，创建一个Spring Boot项目，并添加Dubbo和Spring Boot的依赖。

依赖配置（pom.xml）
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
    </dependency>
    <dependency>
        <groupId>org.apache.dubbo</groupId>
        <artifactId>dubbo-spring-boot-starter</artifactId>
        <version>2.7.8</version>
    </dependency>
    <dependency>
        <groupId>org.apache.dubbo</groupId>
        <artifactId>dubbo-registry-zookeeper</artifactId>
        <version>2.7.8</version>
    </dependency>
</dependencies>

```

服务接口
```java
package com.example.service;

import java.util.List;

public interface DataService {
    List<String> getData(int count);
}

```

服务实现
```java
package com.example.service.impl;

import com.example.service.DataService;
import org.apache.dubbo.config.annotation.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class DataServiceImpl implements DataService {
    @Override
    public List<String> getData(int count) {
        List<String> data = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            data.add("Data-" + i);
        }
        return data;
    }
}


```

配置文件（application.properties）
```properties
dubbo.application.name=data-service-provider
dubbo.registry.address=zookeeper://localhost:2181
dubbo.protocol.name=dubbo
dubbo.protocol.port=20880

```

启动类
```java
package com.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ProviderApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProviderApplication.class, args);
    }
}

```

`服务消费方（Consumer）`
同样创建一个Spring Boot项目，并添加Dubbo和Spring Boot的依赖。

依赖配置（pom.xml）
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter</artifactId>
    </dependency>
    <dependency>
        <groupId>org.apache.dubbo</groupId>
        <artifactId>dubbo-spring-boot-starter</artifactId>
        <version>2.7.8</version>
    </dependency>
    <dependency>
        <groupId>org.apache.dubbo</groupId>
        <artifactId>dubbo-registry-zookeeper</artifactId>
        <version>2.7.8</version>
    </dependency>
</dependencies>

```

服务接口（与提供方相同）
```java
package com.example.service;

import java.util.List;

public interface DataService {
    List<String> getData(int count);
}

```

消费方代码
```java
package com.example.consumer;

import com.example.service.DataService;
import org.apache.dubbo.config.annotation.Reference;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Component;

import java.util.List;

@SpringBootApplication
public class ConsumerApplication {
    public static void main(String[] args) {
        SpringApplication.run(ConsumerApplication.class, args);
    }
}

@Component
class DataConsumer implements CommandLineRunner {
    @Reference
    private DataService dataService;

    @Override
    public void run(String... args) throws Exception {
        List<String> data = dataService.getData(1000);
        for (String item : data) {
            System.out.println(item);
        }
    }
}

```

配置文件（application.properties）
```properties
dubbo.application.name=data-service-consumer
dubbo.registry.address=zookeeper://localhost:2181

```

以上代码展示了如何使用Spring Boot和Dubbo框架来实现一个简单的服务提供方和消费方，该服务可以获取指定数量的数据（在这个示例中是1000条数据）。

`Spring和Dubbo框架来实现一个简单的服务提供方和消费方`

使用Spring框架来实现Dubbo服务提供方和消费方，可以通过XML配置文件来完成。下面是一个完整的示例，包括服务提供方和消费方的实现。

`服务提供方（Provider）`
首先，创建一个Spring项目，并添加Dubbo的依赖。

依赖配置（pom.xml）
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>5.3.10</version>
    </dependency>
    <dependency>
        <groupId>org.apache.dubbo</groupId>
        <artifactId>dubbo</artifactId>
        <version>2.7.8</version>
    </dependency>
    <dependency>
        <groupId>org.apache.dubbo</groupId>
        <artifactId>dubbo-registry-zookeeper</artifactId>
        <version>2.7.8</version>
    </dependency>
</dependencies>

```

服务接口
```java
package com.example.service;

import java.util.List;

public interface DataService {
    List<String> getData(int count);
}

```

服务实现
```java
package com.example.service.impl;

import com.example.service.DataService;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service("dataService")
public class DataServiceImpl implements DataService {
    @Override
    public List<String> getData(int count) {
        List<String> data = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            data.add("Data-" + i);
        }
        return data;
    }
}

```

配置文件（provider-dubbo.xml）
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://dubbo.apache.org/schema/dubbo
       http://dubbo.apache.org/schema/dubbo/dubbo.xsd">

    <!-- 提供方应用信息，用于计算依赖关系 -->
    <dubbo:application name="data-service-provider" />

    <!-- 使用zookeeper注册中心暴露服务地址 -->
    <dubbo:registry address="zookeeper://localhost:2181" />

    <!-- 用dubbo协议在20880端口暴露服务 -->
    <dubbo:protocol name="dubbo" port="20880" />

    <!-- 声明需要暴露的服务接口 -->
    <dubbo:service interface="com.example.service.DataService" ref="dataService" />

    <!-- 和本地bean一样实现服务 -->
    <bean id="dataService" class="com.example.service.impl.DataServiceImpl" />
</beans>

```

启动类
```java
package com.example;

import org.springframework.context.support.ClassPathXmlApplicationContext;

public class ProviderApplication {
    public static void main(String[] args) throws Exception {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("provider-dubbo.xml");
        context.start();
        System.in.read(); // 按任意键退出
    }
}

```

`服务消费方（Consumer）`
同样创建一个Spring项目，并添加Dubbo的依赖。

依赖配置（pom.xml）
```xml
<dependencies>
    <dependency>
        <groupId>org.springframework</groupId>
        <artifactId>spring-context</artifactId>
        <version>5.3.10</version>
    </dependency>
    <dependency>
        <groupId>org.apache.dubbo</groupId>
        <artifactId>dubbo</artifactId>
        <version>2.7.8</version>
    </dependency>
    <dependency>
        <groupId>org.apache.dubbo</groupId>
        <artifactId>dubbo-registry-zookeeper</artifactId>
        <version>2.7.8</version>
    </dependency>
</dependencies>

```

服务接口（与提供方相同）
```java
package com.example.service;

import java.util.List;

public interface DataService {
    List<String> getData(int count);
}

```

配置文件（consumer-dubbo.xml）
```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:dubbo="http://dubbo.apache.org/schema/dubbo"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
       http://dubbo.apache.org/schema/dubbo
       http://dubbo.apache.org/schema/dubbo/dubbo.xsd">

    <!-- 消费方应用信息，用于计算依赖关系 -->
    <dubbo:application name="data-service-consumer" />

    <!-- 使用zookeeper注册中心暴露服务地址 -->
    <dubbo:registry address="zookeeper://localhost:2181" />

    <!-- 生成远程服务代理，可以和本地bean一样使用dataService -->
    <dubbo:reference id="dataService" interface="com.example.service.DataService" />
</beans>

```

消费方代码
```java
package com.example;

import com.example.service.DataService;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

public class ConsumerApplication {
    public static void main(String[] args) {
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("consumer-dubbo.xml");
        context.start();
        DataService dataService = (DataService) context.getBean("dataService");
        List<String> data = dataService.getData(1000);
        for (String item : data) {
            System.out.println(item);
        }
    }
}

```

以上代码展示了如何使用Spring和Dubbo框架来实现一个简单的服务提供方和消费方，该服务可以获取指定数量的数据（在这个示例中是1000条数据）。通过XML配置文件来配置Dubbo服务，使得整个过程更加清晰和易于管理。


## ClickHouse和Zookeeper的区别？

ClickHouse和Zookeeper是两种不同类型的系统，它们在功能和应用场景上有显著的区别。

`ClickHouse`
如前所述，ClickHouse是一个列式存储的分布式数据库管理系统，专门用于在线分析处理（OLAP）。它的主要功能和特点包括：

数据存储和查询：ClickHouse专注于高效的数据存储和查询，特别适合于大数据分析和实时数据仓库。
列式存储：采用列式存储结构，适合于分析查询，能够减少I/O操作并提高压缩率。
分布式处理：支持分布式查询处理，可以在多个服务器上并行处理数据。
实时数据插入：能够实时处理数据插入，支持高吞吐量的数据导入。
SQL支持：支持标准的SQL查询语言，提供丰富的SQL函数和操作符。

`Zookeeper`
Zookeeper是一个分布式的开源协调服务，主要用于分布式系统中的同步、配置维护以及分组和命名。它的主要功能和特点包括：

协调服务：Zookeeper提供分布式环境下的协调服务，帮助分布式应用实现同步、配置管理、分组和命名等。
分布式锁：提供分布式锁机制，用于在分布式系统中实现互斥访问。
命名服务：提供命名服务，帮助分布式系统中的组件找到彼此。
配置管理：集中管理分布式系统的配置信息，支持动态更新。
高可用性：通过集群模式提供高可用性，确保服务的持续运行。

`区别总结`
应用场景：ClickHouse主要用于大数据分析和实时数据仓库，而Zookeeper主要用于分布式系统的协调和管理。
功能定位：ClickHouse专注于数据存储和查询，而Zookeeper专注于分布式系统的协调服务。
数据处理方式：ClickHouse采用列式存储和分布式处理来优化数据分析，而Zookeeper通过提供协调服务来支持分布式系统的稳定运行。

ClickHouse和Zookeeper服务于不同的目的，ClickHouse用于数据分析，而Zookeeper用于分布式系统的管理和协调。在实际应用中，它们可以结合使用，例如在分布式数据库系统中，ClickHouse用于数据存储和查询，而Zookeeper用于协调和管理分布式节点。