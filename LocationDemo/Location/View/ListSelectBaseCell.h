//
//  ListSelectBaseCell.h
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/21.
//  Copyright © 2015年 LRR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationNode.h"

#define ColorWithRGBR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@interface ListSelectBaseCell : UITableViewCell
@property (nonatomic, weak) Node *node;
- (void)setTitle:(NSString*)title;

@end
