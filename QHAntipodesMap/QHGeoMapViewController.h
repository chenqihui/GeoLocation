//
//  QHGeoMapViewController.h
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface QHGeoMapViewController : UIViewController

- (void)addGeoCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate;

- (void)setFrame:(CGRect)frame;

@end
