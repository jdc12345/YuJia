//
//  AirSpeedViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AirSpeedViewController.h"
#import "MMSlider.h"

@interface AirSpeedViewController ()

@end

@implementation AirSpeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"风速调节";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(20);
        make.left.equalTo(self.view).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(50 ,12));
    }];
    
    
    MMSlider *slider = [[MMSlider alloc] init];
    slider.minimumValue = 9;// 设置最小值
    slider.maximumValue = 11;// 设置最大值
    slider.value = (slider.minimumValue + slider.maximumValue) / 2;// 设置初始值
    slider.continuous = YES;// 设置可连续变化
    //    slider.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"progressbar"]];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [slider setMaximumTrackImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [slider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal]; //[UIImage imageNamed:@"button"];
    //    slider.minimumTrackTintColor = [UIColor greenColor]; //滑轮左边颜色，如果设置了左边的图片就不会显示
    //    slider.maximumTrackTintColor = [UIColor redColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
    //    slider.thumbTintColor = [UIColor redColor];//设置了滑轮的颜色，如果设置了滑轮的样式图片就不会显示
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    
    [self.view addSubview:slider];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.view).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(kScreenW -50,10));
    }];
    
    
    
    
    UIImageView *leftImageV = [[UIImageView alloc]init];
    leftImageV.image = [UIImage imageNamed:@"slow_small"];
    [leftImageV sizeToFit];
    [self.view addSubview:leftImageV];
    
    [leftImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(slider.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(25);
        //        make.size.mas_equalTo(CGSizeMake(kScreenW -50,10));
    }];
    
    UIImageView *mediumImageV = [[UIImageView alloc]init];
    mediumImageV.image = [UIImage imageNamed:@"medium_small"];
    [mediumImageV sizeToFit];
    [self.view addSubview:mediumImageV];
    
    [mediumImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(slider.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view).with.offset(0);
        //        make.size.mas_equalTo(CGSizeMake(kScreenW -50,10));
    }];
    
    
    UIImageView *rightImageV = [[UIImageView alloc]init];
    rightImageV.image = [UIImage imageNamed:@"fast_small"];
    [rightImageV sizeToFit];
    [self.view addSubview:rightImageV];
    
    [rightImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(slider.mas_bottom).with.offset(15);
        make.right.equalTo(self.view).with.offset(-25);
        //        make.size.mas_equalTo(CGSizeMake(kScreenW -50,10));
    }];
    
    UILabel *leftLabel = [[UILabel alloc]init];
    leftLabel.text = @"慢速";
    leftLabel.textColor = [UIColor colorWithHexString:@"f1f1f1"];
    leftLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:leftLabel];
    
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(slider.mas_bottom).with.offset(16);
        make.left.equalTo(leftImageV.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(30,12));
    }];
    
    UILabel *rightLabel = [[UILabel alloc]init];
    rightLabel.text = @"快速";
    rightLabel.textColor = [UIColor colorWithHexString:@"f1f1f1"];
    rightLabel.font = [UIFont systemFontOfSize:12];
    
    [self.view addSubview:rightLabel];
    
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(slider.mas_bottom).with.offset(16);
        make.right.equalTo(self.view).with.offset(-25 -13 -5);
        make.size.mas_equalTo(CGSizeMake(30,12));
    }];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)sliderValueChanged:(UISlider *)slider{
    
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
