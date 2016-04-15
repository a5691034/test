//
//  LocationViewController.m
//  test
//
//  Created by Apple on 15/10/12.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "LocationViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationViewController () <CLLocationManagerDelegate>
{
    UILabel *_label;
}
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    [self uiConfig];
    
}

- (void)prepareData {
    self.manager = [[CLLocationManager alloc] init];
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"GPS Sever can useful");
        
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;//精确度
        self.manager.distanceFilter = 0.05;//距离
        self.manager.delegate = self;
        
        /*
         在info.plist中加入下面两条
         NSLocationAlwaysUsageDescription   提示信息"我们需要使用您的地理位置"
         NSLocationWhenInUseUsageDescription    提示信息"我们需要使用您的地理位置"
         
         再加上下面一句话
         */
        [self.manager requestAlwaysAuthorization];
        
    }
}

- (void)uiConfig {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightBtnAction)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.frame.size.width - 40, 50)];
    label.numberOfLines = 0;
    _label = label;
    [self.view addSubview:label];
}

- (void)rightBtnAction  {
    [self.manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    if (locations.count > 0) {
        CLLocation *l = [locations objectAtIndex:0];
        NSLog(@"[%f,%f]",l.coordinate.latitude,l.coordinate.longitude);
        
        
        CLLocationCoordinate2D oldCoordinate = l.coordinate;
        NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
        // 计算两个坐标距离
        //    float distance = [newLocation distanceFromLocation:oldLocation];
        //    NSLog(@"%f",distance);
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:l
                       completionHandler:^(NSArray *placemarks, NSError *error){
                           
                           for (CLPlacemark *place in placemarks) {
                               
                               _label.text = place.name;
                               NSLog(@"name,%@",place.name);                       // 位置名
                               //                           NSLog(@"thoroughfare,%@",place.thoroughfare);       // 街道
                               //                           NSLog(@"subThoroughfare,%@",place.subThoroughfare); // 子街道
                               //                           NSLog(@"locality,%@",place.locality);               // 市
                               //                           NSLog(@"subLocality,%@",place.subLocality);         // 区
                               //                           NSLog(@"country,%@",place.country);                 // 国家
                           }
                           
                       }];
    }
}



@end
