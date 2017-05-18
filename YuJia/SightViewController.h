//
//  SightViewController.h
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SightViewController : UIViewController
@property (nonatomic, copy) NSArray *dataSource;


- (void)reloadData:(NSArray *)newDataSource;
@end
