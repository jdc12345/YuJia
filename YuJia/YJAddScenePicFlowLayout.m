//
//  YJAddScenePicFlowLayout.m
//  YuJia
//
//  Created by 万宇 on 2017/8/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJAddScenePicFlowLayout.h"

@implementation YJAddScenePicFlowLayout
// 准备布局
// 这个方法在调用的时候collectionView已经有的大小
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 计算cell的宽高
    CGFloat w = (self.collectionView.bounds.size.width-2)  / 3;
    CGFloat h = w;
    
    // cell的大小
    self.itemSize = CGSizeMake(w, h);
    
    // cell间的间距
    self.minimumInteritemSpacing = 1;
    // 行间距
    self.minimumLineSpacing = 1;
    //
    //    // 组的内间距
    //    self.sectionInset = UIEdgeInsetsMake(0, 0, 16, 0);
}@end
