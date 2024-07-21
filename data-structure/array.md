# 数组介绍

## 704. 二分查找

https://leetcode.cn/problems/binary-search/

## 27. 移除元素

https://leetcode.cn/problems/remove-element/

## 977.有序数组的平方

https://leetcode.cn/problems/squares-of-a-sorted-array/

## 209.长度最小的子数组

https://leetcode.cn/problems/minimum-size-subarray-sum/

## 59.螺旋矩阵II

https://leetcode.cn/problems/spiral-matrix-ii/

```python
class Solution:
    def minSubArrayLen(self, target: int, nums: List[int]) -> int:
        if not nums:
            return 0
        n = len(nums)
        ans = n + 1
        sums = [0]
        for _, v in enumerate(nums):
            sums.append(sums[-1] + v)
        for i in range(n+1):
            target2 = target + sums[i-1]
            bound = bisect.bisect_left(sums, target2)
            if bound != len(sums):
                ans = min(ans, bound - (i - 1))
        return 0 if ans == n+1 else ans
```

```java
class Solution {
    public int minSubArrayLen(int target, int[] nums) {
        int n = nums.length;
        if (n == 0) {
            return 0;
        }
        
        int ans = Integer.MAX_VALUE;
        int[] sums = new int[n+1];
        for (int i=1; i<=n; i++) {
            sums[i] = nums[i-1] + sums[i-1];
        }
        for (int i=1; i<=n; i++) {
            int target2 = target + sums[i-1];
            int bound = Arrays.binarySearch(sums, target2);
            if (bound < 0) {
                bound = -bound - 1;
            }
            if (bound <= n) {
                ans = Math.min(ans, bound-i+1);
            }
        }
        return ans == Integer.MAX_VALUE ? 0 : ans;
    }
}

```