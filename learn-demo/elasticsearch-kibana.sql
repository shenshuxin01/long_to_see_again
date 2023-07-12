#查看有多少索引库
GET /_cat/indices?v

#删除索引
DELETE /logstash-2023.03.1*


# 条件查询
GET logstash*/_search
{
  "query": {
    "match": {
      "traceId": "efd60667e1352684"
    }
  }
}

