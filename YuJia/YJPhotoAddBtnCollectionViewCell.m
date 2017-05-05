//
//  YJPhotoAddBtnCollectionViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPhotoAddBtnCollectionViewCell.h"

@implementation YJPhotoAddBtnCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(instancetype)init{
    self = [super init];
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

//- (void)setFunctionList:(YYPropertyFunctionList*)functionList
//{
//    _functionList = functionList;
//    // 把数据放在控件上
//    self.iconView.image = [UIImage imageNamed:functionList.icon];
//    self.nameLabel.text = functionList.name;
//}

- (void)setupUI
{
    // 设置整个cell的背景颜色
    self.backgroundColor = [UIColor whiteColor];

    UIButton *btn = [[UIButton alloc]init];
    [btn setImage:[UIImage imageNamed:@"picture_add"] forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(self.contentView);
        //        make.width.height.equalTo(self.contentView);
    }];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnClick:(UIButton *)sender{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(sender.tag);
    }
}
@end
