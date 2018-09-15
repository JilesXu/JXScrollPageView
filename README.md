# JXScrollPageView

## JXSegmentTitleView
### 原理
1. item的宽度计算有两种
- 指定itemWidth
- 根据item标题宽度自适应
不设置itemWidth，则默认itemWidth为0，根据标题的实际宽度，计算segement的总宽度

2. item是否可以滑动
根据总宽度是否超出屏幕宽度来判断

具体见代码内注释
