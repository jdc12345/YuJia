//
//  YJHeaderTitleBtn.m
//  YuJia
//
//  Created by 万宇 on 2017/5/3.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHeaderTitleBtn.h"
#import <Masonry.h>
#import "UIColor+colorValues.h"
@implementation YJHeaderTitleBtn

//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self setUI];
//    }
//    return self;
//}
- (instancetype)initWithFrame:(CGRect)frame and:(NSString*)title
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUIWith:(NSString*)title];
    }
    return self;
}
- (void)setUIWith:(NSString*)title{
    self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateNormal];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];

  
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize titleSize = self.titleLabel.bounds.size;
    CGSize imageSize = self.imageView.bounds.size;
    CGFloat interval = 3.0;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
}


@end
