//
//  IWComposeImageView.h
//  WeiBo17
//
//  Created by teacher on 15/8/26.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IWComposeImageView : UIImageView
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickBtnBlock)(NSInteger tag);
@end
