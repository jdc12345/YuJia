//
//  DoorLockViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "DoorLockViewController.h"
#import "AirConditioningView.h"
#import "AirModelViewController.h"
#import "AirSpeedViewController.h"
#import "AirDirectionViewController.h"
#import "AirTimingViewController.h"
#import "LockTextViewController.h"
#import "LockFigureViewController.h"
#import "LockShareViewController.h"
#import "LockSettingViewController.h"
@interface DoorLockViewController ()

@property (nonatomic, strong) UILabel *figureLabel;

@property (nonatomic, weak) UIView *modelV;
@property (nonatomic, weak) UIView *speedV;
@property (nonatomic, weak) UIView *directionV;
@property (nonatomic, weak) UIView *timingV;
@end

@implementation DoorLockViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"智能门锁";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setSubView];
    // Do any additional setup after loading the view.
}
- (void)setSubView{
    
    //    UIView *topView = [[UIView alloc]init];
    //    topView.backgroundColor = [UIColor cyanColor];
    //    [self.view addSubview:topView];
    
    
    // 图标
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"lock_door"];
    
    [self.view addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(84);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(110 ,110));
    }];
    
    
    // 开关
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"当前门以锁";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageV.mas_bottom).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,23.5));
    }];
    
    
//    UISwitch *switch0 = [[UISwitch alloc]init];
//    switch0.onTintColor= [UIColor colorWithHexString:@"00bfff"];
//    switch0.tintColor = [UIColor colorWithHexString:@"cccccc"];
//    // 控件大小，不能设置frame，只能用缩放比例
//    switch0.transform= CGAffineTransformMakeScale(0.8,0.75);
//    [self.view addSubview:switch0];
//    [switch0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(imageV.mas_bottom).with.offset(20);
//    }];
    
    // 中间灰条
    UILabel *grayLabelBottom = [[UILabel alloc]init];
    grayLabelBottom.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [self.view addSubview:grayLabelBottom];
    
    [grayLabelBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,10));
    }];
    
    
    NSArray *nameList = @[@"密码解锁",@"指纹解锁",@"分享钥匙",@"设置"];
    NSArray *iconList = @[@"password_door",@"fingerprint_door",@"sharekey_door",@"set_door"];
    CGFloat btnW = kScreenW/4.0;
    for(int i = 0; i<4 ;i++){
        AirConditioningView *leftNavBtn = [AirConditioningView buttonWithType:UIButtonTypeCustom];
        //        leftNavBtn.frame = CGRectMake(i *btnW, 130, btnW, 75);
        
        leftNavBtn.backgroundColor = [UIColor whiteColor];
        if (i == 0) {
            leftNavBtn.backgroundColor = [UIColor colorWithHexString:@"c0eefd"];
        }
        [leftNavBtn setTitle:nameList[i] forState:UIControlStateNormal];
        [leftNavBtn setTitleColor:[UIColor colorWithHexString:@"6a6a6a"] forState:UIControlStateNormal];
        [leftNavBtn setImage:[UIImage imageNamed:iconList[i]] forState:UIControlStateNormal];
        leftNavBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        leftNavBtn.tag = 100 +i;
        [leftNavBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftNavBtn];
        [leftNavBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(grayLabelBottom.mas_bottom).with.offset(0);
            make.left.equalTo(self.view).with.offset(i *btnW);
            make.size.mas_equalTo(CGSizeMake(btnW ,75));
        }];
        
    }
    [self setMyChildController];
    
    // 中间灰条
    UILabel *grayLabel = [[UILabel alloc]init];
    grayLabel.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [self.view addSubview:grayLabel];
    
    [grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayLabelBottom.mas_bottom).with.offset(75);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,10));
    }];
    
    //    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(self.view).with.offset(0);
    //        make.centerX.equalTo(topView).with.offset(0);
    //        make.size.width.mas_equalTo(self.view);
    //        make.bottom.equalTo(grayLabel.mas_bottom);
    //    }];
    
    
}
- (void)btnClick:(UIButton *)sender{
    //    NSLog(@"  %ld",action.selectedSegmentIndex);
    //    if (action.selectedSegmentIndex == 0) {
    //        self.equipmentView.hidden = YES;
    //        self.sightView.hidden = NO;
    //    }else{
    //        self.sightView.hidden = YES;
    //        self.equipmentView.hidden = NO;
    //    }
    for (int i = 0; i<4; i++) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:100 +i];
        btn.backgroundColor = [UIColor whiteColor];
    }
    sender.backgroundColor = [UIColor colorWithHexString:@"c0eefd"];
    
    switch (sender.tag -100) {
        case 0:
            self.modelV.hidden = NO;
            self.speedV.hidden = YES;
            self.directionV.hidden = YES;
            self.timingV.hidden = YES;
            break;
        case 1:
            self.modelV.hidden = YES;
            self.speedV.hidden = NO;
            self.directionV.hidden = YES;
            self.timingV.hidden = YES;
            break;
        case 2:
            self.modelV.hidden = YES;
            self.speedV.hidden = YES;
            self.directionV.hidden = NO;
            self.timingV.hidden = YES;
            break;
        case 3:
            self.modelV.hidden = YES;
            self.speedV.hidden = YES;
            self.directionV.hidden = YES;
            self.timingV.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (void)changeTemperature:(UITapGestureRecognizer *)tapGest{
    NSLog(@"123123");
    NSInteger increase;
    if (tapGest.view.tag == 300) {
        increase = -1;
    }else{
        increase = 1;
    }
    if (16 <= [self.figureLabel.text integerValue] + increase && [self.figureLabel.text integerValue] + increase <=40) {
        self.figureLabel.text = [NSString stringWithFormat:@"%ld",[self.figureLabel.text integerValue] + increase];
    }
    
}
- (void)setMyChildController{
    LockTextViewController *modelVC = [[LockTextViewController alloc]init];
    modelVC.view.frame = CGRectMake(0, 352.25 , kScreenW, kScreenH -352.25);
    [self.view addSubview:modelVC.view];
    [self addChildViewController:modelVC];
    self.modelV = modelVC.view;
    
    
    LockFigureViewController *speedVC = [[LockFigureViewController alloc]init];
    speedVC.view.frame = CGRectMake(0, 352.25 , kScreenW, kScreenH -352.25);
    speedVC.view.hidden = YES;
    [self.view addSubview:speedVC.view];
    [self addChildViewController:speedVC];
    self.speedV = speedVC.view;
    
    LockShareViewController *directionVC = [[LockShareViewController alloc]init];
    directionVC.view.frame = CGRectMake(0, 352.25 , kScreenW, kScreenH -352.25);
    directionVC.view.hidden = YES;
    [self.view addSubview:directionVC.view];
    [self addChildViewController:directionVC];
    self.directionV = directionVC.view;
    
    LockSettingViewController *timingVC = [[LockSettingViewController alloc]init];
    timingVC.view.frame = CGRectMake(0, 352.25 , kScreenW, kScreenH -352.25);
    timingVC.view.tag = 403;
    timingVC.view.hidden = YES;
    [self.view addSubview:timingVC.view];
    [self addChildViewController:timingVC];
    self.timingV = timingVC.view;
    
}
- (void)httpRequestInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mSightSave] method:1 parameters:dict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will ofwten want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
