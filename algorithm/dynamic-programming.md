# 动态规划

动态规划（Dynamic Programming，简称DP）是一种通过把原问题分解为相对简单的子问题的方式来求解复杂问题的方法。动态规划常常适用于有重叠子问题和最优子结构性质的问题。

## 动态规划的基本思想

动态规划的基本思想是将复杂问题分解为相对简单的子问题，通过求解这些子问题来得到原问题的解。动态规划的核心在于找到子问题的最优解，并将这些最优解存储起来，以便在后续的计算中重复使用。

## 动态规划的步骤
动态规划通常包括以下几个步骤：

1. 确定状态：将问题分解为若干个子问题，并确定每个子问题的状态。
2. 确定状态转移方程：根据子问题的状态，确定状态转移方程，即如何从一个状态转移到另一个状态。
3. 初始化状态：根据问题的初始条件，初始化状态。
4. 计算状态：根据状态转移方程，计算每个状态的最优解。
5. 输出结果：根据最终状态，输出问题的解。

## 动态规划的例子
动态规划在许多问题中都有应用，例如：

- 最长公共子序列（Longest Common Subsequence，LCS）
- 最短路径（Shortest Path）
- 背包问题（Knapsack Problem）
- 矩阵链乘法（Matrix Chain Multiplication）
- 动态规划在机器学习中的应用，例如：隐马尔可夫模型（Hidden Markov Model，HMM）

## 动态规划的优缺点
动态规划的优点包括：

- 可以将复杂问题分解为相对简单的子问题，通过求解这些子问题来得到原问题的解。
- 可以避免重复计算，提高计算效率。

动态规划的缺点包括：

- 需要找到状态转移方程，这有时可能比较困难。
- 需要存储每个状态的最优解，这可能会占用较多的存储空间。

## 动态规划的实现
动态规划的实现通常需要使用递归或迭代的方法。递归方法比较直观，但可能会出现重复计算的问题。迭代方法可以避免重复计算，但需要找到状态转移方程。在实际应用中，可以根据问题的具体情况选择合适的方法来实现动态规划。

## 动态规划的代码实现
以下是一个使用动态规划解决最长公共子序列问题的示例代码：

```python
def longest_common_subsequence(X, Y):
    m = len(X)
    n = len(Y)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if X[i - 1] == Y[j - 1]:
                dp[i][j] = dp[i - 1][j - 1] + 1
            else:
                dp[i][j] = max(dp[i - 1][j], dp[i][j - 1])
    return dp[m][n]
```

该代码使用一个二维数组 `dp` 来存储每个状态的最优解，其中 `dp[i][j]` 表示 `X[0:i]` 和 `Y[0:j]` 的最长公共子序列的长度。通过比较 `X[i-1]` 和 `Y[j-1]` 是否相等，可以确定状态转移方程。最后，返回 `dp[m][n]` 即为问题的解。

## 动态规划的应用
动态规划在计算机科学和数学中有广泛的应用，包括：

- 最长公共子序列（Longest Common Subsequence，LCS）
- 最长递增子序列（Longest Increasing Subsequence，LIS）
- 最短路径（Shortest Path）
- 背包问题（Knapsack Problem）
- 矩阵链乘法（Matrix Chain Multiplication）
- 动态规划在机器学习中的应用，例如：隐马尔可夫模型（Hidden Markov Model，HMM）

动态规划是一种非常强大的工具，可以解决许多复杂的问题。通过找到状态转移方程，并使用递归或迭代的方法来实现动态规划，可以有效地解决这些问题。

## 动态规划的时间复杂度和空间复杂度
动态规划的时间复杂度和空间复杂度取决于问题的规模和状态转移方程的复杂度。通常情况下，动态规划的时间复杂度是 $O(n^2)$ 或 $O(n^3)$，空间复杂度是 $O(n^2)$ 或 $O(n^3)$。然而，在实际应用中，可以通过一些优化技巧来降低时间复杂度和空间复杂度。

## 动态规划的优化技巧
动态规划的优化技巧包括：

- 状态压缩：将二维或三维的状态压缩为一维，以减少空间复杂度。
- 记忆化搜索：使用哈希表或数组来存储已经计算过的状态，以避免重复计算。
- 动态规划与贪心算法的结合：在某些情况下，可以将动态规划与贪心算法结合使用，以提高算法的效率。


## 509. 斐波那契数

https://leetcode.cn/problems/fibonacci-number/

## 70. 爬楼梯

https://leetcode.cn/problems/climbing-stairs/

## 746. 使用最小花费爬楼梯

https://leetcode.cn/problems/min-cost-climbing-stairs/

## 62.不同路径

https://leetcode.cn/problems/unique-paths/

## 63. 不同路径 II

https://leetcode.cn/problems/unique-paths-ii/

## 343. 整数拆分

https://leetcode.cn/problems/integer-break/

## 96. 不同的二叉搜索树

https://leetcode.cn/problems/unique-binary-search-trees/

## 416. 分割等和子集

https://leetcode.cn/problems/partition-equal-subset-sum/

## 1049.最后一块石头的重量II

https://leetcode.cn/problems/last-stone-weight-ii/

## 494.目标和

https://leetcode.cn/problems/target-sum/

## 474.一和零

https://leetcode.cn/problems/ones-and-zeroes/

## 518.零钱兑换II

https://leetcode.cn/problems/coin-change-2/

## 377. 组合总和 Ⅳ

https://leetcode.cn/problems/combination-sum-iv/

## 70. 爬楼梯（进阶版 卡码网：57. 爬楼梯）

https://kamacoder.com/problempage.php?pid=1067

## 322. 零钱兑换

https://leetcode.cn/problems/coin-change/

## 279. 完全平方数

https://leetcode.cn/problems/perfect-squares/

## 139. 单词拆分

https://leetcode.cn/problems/word-break/

## 198. 打家劫舍

https://leetcode.cn/problems/house-robber/

## 213. 打家劫舍 II

https://leetcode.cn/problems/house-robber-ii/

## 337. 打家劫舍 III

https://leetcode.cn/problems/house-robber-iii/

## 121. 买卖股票的最佳时机

https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/

## 122. 买卖股票的最佳时机 II

https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-ii/

## 123. 买卖股票的最佳时机 III

https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-iii/

## 188. 买卖股票的最佳时机 IV

https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-iv/

## 309. 最佳买卖股票时机含冷冻期

https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-with-cooldown/

## 714. 买卖股票的最佳时机含手续费

https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-with-transaction-fee/

## 1143. 最长公共子序列

https://leetcode.cn/problems/longest-common-subsequence/

## 674. 最长连续递增序列

https://leetcode.cn/problems/longest-continuous-increasing-subsequence/

## 718. 最长重复子数组

https://leetcode.cn/problems/maximum-length-of-repeated-subarray/

## 1143.最长公共子序列

https://leetcode.cn/problems/longest-common-subsequence/

## 1035.不相交的线

https://leetcode.cn/problems/uncrossed-lines/

## 53. 最大子数组和

https://leetcode.cn/problems/maximum-subarray/

## 392. 判断子序列

https://leetcode.cn/problems/is-subsequence/

## 583. 两个字符串的删除操作

https://leetcode.cn/problems/delete-operation-for-two-strings/

## 72. 编辑距离

https://leetcode.cn/problems/edit-distance/

## 647. 回文子串

https://leetcode.cn/problems/palindromic-substrings/

## 516. 最长回文子序列

https://leetcode.cn/problems/longest-palindromic-subsequence/