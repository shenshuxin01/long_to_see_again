
# 2023年9月16日最新报错的代码
1. 登录
    - http://127.0.0.1:8080/oauth2/authorization/oidc-client
    - 请求头 JSESSIONID=BC93D894F308D1268046BB53EE192F5F
    - 响应头 Set-Cookie: JSESSIONID=BFC42DA1C8091D2A548D880CF1ECDB39; Path=/; HttpOnly

2. 跳转server
    - http://localhost:9000/oauth2/authorize?response_type=code&client_id=oidc-client&scope=openid&state=0RAS3anLECFkuo9MIN2T6rsm9DDFW6FIipO-47iP92A%3D&redirect_uri=http://localhost:8080/login/oauth2/code/oidc-client&nonce=4Sf29vVA7azk_zaoUtgwzaQjWqBGarz-Ey4jLop4exM
    - 请求头 JSESSIONID=6BDBBD8BBCFC820088E02AB67958799F
    - 响应头 Set-Cookie: JSESSIONID=72112CA7C5D0A70F3582522B5AD63AFF; Path=/; HttpOnly

3. 跳转loginPage
    - http://localhost:9000/login
    - 请求头 JSESSIONID=72112CA7C5D0A70F3582522B5AD63AFF
    - 响应头 没有设置cookie

4. 输入账号密码后确定
    - http://localhost:9000/login
    - 请求头 JSESSIONID=72112CA7C5D0A70F3582522B5AD63AFF
    - 响应头 Set-Cookie: JSESSIONID=95D4D7AC3E94584CDE5B1D853FD6D118; Path=/; HttpOnly

5. 准备跳转client
    - http://localhost:9000/oauth2/authorize?response_type=code&client_id=oidc-client&scope=openid&state=0RAS3anLECFkuo9MIN2T6rsm9DDFW6FIipO-47iP92A%3D&redirect_uri=http://localhost:8080/login/oauth2/code/oidc-client&nonce=4Sf29vVA7azk_zaoUtgwzaQjWqBGarz-Ey4jLop4exM&continue
    - 请求头 JSESSIONID=95D4D7AC3E94584CDE5B1D853FD6D118
    - 响应头 没有设置cookie

6. 跳转到client回调
    - http://localhost:8080/login/oauth2/code/oidc-client?code=uOgouZ1FQdb_O0HEea2pPDW5VglxSP6YytIQprsrYOIrfC2qTqBo-lygoSomBpgZ4_dJ4zI-g1AiWlnfzatOmwTf0-_Sy5cKPsyIfnXF5NFFRZDJuSgnJ3MSnIs8gH9V&state=0RAS3anLECFkuo9MIN2T6rsm9DDFW6FIipO-47iP92A%3D
    - 请求头 JSESSIONID=95D4D7AC3E94584CDE5B1D853FD6D118
    - 响应头 Set-Cookie: JSESSIONID=AFF1D595C9C62082090955F5ACE1A42B; Path=/; HttpOnly

7. client报错跳转server尝试重新登录
    - http://localhost:8080/oauth2/authorization/oidc-client?error
    - 请求头  JSESSIONID=AFF1D595C9C62082090955F5ACE1A42B
    - 响应头 没有设置cookie
