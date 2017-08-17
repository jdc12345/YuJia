//
//  YJScenePicCollectionVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/8/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJScenePicCollectionVCell.h"

@interface YJScenePicCollectionVCell ()

@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;

@end
@implementation YJScenePicCollectionVCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}
-(void)setPicName:(NSString *)picName{
    _picName = picName;
    self.iconView.image = [UIImage imageNamed:picName];
}
- (void)setupUI
{
    // 设置整个cell的背景颜色
    self.backgroundColor = [UIColor whiteColor];
    
    // 创建子控件
    UIImageView* iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"housekeeping"];
    [self.contentView addSubview:iconView];
    
    // 自动布局
    [iconView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(self.contentView);
        make.width.height.offset(56*kiphone6);
    }];
    
    self.iconView = iconView;
}
-(void)setSelected:(BOOL)selected{
    if (selected) {
        self.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
