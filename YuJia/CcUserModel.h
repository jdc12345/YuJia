//
//  CcUserModel.h
//  KuangWanTV
//
//  Created by 张洋 on 15/12/2.
//  Copyright © 2015年 张洋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface CcUserModel : NSObject

@property (nonatomic, strong) NSString *info_id;
@property (nonatomic, strong) NSString *trueName;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *introduce;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *provider_id;
@property (nonatomic, strong) NSString *provider_uid;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *telephoneNum;

@property (nonatomic,strong) NSArray *userCollectionArr;
@property (nonatomic,strong) NSArray *userAttentionArr;
@property (nonatomic,strong) UIImage *imageAfterChoose;


@property (nonatomic, strong) CLLocation *loation;

+ (CcUserModel *)defaultClient;
- (void)saveAllInfo;
- (void)removeUserInfo;

@end
