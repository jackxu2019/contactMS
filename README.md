# ContactMS
Interview project for iOS Engineer of Microsoft
### 项目描述：

读取联系人信息，显示联系人头像和基本信息。
需求关键点：
1. 头像列表和信息列表的滚动都有snap功能，滚动停止后，一定让某个头像停止在水平中间。信息列表滚动停止后一定显示完整的信息卡片。
2. 滚动同步：头像列表滚动会带动信息列表的滚动，反之依然。
3. 信息列表滚动时，头像列表下方会出现一条阴影线，滚动停止后，阴影线消失。
### 项目结构：

- common目录 : 一些可以作为公司通用的一些控件以及工具类
- model目录 : 数据模型
- business目录 : 所有业务逻辑的封装（ 比如联系人信息的获取，头像的处理等 ）
- ui目录 : 项目中出现的所有控件封装
- assets目录 : 本地化文件，json数据，用户头像，其他图片资源等
## 

### 几个重要类设计说明:

#### ● ScrollSnapHelper
ScrollSnapHelper是一个处理视图滚动的帮助类。
- 可以快速实现所有UIScrollView的滚动自动吸附到某个步长的整数倍
- 可以让两个UIScrollView互相关联滚动，可以设定滚动速度比例

使用方法非常简单：
```obj-c
ScrollSnapHelper* helper = [ ScrollSnapHelper new ];
[ helper attachScrollView: scrollV ]; //关联一个scrollView
helper.snapUnitLengthForOffset = 55; //吸附的步长为55，这样scrollView最终停下的位置一定是55的整数倍。
```
最后需要注意的是，需要在scrollView的相关方法中调用对应的`_mustInvoke_in_scrollViewXXX`代码,例如：
> `_mustInvoke_in_scrollViewWillEndDraggingWithVelocity` 在scrollView的scrollViewWillEndDraggingWithVelocity方法中调用
#####  ⚠️在以后的版本中，可以通过runtime的swizzle替换函数的方法，让用户通过包含头文件，即可现实所有功能。考虑到此次为面试项目，为了节约面试官时间，简化了此步 
这样scrollView就会总是停止在55的整数倍位置，并且每次通过一个55的整数倍，都会在helper.delegate中得到通知。
还可以通过`.scrollDirection`设置是横向滚动还是竖向滚动，通过`.snapTolerance`设置吸附发生的容差值等。
关联两个scrollView的同步滚动：
```obj-c
[ helper1 bindScrollWithAnotherHelper:helper2 scrollRatioToOther:ratio isDual:YES ]
// isDual 表示是否需要双向绑定滚动 ，ratio 是help1对help2的滚动速度比
```
这样helper1滚动时，helper2也会自动滚动，二者的滚动速度比为 ratio
## 

#### ● HorizontalLineCellsView 和 HorizontalLineCircularImageCellsView
HorizontalLineCellsView也是一个可以脱离项目使用的通用控件类，具有滚动吸附功能。
- 可以快速实现一行滚动的CollectionView,无须实现dataSource和delegate,简单的赋予cellsNumber就可快速呈现
- 自动实现滚动吸附功能，可以自动吸附到每一个cell的中心，吸附发生后自动选择处于吸附位置的cell
HorizontalLineCircularImageCellsView继承了HorizontalLineCellsView，提供圆形样式和选择样式
- 每一个cell是一个imageView，可以自动设置为原形
- 每一个cell表面覆盖了一个装饰图层，可用来绘制被选中状态等（ 默认实现的是一个圆环 ）
##

#### ● BusinessEngine 
BusinessEngine是一个单例类，作为业务引擎，处理项目中所有的业务逻辑。考虑到项目的扩展，每一个业务逻辑模都单独拆分。

比如联系人模块，在BusinessEngine中就有contact模块专门处理。

项目中使用非常方便：
```obj-c
[defualtBusinessEngine.contact loadAllContactsAsync]; //装载所有联系人
// defaultBusinessEngine是一个宏，是 [ BusinessEngine defaultEngine ] 的简略写法
```
#####  考虑到效率和流畅度，以及整个项目框架的扩展性，defualtBusinessEngine.contact.loadAllContactsAsync( )被设计成异步装载模式
- 在异步装载过程中，会通知delegate，最开始会直接返回总联系人数量，方便ui控件可以立刻做可视化渲染
- 每一个用户信息返回时，都会有通知
- 每一张用户头像处理完毕后，也会有通知
以后可以直接在引擎中添加圆角化图片处理，缓存图片，更新缓存等更多功能，而不影响ui的流畅度。
也考虑到以后从网络下载数据，或者数据量巨大的情况下，本框架都不需要做任何修改，之需要插入相应处理逻辑即可。

