//
//  YJRepairRecordFlowLayout.m
//  YuJia
//
//  Created by 万宇 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJRepairRecordFlowLayout.h"

@implementation YJRepairRecordFlowLayout
// 准备布局
// 这个方法在调用的时候collectionView已经有的大小
- (void)prepareLayout
{
    [super prepareLayout];
    
    // 计算cell的宽高
    // CGFloat w = (self.collectionView.bounds.size.width-50*kiphone6) / 4;
    // CGFloat h = (self.collectionView.bounds.size.height-23.5*kiphone6) / 2;
    CGFloat w = 56*kiphone6;
    CGFloat h = 56*kiphone6;
    // cell的大小
    self.itemSize = CGSizeMake(w, h);
    
    // cell间的间距
    self.minimumInteritemSpacing = 12*kiphone6;
    // 行间距
    self.minimumLineSpacing = 10*kiphone6;
    //
    //    // 组的内间距
    self.sectionInset = UIEdgeInsetsMake(3.5*kiphone6, 10*kiphone6, 10*kiphone6, 10*kiphone6);
}

@end
