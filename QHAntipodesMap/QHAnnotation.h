//
//  QHAnnotation.h
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import <MapKit/MapKit.h>

//必须实现的，坐标对象，实现<MKAnnotation>
@interface QHAnnotation : NSObject<MKAnnotation>

@property (nonatomic,retain) NSString *title2;
@property (nonatomic,retain) NSString *subtitle2;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

//创建注标对象
- (id)initWithTitle:(NSString*)title SubTitle:(NSString*)subtitle Coordinate:(CLLocationCoordinate2D)coordinate;

@end
