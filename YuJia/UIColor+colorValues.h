//
//  UIColor+colorValues.h
//  进度条
//
//  Created by Any on 16/09/26.
//  Copyright (c) 2015年 Any. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (colorValues)
//颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor*) colorWithHexString:(NSString*)color;
+ (UIColor *) colorWithHexString:(NSString *)color alpha:(float)alpha;
@end
