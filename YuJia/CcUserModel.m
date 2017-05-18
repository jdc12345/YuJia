//
//  CcUserModel.m
//  KuangWanTV
//
//  Created by 张洋 on 15/12/2.
//  Copyright © 2015年 张洋. All rights reserved.
//

#import "CcUserModel.h"

@implementation CcUserModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}
+ (CcUserModel *)defaultClient{
    static CcUserModel *userModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userModel = [[self alloc]init];
    });
    [userModel setUserModelInfo];
    return userModel;
}
// telephoneNum

- (void)saveAllInfo{
    [[NSUserDefaults standardUserDefaults] setValue:self.avatar forKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] setValue:self.nickname forKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] setValue:self.gender forKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] setValue:self.introduce forKey:@"introduce"];
    [[NSUserDefaults standardUserDefaults] setValue:self.uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] setValue:self.provider_id forKey:@"provider_id"];
    [[NSUserDefaults standardUserDefaults] setValue:self.provider_uid forKey:@"provider_uid"];
    [[NSUserDefaults standardUserDefaults] setValue:self.userToken forKey:@"userToken"];
     [[NSUserDefaults standardUserDefaults] setValue:self.telephoneNum forKey:@"telephoneNum"];
}
- (void)setUserModelInfo{
    self.avatar = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
    self.nickname = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickname"];
    self.gender = [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
    self.introduce = [[NSUserDefaults standardUserDefaults] objectForKey:@"introduce"];
    self.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    self.provider_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"provider_uid"];
    self.provider_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"provider_id"];
    self.userToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
    self.telephoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"telephoneNum"];
}
- (void)removeUserInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"avatar"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nickname"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"gender"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"introduce"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"provider_uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"provider_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userToken"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"telephoneNum"];

}

@end
