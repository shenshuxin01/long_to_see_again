最大的区别就是高效、跨语言调用
• grpc四种通信模式？ 答：1）一元 RPC：客户端发起一个请求，服务端给出一个响应，然后请求结束；2）服务端流 RPC：客户端发起一个请求，服务端给一个响应序列，这个响应序列组成一个流； 3）客户端
流RPC：客户端流则是客户端发起多个请求，服务端只给出一个响应； 4）双向流RPC：客户端多次发送数据，服务端也多次响应数据；


ps -auwx --sort=-%cpu | awk NR==2'{print $3}'

sprinng cloud项目代码上kubernets部署，k8s本身有服务发现和负载均衡，如果项目又集成了eureka或者是nacos等，有些多余了，可以用K8s自己作为配置服务发现中心，cloud项目只需要实现rpc功能就好，不足的是K8s的注册中心功能少，管理ui界面需要第三方
如果项目的语言不统一，并且有些服务在k8s有些服务不在，那么注册中心需要单独配置了，

k8s集成istio ，springcloud注册中心使用istio，rpc使用grpc

1. grpc使用demo
2. grpc+zk注册中心使用
3. grpc+istio使用
4. grpc+k8s+istio使用 
