//
//  YJActivitesPhotoTVCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HUImagePickerViewController.h>


@interface YJActivitesPhotoTVCell : UITableViewCell
/** block方式监听点击 */
@property (nonatomic, copy) void (^clickAddBlock)(HUImagePickerViewController *picker);
@property (nonatomic, strong)NSArray *activitypicturelist;//活动已有照片
@property(nonatomic,assign)long isnumber;//用户在该活动已上传的图片数
@property(nonatomic,assign)Boolean isJoined;//用户是否参加了该活动
@property(nonatomic,assign)long activity_id;//该活动id
@end
