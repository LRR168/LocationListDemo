//
//  AreaListCell.h
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/18.
//  Copyright (c) 2015年 LRR. All rights reserved.
//


#import "ListSelectBaseCell.h"

typedef NS_ENUM(NSInteger, AreaListCellType){
    AreaListCellTypeNormal = 1,
    AreaListCellTypeOrientation,
    AreaListCellTypeTip,
};
@interface AreaListCell : ListSelectBaseCell
@property (nonatomic, assign) AreaListCellType cellType;
@end
