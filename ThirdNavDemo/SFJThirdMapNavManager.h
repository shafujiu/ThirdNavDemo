//
//  SFJThirdMapNavManager.h
//  SFJHusbandryAssistant
//
//  Created by 沙缚柩 on 2017/8/10.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//  注意需要设置地图跳转的白名单 在info.plist文件中LSApplicationQueriesSchemes添加

#import <MapKit/MapKit.h>

@interface SFJThirdMapNavManager : NSObject

/**
 跳转第三方导航的UIAlertController（自动检测是否安装了地图，然后会根据有的导航app去创建）

 @param curLoc 当前位置（其中只有腾讯地图是需要当前位置的，其余导航都是自己获取当前位置）
 @param toLoc 目标位置
 @return 创建出一个UIAlertController对象
 */
+ (UIAlertController *)thirdMapNavAlertWithCurrentLocation:(CLLocationCoordinate2D)curLoc toLocation:(CLLocationCoordinate2D)toLoc;

@end
