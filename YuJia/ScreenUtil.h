//
//  ScreenUtil.h
//  Qiandaodao
//
//  Created by Liu Terry on 7/18/16.
//  Copyright © 2016 Qiandaodao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenUtil : NSObject

+ (CGFloat)screenWidth;

+ (CGFloat)screenHeight;

+ (CGFloat)RATE;

+ (CGFloat)RATEH;

/**
 
 ****  主要文字
 
 */

/**登录注册按钮与标题*/

+ (CGFloat)font_Title;

/**页面一级标题文字*/

+ (CGFloat)font_first_title;

/**大多数文字、导航列表、昵称等*/

+ (CGFloat)font_normal_title;

/**说明文字、时况正文*/

+ (CGFloat)font_explain_title;

/**解释性、辅助说明、提醒*/

+ (CGFloat)font_remind_title;


/**
 
 ****  主要尺寸
 
 */

/**通用边距*/

+ (CGFloat)commonScreenSideMargin;

@end
