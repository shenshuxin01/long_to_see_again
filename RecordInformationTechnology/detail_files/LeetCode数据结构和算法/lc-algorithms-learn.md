# 归并排序
时间复杂度：nlogn。
归并排序，是创建在归并操作上的一种有效的排序算法。算法是采用分治法（Divide and Conquer）的一个非常典型的应用，且各层分治递归可以同时进行。归并排序思路简单，速度仅次于快速排序，为稳定排序算法，一般用于对总体无序，但是各子项相对有序的数列。
![1682212588775](image/lc-algorithms-learn/1682212588775.png)

# 字典序最小
字典序是指从前到后比较两个字符串大小的方法。首先比较第1个字符，如果不同则第1个字符较小的字符串更小，一直这样子比较下去。
- 比如：
    - s1：ABCDE 
    - s2：ABCCE 

两个字符串，s1的 D 比 s2的 C要更加大一点，所以s1 > s2。

# 位掩码
首先进行名词解释，什么是”位掩码“。
位掩码（BitMask），是”位（Bit）“和”掩码（Mask）“的组合词。”位“指代着二进制数据当中的二进制位，而”掩码“指的是一串用于与目标数据进行按位操作的二进制数字。组合起来，就是”用一串二进制数字（掩码）去操作另一串二进制数字“的意思。
明白了位掩码的作用以后，我们就可以通过它来对权限集二进制数进行操作了。

# 二叉树广度、深度优先遍历
![1684284000908](image/lc-algorithms-learn/1684284000908.png)
## 深度优先搜索（DFS，Depth First Search）
例如上图遍历顺序：ABDECFG
## 广度优先搜索（BFS，Breadth First Search）
例如上图顺序：ABCDEFG

# 判断整数n是否是2的次幂
`n & (n-1) == 0 ? "true" : "false" `

10 & 01 = 0   -------2^1
100 & 011 = 0  -------2^2
1000 & 0111 = 0  -------2^3
10000 & 01111 = 0  -------2^4
所谓代码（（n & （n-1））== 0）的含义是n满足2的n次方
n的最高有效位为1，其余位为0。因此，n的值是2的某次方。
所以，(n&(n-1))==0检查n是否为2的某次方（或者检查n是否为0


# 数组删除元素时间复杂度优化
一维数组删除元素：待删除的索引对应的值和最后一个索引对应的值交换，然后删除最后一个元素即可
