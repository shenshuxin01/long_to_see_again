# java基础语法
[菜鸟教程java](https://www.runoob.com/java/java-tutorial.html)

# 多线程
## 线程池

自定义参数创建线程池ThreadPoolExecutor
```java
import java.util.concurrent.*;

public class T2 {
    public static void main(String[] args) {
        //定义线程池
        ThreadPoolExecutor threadPoolExecutor = new ThreadPoolExecutor(
                2,
                4,
                1,
                TimeUnit.MINUTES,
                getQuery(),//BlockingQueue<Runnable> workQueue,
                new ThreadFactory() {
                    @Override
                    public Thread newThread(Runnable r) {
                        return null;
                    }
                },
                //AbortPolicy         -- 当任务添加到线程池中被拒绝时，它将抛出 RejectedExecutionException 异常。
                new ThreadPoolExecutor.AbortPolicy()
                //CallerRunsPolicy    -- 当任务添加到线程池中被拒绝时，会在线程池当前正在运行的Thread线程池中处理被拒绝的任务。
//                new ThreadPoolExecutor.CallerRunsPolicy()
                //DiscardOldestPolicy -- 当任务添加到线程池中被拒绝时，线程池会放弃等待队列中最旧的未处理任务，然后将被拒绝的任务添加到等待队列中。
//                new ThreadPoolExecutor.DiscardOldestPolicy()
                //DiscardPolicy       -- 当任务添加到线程池中被拒绝时，线程池将丢弃被拒绝的任务。
//                new ThreadPoolExecutor.DiscardPolicy()
        );

        //运行线程池
        Runnable runnable=null;
        threadPoolExecutor.execute(runnable);
        threadPoolExecutor.shutdown();
    }

     static <T> BlockingQueue<T> getQuery(){ //此处的T为 Runnable类型
         ArrayBlockingQueue<T> arrayBlockingQueue = new ArrayBlockingQueue<>(10); // 数组实现：new Object[capacity]; 有界队列
         LinkedBlockingDeque<T> linkedBlockingDeque = new LinkedBlockingDeque<>();//链表实现：class Node<E>{}; 无界队列
         SynchronousQueue<T> synchronousQueue = new SynchronousQueue<>();//此容器不会存储数据，必须有另一个线程正在等待接收这个元素。同步移交队列
         PriorityBlockingQueue<Object> priorityBlockingQueue = new PriorityBlockingQueue<>();//PriorityBlockingQueue是一个无界的基于数组的优先级阻塞队列
         return null;//选择一个进行返回
    }
}
```
[https://blog.csdn.net/weixin_48835367/article/details/129144975?spm=1001.2014.3001.5501](https://blog.csdn.net/weixin_48835367/article/details/129144975?spm=1001.2014.3001.5501)


## 线程生命周期

# 网络IO
## BIO
同步阻塞I/O模式，数据的读取写入必须阻塞在一个线程内等待其完成。
采用 BIO 通信模型 的服务端，通常由一个独立的 Acceptor 线程负责监听客户端的连接。我们一般通过在 while(true) 循环中服务端会调用 accept() 方法等待接收客户端的连接的方式监听请求，请求一旦接收到一个连接请求，就可以建立通信套接字在这个通信套接字上进行读写操作，此时不能再接收其他客户端连接请求，只能等待同当前连接的客户端的操作执行完成

在活动连接数不是特别高（小于单机1000）的情况下，这种模型是比较不错的，可以让每一个连接专注于自己的 I/O 并且编程模型简单，也不用过多考虑系统的过载、限流等问题。线程池本身就是一个天然的漏斗，可以缓冲一些系统处理不了的连接或请求。但是，当面对十万甚至百万级连接的时候，传统的 BIO 模型是无能为力的。因此，我们需要一种更高效的 I/O 处理模型来应对更高的并发量。

## NIO
Java NIO使我们可以进行非阻塞IO操作。比如说，单线程中从通道读取数据到buffer，同时可以继续做别的事情，当数据读取到buffer中后，线程再继续处理数据。写数据也是一样的。另外，非阻塞写也是如此。一个线程请求写入一些数据到某通道，但不需要等待它完全写入，这个线程同时可以去做别的事情。
Java IO的各种流是阻塞的。这意味着，当一个线程调用 read() 或 write() 时，该线程被阻塞，直到有一些数据被读取，或数据完全写入。该线程在此期间不能再干任何事情了

## AIO
AIO 也就是 NIO 2。在 Java 7 中引入了 NIO 的改进版 NIO 2,它是异步非阻塞的IO模型。异步 IO 是基于事件和回调机制实现的，也就是应用操作之后会直接返回，不会堵塞在那里，当后台处理完成，操作系统会通知相应的线程进行后续的操作。


# java生产者消费者同步模式
开启2个线程，A线程分别打印字符ABC，B线程分别打印123。实现交替打印最终结果是A1B2C3。
使用java的synchronized和wait() notify()实现
```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

static class Main {
    public static int count = 0;

    public static void main(String[] args) throws Exception {
        ExecutorService threadPool = Executors.newFixedThreadPool(2);
        Product product = new Product();
        Condumer condumer = new Condumer();
        LockDemo lockDemo = new LockDemo();

        threadPool.execute(() -> {
            for (int i = 0; i < 100; i++) {
                product.addSomething(lockDemo);
            }
        });
        threadPool.execute(() -> {
            for (int i = 0; i < 100; i++) {
                condumer.delSomething(lockDemo);
            }
        });
        Thread.sleep(3000);
        System.out.println(count);
        threadPool.shutdown();
    }
}

static class Product {
    public void addSomething(Object o) {
        synchronized (o) {
            if (Main.count == 0) {
                Main.count++;
                System.out.println("生产者：" + Main.count);
                o.notify();
            } else {
                try {
                    o.wait();//让当前线程进入等待状态，同时，wait ()也会让当前线程释放它所持有的锁
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

static class Condumer {
    public void delSomething(Object o) {
        synchronized (o) {
            if (Main.count == 1) {
                Main.count--;
                System.out.println("消费者：" + Main.count);
                o.notify();
            } else {
                try {
                    o.wait();//让当前线程进入等待状态，同时，wait ()也会让当前线程释放它所持有的锁
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}

static class LockDemo {
    public void main(String[] args) {

    }
}

```

# 函数式接口Function
```java
Function<Integer,String> function = new Function<Integer,String>() {
    @Override
    public String apply(Integer s) {
        return "converse"+s;
    }
};

BiFunction<String,Integer, BigDecimal> biFunction = new BiFunction<String, Integer, BigDecimal>() {
    @Override
    public BigDecimal apply(String s, Integer integer) {
        return new BigDecimal(integer);
    }
};

System.out.println(function.apply(22));
System.out.println(biFunction.apply("a",33));
```

# Optional处理null值
`Optional.ofNullable("不确定这个是不是null").orElse("另一个").getClass()`



