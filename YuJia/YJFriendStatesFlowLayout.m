//
//  YJFriendStatesFlowLayout.m
//  YuJia
//
//  Created by 万宇 on 2017/7/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJFriendStatesFlowLayout.h"

@implementation YJFriendStatesFlowLayout
// 准备布局
// 这个方法在调用的时候collectionView已经有的大小
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 计算cell的宽高
    // CGFloat w = (self.collectionView.bounds.size.width-50*kiphone6) / 4;
    // CGFloat h = (self.collectionView.bounds.size.height-23.5*kiphone6) / 2;
    CGFloat w = 93*kiphone6;
    CGFloat h = 93*kiphone6;
    // cell的大小
    self.itemSize = CGSizeMake(w, h);
    
    // cell间的间距
    self.minimumInteritemSpacing = 10*kiphone6;
    // 行间距
    self.minimumLineSpacing = 10*kiphone6;
    //
    //    // 组的内间距
    self.sectionInset = UIEdgeInsetsMake(0, 0, 10*kiphone6, 0);
}

@end
