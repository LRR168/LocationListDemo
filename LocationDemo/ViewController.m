//
//  ViewController.m
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/17.
//  Copyright (c) 2015年 LRR. All rights reserved.
//

#import "ViewController.h"
#import "OrientationViewController.h"
@interface ViewController ()
{
    UILabel *_label;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _label = [[UILabel alloc]initWithFrame:self.view.bounds];
    _label.font = [UIFont systemFontOfSize:24];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"点击选择";
    [self.view addSubview:_label];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    OrientationViewController *locVC = [[OrientationViewController alloc]init];
    locVC.callbackBlock = ^(NSString *country) {
        _label.text = country;
    };
//    locVC.selectedString = @"";
    [self.navigationController pushViewController:locVC animated:YES];
}

@end
