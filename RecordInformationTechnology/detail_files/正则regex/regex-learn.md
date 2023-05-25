- \b A word boundary边界

# Java 正则表达式的捕获组(capture group)
[https://www.runoob.com/w3cnote/java-capture-group.html](https://www.runoob.com/w3cnote/java-capture-group.html)

命名捕获组
每个以左括号开始的捕获组，都紧跟着 ?，而后才是正则表达式。

对于时间字符串：2017-04-25，表达式如下:

(?<year>\\d{4})-(?<md>(?<month>\\d{2})-(?<date>\\d{2}))

```java
public static final String P_NAMED = "(?<year>\\d{4})-(?<md>(?<month>\\d{2})-(?<date>\\d{2}))";
public static final String DATE_STRING = "2017-04-25";
 
Pattern pattern = Pattern.compile(P_NAMED);
Matcher matcher = pattern.matcher(DATE_STRING);
matcher.find();
System.out.printf("\n===========使用名称获取=============");
System.out.printf("\nmatcher.group(0) value:%s", matcher.group(0));
System.out.printf("\n matcher.group('year') value:%s", matcher.group("year"));
System.out.printf("\nmatcher.group('md') value:%s", matcher.group("md"));
System.out.printf("\nmatcher.group('month') value:%s", matcher.group("month"));
System.out.printf("\nmatcher.group('date') value:%s", matcher.group("date"));
matcher.reset();
System.out.printf("\n===========使用编号获取=============");
matcher.find();
System.out.printf("\nmatcher.group(0) value:%s", matcher.group(0));
System.out.printf("\nmatcher.group(1) value:%s", matcher.group(1));
System.out.printf("\nmatcher.group(2) value:%s", matcher.group(2));
System.out.printf("\nmatcher.group(3) value:%s", matcher.group(3));
System.out.printf("\nmatcher.group(4) value:%s", matcher.group(4));
```
