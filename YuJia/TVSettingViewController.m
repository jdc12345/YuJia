//
//  TVSettingViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "TVSettingViewController.h"

@interface TVSettingViewController ()
@property (nonatomic, weak) UIButton *changeBtn;

@end

@implementation TVSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"电视";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setSubView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setSubView{
    // 图标
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"tv-1"];
    
    [self.view addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(84);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(110 ,110));
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
    
//    // 中间灰条
//    UILabel *grayLabel = [[UILabel alloc]init];
//    grayLabel.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
//    
//    [self.view addSubview:grayLabel];
//    
//    [grayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(switch0.mas_bottom).with.offset(20);
//        make.centerX.equalTo(self.view).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenW ,10));
//    }];
    
    UIImageView *keyBoardImageV = [[UIImageView alloc]init];
    keyBoardImageV.backgroundColor = [UIColor colorWithHexString:@"38d5cf"];
    keyBoardImageV.userInteractionEnabled = YES;
    
    [self.view addSubview:keyBoardImageV];
    
    [keyBoardImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(switch0.mas_bottom).with.offset(20);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
//        make.size.width.mas_equalTo(kScreenW);
    }];
    
    NSArray *btnNameList = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"切换",@"0",@"返回"];
    NSInteger rowCount;
    NSInteger comment;
    for (int i = 0; i<12; i++) {
        
        rowCount = i/3;
        comment = i%3;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnNameList[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 16.5;
        btn.clipsToBounds = YES;
        btn.layer.borderColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
        btn.layer.borderWidth = 1;
        
        [keyBoardImageV addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(keyBoardImageV).with.offset(34 +rowCount *53);
            make.left.equalTo(keyBoardImageV).with.offset(48 + comment *99);
            make.size.mas_equalTo(CGSizeMake(75 ,33));
        }];
        if (i == 9) {
            self.changeBtn = btn;
        }
        
    }
    // 音量
    UIView *volumeV = [[UIView alloc]init];
    volumeV.backgroundColor = [UIColor clearColor];
    volumeV.layer.cornerRadius = 16.5;
    volumeV.clipsToBounds = YES;
    volumeV.layer.borderColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
    volumeV.layer.borderWidth = 1;
    
    [keyBoardImageV addSubview:volumeV];
    
    [volumeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.changeBtn.mas_bottom).with.offset(34);
        make.left.equalTo(self.changeBtn.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(75 ,125));
    }];
    
    UILabel *volumeLabel = [[UILabel alloc]init];
    volumeLabel.text = @"音量";
    volumeLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    volumeLabel.font = [UIFont fontWithName:kPingFang_M size:17];
    volumeLabel.textAlignment = NSTextAlignmentCenter;
    
    [volumeV addSubview:volumeLabel];
    [volumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(volumeV).with.offset(0);
        make.centerX.equalTo(volumeV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(75 ,17));
    }];
    UIButton *volume_addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    volume_addBtn.backgroundColor = [UIColor clearColor];
    [volume_addBtn setImage:[UIImage imageNamed:@"add_tv"] forState:UIControlStateNormal];
    [volumeV addSubview:volume_addBtn];
    [volume_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(volumeV).with.offset(0);
        make.left.equalTo(volumeV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(75 ,45));
    }];
    UIButton *volume_reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    volume_reduceBtn.backgroundColor = [UIColor clearColor];
    [volume_reduceBtn setImage:[UIImage imageNamed:@"subtract_tv"] forState:UIControlStateNormal];
    [volumeV addSubview:volume_reduceBtn];
    [volume_reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(volumeV).with.offset(0);
        make.left.equalTo(volumeV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(75 ,45));
    }];
    
    
    
    
    
    UIButton *noVolumeV = [UIButton buttonWithType:UIButtonTypeCustom];
    [noVolumeV setTitle:@"静音" forState:UIControlStateNormal];
    [noVolumeV setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    noVolumeV.backgroundColor = [UIColor clearColor];
    noVolumeV.layer.cornerRadius = 16.5;
    noVolumeV.clipsToBounds = YES;
    noVolumeV.layer.borderColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
    noVolumeV.layer.borderWidth = 1;
    
    [keyBoardImageV addSubview:noVolumeV];
    
    [noVolumeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(volumeV.mas_centerY).with.offset(0);
        make.left.equalTo(volumeV.mas_right).with.offset(24);
        make.size.mas_equalTo(CGSizeMake(75 ,75));
    }];
    
    // 频道
    UIView *channelV = [[UIView alloc]init];
    channelV.backgroundColor = [UIColor clearColor];
    channelV.layer.cornerRadius = 16.5;
    channelV.clipsToBounds = YES;
    channelV.layer.borderColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
    channelV.layer.borderWidth = 1;
    
    [keyBoardImageV addSubview:channelV];
    
    [channelV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(noVolumeV.mas_centerY).with.offset(0);
        make.left.equalTo(noVolumeV.mas_right).with.offset(24);
        make.size.mas_equalTo(CGSizeMake(75 ,125));
    }];

    
    UILabel *channelLabel = [[UILabel alloc]init];
    channelLabel.text = @"频道";
    channelLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    channelLabel.font = [UIFont fontWithName:kPingFang_M size:17];
    channelLabel.textAlignment = NSTextAlignmentCenter;
    
    [channelV addSubview:channelLabel];
    [channelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(channelV).with.offset(0);
        make.centerX.equalTo(channelV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(75 ,17));
    }];
    
    UIButton *channel_addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    channel_addBtn.backgroundColor = [UIColor clearColor];
    [channel_addBtn setImage:[UIImage imageNamed:@"up_tv"] forState:UIControlStateNormal];
    [channelV addSubview:channel_addBtn];
    [channel_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(channelV).with.offset(0);
        make.left.equalTo(channelV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(75 ,45));
    }];
    UIButton *channel_reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    channel_reduceBtn.backgroundColor = [UIColor clearColor];
    [channel_reduceBtn setImage:[UIImage imageNamed:@"down_tv"] forState:UIControlStateNormal];
    [channelV addSubview:channel_reduceBtn];
    [channel_reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(channelV).with.offset(0);
        make.left.equalTo(channelV).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(75 ,45));
    }];
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
