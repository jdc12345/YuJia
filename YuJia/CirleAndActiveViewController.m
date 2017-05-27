//
//  CirleAndActiveViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/27.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "CirleAndActiveViewController.h"
#import "MyActiveViewController.h"
#import "MyCircleViewController.h"

@interface CirleAndActiveViewController ()
@property (nonatomic, assign) BOOL isCircle;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) MyActiveViewController *myActiveVC;
@property (nonatomic, weak) MyCircleViewController *mycircleVC;
@property (nonatomic, weak) UIView *myActiveView;
@property (nonatomic, weak) UIView *myCircleView;
@end

@implementation CirleAndActiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeVCType)];
    [titleView addGestureRecognizer:tapGest];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"我的圈子";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel = titleLabel;
    [titleView addSubview:titleLabel];
    
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView).with.offset(0);
        make.left.equalTo(titleView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(70, 17));
    }];
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"v"]];
    [imageV sizeToFit];
    [titleView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView).with.offset(0);
        make.left.equalTo(titleLabel.mas_right).with.offset(10);
        //        make.size.mas_equalTo(CGSizeMake(17, 15));
    }];
    
    
    self.navigationItem.titleView = titleView;
    
    
    MyCircleViewController *sightVC = [[MyCircleViewController alloc]init];
//    sightVC.dataSource = self.sightDataSource;
    sightVC.view.frame = CGRectMake(0, 64, kScreenW, kScreenH -64);
    
    self.myCircleView = sightVC.view;
    self.mycircleVC = sightVC;
    [self.view addSubview:sightVC.view];
    [self addChildViewController:sightVC];
    
    
    MyActiveViewController *equipmentVC = [[MyActiveViewController alloc]init];
    equipmentVC.view.frame = CGRectMake(0, 64, kScreenW, kScreenH -64);
    equipmentVC.view.hidden = YES;
    self.myActiveVC = equipmentVC;
    self.myActiveView = equipmentVC.view;
    [self.view addSubview:equipmentVC.view];
    [self addChildViewController:equipmentVC];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)changeVCType{
    if ([self.titleLabel.text isEqualToString:@"我的圈子"]) {
        self.titleLabel.text = @"我的活动";
        self.myActiveView.hidden = NO;
        self.myCircleView.hidden = YES;
    }else
    {
        self.titleLabel.text = @"我的圈子";
        self.myActiveView.hidden = YES;
        self.myCircleView.hidden = NO;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
