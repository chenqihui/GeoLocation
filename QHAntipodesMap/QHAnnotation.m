//
//  QHAnnotation.m
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHAnnotation.h"

@implementation QHAnnotation

//这个别忘了
- (void)dealloc
{
    self.title2 = nil;
    self.subtitle2 = nil;
    
    [super dealloc];
}

- (id)initWithTitle:(NSString*)title SubTitle:(NSString*)subtitle Coordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.title2 = title;
        self.subtitle2 = subtitle;
        self.coordinate = coordinate;
    }
    return self;
}

//不写你就死定了 直接崩
- (NSString *)title
{
    return _title2;
}

- (NSString *)subtitle
{
    return _subtitle2;
}

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

@end
