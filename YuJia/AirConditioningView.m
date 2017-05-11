//
//  AirConditioningView.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AirConditioningView.h"

@implementation AirConditioningView
- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect imageRect = self.imageView.frame;
    imageRect.size = CGSizeMake(28, 28);
    imageRect.origin.x = (self.frame.size.width - 28) * 0.5;
    imageRect.origin.y = 12.5;
    
    
    
    CGRect titleRect = self.titleLabel.frame;
    titleRect.origin.x = (self.frame.size.width - titleRect.size.width) * 0.5;
    titleRect.origin.y = imageRect.origin.y +38;
    
    self.imageView.frame = imageRect;
    self.titleLabel.frame = titleRect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
