//
//  AntiLocation.m
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHAntiLocation.h"

@implementation QHAntiLocation

+ (CLLocationCoordinate2D) antipode:(CLLocationCoordinate2D)coordinate
{
    double longitudeCorrection = -180.0;
    
    if (coordinate.longitude < 0.0)
        longitudeCorrection *= -1.0;
    
    CLLocationCoordinate2D antipodeLocation =
    CLLocationCoordinate2DMake(coordinate.latitude * -1.0f, coordinate.longitude + longitudeCorrection);
    
    return antipodeLocation;
}

@end
