//
//  QHLocationManager.m
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHLocationManager.h"

@interface QHLocationManager ()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
}

@end

@implementation QHLocationManager

- (void)releaseDefaultManager
{
    [_locationManager release];
    [_defaultManager release];
}

__strong static QHLocationManager *_defaultManager = nil;

+ (QHLocationManager *)defaultManager
{
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^
    {
        _defaultManager = [[self alloc] init];
    });
    
    return _defaultManager;
}

- (void)startLocation
{
    if (_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
        _locationManager.delegate = self;//设置代理
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
        _locationManager.distanceFilter=1000.0f;//设置距离筛选器
        [_locationManager startUpdatingLocation];//启动位置管理器
    }
    [_locationManager startUpdatingLocation];
}

-(void)stopLocation
{
    [_locationManager stopUpdatingLocation];
}

- (void)getAddressInfo:(CLLocationCoordinate2D)coordinate complete:(void(^)(NSDictionary *addressDic))complete
{
    CLGeocoder *clGeoCoder = [[[CLGeocoder alloc] init] autorelease];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks, NSError *error)
    {
        for (CLPlacemark * placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            //            NSLog(@"%@", addressDic);
            //            NSString *state=[addressDic objectForKey:@"State"];
            //            NSString *city=[addressDic objectForKey:@"City"];
            //            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            //            NSString *street=[addressDic objectForKey:@"Street"];
            //            NSString *Name = [addressDic objectForKey:@"Name"];
            //            NSString *FormattedAddressLines = [[addressDic objectForKey:@"FormattedAddressLines"] objectAtIndex:0];
            //            self.lastProvince = state;
            //            self.lastCity = city;
            //            NSString *lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
            
//            [_mapV removeAnnotations:_mapV.annotations];
//            QHAnnotation* an = [[QHAnnotation alloc] initWithTitle:Name SubTitle:FormattedAddressLines Coordinate:coordinate];
//            [_mapV addAnnotation:an];
//            [_mapV setCenterCoordinate:coordinate animated:YES];
//            [an release];
            
            complete(addressDic);
        }
    };
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
}

#pragma mark - Corelocation Delegate

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:0];
    
    NSLog(@"%@", location);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError: %@", error);
}

@end
