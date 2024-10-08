# Java 八股文面试收集

## 怎么防止超卖问题？

超卖是指在高并发环境下，由于多个线程同时读取和更新库存数据，导致库存数量被错误地减少，从而出现库存不足的情况。为了防止超卖问题，可以采用以下几种方法：

1. **乐观锁**：在更新库存时，使用乐观锁机制。首先读取库存数量，然后在更新时检查库存数量是否与读取时一致，如果一致则更新库存数量，否则放弃更新。Java中的乐观锁可以通过synchronized关键字或使用原子类（如AtomicInteger）来实现。

```shell
select version from goods WHERE id= 1001;

update goods set num = num - 1, version = version + 1 WHERE id= 1001 AND num > 0 AND version = @version(上面查到的version);
```

2. **悲观锁**：在更新库存时，使用悲观锁机制。首先锁定库存数据，然后更新库存数量，最后释放锁。Java中的悲观锁可以通过synchronized关键字或使用显式锁（如ReentrantLock）来实现。

一般提前采用 select for update，提前加上写锁：
```java
beginTranse(开启事务)
 
try{
 
    query('select amount from s_store where goodID = 12345   for update');
 
    if(库存 > 0){
 
        //quantity为请求减掉的库存数量
 
        query('update s_store set amount = amount - quantity where goodID = 12345');
 
    }
 
}catch( Exception e ){
 
    rollBack(回滚)
 
}
 
commit(提交事务)

```

行锁：分为 共享锁 和 排它锁。
**共享锁又称：**读锁。当一个事务对某几行上读锁时，允许其他事务对这几行进行读操作，但不允许其进行写操作，也不允许其他事务给这几行上排它锁，但允许上读锁。
上共享锁的写法：lock in share mode
```shell
例如： select math from zje where math>60 lock in share mode；
```
**排它锁又称：**写锁。当一个事务对某几个上写锁时，不允许其他事务写，但允许读。更不允许其他事务给这几行上任何锁。包括写锁。
上排它锁的写法：for update
```shell
例如：select math from zje where math >60 for update；
```

行锁的要点
注意几点：

1.行锁必须有索引才能实现，否则会自动锁全表，那么就不是行锁了。

2.两个事务不能锁同一个索引，例如：
```shell
事务A先执行：
select math from zje where math>60 for update;
 
事务B再执行：
select math from zje where math<60 for update；
这样的话，事务B是会阻塞的。如果事务B把 math索引换成其他索引就不会阻塞，
但注意，换成其他索引锁住的行不能和math索引锁住的行有重复。

```
3.insert ，delete ， update在事务中都会自动默认加上排它锁。
```shell
会话1：
begin；
select math from zje where math>60 for update；

会话2：
begin；
update zje set math=99 where math=68；
阻塞
```

需要注意的是，FOR UPDATE 生效需要同时满足两个条件时才生效：

 数据库的引擎为 innoDB

 操作位于事务块中（BEGIN/COMMIT）

3. **数据库唯一索引**：在数据库中为库存数量字段添加唯一索引，确保在并发更新时，只有一个线程能够成功更新库存数量。这种方法依赖于数据库的并发控制机制，但可能对性能有一定影响。

4. **分布式锁**：在高并发环境下，可以使用分布式锁来保证库存数量的更新操作是原子性的。例如，可以使用Redis的SETNX命令来实现分布式锁，确保只有一个线程能够更新库存数量。

redis 分布式锁
```shell
$expire = 10;//有效期10秒
$key = 'lock';//key
$value = time() + $expire;//锁的值 = Unix时间戳 + 锁的有效期
$lock = $redis->setnx($key, $value);
//判断是否上锁成功，成功则执行下步操作
if(!empty($lock))
{
//下单逻辑...
}
```

redis的lua脚本
```lua
-- KEYS[1]：库存key
-- KEYS[2]：销量key
-- ARGV[1]：减去的数量


-- 库存是否充足
if tonumber(redis.call('get', KEYS[1])) > tonumber(ARGV[1]) then
    -- 扣减库存
    redis.call('decrby', KEYS[1], ARGV[1]);
    -- 增加销量
    redis.call('incrby', KEYS[2], ARGV[1]);
    return 1;
else
    return 0;
end;

```


5. **队列**：将库存更新操作放入队列中，按照顺序依次处理。这样可以避免多个线程同时更新库存，但可能会增加系统的延迟。

在实际应用中，可以根据具体情况选择合适的方法来防止超卖问题。需要注意的是，无论采用哪种方法，都需要考虑系统的性能和可扩展性。

利用 redis 的单线程预减库存。比如商品有 100 件。那么我在 redis 存储一个 k,v。例如

每一个用户线程进来，key 值就减 1，等减到 0 的时候，全部拒绝剩下的请求。

那么也就是只有 100 个线程会进入到后续操作。所以一定不会出现超卖的现象。

## java nio包

在Java中，java.nio（New Input/Output）包提供了一种与传统的java.io包不同的I/O处理方式。java.nio包引入了缓冲区（Buffer）、通道（Channel）和选择器（Selector）等概念，使得I/O操作更加高效和灵活。

以下是一些java.nio包中的关键类和概念：

Buffer（缓冲区）：
Buffer是一个用于存储特定基本类型数据的容器。常见的Buffer子类有ByteBuffer、CharBuffer、IntBuffer等。
Buffer有三个重要的属性：capacity（容量）、position（位置）和limit（界限）。

Channel（通道）：
Channel类似于传统的流（Stream），但它可以进行双向数据传输。常见的Channel子类有FileChannel、SocketChannel、ServerSocketChannel等。
Channel可以与Buffer一起使用，进行高效的数据读写操作。

Selector（选择器）：
Selector用于实现非阻塞I/O操作。它可以监控多个Channel，判断哪些Channel有数据可读、可写或有异常情况。
Selector通常与SelectionKey一起使用，SelectionKey表示一个Channel和一个Selector之间的关系。

Charset（字符集）：
Charset用于字符编码和解码。它提供了将字节序列转换为字符序列以及将字符序列转换为字节序列的方法。

```java
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

public class NIOExample {
    public static void main(String[] args) {
        try (FileChannel channel = FileChannel.open(Paths.get("example.txt"), StandardOpenOption.READ, StandardOpenOption.WRITE)) {
            ByteBuffer buffer = ByteBuffer.allocate(1024);

            // 读取数据到Buffer
            int bytesRead = channel.read(buffer);
            while (bytesRead != -1) {
                buffer.flip(); // 切换到读模式
                while (buffer.hasRemaining()) {
                    System.out.print((char) buffer.get());
                }
                buffer.clear(); // 清空Buffer，准备下一次读取
                bytesRead = channel.read(buffer);
            }

            // 写入数据到Buffer
            String newData = "New data to write";
            buffer.clear();
            buffer.put(newData.getBytes());
            buffer.flip();
            while (buffer.hasRemaining()) {
                channel.write(buffer);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

```

通过使用java.nio包，可以实现更高效和灵活的I/O操作，特别是在处理大量数据和高并发场景时。

## 在Java中，负数用补码表示，补码是什么？

补码是一种用于`表示有符号整数的方法`，它可以将一个数的二进制表示扩展到任意位数的整数。补码的表示方式是将一个数的二进制表示取反，然后加1。

例如，对于8位二进制数，-1的补码表示为11111111，而1的补码表示为00000001。对于16位二进制数，-1的补码表示为1111111111111111，而1的补码表示为0000000000000001。

补码的主要优点是它可以方便地进行加法和减法运算。在进行加法运算时，可以直接将两个数的补码相加，然后取结果的补码作为结果。在进行减法运算时，可以将减数取反，然后与被减数相加，最后取结果的补码作为结果。

在计算机中，补码（Two's Complement）是一种用于表示有符号整数的方法。补码表示法使得加法和减法可以在硬件上统一处理，而不需要单独的减法器。补码的定义如下：

正数的补码：正数的补码就是其本身。例如，+5的补码就是0101（假设使用4位表示）。

负数的补码：负数的补码是通过对其绝对值的二进制表示取反（即0变1，1变0），然后加1得到的。例如，-5的补码计算过程如下：

5的二进制表示是0101。
取反得到1010。
加1得到1011。
因此，-5的补码是1011。

补码的优点
简化加减法：使用补码表示法，加法和减法可以统一处理。

## PriorityQueue PriorityQueue的优先级排序是怎样的？

PriorityQueue 是一个基于优先堆的无界优先队列。优先队列的元素按照自然顺序排序，也可以通过比较器（Comparator）来指定顺序。优先队列不允许插入 null 元素，也不允许插入不可比较的元素。

PriorityQueue 是一个线程不安全的队列，如果需要在多线程环境下使用，需要手动进行同步。

PriorityQueue 的常用方法包括：

- add(E e)：将指定的元素插入此优先队列。
- offer(E e)：将指定的元素插入此优先队列（如果可能的话）。
- remove(Object o)：从此队列中移除指定元素的单个实例（如果存在）。
- poll()：获取并移除此队列的头部元素，或者如果此队列为空，则返回 null。
- peek()：获取但不移除此队列的头部元素，或者如果此队列为空，则返回 null。
- clear()：从此队列中移除所有元素。
- size()：返回此队列中的元素数量。
- contains(Object o)：如果此队列包含指定的元素，则返回 true。
- iterator()：返回在此队列中的元素上进行迭代的迭代器。
- toArray()：返回一个包含此队列中所有元素的数组。

PriorityQueue 的实现是基于优先堆的，因此它的插入和删除操作的时间复杂度都是 O(log n)。

```java
import java.util.PriorityQueue;

public class Main {
    public static void main(String[] args) {
        PriorityQueue<Integer> priorityQueue = new PriorityQueue<>();
        priorityQueue.add(5);
        priorityQueue.add(3);
        priorityQueue.add(8);
        priorityQueue.add(1);

        System.out.println("PriorityQueue elements (natural ordering):");
        while (!priorityQueue.isEmpty()) {
            System.out.println(priorityQueue.poll());
        }
    }
}

```

```java
import java.util.PriorityQueue;
import java.util.Comparator;

public class Main {
    public static void main(String[] args) {
        PriorityQueue<String> priorityQueue = new PriorityQueue<>(new Comparator<String>() {
            @Override
            public int compare(String s1, String s2) {
                return s2.compareTo(s1); // 反向排序
            }
        });

        priorityQueue.add("Apple");
        priorityQueue.add("Banana");
        priorityQueue.add("Cherry");
        priorityQueue.add("Date");

        System.out.println("PriorityQueue elements (custom ordering):");
        while (!priorityQueue.isEmpty()) {
            System.out.println(priorityQueue.poll());
        }
    }
}

```

## Deque 和 queue区别

- Deque 是一个双端队列，它允许在队列的两端进行插入和删除操作。而 Queue 是一个单向队列，只允许在一端进行插入和删除操作。
- Deque 支持在队列的两端进行插入和删除操作，这使得它更加灵活。例如，可以使用 Deque 来实现一个循环队列，其中元素可以从队列的两端添加和删除。
- Deque 还支持一些额外的操作，例如获取队列的头和尾元素，以及获取队列的大小等。这些操作在 Queue 中是不支持的。
- Deque 是 Java Collections Framework 的一部分，而 Queue 不是。因此，如果你正在使用 Java Collections Framework，那么你可以使用 Deque 来实现队列的功能。

Deque（双端队列）和Queue（队列）是Java集合框架中的两个接口，它们用于不同的数据结构和操作需求。以下是它们的主要区别：

Queue（队列）
Queue接口表示一个先进先出（FIFO）的数据结构。元素被添加到队列的末尾，并从队列的前端移除。Queue接口提供了以下主要操作：

add(element): 添加元素到队列的末尾。
offer(element): 添加元素到队列的末尾，如果队列已满则返回false。
remove(): 移除并返回队列的前端元素，如果队列为空则抛出异常。
poll(): 移除并返回队列的前端元素，如果队列为空则返回null。
element(): 返回队列的前端元素，但不移除，如果队列为空则抛出异常。
peek(): 返回队列的前端元素，但不移除，如果队列为空则返回null。
Deque（双端队列）
Deque接口表示一个双端队列，允许在两端进行插入和移除操作。Deque可以作为队列（FIFO）或栈（LIFO）使用。Deque接口提供了以下主要操作：

addFirst(element): 在队列的前端添加元素。
addLast(element): 在队列的末尾添加元素。
offerFirst(element): 在队列的前端添加元素，如果队列已满则返回false。
offerLast(element): 在队列的末尾添加元素，如果队列已满则返回false。
removeFirst(): 移除并返回队列的前端元素，如果队列为空则抛出异常。
removeLast(): 移除并返回队列的末尾元素，如果队列为空则抛出异常。
pollFirst(): 移除并返回队列的前端元素，如果队列为空则返回null。
pollLast(): 移除并返回队列的末尾元素，如果队列为空则返回null。
getFirst(): 返回队列的前端元素，但不移除，如果队列为空则抛出异常。
getLast(): 返回队列的末尾元素，但不移除，如果队列为空则抛出异常。
peekFirst(): 返回队列的前端元素，但不移除，如果队列为空则返回null。
peekLast(): 返回队列的末尾元素，但不移除，如果队列为空则返回null。

总结
`Queue是先进先出（FIFO）的数据结构。
Deque是双端队列，允许在两端进行插入和移除操作，可以作为队列（FIFO）或栈（LIFO）使用。`
选择使用哪一个取决于你的具体需求：如果你只需要一个简单的先进先出队列，Queue就足够了；如果你需要在两端进行插入和移除操作，或者需要使用栈的功能，Deque会更合适。

## Deque 和 Queue除了用LinkedList实现，还能用什么实现

除了LinkedList，Deque和Queue还可以使用其他数据结构来实现，例如：

ArrayDeque：这是一个基于数组的双端队列实现，它提供了快速的插入和删除操作，但它的容量是固定的，不能动态扩展。

PriorityQueue：这是一个基于优先级堆的双端队列实现，它按照元素的优先级进行排序，优先级最高的元素位于队列的前端。

ConcurrentLinkedDeque：这是一个线程安全的双端队列实现，它使用CAS操作来保证线程安全，适用于多线程环境。

ConcurrentLinkedQueue：这是一个线程安全的队列实现，它使用CAS操作来保证线程安全，适用于多线程环境。

在Java中，Deque和Queue接口可以通过多种数据结构来实现。除了LinkedList，还有其他几个常用的实现类。以下是一些常见的实现方式：

Queue的实现类
LinkedList:

这是一个双向链表，实现了Queue接口。
示例：
Queue<String> queue = new LinkedList<>();

PriorityQueue:

这是一个优先队列，元素按照优先级顺序进行排序。
示例：
Queue<String> queue = new PriorityQueue<>();

ArrayDeque:

这是一个基于数组的双端队列，可以作为Queue使用。
示例：
Queue<String> queue = new ArrayDeque<>();

Deque的实现类
LinkedList:

这是一个双向链表，实现了Deque接口。
示例：
Deque<String> deque = new LinkedList<>();

ArrayDeque:

这是一个基于数组的双端队列，实现了Deque接口。
示例：
Deque<String> deque = new ArrayDeque<>();

总结
`Queue接口可以通过LinkedList、PriorityQueue和ArrayDeque实现。
Deque接口可以通过LinkedList和ArrayDeque实现。`
选择使用哪一个实现类取决于你的具体需求：如果你需要一个简单的队列，LinkedList或ArrayDeque可能就足够了；如果你需要元素按优先级排序，PriorityQueue会更合适。对于双端队列，LinkedList和ArrayDeque都是很好的选择。

## LinkedList、PriorityQueue和ArrayDeque 区别

LinkedList、PriorityQueue和ArrayDeque都是Java中常用的数据结构，它们都有各自的特点和适用场景。以下是它们之间的主要区别：

LinkedList：
- 实现了List接口，因此可以存储重复的元素。
- 底层使用双向链表实现，因此插入和删除操作的时间复杂度为O(1)。
- 可以在任意位置插入或删除元素，因此适用于需要频繁插入和删除操作的场景。
- 不保证元素的顺序，因此不适用于需要按顺序访问元素的场景。

PriorityQueue：
- 实现了Queue接口，因此只能存储唯一的元素。
- 底层使用堆实现，因此插入和删除操作的时间复杂度为O(log n)。
- 元素按照优先级顺序进行排序，因此适用于需要按优先级访问元素的场景。
- 不保证元素的顺序，因此不适用于需要按顺序访问元素的场景。

ArrayDeque：
- 实现了Deque接口，因此可以存储重复的元素。
- 底层使用数组实现，因此插入和删除操作的时间复杂度为O(1)。
- 可以在任意位置插入或删除元素，因此适用于需要频繁插入和删除操作的场景。
- 不保证元素的顺序，因此不适用于需要按顺序访问元素的场景。

总结
- 如果你需要一个简单的队列，LinkedList或ArrayDeque可能就足够了。
- 如果你需要元素按优先级排序，PriorityQueue会更合适。
- 对于双端队列，LinkedList和ArrayDeque都是很好的选择。

LinkedList、PriorityQueue和ArrayDeque是Java集合框架中的不同实现类，它们各自有不同的特性和用途。以下是它们的主要区别：

LinkedList
LinkedList是一个双向链表，实现了List和Deque接口。它允许在列表的任意位置进行高效的插入和删除操作，但在随机访问元素时性能较差。

特点
插入和删除高效：由于是链表结构，插入和删除操作在任意位置都是常数时间复杂度O(1)。
随机访问较慢：访问特定位置的元素需要遍历链表，时间复杂度为O(n)。
允许null元素：可以存储null值。
线程不安全：不是线程安全的，如果需要线程安全的实现，可以使用Collections.synchronizedList。

PriorityQueue
PriorityQueue是一个优先队列，实现了Queue接口。元素按照优先级顺序进行排序，默认情况下是最小堆（即最小的元素优先级最高）。

特点
优先级排序：元素按照优先级顺序进行排序，默认是最小堆。
不允许null元素：不能存储null值。
线程不安全：不是线程安全的，如果需要线程安全的实现，可以使用PriorityBlockingQueue。
不保证迭代顺序：迭代器遍历时不保证任何特定的顺序。

ArrayDeque
ArrayDeque是一个基于数组实现的双端队列，实现了Deque接口。它提供了高效的插入和删除操作，特别是在两端。

特点
高效的插入和删除：在两端的插入和删除操作都是常数时间复杂度O(1)。
不允许null元素：不能存储null值。
线程不安全：不是线程安全的，如果需要线程安全的实现，可以使用Collections.synchronizedDeque。
动态扩展：内部数组可以动态扩展，但扩展操作可能会影响性能。


总结
`LinkedList：适用于需要频繁插入和删除操作的场景，特别是在列表的任意位置。
PriorityQueue：适用于需要按优先级排序的场景，例如任务调度。
ArrayDeque：适用于需要在两端进行高效插入和删除操作的场景，例如实现栈或队列。`
选择使用哪一个实现类取决于你的具体需求：如果你需要一个简单的链表结构，LinkedList可能更合适；如果你需要按优先级排序的队列，PriorityQueue会更合适；如果你需要在两端进行高效的插入和删除操作，ArrayDeque会更合适。

## LinkedArrayList 和 ArrayList用法

LinkedArrayList并不是Java标准库中的一个类。你可能想要了解的是LinkedList和ArrayList的用法。这两个类都是Java集合框架中的部分，用于存储和操作对象的集合。

ArrayList
ArrayList是一个动态数组，实现了List接口。它允许存储所有类型的对象，包括null。ArrayList的元素可以随机访问，因为它的内部实现是基于数组的。


LinkedList
LinkedList是一个双向链表，实现了List和Deque接口。它允许存储所有类型的对象，包括null。LinkedList在插入和删除元素时比ArrayList更高效，但在随机访问元素时较慢。

如果你需要频繁地插入和删除元素，LinkedList可能更合适；如果你主要需要随机访问元素，ArrayList可能更合适。

## LinkedHashMap的用法

LinkedHashMap是Java中的一个集合类，继承自HashMap，但它保留了插入顺序。这意味着当你遍历LinkedHashMap时，元素的顺序将与它们被插入的顺序相同。这与普通的HashMap不同，HashMap不保证任何特定的迭代顺序。

```java
import java.util.LinkedHashMap;

public class Main {
    public static void main(String[] args) {
        LinkedHashMap<String, Integer> data = new LinkedHashMap<>();

        // 添加元素
        data.put("key1", 1);
        data.put("key2", 2);
        data.put("key3", 3);

        // 遍历元素
        for (String key : data.keySet()) {
            System.out.println(key + " : " + data.get(key));
        }

        // 获取元素
        int value = data.get("key1");
        System.out.println("Value of key1: " + value);

        // 删除元素
        data.remove("key1");

        // 检查是否包含某个键
        boolean containsKey = data.containsKey("key1");
        System.out.println("Contains key1: " + containsKey);

        // 获取大小
        int size = data.size();
        System.out.println("Size of data: " + size);

        // 清空LinkedHashMap
        data.clear();
        System.out.println("Size of data after clear: " + data.size());
    }
}

```

## indexOf() 和 lastIndexOf()

```java
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        ArrayList<String> list = new ArrayList<>();
        list.add("apple");
        list.add("banana");
        list.add("apple");
        list.add("orange");
        list.add("apple");

        // 查找元素 "apple" 的第一个索引
        int firstIndex = list.indexOf("apple");
        System.out.println("First index of 'apple': " + firstIndex);

        // 查找元素 "apple" 的最后一个索引
        int lastIndex = list.lastIndexOf("apple");
        System.out.println("Last index of 'apple': " + lastIndex);
    }
}
```

在Java中，String.indexOf(char ch)方法是从字符串的开头开始查找指定字符的第一个出现位置。因此，line.indexOf('\\')是从字符串的开头开始查找第一个反斜杠（\）的位置，而不是从最后一个反斜杠开始查找。

如果你需要从字符串的末尾开始查找，可以使用String.lastIndexOf(char ch)方法。

## spring boot 的装配过程

配置元数据：这是通过Java配置类、XML文件、或者使用@Configuration注解的Java类来定义的。

组件扫描与注册：Spring框架会扫描类路径下的包，并根据注解（如@Component, @Service, @Repository, @Controller）将组件注册到Spring容器中。

依赖注入：Spring容器会管理对象之间的依赖关系，并通过构造器注入、setter方法注入或字段注入来建立依赖关系。

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


## Spring Boot的生命周期大致可以分为以下几个阶段：

初始化环境
创建ApplicationContext
准备上下文环境
加载ApplicationContext
刷新上下文
运行Spring应用
应用关闭

## truncate和delete的区别

truncate和delete都是用来删除数据库中的记录，但是它们有一些重要的区别：

1. truncate是一个DDL（数据定义语言）语句，而delete是一个DML（数据操作语言）语句。
2. truncate会删除表中的所有记录，并且会重置表的自增计数器。而delete可以指定删除的条件，只删除满足条件的记录。
3. truncate的速度比delete快，因为它不需要记录每条被删除的记录，也不需要维护事务日志。
4. truncate会立即释放表占用的存储空间，而delete会保留表占用的存储空间，直到事务提交或回滚。

## 三张表，百万数据，怎么连接查询

1、索引优化：确保连接字段上有索引；创建复合索引，特别是当连接条件涉及多个字段时

2、选择合适的连接类型：
根据查询需求选择合适的连接类型（如INNER JOIN、LEFT JOIN、RIGHT JOIN等；
尽量避免使用全表扫描，尽量使用索引扫描；

3、分批处理：
如果数据量非常大，可以考虑分批处理数据。例如，使用分页查询（LIMIT和OFFSET）来分批次获取数据

4、使用临时表：
如果连接查询非常复杂，可以考虑使用临时表来存储中间结果，然后对临时表进行查询。这样可以减少连接查询的复杂度，提高查询性能。

5、优化SQL语句：
优化SQL语句，减少不必要的查询和计算。例如，使用EXISTS代替IN，使用JOIN代替子查询等。

6、使用合适的数据库引擎：
不同的数据库引擎有不同的性能特点。例如，InnoDB引擎支持事务和行级锁定，而MyISAM引擎不支持事务和行级锁定。根据查询需求和数据库引擎的特点，选择合适的数据库引擎。

7、使用缓存：如果查询结果不经常变化，可以考虑使用缓存来提高查询性能。

8、使用分布式数据库：如果数据量非常大，可以考虑使用分布式数据库来分散数据存储和查询压力。

9、并行查询：如果数据库支持并行查询，可以尝试使用并行查询来提高查询性能

## 乐观锁和悲观锁的区别

乐观锁和悲观锁是两种常见的并发控制机制，它们的主要区别在于对并发冲突的处理方式。

1. 乐观锁：乐观锁假设并发冲突很少发生，因此在读取数据时不会加锁。当数据被修改时，乐观锁会检查数据是否被其他事务修改过。如果数据被修改过，则乐观锁会抛出异常或返回错误信息。乐观锁适用于并发冲突较少的场景，因为它避免了加锁的开销。

2. 悲观锁：悲观锁假设并发冲突经常发生，因此在读取数据时会加锁，以防止其他事务修改数据。当数据被修改时，悲观锁会等待其他事务释放锁，然后获取锁并修改数据。悲观锁适用于并发冲突较多的场景，因为它可以确保数据的一致性。

总结来说，乐观锁和悲观锁的主要区别在于对并发冲突的处理方式。乐观锁假设并发冲突很少发生，因此在读取数据时不加锁；而悲观锁假设并发冲突经常发生，因此在读取数据时会加锁。

## java中如何实现乐观锁

在Java中，可以使用以下几种方式实现乐观锁：

1. 使用版本号：在数据库表中添加一个版本号字段，每次更新数据时，都会增加版本号。在更新数据时，先查询当前数据的版本号，然后更新数据时，将版本号作为条件之一。如果版本号与查询时的一致，则更新成功；否则，更新失败。这种方式可以确保数据的一致性，但需要额外的版本号字段。

2. 使用CAS（Compare and Swap）操作：CAS操作是一种原子操作，它可以在不使用锁的情况下实现并发控制。CAS操作包括三个参数：当前值、预期值和新值。如果当前值与预期值相等，则将当前值更新为新值；否则，不做任何操作。CAS操作可以确保数据的一致性，但需要额外的硬件支持。

3. 使用数据库的乐观锁实现：一些数据库提供了乐观锁的实现，例如MySQL的InnoDB引擎支持乐观锁。在更新数据时，可以使用数据库的乐观锁机制来确保数据的一致性。

以上是Java中实现乐观锁的几种常见方式，具体选择哪种方式取决于具体的应用场景和需求。

## java中如何实现悲观锁

在Java中，可以使用以下几种方式实现悲观锁：

1. 使用synchronized关键字：synchronized关键字可以用于方法或代码块，用于实现悲观锁。当多个线程同时访问被synchronized修饰的方法或代码块时，只有一个线程能够获取锁，其他线程需要等待锁释放后才能继续执行。这种方式可以确保数据的一致性，但可能会导致性能下降。

2. 使用Lock接口：Java提供了Lock接口，可以用于实现悲观锁。Lock接口提供了比synchronized更灵活的锁机制，可以设置锁的公平性、可重入性等属性。使用Lock接口时，需要手动获取锁和释放锁，需要小心处理锁的获取和释放，以避免死锁等问题。

3. 使用数据库的悲观锁实现：一些数据库提供了悲观锁的实现，例如MySQL的InnoDB引擎支持悲观锁。在查询数据时，可以使用数据库的悲观锁机制来确保数据的一致性。例如，可以使用SELECT ... FOR UPDATE语句来获取悲观锁。

以上是Java中实现悲观锁的几种常见方式，具体选择哪种方式取决于具体的应用场景和需求。

## java中如何实现分布式锁

在Java中，可以使用以下几种方式实现分布式锁：

1. 使用Redis实现分布式锁：Redis是一种高性能的键值存储数据库，可以用于实现分布式锁。可以使用Redis的`SETNX命令`来实现分布式锁，该命令可以在多个节点上实现原子性的锁操作。使用Redis实现分布式锁时，需要注意锁的释放和超时处理，以避免死锁等问题。

2. 使用Zookeeper实现分布式锁：Zookeeper是一种分布式协调服务，可以用于实现分布式锁。可以使用Zookeeper的`临时节点和监听机制`来实现分布式锁。使用Zookeeper实现分布式锁时，需要注意锁的释放和超时处理，以避免死锁等问题。

3. 使用数据库实现分布式锁：可以使用数据库的行级锁来实现分布式锁。在查询数据时，可以使用`数据库的行级锁机制`来确保数据的一致性。例如，可以使用SELECT ... FOR UPDATE语句来获取行级锁。

## java中如何实现线程池

在Java中，可以使用以下几种方式实现线程池：

1. 使用Executor框架：Java提供了Executor框架，可以用于实现线程池。Executor框架提供了一种灵活的方式来创建和管理线程池，可以设置线程池的大小、队列大小等属性。使用`Executor框架时，可以使用ThreadPoolExecutor类`来创建线程池，并使用execute方法来提交任务。

2. 使用Executors工厂类：`Java提供了Executors工厂类`，可以用于创建常见的线程池。Executors工厂类提供了一些常用的线程池实现，例如FixedThreadPool、CachedThreadPool等。使用Executors工厂类时，可以直接使用工厂类提供的静态方法来创建线程池，并使用execute方法来提交任务。

## java中如何实现线程安全

在Java中，可以使用以下几种方式实现线程安全：

1. 使用synchronized关键字：synchronized关键字可以用于实现线程安全。synchronized关键字可以用于修饰方法或代码块，当一个线程进入被synchronized修饰的方法或代码块时，其他线程将被阻塞，直到该线程执行完毕。使用synchronized关键字时，需要注意锁的粒度，以避免死锁等问题。

2. 使用volatile关键字：volatile关键字可以用于实现线程安全。volatile关键字可以用于修饰变量，当一个线程修改了被volatile修饰的变量时，其他线程可以立即看到修改后的值。使用volatile关键字时，需要注意变量的可见性和原子性，以避免数据不一致等问题。

3. 使用原子类：Java提供了原子类，可以用于实现线程安全。原子类提供了一些原子操作，例如AtomicInteger、AtomicLong等。使用原子类时，可以直接使用原子类提供的原子操作方法，而不需要使用synchronized关键字来保证线程安全。

## java中如何实现线程间通信

在Java中，可以使用以下几种方式实现线程间通信：

1. 使用wait和notify方法：wait和notify方法是Object类提供的方法，可以用于实现线程间通信。当一个线程调用了wait方法后，该线程将被阻塞，直到其他线程调用了notify方法。使用wait和notify方法时，需要注意线程的顺序和锁的释放，以避免死锁等问题。

2. 使用Condition接口：Condition接口是Java提供的线程间通信的另一种方式。Condition接口提供了一些方法，例如await、signal等，可以用于实现线程间通信。使用Condition接口时，需要注意线程的顺序和锁的释放，以避免死锁等问题。

3. 使用CountDownLatch类：CountDownLatch类是Java提供的线程间通信的另一种方式。CountDownLatch类提供了一些方法，例如await、countDown等，可以用于实现线程间通信。使用CountDownLatch类时，需要注意线程的顺序和锁的释放，以避免死锁等问题。


## ZooKeeper

ZooKeeper是什么？
ZooKeeper是一个开源的分布式协调服务，用于实现分布式系统中的一致性、配置管理、命名服务等功能。它使用了一种称为ZAB（ZooKeeper Atomic Broadcast）的一致性协议，确保分布式系统中的所有节点都能保持一致的状态。

ZooKeeper的主要功能包括：
- 配置管理：ZooKeeper可以用于存储和管理分布式系统中的配置信息，例如数据库连接信息、网络配置等。
- 命名服务：ZooKeeper可以用于实现分布式系统中的命名服务，例如分布式锁、分布式队列等。

ZooKeeper的工作原理是什么？
ZooKeeper使用了一种称为ZAB（ZooKeeper Atomic Broadcast）的一致性协议，确保分布式系统中的所有节点都能保持一致的状态。ZAB协议主要包括以下几个步骤：
- 选主：ZooKeeper集群中的节点会通过选举机制选出主节点。
- 同步：主节点会将数据同步到其他节点，确保所有节点上的数据一致。
- 广播：主节点会将数据变更广播到其他节点，确保所有节点都能及时更新数据。

ZooKeeper有哪些应用场景？
ZooKeeper在分布式系统中有很多应用场景，例如：分布式锁、分布式队列、配置管理、命名服务等。它可以帮助分布式系统中的各个节点保持一致的状态，实现高可用性和高可靠性。

`ZooKeeper提供了什么？`
ZooKeeper提供了以下功能：
- 分布式协调：ZooKeeper可以用于实现分布式系统中的协调功能，例如分布式锁、分布式队列等。
- 配置管理：ZooKeeper可以用于存储和管理分布式系统中的配置信息，例如数据库连接信息、网络配置等。
- 命名服务：ZooKeeper可以用于实现分布式系统中的命名服务，例如分布式锁、分布式队列等。
- 数据一致性：ZooKeeper使用了一种称为ZAB（ZooKeeper Atomic Broadcast）的一致性协议，确保分布式系统中的所有节点都能保持一致的状态。

`Zookeeper文件系统`
ZooKeeper文件系统是一个树形结构，类似于Unix文件系统。每个节点（称为znode）都有一个唯一的路径，可以通过路径访问该节点。ZooKeeper文件系统中的节点可以存储数据，并且可以设置节点的属性，例如节点的权限、节点的时间戳等。

ZooKeeper文件系统的主要特点包括：
- 树形结构：ZooKeeper文件系统是一个树形结构，类似于Unix文件系统。每个节点都有一个唯一的路径，可以通过路径访问该节点。
- 数据存储：ZooKeeper文件系统中的节点可以存储数据，数据的大小限制为1MB。- 节点属性：ZooKeeper文件系统中的节点可以设置节点的属性，例如节点的权限、节点的时间戳等。
- 节点类型：ZooKeeper文件系统中的节点有两种类型：持久节点（Persistent）和临时节点（Ephemeral）。持久节点在创建后一直存在，直到被删除。临时节点在创建后会在会话结束后自动删除。
- 监听器：ZooKeeper文件系统中的节点可以设置监听器，当节点的数据发生变化时，监听器会被触发。

`ZAB 协议？`
ZAB（ZooKeeper Atomic Broadcast）协议是ZooKeeper的核心协议，用于保证分布式系统中的数据一致性。ZAB协议主要包括以下几个步骤：
- 选主：ZooKeeper集群中的节点会通过选举机制选出主节点。
- 同步：主节点会将数据同步到其他节点，确保所有节点上的数据一致。
- 广播：主节点会将数据变更广播到其他节点，确保所有节点都能及时更新数据。

ZAB协议的主要特点包括：
- 原子广播：ZAB协议使用了一种称为原子广播的机制，确保所有节点都能及时更新数据。
- 一致性：ZAB协议保证分布式系统中的所有节点都能保持一致的状态。
- 高可用性：ZAB协议使用了一种称为ZooKeeper Atomic Broadcast的一致性协议，确保分布式系统中的所有节点都能保持一致的状态。
- 高性能：ZAB协议使用了一种称为ZooKeeper Atomic Broadcast的一致性协议，确保分布式系统中的所有节点都能保持一致的状态。

`四种类型的数据节点Znode`
- 持久节点（Persistent）：持久节点在创建后一直存在，直到被删除。
- 临时节点（Ephemeral）：临时节点在创建后会在会话结束后自动删除。
- 持久顺序节点（Persistent Sequential）：持久顺序节点在创建后会在节点名称后自动添加一个递增的序号。
- 临时顺序节点（Ephemeral Sequential）：临时顺序节点在创建后会在节点名称后自动添加一个递增的序号，并且在会话结束后自动删除。

`Zookeeper Watcher机制--数据变更通知`
Zookeeper Watcher机制是一种数据变更通知机制，用于在Zookeeper集群中的数据发生变化时通知客户端。Zookeeper Watcher机制主要包括以下几个步骤：
- 注册监听器：客户端可以通过调用Zookeeper API中的`getData()`、`getChildren()`、`exists()`等方法来注册监听器，指定要监听的节点和事件类型。
- 数据变更：当Zookeeper集群中的数据发生变化时，Zookeeper会通知所有注册了监听器的客户端。
- 处理通知：客户端收到通知后，可以通过调用Zookeeper API中的`process()`方法来处理通知，执行相应的操作。

Zookeeper Watcher机制的主要特点包括：
- 异步通知：Zookeeper Watcher机制使用异步通知的方式，客户端在注册监听器时可以指定一个回调函数，当数据发生变化时，Zookeeper会异步调用回调函数来通知客户端。
- 事件类型：Zookeeper Watcher机制支持多种事件类型，包括节点创建、节点删除、节点数据变更、子节点变更等。
- 一次性：Zookeeper Watcher机制是一次性的，即当客户端收到通知后，需要重新注册监听器才能继续监听数据变化。

`客户端注册 Watcher实现`
```java
import org.apache.zookeeper.*;
import org.apache.zookeeper.data.Stat;

import java.io.IOException;
import java.util.concurrent.CountDownLatch;

public class ZookeeperWatcherExample implements Watcher {
    private static final String ZOOKEEPER_ADDRESS = "localhost:2181";
    private static final int SESSION_TIMEOUT = 3000;
    private static final String ZNODE_PATH = "/myZnode";

    private ZooKeeper zooKeeper;
    private CountDownLatch countDownLatch;

    public static void main(String[] args) throws IOException, InterruptedException, KeeperException {
        ZookeeperWatcherExample example = new ZookeeperWatcherExample();
        example.connect(ZOOKEEPER_ADDRESS, SESSION_TIMEOUT);
        example.createZnode(ZNODE_PATH, "Initial data".getBytes());
        example.watchZnode(ZNODE_PATH);
        example.close();
    }

    public void connect(String zookeeperAddress, int sessionTimeout) throws IOException, InterruptedException {
        countDownLatch = new CountDownLatch(1);
        zooKeeper = new ZooKeeper(zookeeperAddress, sessionTimeout, this);
        countDownLatch.await();
        System.out.println("Connected to Zookeeper");
    }

    public void createZnode(String path, byte[] data) throws KeeperException, InterruptedException {
        String znodePath = zooKeeper.create(path, data, ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);
        System.out.println("Znode created at path: " + znodePath);
    }

    public void watchZnode(String path) throws KeeperException, InterruptedException {
        Stat stat = zooKeeper.exists(path, this);
        if (stat != null) {
            byte[] data = zooKeeper.getData(path, this, null);
            System.out.println("Data in znode: " + new String(data));
        } else {
            System.out.println("Znode does not exist");
        }
    }

    public void deleteZnode(String path) throws KeeperException, InterruptedException {
        zooKeeper.delete(path, -1);
        System.out.println("Znode deleted");
    }

    @Override
    public void process(WatchedEvent event) {
        if (event.getState() == Event.KeeperState.SyncConnected) {
            countDownLatch.countDown();
        }
    }
}
```


```java
public class ZooKeeperExample {
    private static final int SESSION_TIMEOUT = 3000;
    private static final String ZOOKEEPER_ADDRESS = "localhost:2181";
    private static final String ZNODE_PATH = "/example-znode";

    public static void main(String[] args) {
        try {
            ZooKeeper zooKeeper = new ZooKeeper(ZOOKEEPER_ADDRESS, SESSION_TIMEOUT, new ZooKeeperExample());
            countDownLatch.await();
            createZnode(zooKeeper);
            watchZnode(zooKeeper);
            deleteZnode(zooKeeper);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void createZnode(ZooKeeper zooKeeper) throws KeeperException, InterruptedException {
        String znodePath = zooKeeper.create(ZNODE_PATH, "example data".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);
        System.out.println("Znode created at path: " + znodePath);
    }

    public static void watchZnode(ZooKeeper zooKeeper) throws KeeperException, InterruptedException {
        Stat stat = zooKeeper.exists(ZNODE_PATH, new Watcher() {
            @Override
            public void process(WatchedEvent event) {
                if (event.getType() == Event.EventType.NodeDataChanged) {
                    System.out.println("Znode data changed");
                }
            }
        });
        if (stat != null) {
            byte[] data = zooKeeper.getData(ZNODE_PATH, null, null);
            System.out.println("Znode data: " + new String(data));
        } else {
            System.out.println("Znode does not exist");
        }
    }

    public static void deleteZnode(ZooKeeper zooKeeper) throws KeeperException, InterruptedException {
        zooKeeper.delete(ZNODE_PATH, -1);
        System.out.println("Znode deleted");
            }
    public static void main(String[] args) throws IOException, KeeperException, InterruptedException {
        ZooKeeper zooKeeper = new ZooKeeper("localhost:2181", 5000, null);
        createZnode(zooKeeper);
        watchZnode(zooKeeper);
        deleteZnode(zooKeeper);
        zooKeeper.close();
    }
}
```

`服务端处理Watcher实现`
```java
import org.apache.zookeeper.*;
import org.apache.zookeeper.data.Stat;

import java.io.IOException;

public class ZooKeeperServer {
    private static final String ZNODE_PATH = "/myZnode";
    private static ZooKeeper zooKeeper;

    public static void main(String[] args) throws IOException, KeeperException, InterruptedException {
        zooKeeper = new ZooKeeper("localhost:2181", 5000, null);
        createZnode(zooKeeper);
        watchZnode(zooKeeper);
        updateZnode(zooKeeper);
        deleteZnode(zooKeeper);
        zooKeeper.close();
    }
    private static void createZnode(ZooKeeper zooKeeper) throws KeeperException, InterruptedException {
        String znodePath = zooKeeper.create(ZNODE_PATH, "data".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);
        System.out.println("Znode created at path: " + znodePath);
    }

    private static void watchZnode(ZooKeeper zooKeeper) throws KeeperException, InterruptedException {
        Stat stat = zooKeeper.exists(ZNODE_PATH, new Watcher() {
            @Override
            public void process(WatchedEvent event) {
                System.out.println("Znode changed: " + event.getPath());
            }
        });
        if (stat != null) {
            System.out.println("Znode exists: " + ZNODE_PATH);
        } else {
            System.out.println("Znode does not exist: " + ZNODE_PATH);
        }
    }

    private static void updateZnode(ZooKeeper zooKeeper) throws KeeperException, InterruptedException {
        Stat stat = zooKeeper.setData(ZNODE_PATH, "new data".getBytes(), -1);
        System.out.println("Znode updated: " + ZNODE_PATH);
    }

    private static void deleteZnode(ZooKeeper zooKeeper) throws KeeperException, InterruptedException {
        zooKeeper.delete(ZNODE_PATH, -1);
        System.out.println("Znode deleted: " + ZNODE_PATH);
    }
}
```

在这个例子中，我们首先创建了一个ZooKeeper客户端，然后创建了一个Znode，并设置了它的值。接着，我们添加了一个监听器，当Znode发生变化时，监听器会被触发。然后，我们更新了Znode的值，并删除了Znode。


`客户端回调Watcher`
```java
import org.apache.zookeeper.*;

import java.io.IOException;

public class ZooKeeperClient {

    private static final String ZNODE_PATH = "/myZnode";

    public static void main(String[] args) throws IOException, KeeperException, InterruptedException {
        ZooKeeper zooKeeper = new ZooKeeper("localhost:2181", 5000, new Watcher() {
            @Override
            public void process(WatchedEvent event) {
                System.out.println("Znode changed: " + event.getPath());
            }
        });

        Stat stat = zooKeeper.exists(ZNODE_PATH, true);
        if (stat == null) {
            zooKeeper.create(ZNODE_PATH, "new data".getBytes(), ZooDefs.Ids.OPEN_ACL_UNSAFE, CreateMode.PERSISTENT);
            System.out.println("Znode created: " + ZNODE_PATH);
        } else {
            zooKeeper.setData(ZNODE_PATH, "new data".getBytes(), -1);
            System.out.println("Znode updated: " + ZNODE_PATH);
        }

        zooKeeper.close();
    }
}
```
在这个例子中，我们创建了一个ZooKeeper客户端，并设置了一个Watcher。当Znode发生变化时，Watcher会打印出Znode的路径。我们创建了一个Znode，并更新了它的值。当Znode发生变化时，Watcher会打印出Znode的路径。

`ACL权限控制机制`
ZooKeeper的ACL（Access Control List）权限控制机制用于控制对Znode的访问权限。ACL权限控制机制可以确保只有授权的用户才能访问Znode。

ZooKeeper的ACL权限控制机制包括以下几种权限：

- READ：允许读取Znode的数据和子节点列表。
- WRITE：允许写入Znode的数据。
- CREATE：允许在Znode下创建子节点。
- DELETE：允许删除子节点。
- ADMIN：允许设置Znode的ACL。

ZooKeeper的ACL权限控制机制可以基于IP地址、用户名和密码、数字证书等多种方式进行权限控制。

## Dubbo

`为什么要用Dubbo？`
Dubbo是一个高性能的Java RPC框架，它可以帮助我们实现分布式系统中的远程调用。Dubbo可以简化分布式系统的开发，提高系统的可扩展性和可靠性。

Dubbo的主要特点包括：

- 高性能：Dubbo采用NIO通信方式，可以支持高并发和高吞吐量的远程调用。
- 可扩展性：Dubbo支持多种协议和序列化方式，可以方便地扩展和定制。
- 可靠性：Dubbo支持多种负载均衡和容错机制，可以提高系统的可靠性和可用性。

RPC（remote procedure call）:远程调用过程。我理解：本质并不是一个技术，只是远程调用的一种方式，我们一般使用的dubbo也可以理解为一种RPC实现。

`Dubbo的架构`
Dubbo的架构主要包括以下几个部分：

- Provider：提供者，提供服务的一方。
- Consumer：消费者，调用服务的一方。
- Registry：注册中心，用于管理Provider和Consumer的注册和发现。
- Monitor：监控中心，用于监控Provider和Consumer的性能和调用情况。

Dubbo的架构图如下：

```
+---------------------+        +---------------------+
|      Provider       |        |      Consumer       |
+---------------------+        +---------------------+
|  +-----------------+  |        |  +-----------------+  | 
|  |  Service A      |  |        |  |  Reference A     |  |
|  +-----------------+  |        |  +-----------------+  |
|  +-----------------+  |        |  +-----------------+  |
|  |  Service B      |  |        |  |  Reference B     |  |
|  +-----------------+  |        |  +-----------------+  |
|  +-----------------+  |        |  +-----------------+  | 
|  |  Service C      |  |        |  |  Reference C     |  |
|  +-----------------+  |        |  +-----------------+  |
|                        |        |                        |
|  +-----------------+  |        |  +-----------------+  |
|  |  Registry       |  |        |  |  Monitor         |  |
|  +-----------------+  |        |  +-----------------+  |
+---------------------+        +---------------------+
```

Provider和Consumer通过Registry进行服务注册和发现，Provider将服务注册到Registry，Consumer通过Registry获取服务列表，然后进行服务调用。Monitor用于监控服务的调用情况。

`Dubbo是什么？`
Dubbo是一个高性能的Java RPC框架，它提供了服务注册、服务发现、负载均衡、容错等功能，可以帮助开发者快速构建分布式系统。Dubbo支持多种通信协议，如Dubbo协议、HTTP协议、Hessian协议等，同时也支持多种序列化方式，如Java序列化、JSON序列化、Hessian序列化等。Dubbo还提供了丰富的服务治理功能，如服务降级、服务限流、服务监控等。


`Dubbo的使用场景有哪些？`
Dubbo的使用场景非常广泛，以下是一些常见的使用场景：

1. 分布式系统：Dubbo可以用于构建分布式系统，将不同的服务模块部署在不同的服务器上，通过Dubbo进行服务调用和通信。
2. 微服务架构：Dubbo可以用于实现微服务架构，将不同的业务模块拆分成独立的服务，通过Dubbo进行服务调用和通信。
3. 大数据平台：Dubbo可以用于构建大数据平台，将不同的数据处理模块部署在不同的服务器上，通过Dubbo进行服务调用和通信。
4. 云计算平台：Dubbo可以用于构建云计算平台，将不同的计算模块部署在不同的服务器上，通过Dubbo进行服务调用和通信。
5. 企业级应用：Dubbo可以用于构建企业级应用，将不同的业务模块部署在不同的服务器上，通过Dubbo进行服务调用和通信。

`Dubbo核心功能有哪些？`
Dubbo的核心功能包括：

1. 服务注册与发现：Dubbo提供了服务注册与发现的功能，可以将服务提供者注册到注册中心，消费者可以通过注册中心获取服务提供者的信息，从而进行服务调用。
2. 负载均衡：Dubbo提供了多种负载均衡策略，如随机负载均衡、轮询负载均衡、一致性哈希负载均衡等，可以根据实际需求选择合适的负载均衡策略。
3. 容错机制：Dubbo提供了多种容错机制，如重试机制、快速失败机制、熔断机制等，可以在服务调用失败时进行相应的处理。
4. 服务监控：Dubbo提供了服务监控的功能，可以对服务的调用情况进行实时监控，包括调用次数、调用耗时、调用成功率等指标。
5. 多协议支持：Dubbo支持多种通信协议，如Dubbo协议、HTTP协议、Hessian协议等，可以根据实际需求选择合适的通信协议。

Dubbo架构包括Registry、Provider、Consumer和Monitor四个部分。

`Dubbo的整体架构设计有哪些分层?`
Dubbo的整体架构设计包括以下分层：

1. 服务接口层：定义了服务接口，包括服务接口的输入参数和输出参数。
2. 配置层：负责配置Dubbo的参数，包括服务提供者的配置、服务消费者的配置、注册中心的配置等。
3. 注册中心层：负责服务注册和发现，将服务提供者的信息注册到注册中心，服务消费者可以通过注册中心获取服务提供者的信息。
4. 调用层：负责服务调用，包括服务调用的负载均衡、容错机制、服务监控等。

`Dubbo的负载均衡策略有哪些？`
Dubbo提供了多种负载均衡策略，包括：

1. Random LoadBalance：随机负载均衡，根据权重随机选择一个服务提供者进行调用。
2. RoundRobin LoadBalance：轮询负载均衡，按照权重轮询选择一个服务提供者进行调用。
3. LeastActive LoadBalance：最少活跃调用数负载均衡，根据权重选择一个活跃调用数最少的提供者进行调用。
4. ConsistentHash LoadBalance：一致性哈希负载均衡，根据请求的哈希值选择一个服务提供者进行调用。

`Dubbo的容错机制有哪些？`
Dubbo提供了多种容错机制，包括：

1. Failover：失败自动切换，当调用失败时，自动切换到其他服务提供者进行调用。
2. Failfast：快速失败，当调用失败时，立即返回失败结果，不进行重试。
3. Failsafe：失败安全，当调用失败时，记录日志并返回成功结果，不进行重试。
4. Forking：并行调用，同时向多个服务提供者发起调用，只要有一个成功就返回成功结果。

`Dubbo Monitor实现原理？`
Dubbo Monitor是Dubbo提供的服务监控功能，用于实时监控服务的调用情况，包括调用次数、调用耗时、调用成功率等指标。

Dubbo Monitor的实现原理如下：

1. 服务提供者和服务消费者在调用服务时，会向Dubbo Monitor发送调用请求和调用结果。
2. Dubbo Monitor接收到调用请求和调用结果后，会进行统计和计算，生成监控数据。
3. Dubbo Monitor将监控数据存储在数据库或文件中，以便后续查询和分析。
4. 用户可以通过Dubbo Monitor提供的Web界面或API接口，查询和分析监控数据。

`Dubbo类似的分布式框架还有哪些？`
Dubbo类似的分布式框架还有以下几种：

1. Spring Cloud：Spring Cloud是一个基于Spring Boot的微服务框架，提供了服务注册、配置管理、负载均衡、断路器、网关等功能。
2. gRPC：gRPC是一个高性能、开源的远程过程调用框架，支持多种编程语言，提供了服务发现、负载均衡、认证等功能。
3. Thrift：Thrift是一个跨语言的远程过程调用框架，支持多种编程语言，提供了服务发现、负载均衡、认证等功能。
4. Apache ZooKeeper：Apache ZooKeeper是一个分布式协调服务，提供了分布式锁、配置管理、命名服务等功能，可以用于实现服务注册和发现。

`Dubbo和Spring Cloud有什么关系？`
Dubbo和Spring Cloud是两个不同的分布式框架，但它们之间有一定的关系。

Dubbo是一个高性能的RPC框架，主要用于实现服务之间的远程调用。Dubbo提供了服务注册、服务发现、负载均衡、容错等功能，可以用于构建高性能的分布式系统。

Spring Cloud是一个基于Spring Boot的微服务框架，提供了服务注册、配置管理、负载均衡、断路器、网关等功能。Spring Cloud可以与Dubbo结合使用，实现更强大的分布式系统。

Dubbo和Spring Cloud的关系主要体现在以下几个方面：

1. 服务注册和发现：Dubbo和Spring Cloud都提供了服务注册和发现的功能，可以用于实现服务之间的自动发现和调用。
2. 负载均衡：Dubbo和Spring Cloud都提供了负载均衡的功能，可以用于实现服务的高可用性和负载均衡。
3. 配置管理：Spring Cloud提供了配置管理的功能，可以用于实现服务的动态配置和更新。
4. 微服务架构：Dubbo和Spring Cloud都支持微服务架构，可以用于构建大规模的分布式系统。

`Dubbo和Spring Cloud有什么哪些区别？`
Dubbo和Spring Cloud的区别主要体现在以下几个方面：
1. 语言支持：Dubbo主要支持Java语言，而Spring Cloud支持多种编程语言。
2. 功能范围：Dubbo主要关注服务之间的远程调用，而Spring Cloud提供了更全面的微服务功能，包括服务注册、配置管理、负载均衡、断路器、网关等。
3. 社区活跃度：Dubbo和Spring Cloud的社区活跃度不同，Dubbo的社区相对较小，而Spring Cloud的社区非常活跃，有很多开源项目和社区支持。

`Dubbo Monitor的作用是什么？`

Dubbo Monitor是Dubbo框架中的一个组件，用于监控Dubbo服务的运行状态和性能指标。其主要作用包括：

1. 服务调用监控：Dubbo Monitor可以实时监控Dubbo服务的调用情况，包括调用次数、调用耗时、调用成功率等指标。
2. 服务性能监控：Dubbo Monitor可以监控Dubbo服务的性能指标，包括TPS、QPS、响应时间等指标，帮助开发者了解服务的性能状况。
3. 服务故障监控：Dubbo Monitor可以监控Dubbo服务的故障情况，包括异常数量、异常类型等指标，帮助开发者及时发现和解决问题。
4. 服务依赖监控：Dubbo Monitor可以监控Dubbo服务的依赖关系，包括服务之间的调用关系、服务之间的依赖关系等，帮助开发者了解服务的依赖关系和调用链路。

通过Dubbo Monitor，开发者可以实时了解Dubbo服务的运行状态和性能指标，及时发现和解决问题，提高服务的稳定性和可靠性。


`Dubbo和Dubbox之间的区别？`
Dubbo和Dubbox都是基于Dubbo框架的扩展版本，它们之间有一些区别：

1. 版本：Dubbo和Dubbox的版本不同，Dubbox是基于Dubbo 2.5.3版本进行扩展的，而Dubbo的最新版本是2.7.x。
2. 功能：Dubbox在Dubbo的基础上增加了一些新的功能，例如支持RESTful风格的接口、支持服务降级等。
3. 社区：Dubbox的社区相对较小，而Dubbo的社区非常活跃，有很多开源项目和社区支持。

`Dubbo有哪些注册中心？`
Dubbo支持多种注册中心，包括但不限于以下几种：

1. Zookeeper：Zookeeper是Dubbo默认的注册中心，它是一个分布式协调服务，可以用于存储Dubbo服务的元数据，并提供服务的注册和发现功能。
2. Redis：Redis是一个高性能的键值存储数据库，可以用于存储Dubbo服务的元数据，并提供服务的注册和发现功能。
3. Multicast：Multicast是一种基于UDP的组播协议，可以用于Dubbo服务的注册和发现功能。
4. Simple：Simple是Dubbo内置的一个简单的注册中心实现，可以用于测试和开发环境。

`Dubbo的注册中心集群挂掉，发布者和订阅者之间还能通信吗？`
Dubbo的注册中心集群挂掉后，发布者和订阅者之间仍然可以通信，但会有一些影响：

1. 服务发现：如果注册中心集群挂掉，Dubbo服务将无法从注册中心获取其他服务的地址信息，因此无法进行服务调用。但是，如果发布者和订阅者之间已经建立了连接，那么它们仍然可以继续通信。
2. 服务注册：如果注册中心集群挂掉，Dubbo服务将无法将自身的地址信息注册到注册中心，因此其他服务将无法发现该服务。但是，如果发布者和订阅者之间已经建立了连接，那么它们仍然可以继续通信。

因此，虽然注册中心集群挂掉后，Dubbo服务仍然可以继续通信，但是服务发现和注册功能将受到影响。为了确保服务的稳定性和可靠性，建议在部署Dubbo服务时，同时部署多个注册中心，并配置高可用性。

## Elasticsearch

`elasticsearch了解多少，说说你们公司es的集群架构，索引数据大小，分片有多少，以及一些调优手段`

在Elasticsearch中，`调优手段`主要包括以下几个方面：
1. 分片数量：分片数量应该根据数据量和查询需求进行调整，以实现最佳的性能和存储效率。
2. 副本数量：副本数量可以增加数据的可用性和容错能力，但是会增加存储和查询的开销。
3. 索引模板：索引模板可以用于定义索引的默认设置，以简化索引的创建和管理。
4. 调整查询和索引策略：根据实际需求调整查询和索引策略，以实现最佳的性能和存储效率。
5. 使用缓存：使用缓存可以减少查询的开销，提高查询性能。


`es的集群架构`
Elasticsearch的集群架构主要包括以下几个部分：
1. 节点（Node）：节点是Elasticsearch集群的基本单元，每个节点可以包含一个或多个分片。节点可以分布在不同的服务器上，以实现负载均衡和容错能力。
2. 索引（Index）：索引是Elasticsearch数据的基本单位，它可以将数据分布在多个节点上，以提高查询性能和容错能力。索引由一个或多个分片组成，每个分片可以分布在不同的节点上。
3. 分片（Shard）：分片是Elasticsearch数据的基本单位，它可以将数据分布在多个节点上，以提高查询性能和容错能力。分片可以分布在不同的节点上，以实现负载均衡和容错能力。
4. 副本（Replica）：副本是Elasticsearch数据的基本单位，它可以将数据分布在多个节点上，以提高数据的可用性和容错能力。副本可以分布在不同的节点上，以实现负载均衡和容错能力。
5. 集群（Cluster）：集群是Elasticsearch的基本单元，它由一个或多个节点组成。集群可以分布在不同的服务器上，以实现负载均衡和容错能力。


`elasticsearch的倒排索引是什么？`
倒排索引（Inverted Index）是一种索引方法，用于快速查找文档中的单词。在倒排索引中，每个单词都映射到一个或多个文档，这些文档包含了该单词。倒排索引通常由两部分组成：词典（Dictionary）和倒排列表（Posting List）。

词典是倒排索引的核心部分，它包含了所有出现在文档中的单词，以及每个单词在倒排列表中的位置。词典通常使用哈希表或树状结构进行存储，以便快速查找单词。

`elasticsearch索引数据多了怎么办，如何调优，部署？`
当Elasticsearch中的索引数据量增多时，可能会出现性能下降、查询速度变慢等问题。为了解决这些问题，可以采取以下调优和部署措施：

1. 分片数量：根据数据量和查询需求调整分片数量，以实现最佳的性能和存储效率。分片数量过多会导致查询性能下降，分片数量过少会导致存储空间不足。
2. 副本数量：根据数据量和查询需求调整副本数量，以实现数据的可用性和容错能力。副本数量过多会导致存储空间不足，副本数量过少会导致数据丢失的风险。
3. 索引策略：根据实际需求调整索引策略，以实现最佳的性能和存储效率。例如，可以只对常用的字段建立索引，或者使用更高效的索引算法。
4. 查询策略：根据实际需求调整查询策略，以实现最佳的性能和存储效率。例如，可以只查询必要的字段，或者使用更高效的查询算法。
5. 部署策略：根据实际需求调整部署策略，以实现最佳的性能和存储效率。例如，可以将数据分布在多个节点上，或者使用更高效的硬件设备。

`elasticsearch是如何实现master选举的`
Elasticsearch通过ZooKeeper来实现master选举。ZooKeeper是一个分布式协调服务，它可以帮助Elasticsearch实现分布式系统的协调和管理。

当Elasticsearch集群启动时，每个节点都会尝试连接到ZooKeeper。如果ZooKeeper中已经存在一个master节点，那么新节点会尝试成为follower节点。如果ZooKeeper中不存在master节点，那么新节点会尝试成为master节点。

当master节点出现故障时，ZooKeeper会自动选举一个新的master节点。新master节点会从ZooKeeper中获取集群的状态信息，并开始管理集群。

`详细描述一下Elasticsearch索引文档的过程`
Elasticsearch索引文档的过程可以分为以下几个步骤：

1. 客户端向Elasticsearch发送索引请求，请求中包含了要索引的文档和索引名称。
2. Elasticsearch接收到请求后，会根据索引名称找到对应的索引。
3. Elasticsearch会将文档中的字段解析为Elasticsearch的内部数据结构，并将其存储在索引中。
4. Elasticsearch会将文档的元数据（如文档ID、版本号等）存储在索引中。
5. Elasticsearch会将文档的索引信息存储在索引的倒排索引中，以便快速查找文档。


`详细描述一下Elasticsearch搜索的过程？`
Elasticsearch搜索的过程可以分为以下几个步骤：

1. 客户端向Elasticsearch发送搜索请求，请求中包含了要搜索的关键词和索引名称。
2. Elasticsearch接收到请求后，会根据索引名称找到对应的索引。
3. Elasticsearch会在索引的倒排索引中查找与关键词相关的文档。
4. Elasticsearch会将找到的文档返回给客户端。

`Elasticsearch在部署时，对Linux的设置有哪些优化方法`
在部署Elasticsearch时，可以对Linux进行以下优化：

1. 禁用Swap：Swap是Linux系统中的交换空间，当物理内存不足时，系统会将一部分内存数据交换到Swap空间中。禁用Swap可以避免Elasticsearch在内存不足时使用Swap空间，从而提高性能。
2. 调整文件描述符限制：Elasticsearch需要大量的文件描述符来处理请求和存储数据。可以通过调整Linux的文件描述符限制来满足Elasticsearch的需求。

`lucence内部结构是什么？`
Lucene是一个开源的全文搜索引擎库，它内部结构主要包括以下几个部分：

1. 索引：索引是Lucene中最重要的数据结构，它包含了文档和关键词的映射关系。Lucene使用倒排索引来存储索引，倒排索引是一种将关键词映射到文档的数据结构。
2. 文档：文档是Lucene中存储的最小单位，它包含了文本数据和其他元数据（如文档ID、文档类型等）。
3. 字段：字段是文档中的一个属性，它包含了文本数据和其他元数据（如字段类型、字段长度等）。
4. 词项：词项是Lucene中存储的最小单位，它包含了文本数据中的一个单词。
5. 词频：词频是Lucene中存储的最小单位，它表示一个词项在文档中出现的次数。

`Elasticsearch中的节点（比如共 20 个），其中的10 个选了一个master，另外10个选了另一个master，怎么办？`
在Elasticsearch中，如果多个节点被选为master节点，可能会导致集群出现脑裂（split-brain）问题，即集群中的节点无法达成一致。为了解决这个问题，可以采取以下措施：

1. 确保只有一个节点被选为master节点：可以通过配置文件或命令行参数来指定哪个节点被选为master节点。例如，可以使用`discovery.zen.minimum_master_nodes`参数来指定至少需要多少个节点才能选举出master节点。
2. 使用负载均衡：可以使用负载均衡器来将请求分发到不同的节点上，从而避免单个节点过载。例如，可以使用Nginx或HAProxy等负载均衡器来分发请求。
3. 使用多副本：可以使用多副本来提高集群的可用性和容错能力。例如，可以为每个索引创建多个副本，并在不同的节点上存储这些副本。这样，即使某个节点出现故障，其他节点仍然可以提供服务。
4. 使用自动故障转移：可以使用自动故障转移来在节点出现故障时自动切换master节点。例如，可以使用`discovery.zen.master_election.filter_client`参数来指定哪些节点可以成为master节点。

## MySQL

`MySQL的索引类型有哪些？`
MySQL的索引类型主要包括以下几种：

1. B-Tree索引：B-Tree索引是最常用的索引类型，它是一种平衡树结构，可以高效地进行范围查询和排序操作。B-Tree索引适用于大多数查询场景。
2. Hash索引：Hash索引是一种基于哈希表的数据结构，它通过计算哈希值来快速定位数据。Hash索引适用于等值查询，但不适用于范围查询和排序操作。
3. Full-text索引：Full-text索引是一种用于全文搜索的索引类型，它可以将文本数据分解为词项，并建立索引以便快速搜索。Full-text索引适用于文本数据的搜索和匹配操作。
4. Spatial索引：Spatial索引是一种用于空间数据的索引类型，它可以将空间数据（如地理坐标）分解为几何对象，并建立索引以便快速搜索。Spatial索引适用于空间数据的搜索和匹配操作。


`MySQL中有哪几种锁？`
MySQL中有以下几种锁：

1. 共享锁（S锁）：共享锁允许多个事务同时读取同一行数据，但不允许其他事务修改该行数据。
2. 排他锁（X锁）：排他锁允许一个事务独占一行数据，不允许其他事务读取或修改该行数据。
3. 意向锁（IS锁和IX锁）：意向锁是一种表级锁，用于表示一个事务想要获取的行级锁的类型。IS锁表示一个事务想要获取共享锁，IX锁表示一个事务想要获取排他锁。
4. 自增锁（AUTO-INC锁）：自增锁是一种特殊的行级锁，用于保证自增列的值是唯一的。当一个事务插入数据时，MySQL会为该事务获取一个自增锁，以确保自增值的唯一性。
5. 外键锁（FOREIGN KEY锁）：外键锁是一种特殊的行级锁，用于保证外键约束的完整性。当一个事务插入或更新数据时，MySQL会为该事务获取一个外键锁，以确保外键约束的完整性。


`MySQL中有哪些不同的表格？`
MySQL中有以下几种不同的表格类型：

1. InnoDB表格：InnoDB是一种事务型存储引擎，支持事务、外键和行级锁定。InnoDB表格适用于需要高性能和高可靠性的场景。
2. MyISAM表格：MyISAM是一种非事务型存储引擎，支持全文搜索和压缩。MyISAM表格适用于不需要事务支持和高可靠性的场景。
3. Memory表格：Memory表格将数据存储在内存中，因此具有极高的读写性能。但是，由于数据存储在内存中，因此重启数据库后数据会丢失。Memory表格适用于需要快速访问小规模数据的场景。

`MySQL中有哪些不同的引擎？`
在MySQL中，有多种不同的存储引擎（也称为表类型），每个引擎都有其独特的特性和用途。以下是一些常见的MySQL存储引擎：

InnoDB：

默认的存储引擎。
支持事务（ACID兼容）。
支持行级锁定和外键约束。
适用于需要事务支持和复杂查询的应用。

MyISAM：
不支持事务。
支持表级锁定。
适用于读密集型应用，如数据仓库和日志记录。

Memory（以前称为HEAP）：
数据存储在内存中，速度快但重启后数据会丢失。
适用于临时表和缓存。

Archive：
高压缩比，适用于存储归档数据。
不支持索引，只支持插入和查询操作。

CSV：
数据以CSV格式存储。
适用于需要与其他应用程序交换数据的场景。

Blackhole：
不存储数据，只记录日志。
适用于数据复制和日志记录。

NDB Cluster（也称为NDB）：
适用于分布式数据库集群。
支持高可用性和分布式存储。

Federated：
允许访问远程MySQL服务器上的表。
适用于分布式环境中的数据访问。
每种引擎都有其优缺点，选择合适的引擎取决于具体的应用需求，如事务支持、读写性能、数据一致性、存储需求等。


简述在MySQL数据库中MyISAM和InnoDB的区别？
MyISAM和InnoDB是MySQL数据库中两种常见的存储引擎，它们之间有以下主要区别：

1. 事务支持：MyISAM不支持事务，而InnoDB支持事务。InnoDB支持ACID（原子性、一致性、隔离性、持久性）特性，可以保证数据的一致性和完整性。2. 锁机制：MyISAM使用表级锁，而InnoDB使用行级锁。表级锁会导致并发性能下降，而行级锁可以提高并发性能。
3. 外键支持：MyISAM不支持外键，而InnoDB支持外键。外键可以保证数据的一致性和完整性。
4. 全文索引：MyISAM支持全文索引，而InnoDB不支持全文索引。全文索引可以加速文本数据的搜索和匹配操作。
5. 自增列：MyISAM的自增列是表级的，而InnoDB的自增列是行级的。InnoDB的自增列可以保证自增值的唯一性。
6. 表空间：MyISAM使用磁盘空间存储数据，而InnoDB使用磁盘空间和内存存储数据。InnoDB的内存存储可以提高读写性能，但也会占用更多的内存资源。
7. 适用场景：MyISAM适用于读多写少的场景，如日志、临时表等。InnoDB适用于需要事务支持、外键约束和行级锁的场景，如电子商务、金融系统等。

`MySQL中InnoDB支持的四种事务隔离级别名称，以及逐级之间的区别？`
在MySQL中，InnoDB存储引擎支持以下四种事务隔离级别：

1. READ UNCOMMITTED（读未提交）：最低的隔离级别，允许读取未提交的数据。这种隔离级别可能会导致脏读、不可重复读和幻读的问题。
2. READ COMMITTED（读已提交）：允许读取已提交的数据，可以避免脏读的问题。但是，这种隔离级别可能会导致不可重复读和幻读的问题。
3. REPEATABLE READ（可重复读）：保证在一个事务中多次读取相同的数据时，结果是一致的。这种隔离级别可以避免脏读和不可重复读的问题，但是可能会导致幻读的问题。
4. SERIALIZABLE（可串行化）：最高的隔离级别，可以避免脏读、不可重复读和幻读的问题。但是，这种隔离级别会导致并发性能下降。

`CHAR和VARCHAR的区别？`
CHAR和VARCHAR是MySQL数据库中两种常用的字符串数据类型，它们之间有以下主要区别：

1. 存储方式：CHAR是一种固定长度的字符串类型，VARCHAR是一种可变长度的字符串类型。CHAR类型的长度在创建表时指定，而VARCHAR类型的长度可以动态变化。
2. 存储空间：CHAR类型的存储空间是固定的，而VARCHAR类型的存储空间是可变的。因此，VARCHAR类型的存储空间通常比CHAR类型要小。
3. 性能：由于CHAR类型的长度是固定的，所以在某些情况下，CHAR类型的性能可能会比VARCHAR类型更好。但是，这并不是绝对的，具体取决于数据的长度和查询的复杂性。
4. 空格处理：CHAR类型会自动删除尾部的空格，而VARCHAR类型不会。因此，在处理包含空格的数据时，CHAR类型可能会产生意想不到的结果。

在大多数情况下，VARCHAR类型比CHAR类型更灵活和高效，因此在大多数情况下，建议使用VARCHAR类型来存储字符串数据。

`主键和候选键有什么区别？`
主键和候选键是数据库设计中两个重要的概念，它们之间有以下主要区别：

1. 唯一性：主键是数据库表中的一个或多个列，用于唯一标识表中的每一行。主键的值必须是唯一的，不能有重复的值。候选键是数据库表中的一个或多个列，可以用于唯一标识表中的每一行，但是候选键可以有重复的值。
2. 非空性：主键的值不能为空，而候选键的值可以为空。
3. 数量：一个表只能有一个主键，但是可以有多个候选键。
4. 使用场景：主键用于唯一标识表中的每一行，通常用于连接表和查询数据。候选键用于唯一标识表中的每一行，但是不用于连接表和查询数据。

在数据库设计中，主键和候选键都是非常重要的概念，它们可以帮助我们更好地组织和管理数据。

`myisamchk是用来做什么的？`
myisamchk是一个MySQL数据库工具，用于检查和修复MyISAM表。MyISAM是MySQL数据库中的一种存储引擎，它支持表级锁定和全文索引。

myisamchk可以用于以下操作：

1. 检查表：myisamchk可以检查MyISAM表的完整性，包括检查表的结构、索引和数据的一致性。
2. 修复表：如果表出现损坏，myisamchk可以尝试修复表，包括修复索引和数据。
3. 分析表：myisamchk可以分析表，包括计算索引的统计信息，以便优化查询性能。
4. 优化表：myisamchk可以优化表，包括重新排序索引和数据，以减少磁盘空间的占用和提高查询性能。

myisamchk是一个非常有用的工具，可以帮助我们更好地管理和维护MyISAM表。

`如果一个表有一列定义为TIMESTAMP，将发生什么？`
如果一个表有一列定义为TIMESTAMP，那么该列将存储一个时间戳，表示该行数据最后一次被修改的时间。当插入或更新该行数据时，MySQL会自动将该列的值设置为当前时间。

TIMESTAMP列的值是自动更新的，因此我们不需要手动设置该列的值。这对于需要跟踪数据修改时间的情况非常有用，例如日志记录、版本控制等。

`你怎么看到为表格定义的所有索引？`
在MySQL中，可以使用以下查询来查看为表格定义的所有索引：

```sql
SHOW INDEXES FROM table_name;
```

其中，`table_name`是要查看索引的表格的名称。

该查询将返回一个结果集，其中包含表格的所有索引的信息，包括索引的名称、类型、列、是否唯一等。

另外，也可以使用以下查询来查看表格的结构，包括列和索引的信息：

```sql
DESCRIBE table_name;
```

其中，`table_name`是要查看结构的表格的名称。

该查询将返回一个结果集，其中包含表格的所有列的信息，包括列的名称、数据类型、是否为主键、是否允许为空等。

`LIKE声明中的％和_是什么意思？`
在SQL中，LIKE声明用于在WHERE子句中搜索包含特定模式的列。LIKE声明中的%和_符号具有特殊含义：

1. %：表示任意数量的任意字符。例如，'%abc%'表示包含'abc'的任意字符串，如'abc'、'xyzabc'、'abcxyz'等。
2. _：表示任意一个字符。例如，'_abc'表示以'abc'结尾的任意字符串，如'xyzabc'、'123abc'等。

例如，以下查询将返回所有以'abc'结尾的字符串：

```sqlsql
SELECT * FROM table_name WHERE column_name LIKE '%abc';
```

其中，`table_name`是要查询的表格的名称，`column_name`是要搜索的列的名称。

`你如何使用MySQL来创建一个视图？`
在MySQL中，可以使用以下语法来创建一个视图：

```sql
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
WHERE condition;
```


## Spring

`什么是Spring框架？`
Spring是一个开源的Java平台，它提供了一种简化Java应用程序开发的方法。Spring框架的核心是依赖注入（DI）和控制反转（IoC），它提供了一种声明式编程模型，可以简化应用程序的配置和管理。

Spring框架还提供了许多其他功能，包括面向切面编程（AOP）、事务管理、数据访问、Web应用程序开发等。Spring框架的目标是使Java应用程序的开发更加简单、灵活和可维护。


`不同版本的Spring Framework有哪些主要功能？`
Spring Framework的不同版本提供了许多主要功能，包括：

1. Spring 1.x：这是Spring框架的第一个版本，它提供了基本的依赖注入和控制反转功能，以及一些其他功能，如面向切面编程（AOP）和事务管理。
2. Spring 2.x：这是Spring框架的第二个版本，它引入了一些新的功能，如注解驱动配置、Java配置和Spring MVC。
3. Spring 3.x：这是Spring框架的第三个版本，它引入了一些新的功能，如Java 5支持、Spring表达式语言（SpEL）和Spring WebFlux。
4. Spring 4.x：这是Spring框架的第四个版本，它引入了一些新的功能，如Java 8支持、Spring Boot和Spring Cloud。
5. Spring 5.x：这是Spring框架的第五个版本，它引入了一些新的功能，如Java 9支持、Spring WebFlux和Spring Data。

这些版本之间的主要区别在于它们引入的新功能和改进，以及它们对Java版本的支持。

`列举Spring Framework的优点`
Spring框架的优点包括：

1. 简化Java应用程序的开发：Spring框架提供了一种声明式编程模型，可以简化应用程序的配置和管理。
2. 提供了丰富的功能：Spring框架提供了许多功能，包括面向切面编程（AOP）、事务管理、数据访问、Web应用程序开发等。
3. 提供了灵活的配置选项：Spring框架提供了多种配置选项，包括XML配置、Java配置和注解配置。
4. 提供了强大的依赖注入功能：Spring框架提供了强大的依赖注入功能，可以简化应用程序的组件之间的依赖关系。
5. 提供了良好的社区支持：Spring框架有一个庞大的社区，提供了许多资源和文档，可以帮助开发者解决开发过程中遇到的问题。

列举Spring Framework的缺点
Spring框架的缺点包括：

1. 学习曲线陡峭：Spring框架提供了许多功能和配置选项，这使得初学者可能需要花费一些时间来学习和理解。
2. 配置复杂：Spring框架的配置可能比较复杂，特别是对于大型应用程序来说。
3. 性能开销：Spring框架的一些功能，如面向切面编程（AOP）和事务管理，可能会引入一些性能开销。
4. 依赖管理：Spring框架依赖于许多其他库和框架，这可能会增加应用程序的复杂性，并需要仔细管理依赖关系。

列举Spring Framework的常见面试题
Spring Framework的常见面试题包括：

1. 什么是Spring Framework？
2. Spring Framework的主要功能是什么？
3. Spring Framework的不同版本有哪些主要功能？
4. Spring Framework的优点是什么？
5. Spring Framework的缺点是什么？
6. 什么是依赖注入？
7. 什么是控制反转？
8. 什么是面向切面编程（AOP）？
9. 什么是事务管理？
10. 什么是Spring MVC？
11. 什么是Spring Boot？

`Spring Framework有哪些不同的功能？`
Spring Framework提供了许多功能，包括：

1. Spring Core：这是Spring框架的核心模块，提供了依赖注入、事件处理、资源管理等基本功能。
2. Spring AOP：这是Spring框架的面向切面编程模块，提供了面向切面编程的支持。
3. Spring Data：这是Spring框架的数据访问模块，提供了对各种数据存储的支持，如关系数据库、NoSQL数据库等。
4. Spring MVC：这是Spring框架的Web应用程序开发模块，提供了对构建Web应用程序的支持。
5. Spring Security：这是Spring框架的安全模块，提供了对身份验证、授权和加密的支持。
6. Spring Boot：这是Spring框架的快速开发模块，提供了对快速构建和部署Spring应用程序的支持。
7. Spring Cloud：这是Spring框架的微服务开发模块，提供了对构建和部署微服务应用程序的支持。

Spring Framework中有多少个模块，它们分别是什么？
Spring Framework中有多个模块，包括：

1. Spring Core：这是Spring框架的核心模块，提供了依赖注入、事件处理、资源管理等基本功能。
2. Spring AOP：这是Spring框架的面向切面编程模块，提供了面向切面编程的支持。
3. Spring Data：这是Spring框架的数据访问模块，提供了对各种数据存储的支持，如关系数据库、NoSQL数据库等。
4. Spring MVC：这是Spring框架的Web应用程序开发模块，提供了对构建Web应用程序的支持。
5. Spring Security：这是Spring框架的安全模块，提供了对身份验证、授权和加密的支持。
6. Spring Boot：这是Spring框架的快速开发模块，提供了对快速构建和部署Spring应用程序的支持。
7. Spring Cloud：这是Spring框架的微服务开发模块，提供了对构建和部署微服务应用程序的支持。

`什么是Spring配置文件？`
Spring配置文件是用于配置Spring应用程序的XML文件。它包含了应用程序的配置信息，如bean的定义、依赖注入的配置等。Spring配置文件可以使用XML或Java注解来定义。

`什么是Spring bean？`
Spring bean是Spring框架中的一个基本概念，它是一个由Spring容器管理的对象。Spring容器负责创建、配置和管理bean的生命周期。bean可以是一个Java类，它可以通过配置文件或注解来定义。

`什么是Spring依赖注入？`
Spring依赖注入是一种设计模式，它允许对象之间的依赖关系通过构造函数、setter方法或字段注入来管理。Spring容器负责创建和注入依赖关系，从而减少了对象之间的耦合度。

`什么是Spring AOP？`
Spring AOP（面向切面编程）是Spring框架的一个模块，它允许在应用程序中定义和实现横切关注点。横切关注点是指那些跨越多个模块或类的功能，如日志记录、事务管理等。Spring AOP通过在应用程序中定义切面和通知来实现在运行时动态地织入横切关注点。

`Spring应用程序有哪些不同组件？`
Spring应用程序通常包含以下组件：

1. Spring容器：这是Spring框架的核心组件，负责创建、配置和管理bean的生命周期。
2. Spring bean：这是Spring容器管理的对象，可以通过配置文件或注解来定义。
3. Spring依赖注入：这是Spring框架提供的一种设计模式，用于管理对象之间的依赖关系。
4. Spring AOP：这是Spring框架的面向切面编程模块，用于在应用程序中定义和实现横切关注点。
5. Spring MVC：这是Spring框架的Web应用程序开发模块，用于构建Web应用程序。
6. Spring Security：这是Spring框架的安全模块，用于提供身份验证、授权和加密功能。
7. Spring Boot：这是Spring框架的快速开发模块，用于快速构建和部署Spring应用程序。
8. Spring Cloud：这是Spring框架的微服务开发模块，用于构建和部署微服务应用程序。

`什么是Spring MVC？`
Spring MVC是Spring框架的一个模块，用于构建Web应用程序。它提供了一种基于模型-视图-控制器（MVC）架构的编程模型，用于处理HTTP请求和生成响应。Spring MVC使用注解来定义控制器、处理请求和返回视图。

`什么是Spring Security？`
Spring Security是Spring框架的一个模块，用于提供身份验证、授权和加密功能。它提供了一种基于角色的访问控制机制，可以保护Web应用程序免受未经授权的访问。Spring Security还提供了一些其他功能，如密码加密、会话管理、跨站请求伪造（CSRF）保护等。

`什么是Spring Boot？`
Spring Boot是Spring框架的一个快速开发模块，用于快速构建和部署Spring应用程序。它提供了一种约定优于配置的方法，可以简化Spring应用程序的配置和部署过程。Spring Boot还提供了一些其他功能，如自动配置、嵌入式服务器、监控和度量等。

`什么是Spring Cloud？`
Spring Cloud是Spring框架的一个微服务开发模块，用于构建和部署微服务应用程序。它提供了一些工具和框架，用于构建和管理微服务应用程序，如服务发现、配置管理、负载均衡、断路器等。Spring Cloud还提供了一些其他功能，如分布式跟踪、消息传递、事件驱动架构等。

`使用Spring有哪些方式？`
使用Spring的方式有很多种，以下是一些常见的方式：

1. 使用Spring框架的各个模块：Spring框架由多个模块组成，如Spring Core、Spring MVC、Spring Security等。你可以根据需要选择使用其中的一个或多个模块来构建你的应用程序。
2. 使用Spring Boot：Spring Boot是一个快速开发模块，可以简化Spring应用程序的配置和部署过程。你可以使用Spring Boot来快速构建和部署你的应用程序。
3. 使用Spring Cloud：Spring Cloud是一个微服务开发模块，可以构建和管理微服务应用程序。你可以使用Spring Cloud来构建和部署你的微服务应用程序。
4. 使用Spring Data：Spring Data是一个数据访问模块，可以简化数据库访问和操作。你可以使用Spring Data来访问和操作数据库。
5. 使用Spring Batch：Spring Batch是一个批处理模块，可以简化批处理应用程序的开发和部署。你可以使用Spring Batch来构建和部署你的批处理应用程序。

`可以通过多少种方式完成依赖注入？`
依赖注入可以通过以下几种方式完成：

1. 构造函数注入：通过在类的构造函数中声明依赖项，并在创建对象时传递依赖项来完成依赖注入。这种方式可以确保依赖项在对象创建时就被注入。
2. Setter方法注入：通过在类中定义Setter方法，并在需要时调用这些方法来完成依赖注入。这种方式可以灵活地控制依赖项的注入时机。
3. 字段注入：通过在类中定义字段，并在需要时直接访问这些字段来完成依赖注入。这种方式可以简化代码，但可能会导致对象之间的耦合度增加。
4. 接口注入：通过定义一个接口，并在接口中声明依赖项，然后在实现类中实现接口来完成依赖注入。这种方式可以提供更好的解耦和灵活性。
5. 注解注入：通过使用注解，如@Autowired、@Resource等，来自动完成依赖注入。这种方式可以简化代码，并提高开发效率。

`什么是依赖注入？`
依赖注入（Dependency Injection，简称DI）是一种设计模式，用于将依赖项（如对象、类、服务等）注入到其他对象中，以实现解耦和可测试性。在依赖注入中，依赖项的创建和配置由外部容器（如Spring框架）负责，而不是由对象本身负责。这种方式可以简化代码，提高可维护性和可测试性。

依赖注入的主要优点包括：
1. 解耦：通过将依赖项注入到对象中，而不是在对象内部创建依赖项，可以降低对象之间的耦合度。这样可以更容易地替换或修改依赖项，而不需要修改对象本身的代码。
2. 可测试性：通过将依赖项注入到对象中，可以更容易地编写单元测试。在单元测试中，可以替换或模拟依赖项，以便测试对象的行为。
3. 可维护性：通过将依赖项注入到对象中，可以更容易地维护和扩展代码。可以更容易地添加、删除或修改依赖项，而不需要修改对象本身的代码。
4. 代码简洁：通过使用依赖注入，可以减少代码中的重复和冗余。可以更简洁地表达对象之间的依赖关系，提高代码的可读性和可维护性。

依赖注入的主要缺点包括：
1. 学习曲线：依赖注入是一种新的编程范式，需要一定的学习曲线。对于初学者来说，可能需要一段时间才能掌握依赖注入的原理和最佳实践。
2. 配置复杂：依赖注入通常需要配置外部容器（如Spring框架），这可能会增加配置的复杂性和维护成本。
3. 性能开销：依赖注入通常需要创建和管理对象的生命周期，这可能会带来一定的性能开销。在某些情况下，性能开销可能会成为问题。


`什么是Spring IOC容器？`
Spring IOC容器是Spring框架的核心组件之一，它负责管理应用程序中的对象（如Bean）的生命周期和依赖关系。IOC容器通过依赖注入的方式将依赖项注入到对象中，以实现解耦和可测试性。

Spring IOC容器的主要功能包括：
1. 对象创建：IOC容器负责创建和管理应用程序中的对象。它可以根据配置文件或注解来创建对象，并管理对象的生命周期。
2. 依赖注入：IOC容器通过依赖注入的方式将依赖项注入到对象中。它可以自动解析对象之间的依赖关系，并将依赖项注入到对象中。
3. 生命周期管理：IOC容器负责管理应用程序中对象的生命周期。它可以创建、初始化、销毁和管理对象的生命周期。
4. 配置管理：IOC容器可以通过配置文件或注解来管理应用程序中的对象。它可以配置对象之间的依赖关系、初始化参数等。

Spring IOC容器的主要优点包括：
1. 解耦：通过将依赖项注入到对象中，IOC容器可以降低对象之间的耦合度。这样可以更容易地替换或修改依赖项，而不需要修改对象本身的代码。
2. 可测试性：通过将依赖项注入到对象中，IOC容器可以更容易地编写单元测试。在单元测试中，可以替换或模拟依赖项，以便测试对象的行为。
3. 可维护性：通过将依赖项注入到对象中，IOC容器可以更容易地维护和扩展代码。可以更容易地添加、删除或修改依赖项，而不需要修改对象本身的代码。
4. 代码简洁：通过使用IOC容器，可以减少代码中的重复和冗余。可以更简洁地表达对象之间的依赖关系，提高代码的可读性和可维护性。


`Spring Boot有哪些优点？`
Spring Boot是Spring框架的一个子项目，它提供了一种快速构建和运行Spring应用程序的方法。Spring Boot的主要优点包括：

1. 简化配置：Spring Boot提供了一种约定优于配置的方法，可以减少应用程序的配置量。它提供了一些默认的配置，可以满足大多数应用程序的需求。如果需要自定义配置，可以通过简单的属性文件或注解来实现。
2. 自动配置：Spring Boot可以根据应用程序的依赖关系自动配置应用程序。它可以根据类路径中的库和配置文件自动配置应用程序，减少了手动配置的工作量。
3. 内嵌服务器：Spring Boot提供了一种内嵌服务器的方式，可以方便地运行应用程序。它支持多种服务器，如Tomcat、Jetty和Undertow。可以通过简单的命令行或脚本启动应用程序。
4. 健康检查：Spring Boot提供了一种健康检查的方式，可以监控应用程序的状态。它可以通过HTTP端点提供应用程序的健康状态信息，如内存使用情况、数据库连接状态等。
5. 开发和部署简化：Spring Boot提供了一种简单的方式来进行开发和部署。它支持多种构建工具，如Maven和Gradle。可以通过简单的命令行或脚本构建和部署应用程序。
6. 社区支持：Spring Boot拥有一个活跃的社区，提供了大量的文档、示例和教程。这使得开发者可以更容易地学习和使用Spring Boot。

`什么是JavaConfig？`
JavaConfig是Spring框架提供的一种配置方式，它允许使用Java代码来配置Spring应用程序。JavaConfig的主要优点包括：

1. 类型安全：JavaConfig使用Java代码来配置应用程序，因此可以提供类型安全。可以在编译时检查配置的正确性，减少了运行时错误的可能性。
2. 可读性：JavaConfig使用Java代码来配置应用程序，因此可以提供更好的可读性。代码更加简洁和易于理解，使得配置更加直观和易于维护。
3. 可测试性：JavaConfig使用Java代码来配置应用程序，因此可以提供更好的可测试性。可以编写单元测试来验证配置的正确性，减少了手动测试的工作量。
4. 可重用性：JavaConfig使用Java代码来配置应用程序，因此可以提供更好的可重用性。可以将配置代码封装在类中，以便在不同的应用程序中重用。


`如何重新加载Spring Boot上的更改，而无需重新启动服务器？`
在Spring Boot中，可以使用以下方法重新加载更改而无需重新启动服务器：

1. 使用Spring Boot DevTools：Spring Boot DevTools是一个开发工具，可以在应用程序运行时自动重新加载更改。它可以在应用程序运行时检测到更改，并自动重新加载应用程序。可以通过在pom.xml文件中添加以下依赖项来启用Spring Boot DevTools：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
    <optional>true</optional>
</dependency>
```

`Spring Boot中的监视器是什么？`
在Spring Boot中，监视器是一个用于监控应用程序状态的组件。它可以通过HTTP端点提供应用程序的健康状态信息，如内存使用情况、数据库连接状态等。监视器可以帮助开发人员了解应用程序的运行状态，并快速发现和解决问题。

`如何在Spring Boot中禁用Actuator端点安全性？`
在Spring Boot中，可以通过在application.properties或application.yml文件中配置以下属性来禁用Actuator端点安全性：

```properties
management.endpoints.web.exposure.include=*
management.endpoints.web.exposure.exclude=health,info
```

这将允许所有Actuator端点访问，但排除health和info端点。如果需要禁用所有Actuator端点，可以将management.endpoints.web.exposure.include属性设置为空字符串。

`如何在自定义端口上运行Spring Boot应用程序？`
要在自定义端口上运行Spring Boot应用程序，可以在application.properties或application.yml文件中配置以下属性：

```properties
server.port=8081
```

这将使应用程序在8081端口上运行。如果需要使用其他端口，只需将8081替换为所需的端口号即可。

`什么是YAML？`
YAML（YAML Ain't Markup Language）是一种人类可读的数据序列化格式，常用于配置文件和数据的存储。它以简洁的语法和易于阅读的特性，使得数据序列化和存储变得更加方便和高效。YAML文件通常以.yml或.yaml为扩展名，可以使用文本编辑器或专门的YAML编辑器进行编辑和查看。

`如何实现Spring Boot应用程序的安全性？`
在Spring Boot中，可以通过以下几种方式实现应用程序的安全性：

1. 使用Spring Security：Spring Security是一个强大的安全框架，可以用于保护Spring Boot应用程序。它提供了身份验证和授权功能，可以保护应用程序的API端点和资源。可以通过在pom.xml文件中添加Spring Security依赖项，并在application.properties或application.yml文件中配置安全设置来实现Spring Security。
2. 使用OAuth2：OAuth2是一个开放标准，用于授权第三方应用程序访问资源。可以使用Spring Security OAuth2来实现OAuth2授权。通过配置OAuth2客户端和资源服务器，可以实现应用程序的安全性。
3. 使用JWT：JWT（JSON Web Token）是一种用于在客户端和服务器之间传递信息的令牌。可以使用Spring Security和JWT来实现应用程序的安全性。通过生成和验证JWT令牌，可以实现应用程序的身份验证和授权。

`如何在Spring Boot中实现跨域资源共享（CORS）？`
在Spring Boot中，可以通过以下几种方式实现跨域资源共享（CORS）：

1. 使用Spring Security：Spring Security提供了CORS支持，可以通过在application.properties或application.yml文件中配置CORS设置来实现。例如，可以配置允许的来源、HTTP方法、头部等信息。
2. 使用Spring Boot Actuator：Spring Boot Actuator提供了CORS支持，可以通过在application.properties或application.yml文件中配置CORS设置来实现。例如，可以配置允许的来源、HTTP方法、头部等信息。

`如何集成Spring Boot和ActiveMQ？`
在Spring Boot中集成ActiveMQ，可以按照以下步骤进行操作：

1. 添加ActiveMQ依赖：在pom.xml文件中添加ActiveMQ依赖项，例如：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-activemq</artifactId>
</dependency>
```

2. 配置ActiveMQ连接：在application.properties或application.yml文件中配置ActiveMQ连接信息，例如：

```properties
spring.activemq.broker-url=tcp://localhost:61616
spring.activemq.user=admin
spring.activemq.password=admin
```

3. 创建消息生产者：创建一个消息生产者类，用于发送消息到ActiveMQ队列或主题。可以使用JmsTemplate类来发送消息，例如：

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.stereotype.Component;

@Component
public class MessageProducer {

    @Autowired
    private JmsTemplate jmsTemplate;

    public void sendMessage(String message) {
        jmsTemplate.convertAndSend("myQueue", message);
    }
}
```

4. 创建消息消费者：创建一个消息消费者类，用于从ActiveMQ队列或主题接收消息。可以使用JmsListener注解来监听消息，例如：

```java
import org.springframework.jms.annotation.JmsListener;
import org.springframework.stereotype.Component;

@Component
public class MessageConsumer {

    @JmsListener(destination = "myQueue")
    public void receiveMessage(String message) {
        System.out.println("Received message: " + message);
    }
}
```

5. 启动应用程序：启动应用程序，消息生产者将消息发送到ActiveMQ队列或主题，消息消费者将接收并处理消息。

注意：以上代码仅为示例，实际使用时需要根据具体情况进行修改和优化。

## Spring Cloud

`什么是Spring Cloud？`
Spring Cloud是一个基于Spring Boot的微服务架构开发工具集，它提供了一系列的组件和工具，用于简化微服务架构的开发和部署。Spring Cloud的目标是帮助开发人员构建可扩展、可靠和易于维护的分布式系统。

Spring Cloud的主要组件包括：

- 服务注册与发现：Spring Cloud Netflix Eureka、Consul等组件可以用于服务注册与发现，使得服务之间可以相互发现和调用。
- 配置管理：Spring Cloud Config组件可以用于集中管理应用程序的配置信息，支持多种配置存储方式，如Git、SVN等。
- 负载均衡：Spring Cloud Ribbon和Spring Cloud LoadBalancer等组件可以用于实现客户端负载均衡，提高系统的可用性和性能。
- 断路器：Spring Cloud Hystrix组件可以用于实现断路器模式，提高系统的容错性和稳定性。
- API网关：Spring Cloud Gateway组件可以用于实现API网关，提供统一的入口和路由功能，支持请求过滤、限流等功能。
- 分布式追踪：Spring Cloud Sleuth组件可以用于实现分布式追踪，帮助开发人员定位和解决分布式系统中的性能问题和故障。
- 安全性：Spring Cloud Security组件可以用于实现微服务架构中的安全性，支持OAuth2、JWT等认证和授权机制。

Spring Cloud的主要特点包括：

- 基于Spring Boot：Spring Cloud与Spring Boot无缝集成，简化了微服务架构的开发和部署。
- 组件丰富：Spring Cloud提供了丰富的组件和工具，可以满足各种微服务架构的需求。
- 易于集成：Spring Cloud与各种开源组件和工具集成良好，如Netflix Eureka、Consul、Ribbon、Hystrix等。
- 社区活跃：Spring Cloud拥有活跃的社区和丰富的文档资源，可以方便地获取帮助和支持。

Spring Cloud的应用场景包括：

- 微服务架构：Spring Cloud可以帮助开发人员构建可扩展、可靠和易于维护的微服务架构。
- 分布式系统：Spring Cloud可以帮助开发人员构建分布式系统，实现服务注册与发现、配置管理、负载均衡、断路器等功能。
- 云原生应用：Spring Cloud可以帮助开发人员构建云原生应用，实现容器化、微服务化、服务网格等功能。


`使用Spring Cloud有什么优势？`
使用Spring Cloud有以下优势：

1. 简化微服务架构的开发和部署：Spring Cloud与Spring Boot无缝集成，简化了微服务架构的开发和部署，提高了开发效率。
2. 提供丰富的组件和工具：Spring Cloud提供了丰富的组件和工具，如服务注册与发现、配置管理、负载均衡、断路器等，可以满足各种微服务架构的需求。
3. 易于集成：Spring Cloud与各种开源组件和工具集成良好，如Netflix Eureka、Consul、Ribbon、Hystrix等，可以方便地与其他组件和工具集成。
4. 社区活跃：Spring Cloud拥有活跃的社区和丰富的文档资源，可以方便地获取帮助和支持。
5. 支持云原生应用：Spring Cloud可以帮助开发人员构建云原生应用，实现容器化、微服务化、服务网格等功能，提高系统的可扩展性和可靠性。

`使用Spring Cloud有哪些注意事项？`
使用Spring Cloud需要注意以下几点：

1. 确保服务之间的通信方式：在微服务架构中，服务之间的通信方式非常重要，需要确保服务之间的通信方式是可靠和高效的。可以使用Spring Cloud提供的组件，如Ribbon、Feign等，实现服务之间的通信。
2. 确保服务的可扩展性：在微服务架构中，服务的可扩展性非常重要，需要确保服务可以水平扩展，以应对高并发请求。可以使用Spring Cloud提供的组件，如Eureka、Consul等，实现服务的注册与发现。
3. 确保服务的可靠性：在微服务架构中，服务的可靠性非常重要，需要确保服务可以处理异常情况，保证系统的稳定运行。可以使用Spring Cloud提供的组件，如Hystrix、Resilience4j等，实现服务的断路器和限流等功能。
4. 确保服务的安全性：在微服务架构中，服务的安全性非常重要，需要确保服务之间的通信是安全的。可以使用Spring Cloud提供的组件，如OAuth2、JWT等，实现服务的认证和授权。
Spring Cloud是一个基于Spring Boot的微服务架构开发工具包，它提供了一系列的组件和工具，帮助开发人员构建可扩展、可靠和易于维护的微服务架构。


`服务注册和发现是什么意思？Spring Cloud如何实现？`
服务注册和发现是微服务架构中非常重要的概念，它可以帮助服务之间进行通信和协作。服务注册是指将服务的信息（如服务名、IP地址、端口号等）注册到一个注册中心，服务发现是指服务在需要调用其他服务时，通过注册中心获取其他服务的信息，从而实现服务之间的通信。

Spring Cloud提供了多种服务注册和发现的方式，如Eureka、Consul、Zookeeper等。其中，Eureka是Spring Cloud中最常用的服务注册和发现组件，它是一个高可用、可扩展的服务注册中心，可以支持服务的高并发访问和故障转移。使用Eureka实现服务注册和发现非常简单，只需要在服务提供者和消费者中添加Eureka客户端的依赖，并在配置文件中配置Eureka注册中心的地址，就可以实现服务的注册和发现。

`负载平衡的意义什么？`
负载平衡是指将请求分配到多个服务器上，以提高系统的性能和可靠性。在微服务架构中，负载平衡是非常重要的，因为它可以帮助服务处理高并发请求，提高系统的可用性和响应速度。

Spring Cloud提供了多种负载平衡的方式，如Ribbon、Feign等。其中，Ribbon是一个客户端负载平衡器，它可以根据服务提供者的负载情况，将请求分配到不同的服务器上。Feign是一个声明式的HTTP客户端，它可以将HTTP请求映射到服务接口上，并自动进行负载平衡。

`什么是Hystrix？它如何实现容错？`
Hystrix是一个开源的容错库，它可以帮助开发人员实现服务的容错和降级。在微服务架构中，服务之间的依赖关系非常复杂，如果某个服务出现故障，可能会导致整个系统的崩溃。Hystrix通过实现服务的断路器和限流等功能，可以防止服务故障的传播，提高系统的稳定性和可靠性。

Hystrix的主要功能包括：
1. 断路器：Hystrix可以监控服务的健康状态，如果服务出现故障，它会自动打开断路器，阻止请求继续发送到故障服务，从而保护系统的稳定运行。


## Redis

Redis是一个高性能的键值存储数据库，它支持多种数据类型，如字符串、哈希、列表、集合、有序集合等。Redis的性能非常高，读写速度可以达到10万次/秒，非常适合用于缓存、会话管理等场景。

Redis的安装和配置非常简单，只需要下载Redis的源代码，编译并安装即可。在配置文件中，可以设置Redis的监听地址、端口号、密码等参数。

`redis的常用命令包括：`
1. SET：设置键值对。
2. GET：获取键对应的值。
3. DEL：删除键值对。
4. EXPIRE：设置键的过期时间。
5. HSET：设置哈希表中的字段值。
6. HGET：获取哈希表中的字段值。
7. LPUSH：将元素插入列表的头部。
8. LPOP：从列表的头部移除元素。
9. SADD：将元素添加到集合中。
10. SPOP：从集合中移除元素。

`redis的常用数据类型包括：`
1. 字符串：用于存储简单的键值对。
2. 哈希表：用于存储字段和值对。
3. 列表：用于存储有序的元素列表。
4. 集合：用于存储无序的元素集合。
5. 有序集合：用于存储有序的元素集合，每个元素都有一个分数，用于排序。

`redis的常用应用场景包括：`
1. 缓存：将频繁访问的数据存储在Redis中，以提高系统的性能。
2. 会话管理：将用户的会话信息存储在Redis中，以实现分布式会话管理。
3. 消息队列：使用Redis的列表数据类型实现消息队列，以实现异步处理。
4. 分布式锁：使用Redis的SETNX命令实现分布式锁，以实现并发控制。
5. 排行榜：使用Redis的有序集合数据类型实现排行榜，以实现实时排名。

`redis的常用配置参数包括：`
1. 监听地址：指定Redis监听的IP地址。
2. 端口号：指定Redis监听的端口号。
3. 密码：指定访问Redis的密码。
4. 最大连接数：指定Redis的最大连接数。
5. 最大内存：指定Redis的最大内存。
6. 数据持久化：指定Redis的数据持久化方式，如RDB或AOF。
7. 主从复制：指定Redis的主从复制配置，以实现数据同步。

`redis的常用监控指标包括`：
1. 连接数：监控Redis的连接数，以判断系统的负载情况。
2. 内存使用量：监控Redis的内存使用量，以判断系统的内存使用情况。
3. 命令执行时间：监控Redis命令的执行时间，以判断系统的性能情况。
4. 错误数：监控Redis的错误数，以判断系统的稳定性情况。
5. 持久化状态：监控Redis的数据持久化状态，以判断系统的数据安全性情况。

`redis的常用优化方法包括：`
1. 使用连接池：使用连接池可以减少Redis的连接开销，提高系统的性能。
2. 使用Pipeline：使用Pipeline可以减少网络传输的开销，提高系统的性能。
3. 使用压缩：使用压缩可以减少Redis的数据存储量，提高系统的性能。
4. 使用分布式：使用分布式可以将Redis的数据分散到多个节点上，提高系统的性能和可靠性。
5. 使用缓存预热：使用缓存预热可以提前加载常用的数据到缓存中，提高系统的性能。

`redis的常用故障排查方法包括：`
1. 查看Redis的日志文件：Redis的日志文件中记录了Redis的运行状态和错误信息，可以用来排查问题。
2. 使用Redis的INFO命令：Redis的INFO命令可以提供Redis的运行状态和性能指标，可以用来排查问题。
3. 使用Redis的MONITOR命令：Redis的MONITOR命令可以实时监控Redis的命令执行情况，可以用来排查问题。
4. 使用Redis的DEBUG命令：Redis的DEBUG命令可以提供Redis的调试信息，可以用来排查问题。

### `redis持久化方法`
1. RDB持久化：RDB持久化是将Redis的数据以二进制的形式保存到磁盘上，可以在Redis重启时恢复数据。
2. AOF持久化：AOF持久化是将Redis的命令以文本的形式保存到磁盘上，可以在Redis重启时恢复数据。
3. 混合持久化：混合持久化是将RDB持久化和AOF持久化结合使用，可以在Redis重启时恢复数据。

`redis的常用数据类型包括：`
1. 字符串：字符串是最基本的数据类型，可以用来存储文本、数字、二进制数据等。
2. 列表：列表是一种有序的数据类型，可以用来存储多个元素。
3. 集合：集合是一种无序的数据类型，可以用来存储多个不重复的元素。
4. 哈希：哈希是一种键值对的数据类型，可以用来存储多个键值对。
5. 有序集合：有序集合是一种有序的数据类型，可以用来存储多个元素，并按照元素的分数进行排序。

## 抽象类和接口有啥区别

`抽象类和接口的区别主要有以下几点：`
1. 抽象类可以包含抽象方法和非抽象方法(即方法体的方法，jdk8以前，)，而接口只能包含抽象方法。
2. 抽象类可以包含成员变量，而接口不能包含成员变量。
3. 抽象类可以继承其他类，而接口可以继承其他接口。
4. 抽象类可以包含构造方法，而接口不能包含构造方法。
5. 抽象类可以包含静态方法，而接口不能包含静态方法。
6. 抽象类可以包含私有方法，而接口不能包含私有方法。

7.接口的成员变量隐士为static final，但抽象类不是的。

8.一个类可以实现多个接口，但只能继承一个抽象类。

## java的集合框架
`java的集合框架主要包括以下几种：`
1. List：List是一个有序的集合，可以存储重复的元素，常用的实现类有ArrayList、LinkedList等。
2. Set：Set是一个无序的集合，不能存储重复的元素，常用的实现类有HashSet、TreeSet等。
3. Map：Map是一个键值对的集合，键和值都可以是任意类型，常用的实现类有HashMap、TreeMap等。
4. Queue：Queue是一个队列，可以存储多个元素，常用的实现类有LinkedList、PriorityQueue等。
5. Deque：Deque是一个双端队列，可以存储多个元素，常用的实现类有LinkedList、ArrayDeque等。


## JDK 各版本新特性

`JDK 各版本新特性主要包括以下几方面：`
1. JDK 5：引入了泛型、枚举、自动装箱/拆箱、for-each循环、静态导入、可变参数、注解等新特性。
2. JDK 6：引入了动态语言支持、编译器API、JDBC 4.0、Java Compiler API、JVM监控和故障排除工具等新特性。
3. JDK 7：引入了NIO.2、字符串连接池、钻石操作符、try-with-resources、多注解、增强的泛型推断等新特性。
4. JDK 8：引入了Lambda表达式、函数式接口、方法引用、默认方法、Stream API、Optional类、新的日期和时间API等新特性。
5. JDK 9：引入了模块化系统、JShell、集合工厂方法、接口私有方法、增强的try-with-resources等新特性。
6. JDK 10：引入了局部变量类型推断、垃圾收集器接口、新的垃圾收集器G1、增强的G1垃圾收集器等新特性。
7. JDK 11：引入了新的垃圾收集器ZGC、Epsilon垃圾收集器、新的字符串方法、增强的NullPointerException等新特性。
8. JDK 12：引入了Switch表达式、增强的NullPointerException、新的垃圾收集器Shenandoah等新特性。
9. JDK 13：引入了文本块、增强的NullPointerException、新的垃圾收集器ZGC等新特性。


## 实现线程和线程池的方法及其要传的参数？

https://blog.csdn.net/PassionAnytime/article/details/126143524

实现多线程的四种方式：
继承 Thread 类
实现 Runnable 接口
实现 Callable 接口
线程池


## Java通过java.util.concurrent包提供了多种线程池的实现，其中最为常用的是ExecutorService接口及其实现类。



2.1 Executors工厂类
Executors工厂类提供了多种创建线程池的静态方法，如：

newFixedThreadPool(int nThreads)：创建一个固定大小的线程池。
newCachedThreadPool()：创建一个可缓存的线程池，如果线程池大小超过了处理任务所需要的线程，就会回收部分空闲线程。
newSingleThreadExecutor()：创建一个单线程的线程池，该线程池中的线程以顺序方式执行所有任务。
newScheduledThreadPool(int corePoolSize)：创建一个支持定时及周期性执行任务的线程池。

Executors.newWorkStealingPool()
创建一个拥有多个任务队列的线程池，可以减少连接数，创建当前可用cpu数量的线程来并行执行，适用于大耗时的操作，可以并行来执行
线程池核心的参数：
一、corePoolSize 线程池核心线程大小
二、maximumPoolSize 线程池最大线程数量
三、keepAliveTime 空闲线程存活时间
四、unit 空闲线程存活时间单位
五、workQueue 工作队列
六、threadFactory 线程工厂
七、handler 拒绝策略

2.2 线程池的配置
在创建线程池时，需要合理配置核心线程数、最大线程数、任务队列容量、线程存活时间等参数，以满足应用的需求。
三、线程池的使用
3.1 提交任务
通过ExecutorService的submit方法提交任务，该方法会返回一个Future对象，用于获取任务执行的结果。

3.2 关闭线程池
任务执行完毕后，应关闭线程池以释放资源。可以通过调用shutdown或shutdownNow方法来关闭线程池。

shutdown：平滑关闭线程池，不再接受新任务，但会等待已提交的任务执行完毕。
shutdownNow：尝试立即关闭线程池，不再接受新任务，并尝试停止正在执行的任务。

相比于继承 Thread 类的方法来说，实现 Runnable 接口是一个更好地选择，因为 Java 不支持多继承，但是可以实现多个接口。
从源码我们可以看到 Callable 接口和 Runnable 接口类似，它们之间的区别在于 run() 方法没有返回值，而 call() 方法是有返回值的。

## 中间件，幂相等？
1、什么是消息的幂等性
幂等：在编程中一个幂等操作的特点是其任意多次执行所产生的影响均与一次执行的影响相同。这是百度百科给出的幂等的概念。
消息的幂等性：就是即使多次收到了消息，也不会重复消费。所以保证消息的幂等性就是保证消息不会重复消费，这在开发中是很重要的。比如客户点击付款，如果点击了多次，那也只能扣一次费。
2.1 MQ出现非幂等性的情况
2.1.1 生成者重复发送消息给MQ
生成者把消息发送给MQ之后，MQ收到消息在给生产者返回ack的时候，网络中断了。这时MQ明明已经接收到了消息，但是生产者没接收到确定消息，就会认为MQ没有接收到消息。因此，在网络重新连接后，生产者会把已经发送的消息再次发送到MQ，如果MQ没有去重措施的话，那么就接收到了重复的消息。
2.1.2 MQ重复发送消息给消费者
消费者从MQ中拉取消息进行消费，当消费者已经消费了消息但还没向MQ返回ack的时候，消费者宕机或者网络断开了。所以消费者成功消费了消息的情况，MQ并不知道。当消费者重启或网络重连后，消费者再次去请求MQ拉取消息的时候，MQ会把已经消费的消息再次发送给消费者，如果消费者没有去重就直接消费，那么就会造成重复消费的情况。便会造成数据的不一致。

2.2 保证消息幂等性的办法
2.2.1 生成者不重复发送消息到MQ
mq内部可以为每条消息生成一个全局唯一、与业务无关的消息id，当mq接收到消息时，会先根据该id判断消息是否重复发送，mq再决定是否接收该消息。

2.2.2 消费者不重复消费
消费者怎么保证不重复消费的关键在于消费者端做控制，因为MQ不能保证不重复发送消息，所以应该在消费者端控制：即使MQ重复发送了消息，消费者拿到了消息之后，要判断是否已经消费过，如果已经消费，直接丢弃。所以根据实际业务情况，有下面几种方式：
1、如果从MQ拿到数据是要存到数据库，那么可以根据数据创建唯一约束，这样的话，同样的数据从MQ发送过来之后，当插入数据库的时候，会报违反唯一约束，不会插入成功的。（或者可以先查一次，是否在数据库中已经保存了，如果能查到，那就直接丢弃就好了）。
2、让生产者发送消息时，每条消息加一个全局的唯一id，然后消费时，将该id保存到redis里面。消费时先去redis里面查一下有么有，没有再消费。（其实原理跟第一点差不多）。
3、如果拿到的数据是直接放到redis的set中的话，那就不用考虑了，因为set集合就是自动有去重的。


## 编程基础四大件 和 应用实践编程

服务端开发、嵌入式开发

基础四大件：数据结构和算法、计算机网络、操作系统、设计模式
应用实践编程：Linux操作系统（shell编程）、编译和调试、Linux系统API、多线程编程、网络编程等等

C语言和C++的学习路线了，内容大致包括：岗位分析、语言学习、数据结构和算法、计算机网络（TCP/IP协议栈->ARP协议、IP协议、ICMP协议、TCP/UDP协议、DNS协议、HTTP/HTTPS协议）、操作系统（进程/线程->并发/多线程、原子性、锁、内存/内存调度算法）、设计模式（23，常见的单例、工厂、代理、策略、模板方法）、Linux操作系统（shell编程）、编译和调试（gcc、gdb、makefile），Linux系统API，多线程编程，网络编程等等

## 什么是可监控、可灰度、可回滚？

可监控：监控系统的运行状态，比如CPU、内存、磁盘、网络等，以及业务运行状态，比如接口调用次数、成功率、耗时等。

可灰度：在系统上线之前，先让一部分用户使用新功能，如果出现问题，可以快速回滚，不影响其他用户。

可回滚：在系统上线之后，如果出现问题，可以快速回滚，恢复到之前的状态。

## HBase（Hadoop Database）是一个开源的、分布式的、可扩展的、非关系型数据库

HBase（Hadoop Database）是一个开源的、分布式的、可扩展的、非关系型数据库，它基于Google的BigTable论文设计，运行在Hadoop集群之上。HBase主要用于存储和管理大量的稀疏数据集，适用于需要实时读写访问的场景。

HBase的主要特点
分布式存储：

HBase将数据分布在多个服务器上，通过水平扩展来处理大规模数据集。
高可靠性：

HBase使用Hadoop的HDFS（Hadoop Distributed File System）作为底层存储，HDFS提供了数据冗余和容错机制，确保数据的高可靠性。
强一致性：

HBase支持强一致性读写，确保在分布式环境下数据的一致性。
稀疏数据集：

HBase特别适合存储稀疏数据集，即大部分数据为空或缺失的情况。
实时读写：

HBase提供了快速的随机读写能力，适用于需要实时访问数据的场景。
列族存储：

HBase采用列族（Column Family）的方式组织数据，每个列族包含一组相关的列。这种存储方式使得数据更加灵活和高效。
HBase的架构
HBase的架构主要包括以下几个组件：

HMaster：

负责管理HBase集群中的元数据信息，如表的创建、删除和修改等操作。
监控RegionServer的状态，负责负载均衡和故障恢复。
RegionServer：

负责实际的数据存储和读写操作。
每个RegionServer管理多个Region，每个Region包含表的一部分数据。
ZooKeeper：

用于协调HBase集群中的各个组件，提供分布式锁服务。
维护HBase集群的元数据信息和状态。
HDFS：

作为HBase的底层存储系统，提供高可靠性和高可扩展性的数据存储。
HBase的数据模型
HBase的数据模型类似于Google的BigTable，主要包括以下几个概念：

表（Table）：

HBase中的数据存储在表中，每个表由多个行组成。
行（Row）：

每行由一个唯一的行键（Row Key）标识，行键是字节数组，用于快速检索数据。
列族（Column Family）：

列族是列的集合，每个列族在物理上存储在一起，列族在表创建时定义。
列（Column）：

列由列族和列限定符（Column Qualifier）组成，列限定符用于标识列族中的具体列。
单元格（Cell）：

单元格是行、列族和列限定符的组合，包含一个具体的数据值和时间戳。

```sql
CREATE TABLE 'my_table' (
  'cf1' (
    'col1',
    'col2'
  ),
  'cf2' (
    'col3',
    'col4'
  )
)

```

在这个示例中，我们创建了一个名为my_table的表，包含两个列族cf1和cf2，每个列族包含两个列。

HBase是一个强大的分布式数据库，适用于需要处理大规模数据和高并发读写的场景。它在许多大型互联网公司和组织中得到了广泛应用。

## DDD（Domain-Driven Design，领域驱动设计）

在传统的软件开发方法中，开发人员往往关注的是技术实现而非业务领域本身。而在DDD的方法论中，开发人员需要与业务专家紧密合作，`深入了解业务领域，将业务领域的知识和业务逻辑转化为软件设计和开发中的概念和实现`。

DDD（Domain-Driven Design，领域驱动设计）是一种软件开发方法论，强调将软件系统的开发重点放在核心领域（Domain）和领域逻辑上。DDD的目标是通过对领域的深入理解和建模，构建出更符合业务需求的高质量软件系统。

DDD的核心概念
领域（Domain）：

领域是软件系统所要解决的业务问题空间。它包含了业务规则、流程、概念和实体等。
领域模型（Domain Model）：

领域模型是对领域中的概念、规则和关系的抽象表示。它帮助开发者理解和表达业务逻辑。
实体（Entity）：

实体是具有唯一标识的对象，其生命周期内标识保持不变。实体通常具有状态和行为。
值对象（Value Object）：

值对象是没有唯一标识的对象，仅通过其属性值来区分。值对象通常是不可变的。
聚合（Aggregate）：

聚合是一组相关对象的集合，作为一个整体进行操作和维护一致性。聚合根（Aggregate Root）是聚合的入口点。
领域服务（Domain Service）：

领域服务用于封装不属于任何实体或值对象的领域逻辑。领域服务通常是无状态的。
仓储（Repository）：

仓储用于封装数据访问逻辑，提供对聚合的持久化和查询操作。
工厂（Factory）：

工厂用于封装对象的创建逻辑，提供复杂的对象创建过程。
界限上下文（Bounded Context）：

界限上下文是领域模型的逻辑边界，每个界限上下文包含一组特定的领域模型和业务逻辑。
DDD的优点
业务一致性：

DDD强调对业务领域的深入理解，确保软件系统与业务需求高度一致。
可维护性：

通过清晰的领域模型和界限上下文，DDD使得软件系统更易于维护和扩展。
可测试性：

DDD鼓励细粒度的模块化和清晰的职责划分，使得单元测试和集成测试更加容易。
团队协作：

DDD促进了业务专家和开发团队之间的紧密合作，通过共同的语言和模型，提高沟通效率。

DDD项目示例

```text
my-ddd-project
├── src
│   ├── main
│   │   ├── java
│   │   │   ├── com
│   │   │   │   ├── mycompany
│   │   │   │   │   ├── domain
│   │   │   │   │   │   ├── model
│   │   │   │   │   │   │   ├── Entity.java
│   │   │   │   │   │   │   ├── ValueObject.java
│   │   │   │   │   │   ├── service
│   │   │   │   │   │   │   ├── DomainService.java
│   │   │   │   │   │   ├── repository
│   │   │   │   │   │   │   ├── Repository.java
│   │   │   │   │   ├── application
│   │   │   │   │   │   ├── service
│   │   │   │   │   │   │   ├── ApplicationService.java
│   │   │   │   │   ├── infrastructure
│   │   │   │   │   │   ├── persistence
│   │   │   │   │   │   │   ├── HibernateRepository.java
│   │   │   │   │   │   ├── messaging
│   │   │   │   │   │   │   ├── KafkaPublisher.java
│   │   │   │   │   ├── interfaces
│   │   │   │   │   │   ├── rest
│   │   │   │   │   │   │   ├── Controller.java
│   │   ├── resources
│   │   │   ├── application.properties
│   ├── test
│   │   ├── java
│   │   │   ├── com
│   │   │   │   ├── mycompany
│   │   │   │   │   ├── domain
│   │   │   │   │   │   ├── model
│   │   │   │   │   │   │   ├── EntityTest.java
│   │   │   │   │   │   ├── service
│   │   │   │   │   │   │   ├── DomainServiceTest.java
│   │   │   │   │   ├── application
│   │   │   │   │   │   ├── service
│   │   │   │   │   │   │   ├── ApplicationServiceTest.java
│   │   ├── resources
│   │   │   ├── application-test.properties

```

在这个示例中，项目结构遵循DDD的原则，将领域模型、领域服务、应用服务、基础设施和接口层分开，确保各层的职责清晰，便于维护和扩展。

```text
ddd-domin
├── pom.xml
└── src
    └── main
        └── java
            └── org
                └── example
                    ├── App.java
                    ├── adapter
                    │   ├── market
                    │   └── product
                    │       ├── kafka
                    │       │   └── ProductConsumer.java
                    │       ├── socket
                    │       │   └── ProductSocket.java
                    │       └── web
                    │           └── ProductController.java
                    ├── application
                    │   ├── event
                    │   │   ├── EventManager.java
                    │   │   └── IEvent.java
                    │   ├── market
                    │   └── product
                    │       ├── ProductFactory.java
                    │       ├── ProductService.java
                    │       ├── command
                    │       │   ├── AddCountProductCommand.java
                    │       │   └── CreateProductCommand.java
                    │       ├── dto
                    │       │   └── ProductDTO.java
                    │       ├── event
                    │       │   ├── AbstractProductEvent.java
                    │       │   ├── AddNumProjectEvent.java
                    │       │   └── CreateProjectEvent.java
                    │       └── mapstruct
                    │           └── ProductStruct.java
                    ├── common
                    │   └── exception
                    │       └── BusException.java
                    ├── domain
                    │   ├── market
                    │   ├── product
                    │   │   └── Product.java
                    │   └── repository
                    │       ├── IProductRepository.java
                    │       └── entity
                    │           └── ProductEntity.java
                    └── infrastructure
                        ├── cache
                        ├── repository
                        │   └── impl
                        │       └── ProductRepositoryImpl.java
                        └── sqlmapper
```

https://www.jianshu.com/p/9d7d6121f5cf   DDD项目实践

## springboot 事物隔离代码

```java
@Transactional(rollbackFor = Exception.class, propagation = Propagation.REQUIRED, isolation = Isolation.READ_COMMITTED)
```

在Spring Boot中，可以通过使用@Transactional注解来管理事务，并且可以指定事务的隔离级别。以下是一个示例代码，展示了如何在Spring Boot中使用事务隔离级别：

首先，确保你的Spring Boot项目中包含了Spring事务管理的依赖。如果你使用的是Maven，可以在pom.xml中添加以下依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>

```

然后，在你的服务类中使用@Transactional注解来指定事务的隔离级别。Spring支持以下几种隔离级别：

ISOLATION_DEFAULT：使用底层数据库的默认隔离级别。
ISOLATION_READ_UNCOMMITTED：允许读取未提交的数据（可能导致脏读、不可重复读和幻读）。
ISOLATION_READ_COMMITTED：允许读取已提交的数据（防止脏读，但可能导致不可重复读和幻读）。
ISOLATION_REPEATABLE_READ：保证在同一个事务中多次读取同一数据的结果是一致的（防止脏读和不可重复读，但可能导致幻读）。
ISOLATION_SERIALIZABLE：最高的隔离级别，完全服从ACID的隔离级别，确保事务串行执行（防止脏读、不可重复读和幻读）。

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

@Service
public class MyService {

    @Autowired
    private MyRepository myRepository;

    @Transactional(isolation = Isolation.READ_COMMITTED)
    public void performTransaction() {
        // 在这里执行你的数据库操作
        myRepository.save(new MyEntity());
    }
}

```

在这个示例中，performTransaction方法将在READ_COMMITTED隔离级别下执行事务。你可以根据需要更改isolation属性的值来指定不同的事务隔离级别。

请注意，事务隔离级别的选择应根据具体的业务需求和数据库的性能考虑。较高的隔离级别可以提供更强的一致性保证，但可能会影响性能。

## springboot 事物隔离级别

- 脏读：一个事务读取了另一个事务未提交的数据
- 不可重复读：一个事务读取了另一个事务已经提交的update数据
- 幻读：一个事务读取了另一个事务已经提交的insert数据
- 串行化：所有事务串行执行，隔离级别最高，事务不能并发执行

## springboot 事物传播级别

- PROPAGATION_REQUIRED：支持当前事务，如果当前没有事务，就新建一个事务
- PROPAGATION_SUPPORTS：支持当前事务，如果当前没有事务，就以非事务方式执行
- PROPAGATION_MANDATORY：支持当前事务，如果当前没有事务，就抛出异常
- PROPAGATION_REQUIRES_NEW：新建事务，如果当前存在事务，把当前事务挂起
- PROPAGATION_NOT_SUPPORTED：以非事务方式执行操作，如果当前存在事务，就把当前事务挂起
- PROPAGATION_NEVER：以非事务方式执行，如果当前存在事务，则抛出异常
- PROPAGATION_NESTED：如果当前存在事务，则在嵌套事务内执行。如果当前没有事务，则执行与PROPAGATION_REQUIRED类似的操作


## BS CS 架构

- BS架构：Browser/Server架构，客户端是浏览器，服务器是Web服务器，通过HTTP协议进行通信
- CS架构：Client/Server架构，客户端是桌面应用程序，服务器是服务器应用程序，通过TCP/IP协议进行通信

TCP/IP协议和HTTP/HTTPS协议的区别

- TCP/IP协议：传输控制协议/互联网协议，是一种面向连接的、可靠的、基于字节流的传输层通信协议，用于在网络上进行数据传输
- HTTP/HTTPS协议：超文本传输协议/安全超文本传输协议，是一种应用层协议，用于在网络上传输超文本信息，`HTTP协议使用TCP/IP协议进行传输`，HTTPS协议在HTTP协议的基础上加入了SSL/TLS加密，提供了数据传输的安全性

在BS（Browser/Server）架构和CS（Client/Server）架构中，处理输入的方式有所不同。BS架构通常通过HTTP请求和响应来处理输入，而CS架构则可能直接通过Socket或类似的机制进行通信。

以下是如何在BS架构中处理输入的示例代码，使用Spring Boot来接收HTTP请求并处理输入：

`BS架构示例（Spring Boot）`
首先，确保你的Spring Boot项目中包含了Spring Web依赖。如果你使用的是Maven，可以在pom.xml中添加以下依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>

```

然后，创建一个控制器来处理HTTP请求：
```java
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class InputController {

    @GetMapping("/process")
    public String processInput(@RequestParam int num) {
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i <= num; i++) {
            int start = (i - 1) * i / 2 + 1;
            int step = i + 1;
            for (int j = 1; j <= num - i + 1; j++) {
                sb.append(start).append(" ");
                start += step;
            }
            sb.append("\n");
        }
        return sb.toString();
    }
}

```

在这个示例中，processInput方法接收一个名为num的请求参数，并根据该参数生成相应的输出。

`CS架构示例`
在CS架构中，可以使用Socket来进行客户端和服务器之间的通信。以下是一个简单的CS架构示例，使用Java的Socket API：

服务器端代码
```java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;

public class Server {
    public static void main(String[] args) throws IOException {
        ServerSocket serverSocket = new ServerSocket(12345);
        while (true) {
            Socket clientSocket = serverSocket.accept();
            BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
            PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);

            String str;
            while ((str = in.readLine()) != null) {
                int num = Integer.parseInt(str);
                StringBuilder sb = new StringBuilder();
                for (int i = 1; i <= num; i++) {
                    int start = (i - 1) * i / 2 + 1;
                    int step = i + 1;
                    for (int j = 1; j <= num - i + 1; j++) {
                        sb.append(start).append(" ");
                        start += step;
                    }
                    sb.append("\n");
                }
                out.println(sb.toString());
            }
        }
    }
}

```

客户端代码:
```java
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class Client {
    public static void main(String[] args) throws IOException {
        Socket socket = new Socket("localhost", 12345);
        BufferedReader in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        PrintWriter out = new PrintWriter(socket.getOutputStream(), true);

        BufferedReader stdIn = new BufferedReader(new InputStreamReader(System.in));
        String userInput;
        while ((userInput = stdIn.readLine()) != null) {
            out.println(userInput);
            System.out.println("Server response: " + in.readLine());
        }
    }
}
在这个CS架构示例中，服务器端监听一个端口，客户端连接到该端口并发送输入，服务器处理输入并返回结果。
```

`BS CS 架构的结合`
在实际应用中，BS 和 CS 架构可以结合使用，以充分发挥各自的优势。例如，可以使用 BS 架构提供基本的 Web 服务，同时使用 CS 架构提供高性能和复杂功能。

示例：

使用 BS 架构提供基本的用户界面和数据展示。
使用 CS 架构提供高性能的数据处理和复杂的业务逻辑。
通过这种结合，可以实现既具有跨平台性和易维护性，又具有高性能和丰富功能的应用系统。

## jdk 各个版本特性

JDK（Java Development Kit）是Java开发工具包，每个版本都会引入新的特性和改进。以下是JDK各个主要版本的特性概述：

JDK 1.0
初始版本，包含了Java的基本功能。

JDK 1.1
内部类（Inner Classes）
JavaBeans
JDBC（Java Database Connectivity）
RMI（Remote Method Invocation）
反射（Reflection）

JDK 1.2（Java 2）
Swing图形API
Java插件（Java Plug-in）
Java IDL（Interface Definition Language）
Collections框架

JDK 1.3
Java Sound API
HotSpot虚拟机

JDK 1.4
正则表达式（Regular Expressions）
NIO（Non-blocking I/O）
日志API（Logging API）
XML解析器（XML Parser）
断言（Assertions）

JDK 5（Java 5）
泛型（Generics）
枚举（Enums）
自动装箱/拆箱（Autoboxing/Unboxing）
注解（Annotations）
可变参数（Varargs）
增强的for循环（Enhanced for Loop）

JDK 6
脚本引擎（Scripting Engine）
JDBC 4.0
改进的锁机制（Improved Locking Mechanisms）

JDK 7
钻石操作符（Diamond Operator）
多重捕获异常（Multi-catch）
try-with-resources
switch语句支持字符串
NIO 2.0

`JDK 8
Lambda表达式
函数式接口（Functional Interfaces）
默认方法（Default Methods）
新的日期/时间API（Date and Time API）
Stream API
Optional类`

JDK 9
模块系统（Project Jigsaw）
JShell（交互式编程工具）
改进的HTTP客户端
私有接口方法

JDK 10
局部变量类型推断（Local-Variable Type Inference）

JDK 11
标准化的HTTP客户端
运行单文件源代码程序（Launch Single-File Source-Code Programs）
新的字符串方法

JDK 12
Switch表达式预览
微基准测试套件

JDK 13
Switch表达式正式引入
文本块（Text Blocks）预览

JDK 14
instanceof模式匹配预览
Records预览
改进的NullPointerException消息

JDK 15
密封类（Sealed Classes）预览
文本块正式引入
隐藏类（Hidden Classes）

JDK 16
记录类（Records）正式引入
instanceof模式匹配正式引入
向量API预览

JDK 17
密封类正式引入
强封装JDK内部API
新的macOS渲染管道
每个版本的JDK都在不断改进和增强Java语言的功能和性能，以适应不断变化的开发需求和技术趋势。

## AOP 面向切面编程

AOP（Aspect-Oriented Programming，面向切面编程）是一种编程范式，旨在通过将横切关注点（cross-cutting concerns）从业务逻辑中分离出来，来提高模块化程度和代码的可维护性。AOP的核心思想是将那些与业务逻辑无关的代码（`如日志记录、事务管理、安全检查等`）`从业务逻辑中分离出来`，以减少代码的重复和复杂性。

实现方式
AOP可以通过以下几种方式实现：

1. **静态代理**：在编译时将横切关注点代码织入到目标类中。这种方式需要手动编写代理类，且代理类与目标类一一对应，难以维护。
2. **动态代理**：在运行时动态创建代理类，通过反射机制调用目标类的方法。这种方式不需要手动编写代理类，但性能相对较低。
3. **字节码增强**：通过修改字节码，在运行时动态织入横切关注点代码。这种方式性能较高，但实现复杂。
4. **AspectJ**：一种基于Java的AOP框架，通过在编译时或运行时修改字节码，将横切关注点代码织入到目标类中。AspectJ提供了丰富的AOP功能，但需要额外的编译器和运行时支持。
5. **Spring AOP**：Spring框架提供的AOP实现，通过动态代理或CGLIB字节码增强技术，将横切关注点代码织入到目标类中。Spring AOP支持方法级别的AOP，且与Spring框架无缝集成。
6. **AspectJ Weaver**：AspectJ提供的字节码增强工具，可以在编译时或运行时将横切关注点代码织入到目标类中。AspectJ Weaver支持类级别的AOP，且与AspectJ框架无缝集成。

使用场景
AOP适用于以下场景：
1. **日志记录**：在方法执行前后记录日志信息，以便于调试和监控。
2. **事务管理**：在方法执行前后开启和提交事务，确保数据的一致性。
3. **安全检查**：在方法执行前进行权限检查，确保只有授权用户才能执行该方法。
4. **性能监控**：在方法执行前后记录时间，以便于性能分析和优化。
5. **缓存**：在方法执行前检查缓存，如果缓存中存在结果则直接返回，否则执行方法并将结果缓存起来。
6. **异常处理**：在方法执行过程中捕获异常，并进行相应的处理。


IOP（面向方面编程，Aspect-Oriented Programming）是一种编程范式，旨在通过允许开发者将横切关注点（cross-cutting concerns）模块化，从而提高代码的模块性和可维护性。横切关注点是指那些影响多个模块或类的功能，如日志记录、事务管理、安全性检查等。

主要概念
切面（Aspect）：切面是横切关注点的模块化实现。它包含了一组通知（advice）和切入点（pointcut），用于定义在何时何地应用这些通知。
通知（Advice）：通知定义了切面在特定连接点（join point）上执行的动作。常见的通知类型包括：
前置通知（Before Advice）：在连接点之前执行。
后置通知（After Advice）：在连接点之后执行，无论是否发生异常。
返回通知（After-returning Advice）：在连接点正常完成后执行。
异常通知（After-throwing Advice）：在连接点抛出异常后执行。
环绕通知（Around Advice）：在连接点前后执行，可以控制是否继续执行连接点。
切入点（Pointcut）：切入点定义了哪些连接点会被切面捕获。它通常使用表达式来匹配特定的方法或代码位置。
连接点（Join Point）：连接点是程序执行过程中的一个特定点，如方法调用、异常抛出等。
引入（Introduction）：引入允许向现有类添加新的方法或字段，从而扩展类的功能。
实现方式
IOP可以通过多种方式实现，常见的有：

AspectJ：一个功能强大的AOP框架，支持编译时、编译后和加载时织入（weaving）。
Spring AOP：Spring框架提供的AOP支持，基于代理模式实现，主要用于Spring应用中。

示例
以下是一个使用Spring AOP的简单示例：
```java
// 定义一个切面
@Aspect
public class LoggingAspect {

    // 定义一个切入点，匹配所有service包下的方法
    @Pointcut("execution(* com.example.service.*.*(..))")
    public void serviceMethods() {}

    // 前置通知，在切入点之前执行
    @Before("serviceMethods()")
    public void logBefore(JoinPoint joinPoint) {
        System.out.println("Before method: " + joinPoint.getSignature().getName());
    }

    // 后置通知，在切入点之后执行
    @After("serviceMethods()")
    public void logAfter(JoinPoint joinPoint) {
        System.out.println("After method: " + joinPoint.getSignature().getName());
    }
}

// 配置Spring应用上下文
@Configuration
@EnableAspectJAutoProxy
public class AppConfig {

    @Bean
    public LoggingAspect loggingAspect() {
        return new LoggingAspect();
    }
}

```

在这个示例中，LoggingAspect 是一个切面，定义了在 service 包下的所有方法执行前后进行日志记录的通知。通过Spring AOP，这些通知会在匹配的方法执行时自动应用。

优点
模块化：将横切关注点与核心业务逻辑分离，提高代码的模块性和可维护性。
重用性：切面可以跨多个模块重用，减少重复代码。
灵活性：通过配置切入点和通知，可以灵活地控制横切关注点的应用范围和行为。
缺点
复杂性：引入AOP会增加系统的复杂性，特别是在理解和调试方面。
性能开销：AOP的实现可能会引入一定的性能开销，特别是在使用动态代理和反射的情况下。
总的来说，IOP是一种强大的编程范式，适用于需要处理横切关注点的场景，但在使用时需要权衡其带来的复杂性和性能开销。

## IOC（Inversion of Control，控制反转）是一种设计原则

IOC（Inversion of Control，控制反转）是一种设计原则，它将`对象的创建和依赖管理从应用程序代码中转移到外部容器（如Spring容器）。IOC的核心思想是将对象的控制权从应用程序代码中转移给外部容器`，从而实现对象之间的解耦。

在传统的编程模式中，对象的创建和依赖管理是由应用程序代码直接控制的。例如，在创建一个对象时，需要手动创建其依赖的对象，并将它们传递给该对象。这种方式会导致代码的耦合度增加，难以进行单元测试和重构。

而IOC通过将对象的创建和依赖管理交给外部容器，实现了对象之间的解耦。在IOC模式下，应用程序代码只需要声明需要哪些依赖，而不需要关心这些依赖的创建和配置。外部容器会根据应用程序代码的声明，自动创建和配置这些依赖，并将它们注入到应用程序代码中。

在Spring框架中，IOC的实现是通过依赖注入（Dependency Injection，DI）来实现的。依赖注入是一种将依赖对象注入到目标对象中的技术。Spring框架提供了多种依赖注入的方式，包括构造函数注入、Setter方法注入和字段注入。

优点
解耦：通过将对象的创建和依赖管理交给外部容器，实现了对象之间的解耦，降低了代码的耦合度。
可测试性：在IOC模式下，可以通过外部容器注入模拟对象，从而进行单元测试。
灵活性：通过配置文件或注解，可以灵活地控制对象的创建和依赖管理。
重用性：通过将依赖管理交给外部容器，可以重用已有的对象配置，提高代码的重用性。
缺点
学习曲线：IOC是一种新的编程范式，需要一定的学习和适应过程。
性能开销：在IOC模式下，对象的创建和依赖管理是由外部容器来完成的，可能会引入一定的性能开销。
配置复杂性：在IOC模式下，需要配置大量的对象和依赖关系，可能会增加配置的复杂性。
总的来说，IOC是一种强大的设计原则，通过将对象的创建和依赖管理交给外部容器，实现了对象之间的解耦，提高了代码的可测试性和灵活性。然而，它也有一些缺点，如学习曲线、性能开销和配置复杂性等。因此，在使用IOC时，需要权衡其带来的优点和缺点。

IOC（Inversion of Control，控制反转）是一种设计原则，用于减少代码之间的耦合度。它通过将对象的创建和管理交给外部容器（通常是框架或容器）来实现。IOC的核心思想是将控制权从应用程序代码转移到外部容器，从而实现更灵活和可维护的系统。

主要概念
依赖注入（Dependency Injection，DI）：依赖注入是IOC的一种实现方式，通过外部容器将对象的依赖关系注入到对象中，而不是由对象自己创建或查找依赖。
容器（Container）：容器是负责管理对象生命周期和依赖关系的组件。它负责创建对象、注入依赖、配置对象以及销毁对象。
Bean：在IOC容器中管理的对象称为Bean。Bean是由容器创建和管理的，通常通过配置文件或注解进行定义。
实现方式
IOC可以通过多种方式实现，常见的有：

Spring框架：Spring是最流行的Java IOC框架，提供了强大的依赖注入和面向切面编程（AOP）功能。
Guice：Google Guice是一个轻量级的Java依赖注入框架，主要使用注解进行配置。
CDI（Contexts and Dependency Injection）：CDI是Java EE标准的一部分，提供了一种标准的依赖注入机制。
示例
以下是一个使用Spring框架实现依赖注入的简单示例：
```java
// 定义一个接口
public interface MessageService {
    String getMessage();
}

// 实现接口
public class EmailService implements MessageService {
    public String getMessage() {
        return "Email message";
    }
}

// 定义一个需要依赖注入的类
public class MyApp {
    private MessageService messageService;

    // 构造器注入
    public MyApp(MessageService messageService) {
        this.messageService = messageService;
    }

    public void sendMessage() {
        System.out.println(messageService.getMessage());
    }
}

// 配置Spring应用上下文
@Configuration
public class AppConfig {

    @Bean
    public MessageService messageService() {
        return new EmailService();
    }

    @Bean
    public MyApp myApp() {
        return new MyApp(messageService());
    }
}

// 运行应用程序
public class Main {
    public static void main(String[] args) {
        ApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        MyApp myApp = context.getBean(MyApp.class);
        myApp.sendMessage();
    }
}

```

在这个示例中，`MyApp 类依赖于 MessageService 接口，但并不直接创建 MessageService 的实例。相反，它通过构造器注入的方式从Spring容器中获取 MessageService 的实例。AppConfig 类定义了Bean的配置，Spring容器根据这些配置创建和管理Bean`。

优点
解耦：通过将对象的创建和管理交给外部容器，减少了代码之间的直接依赖，提高了系统的灵活性和可维护性。
可测试性：依赖注入使得单元测试更加容易，可以通过Mock对象替换实际的依赖进行测试。
可配置性：通过配置文件或注解，可以灵活地改变对象的创建和依赖关系，而无需修改代码。
缺点
复杂性：引入IOC框架会增加系统的复杂性，特别是在理解和调试方面。
性能开销：IOC容器的初始化和Bean的管理可能会引入一定的性能开销。
总的来说，IOC是一种强大的设计原则，适用于需要减少耦合度和提高系统灵活性的场景，但在使用时需要权衡其带来的复杂性和性能开销。

## JDK 1.8 流的用法

Java 8 引入了流（Stream）的概念，它是一种用于处理集合数据的API。流提供了一种声明式的方式来处理数据，可以简化代码，提高可读性和可维护性。

下面是一些常见的流操作：

1. 创建流：可以使用集合的 `stream()` 方法创建流，也可以使用 `Stream.of()` 方法创建包含指定元素的流。

```java
List<String> list = Arrays.asList("a", "b", "c");
Stream<String> stream = list.stream();
Stream<String> stream2 = Stream.of("a", "b", "c");
```

2. 过滤：使用 `filter()` 方法可以过滤出满足条件的元素。

```java
Stream<String> filteredStream = stream.filter(s -> s.startsWith("a"));
```



3. 映射：使用 `map()` 方法可以将流中的元素映射为其他形式。

```java
Stream<String> mappedStream = stream.map(String::toUpperCase);
```



4. 聚合：使用 `collect()` 方法可以将流中的元素收集为集合或其他形式。

```java
List<String> collectedList = stream.collect(Collectors.toList());
```



5. 统计：使用 `count()` 方法可以统计流中元素的数量。

```java
long count = stream.count();
```



6. 其他操作：流还提供了许多其他操作，如 `sorted()`（排序）、`distinct()`（去重）、`limit()`（限制元素数量）等。

```java
Stream<String> sortedStream = stream.sorted();
Stream<String> distinctStream = stream.distinct();
Stream<String> limitedStream = stream.limit(2);
```

需要注意的是，流是一个中间操作，它不会立即执行，只有当遇到终端操作时才会执行。常见的终端操作有 `collect()`、`count()`、`forEach()` 等。

流还可以进行组合操作，例如先过滤再映射再收集：

```java
List<String> filteredAndMappedList = stream.filter(s -> s.startsWith("a"))
                                          .map(String::toUpperCase)
                                          .collect(Collectors.toList());
```

流还可以进行并行操作，使用 `parallelStream()` 方法可以创建一个并行流，并行流可以充分利用多核CPU的性能，提高处理速度。

```java
Stream<String> parallelStream = stream.parallel();
```

需要注意的是，并行流并不是万能的，它适用于计算密集型任务，对于IO密集型任务，使用并行流反而可能会降低性能。


JDK 1.8 引入了流（Stream）API，它提供了一种高效且易于使用的方式来处理集合数据。流API允许你以声明式的方式处理数据，使得代码更加简洁和易读。下面是一些常见的流操作及其用法：

1. 创建流
从集合创建流：
List<String> list = Arrays.asList("a", "b", "c");
Stream<String> stream = list.stream();

从数组创建流：
String[] array = {"a", "b", "c"};
Stream<String> stream = Arrays.stream(array);

使用Stream.of()创建流：
Stream<String> stream = Stream.of("a", "b", "c");

2. 中间操作
filter：过滤元素
stream.filter(s -> s.startsWith("a"));

map：转换元素
stream.map(String::toUpperCase);

sorted：排序元素
stream.sorted();

distinct：去重元素
stream.distinct();

3. 终端操作
forEach：遍历元素
stream.forEach(System.out::println);

collect：收集元素到集合
List<String> result = stream.collect(Collectors.toList());

reduce：归约操作
Optional<String> reduced = stream.reduce((s1, s2) -> s1 + "," + s2);

count：计数
long count = stream.count();

anyMatch、allMatch、noneMatch：匹配操作
boolean anyStartsWithA = stream.anyMatch(s -> s.startsWith("a"));
boolean allStartsWithA = stream.allMatch(s -> s.startsWith("a"));
boolean noneStartsWithA = stream.noneMatch(s -> s.startsWith("a"));


4. 示例
下面是一个完整的示例，展示了如何使用流API来处理一个字符串列表：
```java
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class StreamExample {
    public static void main(String[] args) {
        List<String> list = Arrays.asList("a1", "a2", "b1", "c2", "c1");

        List<String> result = list.stream()
                .filter(s -> s.startsWith("c"))
                .map(String::toUpperCase)
                .sorted()
                .collect(Collectors.toList());

        result.forEach(System.out::println);
    }
}

```

这个示例首先过滤出以"c"开头的字符串，然后将它们转换为大写，再进行排序，最后收集到一个新的列表中并打印出来。

通过这些操作，JDK 1.8 的流API使得数据处理变得更加简洁和高效。

## 数据库性能分析工具

1. MySQL Workbench
MySQL Workbench 是 MySQL 官方提供的图形化工具，用于数据库设计和开发。它提供了性能分析工具，可以帮助你分析和优化查询性能。

2. Percona Toolkit
Percona Toolkit 是一个开源工具集，用于 MySQL 和 Percona Server 的性能监控、优化和故障排除。它包含了一些性能分析工具，如 pt-query-digest 和 pt-query-analyzer，可以帮助你分析查询性能。

3. MySQL Enterprise Monitor
MySQL Enterprise Monitor 是 MySQL 的商业监控工具，提供了实时的性能监控和性能分析功能。它可以帮助你识别性能瓶颈，并提供优化建议。

4. Zabbix
Zabbix 是一个开源的监控解决方案，可以监控 MySQL 的性能指标，如查询时间、连接数等。它可以帮助你及时发现性能问题并进行优化。

5. Nagios
Nagios 是一个开源的监控解决方案，可以监控 MySQL 的性能指标，如查询时间、连接数等。它可以帮助你及时发现性能问题并进行优化。

6. New Relic APM
New Relic APM 是一个商业的 APM 工具，可以监控 MySQL 的性能指标，如查询时间、连接数等。它可以帮助你及时发现性能问题并进行优化。

7. Datadog
Datadog 是一个商业的监控解决方案，可以监控 MySQL 的性能指标，如查询时间、连接数等。它可以帮助你及时发现性能问题并进行优化。

8. Prometheus
Prometheus 是一个开源的监控解决方案，可以监控 MySQL 的性能指标，如查询时间、连接数等。它可以帮助你及时发现性能问题并进行优化。

9. Grafana
Grafana 是一个开源的监控解决方案，可以监控 MySQL 的性能指标，如查询时间、连接数等。它可以帮助你及时发现性能问题并进行优化。

10. Oracle Enterprise Manager
Oracle Enterprise Manager 是 Oracle 提供的商业监控工具，可以监控 MySQL 的性能指标，如查询时间、连接数等。它可以帮助你及时发现性能问题并进行优化。

## MySQL 数据库explain用法

EXPLAIN 是 MySQL 提供的一个命令，用于分析查询语句的性能。它可以显示查询语句的执行计划，包括查询的执行顺序、使用的索引、查询的行数等信息。通过分析这些信息，你可以了解查询的性能瓶颈，并采取相应的优化措施。

下面是 EXPLAIN 命令的基本用法：

```sql
EXPLAIN SELECT * FROM table_name WHERE column_name = 'value';
```

这条命令会返回一个结果集，其中包含了查询的执行计划。结果集中的每一行表示一个查询步骤，包括以下信息：

- id：查询步骤的标识符。每个查询步骤都有一个唯一的 id。
- select_type：查询的类型。常见的类型包括 SIMPLE（简单查询，不包含子查询或 UNION）、PRIMARY（主查询，包含子查询或 UNION）、UNION（UNION 查询的第一个查询）、DEPENDENT UNION（UNION 查询的第二个查询，依赖于外部查询的结果）等。
- table：查询涉及的表名。
- type：查询的类型。常见的类型包括 ALL（全表扫描）、index（索引扫描）、range（范围扫描）、ref（引用扫描）、eq_ref（唯一索引扫描）、const（常量扫描）等。查询的类型决定了查询的性能，一般来说，查询的类型越低，查询的性能越好。
- possible_keys：查询可能使用的索引。
- key：查询实际使用的索引。
- key_len：查询使用的索引的长度。
- ref：查询使用的索引的引用。
- rows：查询返回的行数。
- Extra：额外的信息。常见的信息包括 Using where（使用了 WHERE 子句）、Using index（使用了索引）、Using temporary（使用了临时表）等。    

通过分析这些信息，你可以了解查询的性能瓶颈，并采取相应的优化措施。例如，如果查询的类型是 ALL，表示全表扫描，你可以考虑添加索引来提高查询的性能。如果查询使用了临时表，你可以考虑优化查询语句，避免使用临时表。

总之，EXPLAIN 命令是一个非常有用的工具，可以帮助你了解查询的性能，并采取相应的优化措施。

## Java中如何获取当前时间戳

在Java中，可以使用`System.currentTimeMillis()`方法来获取当前时间戳。这个方法返回一个long类型的值，表示从1970年1月1日00:00:00 UTC到当前时间的毫秒数。

下面是一个示例代码：

```java
long timestamp = System.currentTimeMillis();
System.out.println("当前时间戳：" + timestamp);
```

输出结果类似于：

```
当前时间戳：1634567890000
```

这个时间戳可以用于记录日志、生成唯一ID等场景。

## Java中如何获取当前日期

在Java中，可以使用`java.util.Date`类来获取当前日期。`Date`类表示一个特定的瞬间，精确到毫秒。

下面是一个示例代码：

```java
import java.util.Date;

public class Main {
    public static void main(String[] args) {
        Date currentDate = new Date();
        System.out.println("当前日期：" + currentDate);
    }
}
```

输出结果类似于：

```
当前日期：Thu Oct 20 10:30:00 CST 2022
```

这个日期可以用于记录日志、生成文件名等场景。

## MYSQL 数据分区功能/类型 数据库分区需要结合场景+对应的查询语句
MySQL 数据分区功能是一种将数据表分成多个部分的技术，可以提高查询性能和存储效率。MySQL 支持多种类型的分区，包括范围分区、列表分区、哈希分区和复合分区等。

下面是一个示例，演示如何使用范围分区：

```sql
CREATE TABLE sales (
    id INT,
    sale_date DATE,
    amount DECIMAL(10, 2)
)
PARTITION BY RANGE(YEAR(sale_date)) (
    PARTITION p0 VALUES LESS THAN (2020),
    PARTITION p1 VALUES LESS THAN (2021),
    PARTITION p2 VALUES LESS THAN (2022),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);
```

这个示例创建了一个名为 sales 的表，并使用范围分区将数据分成四个部分。每个部分对应一个年份，例如 p0 对应 2020 年之前的数据，p1 对应 2020 年到 2021 年的数据，以此类推。

使用分区可以加快查询速度，因为 MySQL 可以根据分区键直接定位到包含所需数据的分区，而不需要扫描整个表。此外，分区还可以提高存储效率，因为 MySQL 可以将数据分散到多个磁盘上，从而减少磁盘 I/O。

`RANGE分区`

月份或年份进行分区的场景

```sql
CREATE TABLE biz_execution_region (
    id BIGINT AUTO_INCREMENT,
    biz_id BIGINT,
    biz_date DATE,
    remark VARCHAR(255),
    PRIMARY KEY (id, biz_date)
)
PARTITION BY RANGE (TO_DAYS(biz_date)) (
    PARTITION p202401 VALUES LESS THAN TO_DAYS(('2024-02-01')),
    PARTITION p202402 VALUES LESS THAN TO_DAYS(('2024-03-01')),
    PARTITION p202403 VALUES LESS THAN TO_DAYS(('2024-04-01')),
    PARTITION p202404 VALUES LESS THAN TO_DAYS(('2024-05-01')),
    PARTITION p202405 VALUES LESS THAN TO_DAYS(('2024-06-01')),
    PARTITION p202406 VALUES LESS THAN TO_DAYS(('2024-07-01')),
    PARTITION p202407 VALUES LESS THAN TO_DAYS(('2024-08-01')),
    PARTITION p202408 VALUES LESS THAN TO_DAYS(('2024-09-01')),
    PARTITION p202409 VALUES LESS THAN TO_DAYS(('2024-10-01')),
    PARTITION p202410 VALUES LESS THAN TO_DAYS(('2024-11-01')),
    PARTITION p202411 VALUES LESS THAN TO_DAYS(('2024-12-01')),
    PARTITION pMax VALUES LESS THAN MAXVALUE
)

```

限制了月份是必填查询参数，则使用RANGE分区可以减少查询扫描的数据量。查询性能依旧很高

`LIST分区`

枚举值进行分区的场景

```sql
CREATE TABLE city_orders (
    id BIGINT AUTO_INCREMENT,
    order_id BIGINT,
    user_id BIGINT,
    province VARCHAR(50),
    PRIMARY KEY (id, province)
)
PARTITION BY LIST COLUMNS (province) (
    PARTITION pBeijing VALUES IN ('Beijing'),
    PARTITION pShanghai VALUES IN ('Shanghai'),
    PARTITION pGuangzhou VALUES IN ('Guangzhou'),
    PARTITION pZheJiang VALUES IN ('ZheJiang'),
    PARTITION pOther VALUES IN ('Other')
)
```


`HASH分区`

根据某个字段的值进行哈希运算(哈希函数)，然后根据运算结果进行分区

```sql
CREATE TABLE city_orders (
    id INT NOT NULL AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    order_date DATE,
    PRIMARY KEY (id, product_id)
)
PARTITION BY HASH (product_id)
PARTITIONS 20;
```

`KEY分区`

采用了mysql内部定义的散列函数，不过hash分区提供了更大的灵活性，可以自定义一些hash表达式

```sql
CREATE TABLE city_orders (
    id INT NOT NULL AUTO_INCREMENT,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    order_date DATE,
    PRIMARY KEY (id, product_id)
)
PARTITION BY KEY (product_id)
PARTITIONS 20;
```

## FITTEN CODE 插件

更新后，自动更新上下文，自动获取上下文对象，不需要再选中代码

`@workspace` 全项目分析

`截图，拖进去就能得到前端代码`

`聊天分享，还可以继续问`

## @Async (需自定义线程池，否则可能并发大导致内存溢出) 默认线程池 springboot 2.1.0前：SimpleAsyncTaskExecutor 2.1.0之后：TaskExecutor

自定义业务线程池，注入到Bean容器
```java
@Configuration
public class ThreadPoolExecutorConfig {
    private final int CORE_THREAD_SIZE = Runtime.getRuntime().availableProcessors() * 1;
    private final int MAX_THREAD_SIZE = Runtime.getRuntime().availableProcessors() * 2 + 1;
    private final int QUEUE_SIZE = 1000;
    private final int KEEP_ALIVE_TIME = Integer.MAX_VALUE; // 秒

    @Bean('myTaskExecutor') // 名称，下面用
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(CORE_THREAD_SIZE);
        executor.setMaxPoolSize(MAX_THREAD_SIZE);
        executor.setQueueCapacity(QUEUE_SIZE);
        executor.setKeepAliveSeconds(KEEP_ALIVE_TIME);
        executor.setThreadNamePrefix("myTaskExecutor-");
        // executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());
        executor.initialize();
        executor.setAllowCoreThreadTimeOut(true);
        return executor;
    }
}
```

使用

```java
@Service
public class AsyncService {
    @Async('myTaskExecutor')
    public void asyncWaiting() throws InterruptedException {
        // 异步方法
        System.out.println(Thread.currentThread().getName() +"异步方法开始");
        Thread.sleep(100);
        System.out.println("异步方法结束");
    }
}
```



```java
@Configuration
public class AsyncConfig implements AsyncConfigurer {
    @Override
    public Executor getAsyncExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(10);
        executor.setMaxPoolSize(20);
        executor.setQueueCapacity(100);
        executor.setThreadNamePrefix("AsyncThread-");
        executor.initialize();
        return executor;
    }
}
```

使用
```java
@Service
public class AsyncService {
    @Async
    public void asyncMethod() {
        // 异步执行的方法
    }
}
```

## ThreadPoolTaskScheduler 定时任务

```java
@Configuration
@EnableScheduling
public class ScheduleConfig {
    @Bean
    public TaskScheduler taskScheduler() {
        ThreadPoolTaskScheduler scheduler = new ThreadPoolTaskScheduler();
        scheduler.setPoolSize(10);
        scheduler.setThreadNamePrefix("TaskScheduler-");
        scheduler.setAwaitTerminationSeconds(60);
        scheduler.setWaitForTasksToCompleteOnShutdown(true);
        scheduler.initialize();
        return scheduler;
    }
}
```

使用

```java
@Service
public class ScheduleService {
    @Scheduled(cron = "0 0/1 * * * ?") // 每分钟执行一次
    public void scheduledMethod() {
        // 定时执行的方法
    }
}
```

## 包米豆(Mybatis-plus的作者) Lock4j @Lock4j分布式锁 ThreadPoolTaskScheduler

该项目的源码也很简单，适合新手看

屏蔽了锁的底层实现，redis锁换成zookeeper，一行业务代码都不用动

```java
public class TestService {
    public void asyncMethod() {
        System.out.println(userContext);
        // 后面一堆代码
    }

    @Lock4j(keys={#user.id}, expire = 60000, acquireTimeout=1000)
    public void lockMethod(User user) throws InterruptedException {
        System.out.println("进入锁方法内部，用户信息为：" + user);
        Thread.sleep(5000);
        System.out.println("锁方法执行完成");
    }

}
```

```java
public class TestController {
    public void testThreadLock() {
        // 调用一个异步方法
        testService.asyncMethod();
    }

    @GetMapping("testLock4j")
    public void testLock4j(@RequestBody User user) throws InterruptedException {
        testService.lockMethod(user);
    }
}
```


## 解决ThreadLocal在多线程的情况下，无法进行上下文传递的问题 阿里：TransmittableThreadLocal （继承了JDK自带的InheritableThreadLocal -> ThreadLocal）

https://codeease.top/blog

```java
public class TestController {
    @Autowired
    private TestService testService;

    @GetMapping("/testThreadLocal")
    public void testThreadLocal() {
        // 前面一堆逻辑
        // 获取用户信息
        UserContextInfo userContext = userContext.getUserContext();
        System.out.println(userContext);
        // 调用一个异步方法
        testService.asyncMethod();
    }
}

```

```java
@Service
@Slf4j
public class TestService {

    @Async("taskExecutor")
    public void asyncMethod() {
        // 前面一堆逻辑
        // 执行异步方法体
        UserContextInfo userContext = userContext.getUserContext();
        System.out.println(userContext);
        // 后面一堆逻辑
    }
}
```

```java

public class UserContext {
    // 用户上下文，通过ThreadLocal保存
    // private static ThreadLocal<UserContextInfo> userContext = new ThreadLocal<>(); // ThreadLocal换成 TransmittableThreadLocal
    private static ThreadLocal<UserContextInfo> userContext = new TransmittableThreadLocal<>();

    private UserContext() {
    }

    public static UserContextInfo getUserContext() {
        return userContext.get();
    }

    public static void setUserContext(UserContextInfo userContextInfo) {
        userContext.set(userContextInfo);
    }
}
```

```java
@Configuration
public class ThreadPoolExecutorConfig {
    private final int CORE_THREAD_SIZE = Runtime.getRuntime().availableProcessors() * 1;
    private final int MAX_THREAD_SIZE = Runtime.getRuntime().availableProcessors() * 2 + 1;
    private final int QUEUE_SIZE = 1000;
    private final int KEEP_ALIVE_TIME = Integer.MAX_VALUE; // 秒

    @Bean('myTaskExecutor') // 名称，下面用
    public Executor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(CORE_THREAD_SIZE);
        executor.setMaxPoolSize(MAX_THREAD_SIZE);
        executor.setQueueCapacity(QUEUE_SIZE);
        executor.setKeepAliveSeconds(KEEP_ALIVE_TIME);
        executor.setThreadNamePrefix("myTaskExecutor-");
        // executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());
        executor.initialize();
        executor.setAllowCoreThreadTimeOut(true);
        // return executor;
        return TtlExecutor.getTtlExecutor(executor); // 解决线程池中线程上下文丢失的问题 // https://github.com/alibaba/transmittable-thread-local
        // 不管父线程，还是其他线程，都能获取用户上下文信息
    }
}
```

```java
// 拦截器
@Component
public class UserInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        if (handler instanceof HandlerMethod) {
            // 从请求中获取token，通过token获取用户信息
            String token = request.getHeader("User-Account");
            UserContextInfo userContextInfo = getUserInfoByToken(token);
            // 将用户信息保存到ThreadLocal中，先清空，再设置值
            UserContext.setUserContext(userContextInfo);
            return true;
        }
        return true;
    }

    // aferCompletion方法在请求完成之后执行，可以用来清理ThreadLocal中的数据
    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        UserContext.setUserContext(null);
    }
}
```

## TaskDecorator装饰器，解决主线程的用户信息，到异步线程丢了的问题(和上面同)

https://codeease.top/blog

```java
public class BusinessContextDecorator implements TaskDecorator {
    @Override
    public Runnable decorate(Runnable runnable) {
        UserContextInfo userContext = UserContext.getUserContext();
        return () -> {
            try {
                UserContext.setUserContext(userContext);
                runnable.run();
            }finally {
                UserContext.clear();
            }
        };
    }
}


```

```java
@Configuration
public class ThreadPoolExecutorConfig {

    private static final int CORE_THREAD_SIZE = Runtime.getRuntime().availableProcessors() + 1;

    private static final int MAX_THREAD_SIZE = Runtime.getRuntime().availableProcessors() * 2 + 1;

    private static final int WORK_QUEUE = 1000;

    private static final int KEEP_ALIVE_SECONDS = 60;

    @Bean("taskExecutor")
    public Executor taskExecutor(){
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        executor.setCorePoolSize(CORE_THREAD_SIZE);
        executor.setMaxPoolSize(MAX_THREAD_SIZE);
        executor.setQueueCapacity(WORK_QUEUE);
        executor.setKeepAliveSeconds(KEEP_ALIVE_SECONDS);
        executor.setThreadNamePrefix("task-thread-");
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());
        // 新增线程装饰器
        executor.setTaskDecorator(new BusinessContextDecorator());
        executor.initialize();
        return executor;
    }
}

```

## @Transactional失效场景

`@Transactional`注解只能应用到public方法上，否则事务不会生效

1. @Transactional 应用在非 public 修饰的方法上
2. @Transactional 注解属性 propagation 设置错误
3. @Transactional 注解属性 rollbackFor 设置错误
4. 同一个类中方法调用，导致@Transactional失效
5. 异常被try…catch捕获导致@Transactional失效




