# springboot bean生命周期
![bean生命周期](./1680164616863.jpg)
![bean生命周期代码](./1680164680863.jpg)

# starter机制
[starter例子](https://gitee.com/shenshuxin01/first_-spring-boot_-demo/tree/master/BootAutoConfigDemo)

# SpringBoot自动配置的原理
自己看源码整理

# springboot启动流程
自己看源码

# 知识点
1. 复制一个实体类的属性到另一个实体类
`org.springframework.beans.BeanUtils.copyProperties(pojo1,pojo2);`

# 通过actuator动态配置日志级别
首先配置文件开启
```yaml
management:
  endpoints:
    web:
      exposure:
        include: 'loggers'
```
```sh
# 查询日志级别
curl http://localhost:8091/actuator/loggers/ssx.demo.specialarchlinuxprovider.controller.autorunscript.impl
#{
#     "configuredLevel": "INFO",
#     "effectiveLevel": "INFO"
# }

curl -X POST http://localhost:8091/actuator/loggers/ssx.demo.specialarchlinuxprovider \
-H "Content-Type: application/vnd.spring-boot.actuator.v2+json;charset=UTF-8" \
--data '{"configuredLevel":"info"}'
```

# 全局异常处理
```java
@ControllerAdvice(annotetions={RestCotroller.class})
public class MyBean{
  @ExceptionHandler(value={RuntimeException.class})
  public final XXX dealRun(RuntimeException e,HttpServletRequest req){
    return null;
  }
}
```
curl http://node101:30501/developer-function-provider/actuator/loggers/ssx.demo.developerfunctionprovider.service.camera.ezviz

curl -X POST http://node101:30501/developer-function-provider/actuator/loggers/ssx.demo.developerfunctionprovider.service.camera.ezviz \
-H "Content-Type: application/vnd.spring-boot.actuator.v2+json;charset=UTF-8" \
--data '{"configuredLevel":"debug"}'


curl http://node101:30501/developer-function-provider/cameraEzviz


-i 'rtsp://admin:AGXXZI@192.168.0.105:554/h264/ch1/main/av_stream' -fflags flush_packets -flags -global_header -force_key_frames 'expr:gte(t,n_forced*1)' -hls_time 5 -hls_segment_filename /index%20d.ts /index.m3u8


# web请求拦截controller层方法，继承org.springframework.web.servlet.HandlerInterceptor
![1688690595482](image/springboot-learn/1688690595482.png)
preHandle方法是进行处理器拦截用的，顾名思义，该方法将在Controller处理之前进行调用。
postHandle是进行处理器拦截用的，它的执行时间是在处理器进行处理之后，也就是在Controller的方法调用之后执行，但是它会在DispatcherServlet进行视图的渲染之前执行，也就是说在这个方法中你可以对ModelAndView进行操作。
afterCompletion方法将在整个请求完成之后，也就是DispatcherServlet渲染了视图执行。