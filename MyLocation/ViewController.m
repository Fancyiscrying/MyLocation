//
//  ViewController.m
//  MyLocation
//
//  Created by Fancy on 16/3/1.
//  Copyright © 2016年 Fancy. All rights reserved.
//定位服务编程，参考资料   iOS开发指南   关东升

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>

@interface ViewController ()<CLLocationManagerDelegate>
//经度
@property (weak, nonatomic) IBOutlet UITextField *txtLng;
//纬度
@property (weak, nonatomic) IBOutlet UITextField *txtLat;
//高度
@property (weak, nonatomic) IBOutlet UITextField *txtAlt;

@property (nonatomic, strong)CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UITextView *txtview;
@property CLLocation *currentlocation;
- (IBAction)reverseGeocode:(id)sender;
@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    //开始定位
    [self.locationManager startUpdatingLocation];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.locationManager stopUpdatingLocation];

}
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{

    _currentlocation = [locations lastObject];
    self.txtLat.text = [NSString stringWithFormat:@"%3.5f",_currentlocation.coordinate.latitude];
    self.txtLng.text = [NSString stringWithFormat:@"%3.5f",_currentlocation.coordinate.longitude];
    self.txtAlt.text = [NSString stringWithFormat:@"%3.5f",_currentlocation.altitude];




}
//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);


}
//授权状态发生变化时调用
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{

    if (status ==kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"Authorized");
    }
else if (status ==kCLAuthorizationStatusAuthorizedWhenInUse)
{
    NSLog(@"AuthorizedWhenInUse");

}
    else if (status == kCLAuthorizationStatusDenied)
    {
        NSLog(@"Denied");
    
    }
    else if (status ==kCLAuthorizationStatusRestricted)
    {
        NSLog(@"Restricted");
    
    }
    else if (status ==kCLAuthorizationStatusNotDetermined)
    {
    
        NSLog(@"NotDetemined");
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    //定位服务服务对象初始化
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;//精确度
    self.locationManager.distanceFilter = 1000.0f;//距离过滤器
    //ios8新添加的方法，它们会弹出用户授权对话框
    [self.locationManager requestWhenInUseAuthorization];//在使用应用程序期间
    [self.locationManager requestAlwaysAuthorization];//始终授权
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reverseGeocode:(id)sender {
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_currentlocation completionHandler:^(NSArray *placemarks,NSError *error)
     {
         if ([placemarks count]>0) {
             CLPlacemark *placemark = placemarks[0];
             NSDictionary *addressDictionary = placemark.addressDictionary;
             NSString *address = [addressDictionary objectForKey:(NSString *)kABPersonAddressStreetKey];
             address = address ==nil? @"":address;
             NSString *state = [addressDictionary objectForKey:(NSString *)kABPersonAddressStateKey];
             state = state ==nil?@"":state;
             NSString *city = [addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
             city = city ==nil? @"":city;
             self.txtview.text = [NSString stringWithFormat:@"%@\n%@\n%@",state,address,city];
         }
     
     }];
}
@end
