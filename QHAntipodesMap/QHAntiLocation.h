//
//  AntiLocation.h
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface QHAntiLocation : NSObject

+ (CLLocationCoordinate2D) antipode:(CLLocationCoordinate2D)coordinate;

@end
