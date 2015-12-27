//
//  AreaListCell.m
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/18.
//  Copyright (c) 2015年 LRR. All rights reserved.
//

#import "AreaListCell.h"
#import "LocationNode.h"
@interface AreaListCell()
{
    __weak IBOutlet UILabel *_titleLb;
    __weak IBOutlet UIImageView *_orientationImgView;
    __weak IBOutlet NSLayoutConstraint *_imgWidthConstraint;
    __weak IBOutlet UIImageView *_arrow;
}

@end


@implementation AreaListCell

- (void)awakeFromNib {
    
    _imgWidthConstraint.constant = 0;
    _arrow.hidden = YES;
    
    // cell的分割线
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, 44 - 1, [UIScreen mainScreen].bounds.size.width-40, 0.5f)];
    line.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.25f];
    [self addSubview:line];
    
}

- (void)setTitle:(NSString *)title{
    _titleLb.text = title;
}


#pragma mark -- getter&setter

- (void)setNode:(Node *)node{
    [super setNode:node];
    self.cellType = AreaListCellTypeNormal;
    _titleLb.text = node.name;
    if ([node hasChildNode]) {
        _arrow.hidden = NO;
    }else{
        _arrow.hidden = YES;
    }
    
    
    // 是否之前选中过>>>选中style
    if ([node isKindOfClass:[LocationNode class]]) {
        LocationNode *locNode = (LocationNode*)node;
        if (locNode.isSelectedStyle) {
            _titleLb.textColor = [UIColor blueColor];
        }
    }else{
        NSAssert(NO, @"传入AreaListCell的node不是LocationNode类");
    }
}


- (void)setCellType:(AreaListCellType)cellType{
    
    _cellType = cellType;
    
    switch (cellType) {
        case AreaListCellTypeNormal:{
            self.contentView.backgroundColor = ColorWithRGBR(244, 244, 244, 1);
            _arrow.backgroundColor = self.contentView.backgroundColor;
            _titleLb.font = [UIFont fontWithName:@"Helvetica" size:18];
            [_titleLb setTextColor:ColorWithRGBR(69, 70, 71, 1)];
        }
            break;
            
            
        case AreaListCellTypeOrientation:{
            self.contentView.backgroundColor = ColorWithRGBR(245, 75, 100, 1);
            _orientationImgView.backgroundColor = self.contentView.backgroundColor;
            _imgWidthConstraint.constant = 33;
            _titleLb.font = [UIFont fontWithName:@"Helvetica" size:18];
            [_titleLb setTextColor:[UIColor whiteColor]];
        }
            break;
            
            
        case AreaListCellTypeTip:{
            self.contentView.backgroundColor = ColorWithRGBR(244, 244, 244, 1);
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            _titleLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
            [_titleLb setTextColor:ColorWithRGBR(21, 22, 24, 1)];
        }
            break;
            
            
        default:{
            
        }
            break;
    }
}

@end

