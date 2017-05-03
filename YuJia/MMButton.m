//
//  MMButton.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/3.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "MMButton.h"

@implementation MMButton




- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect imageRect = self.imageView.frame;
    imageRect.size = CGSizeMake(18, 18);
    imageRect.origin.x = (self.frame.size.width - 18) * 0.5;
    imageRect.origin.y = 25;
    
    
    
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
