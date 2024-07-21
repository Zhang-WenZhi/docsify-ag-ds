# 贪心算法

贪心算法（Greedy Algorithm）是一种在每一步选择中都采取在当前状态下最好或最优（即最有利）的选择，从而希望导致结果是全局最好或最优的算法。贪心算法在有最优子结构的问题中尤为有效。最优子结构的意思是局部最优解能决定全局最优解。简单来说，贪心算法就是做出当前最好的选择，也就是说，贪心算法不是从整体最优考虑，它所作出的选择只是在某种意义上的局部最优选择。贪心算法并不能从整体上保证是最优解，但是对于大部分问题，贪心算法都是一种相当好的解决方案。

贪心算法的基本思路如下：

1. 建立数学模型来描述问题。
2. 把求解过程分成若干个步骤，并确定每一步的最优解。
3. 每一步都选取当前状态下的最优解，以期望通过局部最优解，导致全局最优解。

贪心算法的适用场景：

1. 问题具有最优子结构性质，即问题的最优解可以由子问题的最优解构造得到。
2. 问题可以分解为一系列的子问题，并且子问题的最优解可以合并为原问题的最优解。
3. 贪心算法每一步都选择当前最优解，并且一旦做出选择，就不再改变。

贪心算法的缺点：

1. 贪心算法不能保证得到全局最优解，只能保证在当前状态下做出最优选择。
2. 贪心算法的时间复杂度通常较高，因为它需要遍历所有可能的解。

贪心算法的例子：

1. 活动选择问题：给定一组活动，每个活动都有一个开始时间和结束时间，选择尽可能多的活动，使得它们互不冲突。
2. 最小生成树问题：给定一个带权无向图，选择一棵最小生成树，使得所有顶点都连通，并且边的权值之和最小。
3. 背包问题：给定一组物品，每个物品有一个价值和重量，选择一组物品，使得总重量不超过背包容量，并且总价值最大。

贪心算法的实现通常需要根据具体问题进行设计，并且需要考虑算法的时间复杂度和空间复杂度。在实际应用中，贪心算法是一种简单而有效的算法，但是需要谨慎使用，因为它不能保证得到全局最优解。

贪心算法的伪代码如下：

```
function greedy_algorithm(problem):
    initialize solution
    while problem is not solved:
        select the best option from the current state
        update the problem and solution
    return solution
``` 
贪心算法的伪代码中，`initialize solution`表示初始化解，`while problem is not solved`表示问题还没有解决，`select the best option from the current state`表示从当前状态中选择最好的选项，`update the problem and solution`表示更新问题和解，`return solution`表示返回解。

贪心算法的伪代码中，`initialize solution`表示初始化解，`while problem is not solved`表示问题还没有解决，`select the best option from the current state`表示从当前状态中选择最好的选项，`update the problem and solution`表示更新问题和解，`return solution`表示返回解。

贪心算法是一种在每一步选择中都做出局部最优选择，从而希望最终得到全局最优解的算法。贪心算法的原理是：在每一步选择中，选择当前状态下最优的选择，然后继续选择，直到问题解决。贪心算法的步骤如下：

1. 初始化解，将问题转化为一个可以求解的形式。
2. 在每一步选择中，选择当前状态下最优的选择，然后继续选择，直到问题解决。
3. 返回解。

## 455.分发饼干

https://leetcode.cn/problems/assign-cookies/

## 376. 摆动序列

https://leetcode.cn/problems/wiggle-subsequence/

## 53. 最大子序和

https://leetcode.cn/problems/maximum-subarray/

## 122.买卖股票的最佳时机 II

https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-ii/

## 55. 跳跃游戏

https://leetcode.cn/problems/jump-game/

## 45. 跳跃游戏 II

https://leetcode.cn/problems/jump-game-ii/

## 134. 加油站

https://leetcode.cn/problems/gas-station/

## 135. 分发糖果

https://leetcode.cn/problems/candy/

## 860. 柠檬水找零

https://leetcode.cn/problems/lemonade-change/

## 406.根据身高重建队列

https://leetcode.cn/problems/queue-reconstruction-by-height/

## 452. 用最少数量的箭引爆气球

https://leetcode.cn/problems/minimum-number-of-arrows-to-burst-balloons/

## 435. 无重叠区间

https://leetcode.cn/problems/non-overlapping-intervals/


## 763. 划分字母区间

https://leetcode.cn/problems/partition-labels/

## 56. 合并区间

https://leetcode.cn/problems/merge-intervals/

## 738.单调递增的数字

https://leetcode.cn/problems/monotone-increasing-digits/

## 968.监控二叉树

https://leetcode.cn/problems/binary-tree-cameras/

