//
//  AirConditioningViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AirConditioningViewController.h"
#import "AirConditioningView.h"
#import "AirModelViewController.h"
#import "AirSpeedViewController.h"
#import "AirDirectionViewController.h"
#import "AirTimingViewController.h"

@interface AirConditioningViewController ()

@property (nonatomic, strong) UILabel *figureLabel;

@property (nonatomic, weak) UIView *modelV;
@property (nonatomic, weak) UIView *speedV;
@property (nonatomic, weak) UIView *directionV;
@property (nonatomic, weak) UIView *timingV;


@end

@implementation AirConditioningViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"空调";
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
    imageV.image = [UIImage imageNamed:@"00"];
    
    [self.view addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(84);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(110 ,110));
    }];
    
    
    // 圈内文字
    
    UILabel *figureLabel = [[UILabel alloc]init];
    figureLabel.text = @"22";
//    figureLabel.backgroundColor = [UIColor redColor];
    figureLabel.textColor = [UIColor colorWithHexString:@"666666"];
    figureLabel.font = [UIFont fontWithName:kPingFang_M size:30];
    figureLabel.textAlignment = NSTextAlignmentCenter;
    
    [imageV addSubview:figureLabel];
    self.figureLabel = figureLabel;
    
    [figureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageV).with.offset(0);
        make.centerX.equalTo(imageV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(40 ,26));
    }];
    
    
    UILabel *cLabel = [[UILabel alloc]init];
    cLabel.text = @"℃";
    cLabel.textColor = [UIColor colorWithHexString:@"666666"];
    cLabel.font = [UIFont systemFontOfSize:12];
    cLabel.textAlignment = NSTextAlignmentLeft;
    
    [imageV addSubview:cLabel];
    
    [cLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(figureLabel.mas_top).with.offset(5);
        make.left.equalTo(figureLabel.mas_right).with.offset(-3);
        make.size.mas_equalTo(CGSizeMake(24 ,12));
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"当前温度";
    titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    titleLabel.font = [UIFont systemFontOfSize:11];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [imageV addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(figureLabel.mas_bottom).with.offset(8);
        make.centerX.equalTo(imageV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(50 ,11));
    }];
    
    
    //／／／／／／／／
    
    UIImageView *leftImageV = [[UIImageView alloc]init];
    leftImageV.image = [UIImage imageNamed:@"subtract"];
    [leftImageV sizeToFit];
    leftImageV.tag = 300;
    UITapGestureRecognizer *tapGestLeft = [[UITapGestureRecognizer alloc]init];
    [tapGestLeft addTarget:self action:@selector(changeTemperature:)];
    leftImageV.userInteractionEnabled = YES;
    [leftImageV addGestureRecognizer:tapGestLeft];
    
    
    [self.view addSubview:leftImageV];
    
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageV.mas_centerY).with.offset(0);
        make.right.equalTo(imageV.mas_left).with.offset(-40);
    }];
    
    
    UIImageView *rightImageV = [[UIImageView alloc]init];
    rightImageV.tag = 301;
    rightImageV.image = [UIImage imageNamed:@"add"];
    [rightImageV sizeToFit];
    UITapGestureRecognizer *tapGestRight = [[UITapGestureRecognizer alloc]init];
    [tapGestRight addTarget:self action:@selector(changeTemperature:)];
    rightImageV.userInteractionEnabled = YES;
    [rightImageV addGestureRecognizer:tapGestRight];
    
    [self.view addSubview:rightImageV];
    
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageV.mas_centerY).with.offset(0);
        make.left.equalTo(imageV.mas_right).with.offset(40);
    }];
    
    
    // 开关
    
    UISwitch *switch0 = [[UISwitch alloc]init];
    switch0.onTintColor= [UIColor colorWithHexString:@"00bfff"];
    switch0.tintColor = [UIColor colorWithHexString:@"cccccc"];
    // 控件大小，不能设置frame，只能用缩放比例
    switch0.transform= CGAffineTransformMakeScale(0.8,0.75);
    [self.view addSubview:switch0];
    [switch0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(imageV.mas_bottom).with.offset(20);
    }];
    
    // 中间灰条
    UILabel *grayLabelBottom = [[UILabel alloc]init];
    grayLabelBottom.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    [self.view addSubview:grayLabelBottom];
    
    [grayLabelBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(switch0.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW ,10));
    }];
    
    
    NSArray *nameList = @[@"自动",@"中速",@"上下风",@"00:00"];
    NSArray *iconList = @[@"self-motion",@"medium",@"winddirection",@"timing"];
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
    AirModelViewController *modelVC = [[AirModelViewController alloc]init];
    modelVC.view.frame = CGRectMake(0, 352.25 , kScreenW, kScreenH -352.25);

    [self.view addSubview:modelVC.view];
    [self addChildViewController:modelVC];
    self.modelV = modelVC.view;

    
    
    AirSpeedViewController *speedVC = [[AirSpeedViewController alloc]init];
    speedVC.view.frame = CGRectMake(0, 352.25 , kScreenW, kScreenH -352.25);
    speedVC.view.hidden = YES;
    [self.view addSubview:speedVC.view];
    [self addChildViewController:speedVC];
    self.speedV = speedVC.view;
    
    AirDirectionViewController *directionVC = [[AirDirectionViewController alloc]init];
    directionVC.view.frame = CGRectMake(0, 352.25 , kScreenW, kScreenH -352.25);
    directionVC.view.hidden = YES;
    [self.view addSubview:directionVC.view];
    [self addChildViewController:directionVC];
    self.directionV = directionVC.view;
    
    AirTimingViewController *timingVC = [[AirTimingViewController alloc]init];
    timingVC.view.frame = CGRectMake(0, 352.25 , kScreenW, kScreenH -352.25);
    timingVC.view.tag = 403;
    timingVC.view.hidden = YES;
    [self.view addSubview:timingVC.view];
    [self addChildViewController:timingVC];
    self.timingV = timingVC.view;
    
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
