Spring Authorization Server 是一个框架，它提供了 OAuth 2.1和 OpenID Connect 1.0规范以及其他相关规范的实现。它构建在 Spring Security 之上，为构建 OpenID Connect 1.0 Identity Provider 和 OAuth2 Authorization Server 产品提供安全、轻量级和可定制的基础。


# 服务端代码
```yaml
server:
  port: 9000
```
```java
    @Bean
    @Order(1)
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        OAuth2AuthorizationServerConfiguration.applyDefaultSecurity(http);
        http.getConfigurer(OAuth2AuthorizationServerConfigurer.class)
                .oidc(Customizer.withDefaults());
        http.exceptionHandling(exception -> exception
                .authenticationEntryPoint(new LoginUrlAuthenticationEntryPoint("/login")));
        return http.build();
    }

    @Bean
    @Order(2)
    public SecurityFilterChain appSecurityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().authenticated()
                )
                .formLogin(Customizer.withDefaults());
        return http.build();
    }

    @Bean
    public UserDetailsService userDetailsService() {
        var user1 = User.withUsername("user")
                .password("password")
                .authorities("read")
                .build();
        return new InMemoryUserDetailsManager(user1);
    }
```

# 服务端代码
```yaml
spring:
  security:
    oauth2:
      client:
        registration:
          myoauth2:
            provider: spring
            client-id: client
            client-secret: secret
            redirect-uri: http://127.0.0.1:8080/login/oauth2/code/myoauth2
            scope: openid
            authorization-grant-type: authorization_code
        provider:
          spring:
            issuer-uri: http://localhost:9000
server:
  port: 8080
```
```java
    @Bean
    SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .authorizeHttpRequests(authorize -> authorize
                        .anyRequest().authenticated())
                .oauth2Login(oauth2Login ->
                        oauth2Login.loginPage("/oauth2/authorization/myoauth2"))
                .oauth2Client(withDefaults());
        return http.build();
    }
```

# 参考代码
https://github.com/shenshuxin01/grpc-springboot/tree/oauth2

