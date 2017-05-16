//
//  ScreenUtil.m
//  Qiandaodao
//
//  Created by Liu Terry on 7/18/16.
//  Copyright © 2016 Qiandaodao. All rights reserved.
//

#import "ScreenUtil.h"

@implementation ScreenUtil

+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)RATE {
    return [UIScreen mainScreen].bounds.size.width / 375;
}

+ (CGFloat)RATEH {
    return [UIScreen mainScreen].bounds.size.height / 667;
}

/**
 
 ****  主要文字
 
 */

/**登录注册按钮与标题*/

+ (CGFloat)font_Title {
    return 18;
}

/**页面一级标题文字*/

+ (CGFloat)font_first_title {
    return 16;
}

/**大多数文字、导航列表、昵称等*/

+ (CGFloat)font_normal_title {
    return 14;
}

/**说明文字、时况正文*/

+ (CGFloat)font_explain_title {
    return 13;
}

/**解释性、辅助说明、提醒*/

+ (CGFloat)font_remind_title {
    return 11;
}

/**
 
 ****  主要尺寸
 
 */

/**通用边距*/

+ (CGFloat)commonScreenSideMargin {
    return 10;
}


@end
