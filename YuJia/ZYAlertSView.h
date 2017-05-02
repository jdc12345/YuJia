//
//  ZYAlertSView.h
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYAlertSView : UIView

- (instancetype)initWithContentSize:(CGSize)contentSize
                          TitleView:(UIView *)titleView
                         selectView:(UIView *)selectView
                           sureView:(UIView *)sureView;

- (void)show;
- (void)dismiss:(UITapGestureRecognizer *)tap;

@end
