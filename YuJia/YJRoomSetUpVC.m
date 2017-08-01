//
//  YJRoomSetUpVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/1.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJRoomSetUpVC.h"
#import "UIBarButtonItem+Helper.h"

@interface YJRoomSetUpVC ()
@property(nonatomic, weak) UITextField *roomNameTF;//房间名称
@end

@implementation YJRoomSetUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房间设置";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" normalColor:[UIColor colorWithHexString:@"#333333"] highlightedColor:[UIColor colorWithHexString:@"00bfff"] target:self action:@selector(action:)];
    self.view.backgroundColor = [UIColor grayColor];
}
-(void)setEquipmentListData:(NSArray *)equipmentListData{
    _equipmentListData = equipmentListData;
    [self setUPUI];
}
- (void)setUPUI{
   UIView *headerView = [self personInfomation];
    [self.view addSubview:headerView];
}
- (void)action:(NSString *)actionStr{
    NSLog(@"点什么点");
}
- (UIView *)personInfomation{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 130*kiphone6)];
    headView.backgroundColor = [UIColor whiteColor];
    
    NSString *sightName = @"房 间 名 称";
    NSString *startW = @"添 加 照 片";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGRect rect = [sightName boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    
    UITextField  *sightNameText = [[UITextField alloc]init];
    sightNameText.textColor = [UIColor colorWithHexString:@"#333333"];
    sightNameText.font = [UIFont systemFontOfSize:14];
    sightNameText.text = self.roomName;
    sightNameText.layer.cornerRadius = 2.5;
    sightNameText.clipsToBounds = YES;
    sightNameText.layer.borderWidth = 1;
    sightNameText.layer.borderColor = [UIColor colorWithHexString:@"#f1f1f1"].CGColor;
    self.roomNameTF = sightNameText;
    
    
    
    UIButton *selectPictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPictureBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectPictureBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [selectPictureBtn setBackgroundColor:[UIColor colorWithHexString:@"#00eac6"]];
    [selectPictureBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [selectPictureBtn sizeToFit];
    
    
    
    CGRect frame = CGRectMake(0, 0, 10.0, 30*kiphone6);
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    sightNameText.leftViewMode = UITextFieldViewModeAlways;
    sightNameText.leftView = leftview;
    
    
    UILabel *sightNameLabel = [[UILabel alloc]init];
    sightNameLabel.text = sightName;
    sightNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    sightNameLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *startWLabel = [[UILabel alloc]init];
    startWLabel.text = startW;
    startWLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    startWLabel.font = [UIFont systemFontOfSize:14];
    
    
    [headView addSubview:sightNameText];
    [headView addSubview:selectPictureBtn];
    [headView addSubview:sightNameLabel];
    [headView addSubview:startWLabel];
    
//    WS(ws);
    [sightNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).with.offset(25*kiphone6);
        make.left.equalTo(headView).with.offset(35*kiphone6 +rect.size.width*kiphone6);
        make.size.mas_equalTo(CGSizeMake(254*kiphone6 ,30*kiphone6));
    }];
    [selectPictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sightNameText.mas_bottom).with.offset(20*kiphone6);
        make.left.equalTo(headView).with.offset(35*kiphone6 +rect.size.width*kiphone6);
        //        make.size.mas_equalTo(CGSizeMake(210 ,30));
    }];
    
    [sightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sightNameText.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(2035*kiphone6 +rect.size.width*kiphone6);
        make.size.mas_equalTo(CGSizeMake((rect.size.width +5)*kiphone6,14*kiphone6));
    }];
    [startWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectPictureBtn.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(20*kiphone6);
        make.size.mas_equalTo(CGSizeMake((rect.size.width +5)*kiphone6,14*kiphone6));
    }];
    
    return headView;
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
