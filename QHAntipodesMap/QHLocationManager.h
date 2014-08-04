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

- (void)startLocation;

-(void)stopLocation;

//通过坐标获取地理位置信息
- (void)getAddressInfo:(CLLocationCoordinate2D)coordinate complete:(void(^)(NSDictionary *addressDic))complete;

@end
