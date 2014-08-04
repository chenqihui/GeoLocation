//
//  QHMapLocationViewController.m
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHMapLocationViewController.h"

#import "QHLocationManager.h"
#import "QHAnnotation.h"

@interface QHMapLocationViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, readwrite, retain) MKMapView *mapV;

@end
/*
 这里使用CLLocationManager和MKMapView的showsUserLocation获取用户定位的作用时一样的
 */
@implementation QHMapLocationViewController

- (void)dealloc
{
    [_mapV release];
    [super dealloc];
}

- (void)viewDidLoad
{
//    //初始纬度，经度//latitude = -23.125611058498336, longitude = -66.622473329806212
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(-23.125611058498336, -66.622473329806212);
//    //缩放比例
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
//    //确定一个区域
//    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    
    _mapV = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapV.mapType = MKMapTypeStandard;
    //地图类型
    //MKMapTypeStandard = 0,  标准
    //MKMapTypeSatellite,  卫星
    //MKMapTypeHybrid    混合
//    _mapV.region = region;//显示区域
    _mapV.delegate = self;
//    _mapV.showsUserLocation = YES;
    [self.view addSubview:_mapV];
    
    //定位
    CLLocationManager* manager = [[CLLocationManager alloc]init];
    manager.distanceFilter = 10;//每隔10米定位一次
    manager.desiredAccuracy = kCLLocationAccuracyBest;//精细程度 费电
    manager.delegate = self;
    [manager startUpdatingLocation];
    
    //长按手势 插上大头针
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [_mapV addGestureRecognizer:longPress];
    [longPress release];
}

- (void)reverLocation:(CLLocationCoordinate2D)coordinate
{
    if ([_delegate respondsToSelector:@selector(geoCLLocationCoordinate2D:)])
    {
        [_delegate geoCLLocationCoordinate2D:coordinate];
    }
    CLGeocoder *clGeoCoder = [[[CLGeocoder alloc] init] autorelease];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks, NSError *error)
    {
        for (CLPlacemark * placeMark in placemarks)
        {
            //通过坐标获取位置信息
            NSDictionary *addressDic=placeMark.addressDictionary;
            
//            NSLog(@"%@", addressDic);
//            NSString *state=[addressDic objectForKey:@"State"];
//            NSString *city=[addressDic objectForKey:@"City"];
//            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
//            NSString *street=[addressDic objectForKey:@"Street"];
            NSString *Name = [addressDic objectForKey:@"Name"];
            NSString *FormattedAddressLines = [[addressDic objectForKey:@"FormattedAddressLines"] objectAtIndex:0];
//            self.lastProvince = state;
//            self.lastCity = city;
//            NSString *lastAddress=[NSString stringWithFormat:@"%@%@%@%@",state,city,subLocality,street];
            
            __async_main__, ^
            {
                [_mapV removeAnnotations:_mapV.annotations];
                QHAnnotation* an = [[QHAnnotation alloc] initWithTitle:Name SubTitle:FormattedAddressLines Coordinate:coordinate];
                [_mapV addAnnotation:an];
                [_mapV setCenterCoordinate:coordinate animated:YES];
                [an release];
            });
        }
    };
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
    
//    [[QHLocationManager defaultManager] getAddressInfo:coordinate complete:^(NSDictionary *addressDic) {
//        
//        NSString *Name = [addressDic objectForKey:@"Name"];
//        NSString *FormattedAddressLines = [[addressDic objectForKey:@"FormattedAddressLines"] objectAtIndex:0];
//        
//        [_mapV removeAnnotations:_mapV.annotations];
//        QHAnnotation* an = [[QHAnnotation alloc] initWithTitle:Name SubTitle:FormattedAddressLines Coordinate:coordinate];
//        [_mapV addAnnotation:an];
//        [_mapV setCenterCoordinate:coordinate animated:YES];
//        [an release];
//    }];
}

- (CLLocationCoordinate2D)getGeoCLLocationCoordinate2D
{
    if ([_mapV.annotations count] <= 0)
        return CLLocationCoordinate2DMake(-999, -999);
    return ((QHAnnotation *)[_mapV.annotations objectAtIndex:0]).coordinate;
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [_mapV setFrame:self.view.bounds];
}

#pragma mark - viewDidLoad UILongPressGestureRecognize longPress:
- (void)longPress:(UILongPressGestureRecognizer*)longPress
{
    //长按一次 只在开始插入一次大头针   否则能用大头针写字。。。
    if (longPress.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [longPress locationInView:_mapV];
        CLLocationCoordinate2D coordinate = [_mapV convertPoint:point toCoordinateFromView:_mapV];
        
        [self reverLocation:coordinate];
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //得到定位后的位置
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [_mapV setRegion:region animated:YES];
    
    [self reverLocation:coordinate];
    //停止定位
    [manager stopUpdatingLocation];
    [manager release];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
//    MKCoordinateSpan theSpan;
//    //地图的范围 越小越精确
//    theSpan.latitudeDelta=0.05;
//    theSpan.longitudeDelta=0.05;
//    MKCoordinateRegion theRegion;
//    theRegion.center=[[userLocation location] coordinate];
//    theRegion.span=theSpan;
//    [mapView setRegion:theRegion];
    
//    [self reverLocation:userLocation.coordinate];
    
//    mapView.showsUserLocation = NO;
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //如果是所在地 跳过   固定写法
//    if ([annotation isKindOfClass:[mapView.userLocation class]]) {
//        return nil;
//    }
    MKPinAnnotationView* pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    if (pinView == nil) {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ID"] autorelease];
    }
    
    pinView.canShowCallout = YES;//能显示Call信息 上面那些图字
    pinView.pinColor = MKPinAnnotationColorRed;//只有三种
    //大头针颜色
    //MKPinAnnotationColorRed = 0,
    //MKPinAnnotationColorGreen,
    //MKPinAnnotationColorPurple
    pinView.animatesDrop = YES;//显示动画  从天上落下
    
//    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    view.backgroundColor = [UIColor redColor];
//    pinView.leftCalloutAccessoryView = view;
//    [view release];
//    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    pinView.rightCalloutAccessoryView = button;
    
    return pinView;
}

@end
