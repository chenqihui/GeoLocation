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
    MKMapView *_mapV;
    CLLocationManager *_locationManager;
}

//@property(nonatomic, assign) CLLocationManager *locationManager;

@end

@implementation QHLocationManager

+ (QHLocationManager *)defaultManager
{
    static dispatch_once_t onceToken = 0;
    __strong static QHLocationManager *_defaultManager = nil;
    dispatch_once(&onceToken, ^
    {
        _defaultManager = [[self alloc] init];
    });
    
    return _defaultManager;
}

- (void)setMapView:(MKMapView *)mapView
{
    _mapV = mapView;
}

- (void)startLocation
{
//    _mapV.showsUserLocation=YES;
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
//    _mapV.showsUserLocation = NO;
//    _mapV = nil;
    
    [_locationManager stopUpdatingLocation];
}

#pragma mark - Corelocation Delegate

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations objectAtIndex:0];
    
    NSLog(@"%@", location);
    
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    MKCoordinateRegion theRegion;
    theRegion.center=[[_locationManager location] coordinate];
    theRegion.span=theSpan;
    [_mapV setRegion:theRegion];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"didFailWithError: %@", error);
}

@end
