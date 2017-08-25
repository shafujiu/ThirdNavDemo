//
//  ViewController.m
//  ThirdNavDemo
//
//  Created by 沙缚柩 on 2017/8/25.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SFJThirdMapNavManager.h"

@interface ViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    // 请求用户定位权限
    [self.locManager requestWhenInUseAuthorization];
    
    // 成都
    CLLocationCoordinate2D toLoc = CLLocationCoordinate2DMake(30, 104);
    [self p_addAnnotationWithLocation:toLoc];
}

- (void)p_moveToUserLoc{
    
//    [self p_addAnnotationWithLocation:self.mapView.userLocation.coordinate];
    [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
}

- (void)p_addAnnotationWithLocation:(CLLocationCoordinate2D)location{
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location;
//    annotation.title = @"砂缚柩";
    
    [self.mapView addAnnotation:annotation];
    
    // 地图显示到标注位置
    self.mapView.centerCoordinate = annotation.coordinate;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mapView selectAnnotation:annotation animated:YES];
    });
}

#pragma mark -
#pragma mark - click event
- (IBAction)myLocation:(id)sender {
    [self p_moveToUserLoc];
}

- (IBAction)gotochengdu:(id)sender {
    
    // 成都
    CLLocationCoordinate2D toLoc = CLLocationCoordinate2DMake(30, 104);
    // 当前
    CLLocationCoordinate2D curLoc = self.mapView.userLocation.coordinate;
    
    UIAlertController *alert = [SFJThirdMapNavManager thirdMapNavAlertWithCurrentLocation:curLoc toLocation:toLoc];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
#pragma mark - <MAMapViewDelegate>

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) { // 用户自己的位置，用系统提供的样式
        return nil;
    }
    
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MKPinAnnotationView *annotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        return annotationView;
    }
    return nil;
}

@end
