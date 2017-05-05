//
//  YJPhotoDisplayCollectionViewCell.h
//  YuJia
//
//  Created by 万宇 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWComposeImageView.h"
@interface YJPhotoDisplayCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) IWComposeImageView* imageView;
@property(nonatomic,weak)UIImage *photo;
@end
