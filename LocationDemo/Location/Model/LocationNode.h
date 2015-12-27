//
//  LocationNode.h
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/21.
//  Copyright © 2015年 LRR. All rights reserved.
//

#import "Node.h"

@interface LocationNode : Node
// 加载全球国家数据(根节点调用)
- (void)addAreaDataWithSelectedString:(NSString*)selectedString;

@property (nonatomic, assign,readonly)BOOL isSelectedStyle;
@end



