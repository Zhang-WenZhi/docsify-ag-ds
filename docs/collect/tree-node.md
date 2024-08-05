# 二叉树


#### 572. 另一棵树的子树 (S)

```python
from typing import Optional



# Definition for a binary tree node.
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right

class Solution:
    def isSameTree(self, p: Optional[TreeNode], q: Optional[TreeNode]) -> bool:
        """
        :type p: TreeNode
        :type q: TreeNode
        :rtype: bool
        递归
        """
        if not p and not q:
            return True
        if not p or not q:
            return False
        if p.val != q.val:
            return False
        return self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)

    def isSubtree(self, root: Optional[TreeNode], subRoot: Optional[TreeNode]) -> bool:
        """
        :type root: TreeNode
        :type subRoot: TreeNode
        :rtype: bool
        递归
        """
        if not root and not subRoot:
            return True
        if not root or not subRoot:
            return False
        return self.isSameTree(root, subRoot) or self.isSubtree(root.left, subRoot) \
            or self.isSubtree(root.right, subRoot)

```

```python
# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    """
    用时最少解法
    """
    def getHeight(self, root):
        if not root:
            return 0
        return max(self.getHeight(root.left), self.getHeight(root.right)) + 1
    
    def isSameTree(self, p, q):
        if not p and not q:
            return True
        if not p or not q:
            return False
        return p.val == q.val and self.isSameTree(p.left, q.left) and self.isSameTree(p.right, q.right)

    def isSubtree(self, root: Optional[TreeNode], subRoot: Optional[TreeNode]) -> bool:
        hs = self.getHeight(subRoot)
        
        def dfs(node):
            if not node:
                return 0, False
            left_h, left_f = dfs(node.left)
            right_h, right_f = dfs(node.right)
            if left_f or right_f:
                return 0, True
            node_h = max(left_h, right_h) + 1
            return node_h, node_h == hs and self.isSameTree(node, subRoot)
        
        return dfs(root)[1]
            
```