//
//  EquipmentModel.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "EquipmentModel.h"

@implementation EquipmentModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/**
 * PS:用自己的属性，代替字典里的
 */
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"info_id" : @"id"};
}

//- (NSDictionary *)backDict{
//    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:2];
//    dict setValue:<#(nullable id)#> forKey:<#(nonnull NSString *)#>
//}
- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if ([propertyName isEqualToString:@"info_id"]) {
            propertyName = @"id";
        }
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

@end
