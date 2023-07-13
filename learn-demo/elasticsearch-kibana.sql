GET _search
{
  "query": {
    "match_all": {}
  }
}

#查看有多少索引库
GET /_cat/indices?v

#删除索引
DELETE /logstash-2023.07.0*


GET logstash*/_search
{
  "query": {
    "match": {
      "traceId": "efd60667e1352684"
    }
  }
}


GET logstash*/_search
{
  "query": {
    "match_all": {}
  }
}


# 分组
GET logstash*/_search
{
  "query": {
    "match": {
      "traceId": "efd60667e1352684"
    }
  },
  "aggs": {
    "count": {
      "terms": {
        "field": "traceId.keyword"
      }
    }
  }
}

# 分组
GET logstash*/_search
{
  "query": {
    "match": {
      "traceId": "efd60667e1352684"
    }
  },
  "aggs": {
    "group_by_tags": {
      "terms": {
        "field": "traceId.keyword"
      }
    }
  }
}

# 查询元数据
GET logstash-*/doc/_mapping

# 查询元数据
GET logstash-*/_mapping/doc
 


























