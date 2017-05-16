//
//  PickViewController.h
//  TestDemo
//
//  Created by Qian on 2017/5/15.
//  Copyright © 2017年 Qian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickViewController : UIViewController

@property (copy) void (^blocksureBtn)(id sender);

@property (nonatomic, copy)NSString *type;

@property (nonatomic, assign)NSInteger count;

@property (nonatomic, strong) NSArray *dataArr;


@end
