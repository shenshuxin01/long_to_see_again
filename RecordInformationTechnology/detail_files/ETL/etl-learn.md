ETL（Extraction-Transformation-Loading的缩写，即数据抽取、转换和加载）等等

# informatica
## 主要模块
- Repository manager 资料库管理，功能建立文件夹,设置权限。
- Designer 定义源与目标结构，设计转换规则，生成ETL映射。
- Workflow manager 建立工作流，作业调度。
- Workflow Monitor 监控Workflow,生成日志。
- Informatica的开发分为六个步骤：

## 开发分为六个步骤
- 定义源，就是定义我们源头数据在哪里。配置数据链接，比如IP 账号密码等信息。
- 定义目标，就是我们准备把数据放到哪里。这个是我们事先定义的数据仓库。
- 创建映射，就是我们的元数据和目标数据的映射关系。
- 定义任务，就是我们每个表的转换过程，可以同时处理多个表。
- 创建工作流，将任务按照一定的顺序进行组合。
- 工作流调度和监控，定时、自动或者手动方式触发工作流。

[参考文档知乎:功能强大数据ETL工具informatica](https://zhuanlan.zhihu.com/p/335541466)

# kettle
免费开源的基于java的企业级ETL工具，功能强大简单易用，无可抗拒
ETL（Extract-Transform-Load的缩写，即数据抽取、转换、装载的过程），对于企业或行业应用来说，我们经常会遇到各种数据的处理，转换，迁移，所以了解并掌握一种etl工具的使用，必不可少，这里我介绍一个我在工作中使用了3年左右的ETL工具Kettle,本着好东西不独享的想法，跟大家分享碰撞交流一下！在使用中我感觉这个工具真的很强大，支持图形化的GUI设计界面，然后可以以工作流的形式流转，在做一些简单或复杂的数据抽取、质量检测、数据清洗、数据转换、数据过滤等方面有着比较稳定的表现，其中最主要的我们通过熟练的应用它，减少了非常多的研发工作量，提高了我们的工作效率

## 教程
[Kettle中文网文档](http://www.kettle.org.cn/2794.html)