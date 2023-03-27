# profiles
maven配置文件的profiles功能类似于springboot的`spring.profiles.active`配置，指定不同的环境来读取相应的配置内容。
`<profiles>`标签的子标签可以包含`<repository>` `<plugin>` `<dependencies>` `<distributionManagement>`等。

触发激活配置可以是:
- 命令行 `mvn -p prod xxx `
- 默认配置 `<activeByDefault>true</activeByDefault>`

详情查看[csdn文章](https://blog.csdn.net/zy103118/article/details/79879879?spm=1001.2014.3001.5506)

---


# 自定义maven插件plugin
1. 创建maven项目
2. pom文件设置：
    -   ```xml
        <artifactId>demo-ssx</artifactId>
        <packaging>maven-plugin</packaging>
        <dependencies>
            <dependency>
                <groupId>org.apache.maven</groupId>
                <artifactId>maven-plugin-api</artifactId>
                <version>2.0</version>
            </dependency>
            <dependency>
                <groupId>org.apache.maven.plugin-tools</groupId>
                <artifactId>maven-plugin-annotations</artifactId>
                <version>3.1</version>
            </dependency>
        </dependencies>
        ```
3. 继承`Mojo`插件的抽象类实现方法
    ```java
    package ssx;

    import org.apache.maven.plugin.AbstractMojo;
    import org.apache.maven.plugin.MojoExecutionException;
    import org.apache.maven.plugin.MojoFailureException;
    import org.apache.maven.plugins.annotations.LifecyclePhase;
    import org.apache.maven.plugins.annotations.Mojo;
    import org.apache.maven.plugins.annotations.Parameter;

    @Mojo(name="hello",defaultPhase = LifecyclePhase.CLEAN)
    public class SsxMojo extends AbstractMojo {
        @Parameter
        private String test;
        //真正执行的方法
        @Override
        public void execute() throws MojoExecutionException, MojoFailureException {
            getLog().warn("ssx 自定义plugin："+test);
            getLog().warn("ssx 自定义plugin："+test);
            getLog().warn("ssx 自定义plugin："+test);
            getLog().warn("ssx 自定义plugin："+test);
        }
    }
    ```
4. 把此工程打包发布
`mvn install deploy`
5. 使用
在另一个工程中pom文件引入此plugin
    ```xml
    <plugins>
        <plugin>
            <groupId>org.example</groupId>
            <artifactId>demo-ssx</artifactId>
            <version>1.0-SNAPSHOT</version>
            <executions>
                <execution>
                    <goals>
                        <goal>hello</goal>
                    </goals>
                </execution>
            </executions>
            <configuration>
                <test>你好你好你好</test>
            </configuration>
        </plugin>
    </plugins>
    ```
    执行命令`mvn demo-ssx:hello`或者idea中右侧maven的plugin选项



https://github.com/shenshuxin01/maven_diy_plugin/tree/master

