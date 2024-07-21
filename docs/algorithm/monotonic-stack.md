# 单调栈(单调栈既是数据结构也是算法)

单调栈是一种特殊的栈，它的特点是栈内元素是单调递增或单调递减的。单调栈通常用于解决一些与数组中元素顺序相关的问题，例如找到每个元素右边或左边第一个比它大或小的元素。

## 单调递增栈
单调递增栈是一种栈，它的特点是栈内元素是单调递增的。也就是说，当新元素入栈时，如果新元素比栈顶元素小，那么新元素入栈；如果新元素比栈顶元素大，那么栈顶元素出栈，直到新元素比栈顶元素小或者栈为空，然后将新元素入栈。单调递增栈可以用来找到每个元素右边第一个比它大的元素。

```python
def next_greater_element(nums):
    stack = []
    result = [-1] * len(nums)
    for i in range(len(nums)):
        while stack and nums[i] > nums[stack[-1]]:
            result[stack.pop()] = nums[i]
        stack.append(i)
    return result
```

## 单调递减栈
单调递减栈是一种栈，它的特点是栈内元素是单调递减的。也就是说，当新元素入栈时，如果新元素比栈顶元素大，那么新元素入栈；如果新元素比栈顶元素小，那么栈顶元素出栈，直到新元素比栈顶元素大或者栈为空，然后将新元素入栈。单调递减栈可以用来找到每个元素右边第一个比它小的元素。

```python
def next_smaller_element(nums):
    stack = []
    result = [-1] * len(nums)
    for i in range(len(nums)):
        while stack and nums[i] < nums[stack[-1]]:
            result[stack.pop()] = nums[i]
        stack.append(i)
    return result
```

## 总结
单调栈是一种特殊的栈，它的特点是栈内元素是单调递增或单调递减的。单调栈通常用于解决一些与数组中元素顺序相关的问题，例如找到每个元素右边或左边第一个比它大或小的元素。单调递增栈和单调递减栈是两种常见的单调栈，它们分别用于找到每个元素右边第一个比它大或小的元素。

单调栈的时间复杂度是O(n)，其中n是数组的长度。这是因为每个元素最多只会被压入和弹出栈一次。单调栈的空间复杂度是O(n)，其中n是数组的长度。

单调栈是一种非常有用的数据结构，它可以帮助我们解决许多与数组中元素顺序相关的问题。


## 739. 每日温度

https://leetcode.cn/problems/daily-temperatures/

## 496.下一个更大元素 I

https://leetcode.cn/problems/next-greater-element-i/

## 503.下一个更大元素 II

https://leetcode.cn/problems/next-greater-element-ii/

## 42. 接雨水

https://leetcode.cn/problems/trapping-rain-water/

## 84.柱状图中最大的矩形

https://leetcode.cn/problems/largest-rectangle-in-histogram/



