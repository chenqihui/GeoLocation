//
//  QHLocationManager.h
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface QHLocationManager : NSObject

+ (QHLocationManager *)defaultManager;

- (void)setMapView:(MKMapView *)mapView;

- (void)startLocation;

-(void)stopLocation;

@end
