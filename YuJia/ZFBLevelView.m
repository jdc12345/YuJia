//
//  ZFBLevelView.m
//  02-星星评价
//
//  Created by heima on 16/6/22.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "ZFBLevelView.h"

@implementation ZFBLevelView

// set数据的方法
- (void)setLevel:(float)level
{

    _level = level;

    // 2

    //    for (int i = 0; i < 5; i--) {
    //        level--;
    //        if(level > 0.5){
    //
    //        }else if (level >0){
    //
    //        }else{
    //
    //        }
    //    }

    // --- 全星星
    // 把level强转(只取整数,这个整数就是全星星的个数)
    NSInteger fullStar = (NSInteger)level;

    for (int i = 0; i < fullStar; i++) {
        [self loadStarWithPosition:i andImageName:@"full_star"];
    }

    // --- 半星星
    // 判断是否有.5
    if (((NSInteger)(level / 0.5)) % 2) { // 如果有.5
        [self loadStarWithPosition:fullStar andImageName:@"half_star"];

        fullStar += 1; // 如果是.5的话那么 空星星应该在后一个位置开始添加
    }

    // --- 空星星
    for (NSInteger i = fullStar; i < 5; i++) {
        [self loadStarWithPosition:i andImageName:@"empty_star"];
    }
}

/**
 *  根据位置和图片的名字 添加对应的星星
 *
 *  @param position  位置
 *  @param imageName 星星的图片名称
 */
- (void)loadStarWithPosition:(NSInteger)position andImageName:(NSString*)imageName
{

    UIImageView* imageView = [[UIImageView alloc] init];

    // 计算最左的位置
    CGRect rect = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.height);

    // 根据位置计算应该显示的rect
    CGRect positionRect = CGRectOffset(rect, position * self.bounds.size.height, 0);

    imageView.frame = positionRect;

    imageView.image = [UIImage imageNamed:imageName];
    [self addSubview:imageView];
}

@end
