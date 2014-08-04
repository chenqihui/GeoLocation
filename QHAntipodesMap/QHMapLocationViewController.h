//
//  QHMapLocationViewController.h
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol QHMapLocationViewControllerDelegate <NSObject>

- (void)geoCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate;

@end

@interface QHMapLocationViewController : UIViewController

@property (nonatomic, readonly, retain) MKMapView *mapV;
@property (nonatomic, assign) id<QHMapLocationViewControllerDelegate> delegate;

- (CLLocationCoordinate2D)getGeoCLLocationCoordinate2D;

@end
