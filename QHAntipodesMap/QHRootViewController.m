//
//  RootViewController.m
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHRootViewController.h"

#import "QHMapLocationViewController.h"
#import "QHGeoMapViewController.h"
#import "QHAntiLocation.h"

#define kDuration 0.7   // 动画持续时间(秒)

@interface QHRootViewController ()<QHMapLocationViewControllerDelegate>
{
    QHMapLocationViewController *_mapVC;
    QHGeoMapViewController *_geoMapVC;
    
    UIView *_mainV;
    
    UIDeviceOrientation _currentOrientation;
    UIButton *_geobtn;
}

@end

@implementation QHRootViewController

- (void)dealloc
{
    [_mapVC release];
    [_geoMapVC release];
    [_mainV release];
    [_geobtn release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    _geobtn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [_geobtn setTitle:@"获取与你在时间相对的另一端点" forState:UIControlStateNormal];
    [_geobtn setTitle:@"返回你的位置" forState:UIControlStateSelected];
    [_geobtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_geobtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_geobtn setBackgroundColor:[UIColor orangeColor]];
//    btn.layer.borderWidth = 6;
    _geobtn.layer.masksToBounds = YES;
    _geobtn.layer.cornerRadius = 6;
    [_geobtn setFrame:CGRectMake(20, 40, 280, 35)];
    [self.view addSubview:_geobtn];
    [_geobtn addTarget:self action:@selector(geoLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    _mainV = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_mainV belowSubview:_geobtn];
    
    _geoMapVC = [[QHGeoMapViewController alloc] init];
    [_geoMapVC.view setFrame:self.view.bounds];
    
    [_mainV addSubview:_geoMapVC.view];
    
    _mapVC = [[QHMapLocationViewController alloc] init];
    [_mapVC.view setFrame:self.view.bounds];
    _mapVC.delegate = self;
    
    [_mainV addSubview:_mapVC.view];
}

- (void)geoLocation:(UIButton *)btn
{
    if (_currentOrientation == UIDeviceOrientationPortrait)
    {
        [btn setSelected:!btn.selected];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = kDuration;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"oglFlip";
        
        if (btn.selected)
            animation.subtype = kCATransitionFromBottom;
        else
            animation.subtype = kCATransitionFromTop;
        
        if ([_mapVC getGeoCLLocationCoordinate2D].latitude == -999 && [_mapVC getGeoCLLocationCoordinate2D].longitude == -999)
        {
            
        }else
            [_geoMapVC addGeoCLLocationCoordinate2D:[QHAntiLocation antipode:[_mapVC getGeoCLLocationCoordinate2D]]];
        NSUInteger green = [[_mainV subviews] indexOfObject:_mapVC.view];
        NSUInteger blue = [[_mainV subviews] indexOfObject:_geoMapVC.view];
        [_mainV exchangeSubviewAtIndex:green withSubviewAtIndex:blue];
        
        [[_mainV layer] addAnimation:animation forKey:@"animation"];
    }else if (_currentOrientation == UIDeviceOrientationLandscapeLeft ||
              _currentOrientation == UIDeviceOrientationLandscapeRight)
    {
    }
}

#pragma mark - NSNotification

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    if ((int)[UIDevice currentDevice].orientation == UIDeviceOrientationFaceUp || (int)[UIDevice currentDevice].orientation ==  UIDeviceOrientationFaceDown)
    {
        return;
    }
    _currentOrientation = (int)[UIDevice currentDevice].orientation;
    
    if(_currentOrientation == UIDeviceOrientationPortrait)
    {
        [_geobtn setHidden:NO];
        [_mainV setFrame:CGRectMake(0, 0, __iphone_width__, __iphone_height__)];
        [_mapVC setFrame:_mainV.bounds];
        [_geoMapVC setFrame:_mainV.bounds];
    }else if (UIDeviceOrientationIsLandscape(_currentOrientation))
    {
        [_geobtn setHidden:YES];
        [_mainV setFrame:CGRectMake(0, 0, __iphone_height__, __iphone_width__)];
        [_mapVC setFrame:CGRectMake(0, 0, __iphone_height__/2, __iphone_width__)];
        [_geoMapVC setFrame:CGRectMake(__iphone_height__/2, 0, __iphone_height__/2, __iphone_width__)];
        
        if ([_mapVC getGeoCLLocationCoordinate2D].latitude == -999 && [_mapVC getGeoCLLocationCoordinate2D].longitude == -999)
            return;
        [_geoMapVC addGeoCLLocationCoordinate2D:[QHAntiLocation antipode:[_mapVC getGeoCLLocationCoordinate2D]]];
    }
}

#pragma mark

- (void)geoCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate
{
    if (UIDeviceOrientationIsLandscape(_currentOrientation))
    {
        [_geoMapVC addGeoCLLocationCoordinate2D:[QHAntiLocation antipode:coordinate]];
    }
}

@end
