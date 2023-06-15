接触过redis分布式锁（红锁redlock），zookeeper（创建临时节点）

# zookeeper锁
首先创建一个持久化节点 /zklock
- 线程A：查询 /zklock是否存在顺序临时节点 lock，若不存在则新建此节点，并且执行同步逻辑
- 线程B：查询 /zklock是否存在顺序临时节点 lock，发现已经存在了，等待。。

# redis锁
实现分布式锁按照安全等级分
## 低等级
- setnx lock test //上锁 key不存在的时候创建 
- del lock test //解锁 

当某个key没有被占用的时候，setnx指令会返回1，否则返回0，这就是Redis中分布式锁的使用原理。当然我们还可以在上锁之后使用expire指令给锁设置过期时间。
Redis 2.8版本中加入了set指令的扩展参数，使得setnx指令和expire指令能够同时执行 set lock test ex 5 nxex 此方法效率高，容错率低

### java redisTemplate使用
`Boolean isSuccess = redisTemplate.opsForValue().setIfAbsent("key_1", "value1", 1, TimeUnit.MINUTES);`

## 高等级
我们考虑这么一种情况：假设我们在redis的主节点上添加了一把分布式锁，不幸的是主节点挂掉了，而且主节点上的锁还没有同步到从节点上，如果此时有客户端来请求获得同一把锁，那么它将顺利地获得锁，之前那把锁会被无情地忽视掉，这就是分布式锁在Redis集群中遇到的麻烦。
Redis的作者为了解决这个问题提出了一个叫**Redlock**的算法： 它的原理是这样的：当上锁的时候，把set指令发送给过半的节点，只要过半的锁set成功，就认为这次加锁成功；当解锁的时候，会向所有的节点发送del指令。
redis红锁，在集群中的每个节点设置一个锁，注意锁不能重名，因为锁重名会覆盖，整个集群key不可以重复。开始在每个节点加锁，加锁完成后，当前线程开始加锁的时间，和加锁完成的时间，每个锁的剩余时间都要大于加锁完成的时间才行，保证半数以上符合以上条件即可
此方法效率低，容错率高

- [redis红锁demo源码](https://gitee.com/shenshuxin01/first_-spring-boot_-demo/tree/master/Redisson_RedLock_Demo)


# 区别
众所周知，Redis标榜的是轻量级，直观上分布式锁是比较好实现的，比如使用setnx，但一旦加入高可用这个属性，Redis锁的实现难度就会爆炸式上升。
Redis，使用redisson封装的RedLock Zk，使用curator封装的InterProcessMutex
实现难度上：Zookeeper >= redis 服务端性能：redis > Zookeeper 客户端性能：Zookeeper > redis 可靠性：Zookeeper > redis