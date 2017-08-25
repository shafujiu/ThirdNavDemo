# ThirdNavDemo
iOS跳转第三方的导航app进行导航

解决应用里的导航功能，通常我们也不用自己去开发导航，那么成熟的导航不用，非得自己开发，累不累
参考链接 [iOS 跳转方式实现地图导航功能](http://www.jianshu.com/p/1277346a8bb4)
在参考链接的基础上加入了腾讯导航


效果如下

<img src="http://on5ajnh9a.bkt.clouddn.com/1503661317.png" width="424" height="752" />


该demo对此进行了分装，我们可以通过SFJThirdMapNavManager，直接创建一个UIAlertController，
方法已经自动去检测，然后创建 UIAlertController 对象。

```Objective-c
/**
 跳转第三方导航的UIAlertController（自动检测是否安装了地图，然后会根据有的导航app去创建）

 @param curLoc 当前位置（其中只有腾讯地图是需要当前位置的，其余导航都是自己获取当前位置）
 @param toLoc 目标位置
 @return 创建出一个UIAlertController对象
 */
+ (UIAlertController *)thirdMapNavAlertWithCurrentLocation:(CLLocationCoordinate2D)curLoc toLocation:(CLLocationCoordinate2D)toLoc;
```

> 需要注意： 我们需要添加这几种app的白名单才能打开app，并且我们的UIAlertController对象的Action也是通过检测是否能打开app来创建的。
具体操作 在`info.plist`中添加 `LSApplicationQueriesSchemes`的数组，然后依次添加下列item  

- comgooglemaps
- iosamap
- baidumap
- qqmap

<img src="http://on5ajnh9a.bkt.clouddn.com/1503662047.png" width="546" height="98" />

分别代表了 谷歌，高德，百度，腾讯地图的白名单。

代码写的不好，只是为了方便，能够快速的通过该方式实现第三方导航。如果有错误希望指正，谢谢。


