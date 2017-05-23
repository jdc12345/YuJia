//
//  YJSelectView.m
//  YuJia
//
//  Created by 万宇 on 2017/5/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJSelectView.h"

@implementation YJSelectView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.floor.textAlignment = NSTextAlignmentCenter;
    self.allFloor.textAlignment = NSTextAlignmentCenter;
    [self.tvBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.broadbandBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.AirConditioningBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.waterBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bedBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.supHeatingBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.washerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.iceBoxBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *boxBtn = [self viewWithTag:21];
    self.boxBtn = boxBtn;
    [boxBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *sofaBtn = [self viewWithTag:22];
    self.sofaBtn = sofaBtn;
    [sofaBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UITextField *rentMoney = [self viewWithTag:23];
    self.rentMoney = rentMoney;
    UIButton *conditionBtn = [self viewWithTag:24];
    self.conditionBtn = conditionBtn;
}
-(void)btnClick:(UIButton*)sender{
    sender.selected = !sender.isSelected;

}
@end
