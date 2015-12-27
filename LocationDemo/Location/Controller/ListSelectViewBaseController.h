//
//  LocationListSelectViewController.h
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/17.
//  Copyright (c) 2015年 LRR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationNode.h"
@interface ListSelectViewBaseController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) Node *rootNode;
@property (nonatomic, copy) NSString *tableViewCellClass;
@property (nonatomic, copy) void(^callbackBlock)(NSString* backSting);

@end
