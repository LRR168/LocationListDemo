//
//  OrientationViewController.h
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/18.
//  Copyright (c) 2015年 LRR. All rights reserved.
//NSLocationAlwaysUsageDescription
//NSLocationWhenInUseUsageDescription
//CoreLocation
//Mapkit

#import "ListSelectViewBaseController.h"

@interface OrientationViewController : ListSelectViewBaseController
@property(nonatomic,copy) NSString *selectedString;
@property(nonatomic,assign) BOOL openOrientation;
@end
