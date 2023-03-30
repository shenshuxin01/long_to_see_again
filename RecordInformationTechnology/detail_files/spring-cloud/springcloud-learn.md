分布式框架，通过springboot一键启动的风格整合起来，简单易用，配置简单，专注业务逻辑。

# 服务注册发现
eureka（ap）、nacos（ap）、zookeeper（cp）、etcd（cp）、consul（cp）。这些都是cs架构的，cap：一致性consistency 可用性available 分区容错partition
# 远程配置中心
nacos、springCloudConfig、apollo 都是cs架构
# RPC
# 负载均衡
# 熔断

• Spring Cloud Eureka、nacos、consul、etcd、zookeeper：服务注册与发现
• Spring Cloud Zuul、gateway：服务网关
• Spring Cloud Ribbon：客户端负载均衡
• Spring Cloud Feign、dubbo、grpc：声明性的Web服务客户端
• Spring Cloud Hystrix：断路器
• Spring Cloud Config、nacos：分布式统一配置管理