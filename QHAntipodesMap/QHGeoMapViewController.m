//
//  QHGeoMapViewController.m
//  QHAntipodesMap
//
//  Created by chen on 14-8-4.
//  Copyright (c) 2014年 chen. All rights reserved.
//

#import "QHGeoMapViewController.h"

#import "QHAnnotation.h"

@interface QHGeoMapViewController ()<MKMapViewDelegate>
{
    MKMapView *_geoMapV;
}

@end

@implementation QHGeoMapViewController

- (void)viewDidLoad
{
    _geoMapV = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _geoMapV.mapType = MKMapTypeStandard;
    _geoMapV.delegate = self;
    [self.view addSubview:_geoMapV];
}

- (void)addGeoCLLocationCoordinate2D:(CLLocationCoordinate2D)coordinate
{
    [_geoMapV removeAnnotations:_geoMapV.annotations];
    QHAnnotation* an = [[QHAnnotation alloc] initWithTitle:@"未知" SubTitle:@"" Coordinate:coordinate];
    [_geoMapV addAnnotation:an];
    [an release];
    
    //得到定位后的位置
    MKCoordinateSpan span = MKCoordinateSpanMake(10, 10);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [_geoMapV setRegion:region animated:YES];
    
    CLGeocoder *clGeoCoder = [[[CLGeocoder alloc] init] autorelease];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks, NSError *error)
    {
        for (CLPlacemark * placeMark in placemarks)
        {
            NSDictionary *addressDic=placeMark.addressDictionary;
            
            __block NSString *Name = [addressDic objectForKey:@"Name"];
            __block NSString *FormattedAddressLines = [[addressDic objectForKey:@"FormattedAddressLines"] objectAtIndex:0];
            
            __async_main__, ^
            {
                [_geoMapV removeAnnotations:_geoMapV.annotations];
                QHAnnotation* an = [[QHAnnotation alloc] initWithTitle:Name SubTitle:FormattedAddressLines Coordinate:coordinate];
                [_geoMapV addAnnotation:an];
                [an release];
            });
        }
    };
    CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView* pinView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    if (pinView == nil)
    {
        pinView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ID"] autorelease];
    }
    
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorGreen;
    pinView.animatesDrop = YES;
    
    return pinView;
}

@end
