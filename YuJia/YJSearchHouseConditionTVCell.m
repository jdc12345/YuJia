//
//  YJSearchHouseConditionTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/7/18.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJSearchHouseConditionTVCell.h"
@interface MTShopDetailOrderFoodCategoryCellBGView : UIView

@end

@implementation MTShopDetailOrderFoodCategoryCellBGView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f8f9fa"];
    }
    return self;
}

// 把黄色的条 画出来
- (void)drawRect:(CGRect)rect
{
    
    CGFloat w = 2.5;
    CGFloat h = 21;
    CGFloat x = 0;
    CGFloat y = (self.bounds.size.height - h) * .5;
    
    // 创建rect
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
    [[UIColor colorWithHexString:@"#00eac6"] set];
    [path fill];
}

@end
@implementation YJSearchHouseConditionTVCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //cell的背景颜色
//        self.contentView.backgroundColor = [UIColor colorWithHex:0xf8f8f8];
//        self.selected= true;
        // 创建选中的view
        MTShopDetailOrderFoodCategoryCellBGView* bgView = [[MTShopDetailOrderFoodCategoryCellBGView alloc] init];
        
        // 设置frame
        //        bgView.frame = self.contentView.bounds;
        // 设置选中的view
        self.selectedBackgroundView = bgView;
        
//        [self textLabel];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
