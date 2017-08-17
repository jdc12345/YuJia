//
//  YJAddRoomBackgroundImageVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJAddRoomBackgroundImageVC.h"
#import "UILabel+Addition.h"

@interface YJAddRoomBackgroundImageVC ()

@end

@implementation YJAddRoomBackgroundImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房间照片";
    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [self setupUI];
}
- (void)setupUI{
    //默认图片
    UILabel *defaultImageLabel = [UILabel labelWithText:@"默认图片" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    [self.view addSubview:defaultImageLabel];
    [defaultImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.offset(25*kiphone6);
    }];
    UIButton *oneImageBtn = [[UIButton alloc]init];
    [oneImageBtn setImage:[UIImage imageNamed:roomBackImages[0]] forState:UIControlStateNormal];
    [self.view addSubview:oneImageBtn];
    [oneImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(defaultImageLabel.mas_bottom).offset(15*kiphone6);
        make.width.offset(112.5*kiphone6);
        make.height.offset(200*kiphone6);
    }];
    UIButton *twoImageBtn = [[UIButton alloc]init];
    [twoImageBtn setImage:[UIImage imageNamed:roomBackImages[1]] forState:UIControlStateNormal];
    [self.view addSubview:twoImageBtn];
    [twoImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneImageBtn.mas_right).offset(10*kiphone6);
        make.top.equalTo(defaultImageLabel.mas_bottom).offset(15*kiphone6);
        make.width.offset(112.5*kiphone6);
        make.height.offset(200*kiphone6);
    }];
    //拍摄照片
    UILabel *shotPhotoLabel = [UILabel labelWithText:@"拍摄照片" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    [self.view addSubview:shotPhotoLabel];
    [shotPhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(oneImageBtn.mas_bottom).offset(25*kiphone6);
    }];
    UIView *shotView = [[UIView alloc]init];
    shotView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shotView];
    [shotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(shotPhotoLabel.mas_bottom).offset(15*kiphone6);
        make.height.offset(75*kiphone6);
    }];
    //从相册选取
    UILabel *fromAlbumLabel = [UILabel labelWithText:@"从相册选取" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    [self.view addSubview:fromAlbumLabel];
    [fromAlbumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(shotView.mas_bottom).offset(25*kiphone6);
    }];
    UIView *albumView = [[UIView alloc]init];
    albumView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:albumView];
    [albumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(fromAlbumLabel.mas_bottom).offset(15*kiphone6);
        make.height.offset(75*kiphone6);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
