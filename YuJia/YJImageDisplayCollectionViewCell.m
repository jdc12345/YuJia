//
//  YJImageDisplayCollectionViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJImageDisplayCollectionViewCell.h"
@interface YJImageDisplayCollectionViewCell()

@property (nonatomic, weak) UIImageView* imageView;
@end
@implementation YJImageDisplayCollectionViewCell
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

-(void)setPhoto:(UIImage *)photo{
    _photo = photo;
    self.imageView.image = photo;
}

- (void)setupUI
{
    // 设置整个cell的背景颜色
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:@"picture_add"];
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    [imageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(self.contentView);
        make.width.height.equalTo(self.contentView);
    }];
}

@end
