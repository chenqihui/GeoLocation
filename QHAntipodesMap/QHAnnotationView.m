//
//  QHAnnotationView.m
//  QHAntipodesMap
//
//  Created by chen on 14/8/4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHAnnotationView.h"

@implementation QHAnnotationView

- (id)initWithAnnotation:(id <MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    self.canShowCallout = YES;//能显示Call信息 上面那些图字
    self.pinColor = MKPinAnnotationColorRed;//只有三种
    //大头针颜色
    //MKPinAnnotationColorRed = 0,
    //MKPinAnnotationColorGreen,
    //MKPinAnnotationColorPurple
    self.pinColor = MKPinAnnotationColorGreen;
    self.animatesDrop = YES;//显示动画  从天上落下
    
    //注标的标题view
    //    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    //    view.backgroundColor = [UIColor redColor];
    //    pinView.leftCalloutAccessoryView = view;
    //    [view release];
    //
    //    UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    //    pinView.rightCalloutAccessoryView = button;
    
    return self;
}

@end
