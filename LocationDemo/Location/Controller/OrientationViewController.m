//
//  OrientationViewController.m
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/18.
//  Copyright (c) 2015年 LRR. All rights reserved.
//

#import "OrientationViewController.h"
#import <MapKit/MapKit.h>

#import "AreaListCell.h"

typedef NS_ENUM(NSInteger,OrientationSectionType){
    OrientationSectionTypeTip = 0,
    OrientationSectionTypeOrientation = 1,
    OrientationSectionTypeNormal = 2,
};

@interface OrientationViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate>
{
    // 定位
    CLLocationManager * _locationManager;
    NSString *_orientationResult;
}
@property (nonatomic,strong) AreaListCell *orientationCell;
@end

@implementation OrientationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableViewCellClass = @"AreaListCell";
    
    // 设置已选的位置的string: "广东省 深圳市" >> "中国 广东省 深圳市"
    NSString *chinaStr = nil;
    if ([self.selectedString componentsSeparatedByString:@" "].count>1) {  // 中国省份
        chinaStr = @"中国 ";
    }
    // 初始化根节点(所有国家)
    LocationNode *rootNode = [LocationNode nodeWithNodeName:@""];
    [rootNode addAreaDataWithSelectedString:[NSString stringWithFormat:@"%@ %@",chinaStr,self.selectedString]];
    self.rootNode = rootNode;

    // 初始化定位管理器
    [self initializeLocationService];
    
}


#pragma mark - CLLocationManagerDelegate---------------定位回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * location = [locations lastObject];
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    
    // 反地理编码: 经纬度>>物理地址
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error || placemarks.count == 0){
            NSLog(@"error");
        }else{
            CLPlacemark * place = [placemarks lastObject];
            if (place.name.length >0) {
                //获取城市
                NSString *city = place.locality;
                if (!city) {
                    //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                    city = place.administrativeArea;
                }else{
                    // 广东省 深圳市
                    city = [NSString stringWithFormat:@"%@ %@",place.administrativeArea,city];
                }
                
                _orientationResult = city;
                [self.orientationCell setTitle:city];
                [_locationManager stopUpdatingLocation];
            }
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    // 定位失败回调
}


// 授权状态发生改变的时候执行
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch(status){
            
            // 用户在设置里关闭了「定位」
        case kCLAuthorizationStatusDenied:
        {
//            [self showSkipToLocationServicesEnabledAlert];
            //         如果没有开启，对用户进行提示
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您没有开启定位功能" delegate:nil cancelButtonTitle:@"确定"  otherButtonTitles:nil, nil];
            [alertView show];

        }
            break;
        
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusNotDetermined:
        {
            // 允许在「使用改应用时」访问您的位置吗
            if([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                [_locationManager requestWhenInUseAuthorization];
            }
        }
            break;
            
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            // 如果用户既打开了「定位」，又「允许该应用访问位置」，那么下一次进入该VC会直接走这个case
            if (_orientationResult.length == 0) {
                //开始定位
                [_locationManager startUpdatingLocation];
            }
        }
        default:
            break;
    }
}


#pragma mark -- tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return OrientationSectionTypeNormal + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 提示段: 选择常在地、定位城市
    if (section == OrientationSectionTypeTip) {
        if (self.openOrientation) {
            return 2;
        }else{
            return 1;
        }
    }
    
    if (section == OrientationSectionTypeOrientation){
        if (self.openOrientation) {
            return 1;
        }else{
            return 0;
        }
    }
    
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    // 固定的提示cell: 「选择常在地」/「定位城市」
    if (indexPath.section == OrientationSectionTypeTip) {
        
        AreaListCell *cell = [[NSBundle mainBundle] loadNibNamed:@"AreaListCell" owner:self options:NULL][0];
        cell.cellType = AreaListCellTypeTip;
        if (indexPath.row == 0) {
            [cell setTitle:@"选择常在地"];
        }else if(indexPath.row == 1){
            [cell setTitle:@"定位城市"];
        }
        return cell;
    }
    
    
    if (indexPath.section == OrientationSectionTypeOrientation){
        return self.orientationCell;
    }
    
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == OrientationSectionTypeNormal) {
        
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
        
    }else if (indexPath.section == OrientationSectionTypeOrientation) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        if (self.callbackBlock&&_orientationResult.length>0) {
            self.callbackBlock(_orientationResult);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [_locationManager startUpdatingLocation];
        }
        
    }else if (indexPath.section == OrientationSectionTypeTip) {
    
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    }
}


#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            //跳转定位服务设置界面
            NSURL *url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
}


#pragma mark -- 初始化定位管理器
- (void)initializeLocationService {
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    // 设置过滤器为无
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    // 设置精度
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    
}


#pragma mark -- 定位跳转提示
- (void)showSkipToLocationServicesEnabledAlert{
    // 如果没有开启，对用户进行提示
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您没有开启定位功能\n是否开启定位功能?" delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"确定", nil];
    alertView.tag = 1000;
    [alertView show];
}


#pragma mark -- setter&getter
- (AreaListCell*)orientationCell{
    if (!_orientationCell) {
        _orientationCell = [[NSBundle mainBundle] loadNibNamed:@"AreaListCell" owner:self options:NULL][0];
        _orientationCell.cellType = AreaListCellTypeOrientation;
        [_orientationCell setTitle:@"定位中..."];
    }
    return _orientationCell;
}

@end

