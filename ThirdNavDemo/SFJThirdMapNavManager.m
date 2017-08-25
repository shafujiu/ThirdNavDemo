//
//  SFJThirdMapNavManager.m
//  SFJHusbandryAssistant
//
//  Created by 沙缚柩 on 2017/8/10.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJThirdMapNavManager.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

typedef NS_ENUM(NSInteger, SFJMapType) {
    SFJMapTypeGoogle = 0,       // 谷歌地图
    SFJMapTypeBaidu,            // 百度
    SFJMapTypeGaode,            // 高德
    SFJMapTypeTencent,          // 腾讯
    SFJMapTypeApple             // 苹果地图
};

@implementation SFJThirdMapNavManager

// 检测是否安装地图
/*
 1.苹果自带地图（不需要检测，所以不需要URL Scheme）
 2.百度地图 ：baidumap://
 3.高德地图 ：iosamap://
 4.谷歌地图 ：comgooglemaps://
 5.腾讯地图 ：qqmap://
 */
+ (BOOL)openMapWithMapType:(SFJMapType)type{
    switch (type) {
        case SFJMapTypeGoogle:
            return [self p_canOpenMapWithURL:@"comgooglemaps://"];
        case SFJMapTypeGaode:
            return [self p_canOpenMapWithURL:@"iosamap://"];
        case SFJMapTypeBaidu:
            return [self p_canOpenMapWithURL:@"baidumap://"];
        case SFJMapTypeTencent:
            return [self p_canOpenMapWithURL:@"qqmap://"];
        case SFJMapTypeApple:
            return YES;
    }
}

+ (BOOL)p_canOpenMapWithURL:(NSString *)urlStr{
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]];
}

// 跳转到第三方导航
// 1.跳转ios自带地图 目的地 addressDict
+ (void)gotoLocationWithAppleMap:(CLLocationCoordinate2D)loc{
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    
    NSDictionary *addressDict = @{
//                                  CNPostalAddressStreetKey : @"砂缚柩Street",
                                  CNPostalAddressCityKey : @"目的地",
//                                  CNPostalAddressStateKey : @"砂缚柩State",
//                                  CNPostalAddressPostalCodeKey : @"砂缚柩PostalCode",
//                                  CNPostalAddressCountryKey : @"砂缚柩Country",
//                                  CNPostalAddressISOCountryCodeKey : @"砂缚柩ISOCountry"
                                  };
    
    MKPlacemark *placeMark = [[MKPlacemark alloc] initWithCoordinate:loc addressDictionary:addressDict];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placeMark];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{
    MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
      MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}
     ];
}

// 2. 跳转百度地图 目的地 -> 地图上的点
/*
 1，origin={{我的位置}}, 这个是不能被修改的，不然无法把出发位置设置为当前位置
 2，destination = latlng:%f,%f|name = 目的地
 这里面的 name 的字段不能省略，否则导航会失败，而后面的文字则可以随意，赋个你的目的地的值给他就可以了。
 3，coord_type = gcj02
 coord_type 允许的值为 bd09ll、gcj02、wgs84，如果你 APP 的地图 SDK 用的是百度地图 SDK，请填 bd09ll，否则就填gcj02，wgs84的话基本是用不上了（需要涉及到地图加密，有兴趣的同学可以自己去了解）
 */
+ (void)gotoLocationWithBaiduMap:(CLLocationCoordinate2D)loc{
    NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=目的地&mode=driving&coord_type=gcj02",loc.latitude, loc.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}
// 3. 跳转高德地图 未显示
/**
 sourceApplication=%@&backScheme=%@
 sourceApplication代表你自己APP的名称 会在之后跳回的时候显示出来 所以必须填写 backScheme是你APP的URL Scheme 不填是跳不回来的哟
 dev=0
 这里填0就行了，跟上面的gcj02一个意思 1代表wgs84 也用不上

 */
+ (void)gotoLocationWithGaodeMap:(CLLocationCoordinate2D)toLoc{
    NSString *appName = @"农牧宝";
    NSString *urlScheme = @"";
    
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,urlScheme,toLoc.latitude, toLoc.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

// 4. 跳转谷歌地图 自动获取
/**
 x-source=%@&x-success=%@
 跟高德一样 这里分别代表APP的名称和URL Scheme
 saddr=
 这里留空则表示从当前位置触发。
 */
+ (void)gotoLocationWithGoogleMap:(CLLocationCoordinate2D)toLoc{
    [self gotoLocationWithGoogleMap:toLoc fromLocation:CLLocationCoordinate2DMake(0, 0)];
}

+ (void)gotoLocationWithGoogleMap:(CLLocationCoordinate2D)toLoc fromLocation:(CLLocationCoordinate2D)fromLoc{
    NSString *appName = @"农牧宝";
    NSString *urlScheme = @"";

    NSString *curLocation = (fromLoc.latitude == 0 && fromLoc.longitude ==0) ? @"" :[NSString stringWithFormat:@"%f,%f",fromLoc.latitude,fromLoc.longitude];
    
    NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=%@&daddr=%f,%f&directionsmode=driving",appName,urlScheme,curLocation,toLoc.latitude, toLoc.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}

// 5. 跳转腾讯地图 未显示
+ (void)gotoLocationWithTencentMap:(CLLocationCoordinate2D)toLoc curLoc:(CLLocationCoordinate2D)curLoc{
    
    NSString *urlStr = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=%f,%f&tocoord=%f,%f&policy=1",curLoc.latitude, curLoc.longitude,toLoc.latitude,toLoc.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *r = [NSURL URLWithString:urlStr];
    [[UIApplication sharedApplication] openURL:r];
}

// 苹果导航
+ (UIAlertAction *)appleActionWithToLocation:(CLLocationCoordinate2D)loc {
    return [UIAlertAction actionWithTitle:@"苹果导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoLocationWithAppleMap:loc];
    }];
}

// 高德导航
+ (UIAlertAction *)gaodeActionWithToLocation:(CLLocationCoordinate2D)loc {
    return [UIAlertAction actionWithTitle:@"高德导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoLocationWithGaodeMap:loc];
    }];
}

// 腾讯
+ (UIAlertAction *)tencentActionWithToLocation:(CLLocationCoordinate2D)loc curLoc:(CLLocationCoordinate2D)curLoc{
     return [UIAlertAction actionWithTitle:@"腾讯导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoLocationWithTencentMap:loc curLoc:curLoc];
    }];
}

// 百度地图
+ (UIAlertAction *)baiduActionWithToLocation:(CLLocationCoordinate2D)loc{
    return [UIAlertAction actionWithTitle:@"百度导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoLocationWithBaiduMap:loc];
    }];
}

// 谷歌地图
+ (UIAlertAction *)googleActionWithToLocation:(CLLocationCoordinate2D)loc{
    return [UIAlertAction actionWithTitle:@"谷歌导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoLocationWithGoogleMap:loc];
    }];
}

+ (UIAlertAction *)googleActionWithToLocation:(CLLocationCoordinate2D)loc curLocation:(CLLocationCoordinate2D)curLoc{
    return [UIAlertAction actionWithTitle:@"谷歌导航" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self gotoLocationWithGoogleMap:loc fromLocation:curLoc];
    }];
}
/*
 SFJMapTypeGoogle = 0,      // 谷歌地图
 SFJMapTypeBaidu,           // 百度
 SFJMapTypeGaode,           // 高德
 SFJMapTypeTencent
 */
+ (UIAlertAction *)alertActionWithCurLocation:(CLLocationCoordinate2D)curLoc toLocation:(CLLocationCoordinate2D)toLocation type:(SFJMapType)type{
    if (![self openMapWithMapType:type]) {
        return nil;
    }
    switch (type) {
        case SFJMapTypeGoogle:
            return [self googleActionWithToLocation:toLocation curLocation:curLoc];
         case SFJMapTypeBaidu:
            return [self baiduActionWithToLocation:toLocation];
        case SFJMapTypeGaode:
            return [self gaodeActionWithToLocation:toLocation];
        case SFJMapTypeTencent:
            return [self tencentActionWithToLocation:toLocation curLoc:curLoc];
        case SFJMapTypeApple:
            return [self appleActionWithToLocation:toLocation];
    }
}

+ (UIAlertController *)thirdMapNavAlertWithCurrentLocation:(CLLocationCoordinate2D)curLoc toLocation:(CLLocationCoordinate2D)toLoc{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (SFJMapType type = SFJMapTypeGoogle; type <= SFJMapTypeApple; type++) {
        UIAlertAction *action = [SFJThirdMapNavManager alertActionWithCurLocation:curLoc toLocation:toLoc type:type];
        if (action) {
            [alert addAction:action];
        }
    }
    
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:delAction];
    return alert;
}


@end
