//
//  MMTextField.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/6/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "MMTextField.h"

@implementation MMTextField
- (id)initWithFrame:(CGRect)frame

{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        // Initialization code
        
    }
    
    return self;
    
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 10, 0);
    
}
-(CGRect)editingRectForBounds:(CGRect)bounds{
    
    return CGRectInset(bounds, 10, 0);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
