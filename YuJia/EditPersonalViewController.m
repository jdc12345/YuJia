//
//  EditPersonalViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "EditPersonalViewController.h"

@interface EditPersonalViewController ()

@end

@implementation EditPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.title = @"家";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self createSubViews];
    // Do any additional setup after loading the view.
}
- (void)createSubViews{
    UIImageView *iconImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    iconImageV.layer.cornerRadius = 45;
    iconImageV.clipsToBounds = YES;
    
    [self.view addSubview:iconImageV];
    
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(94);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(90 ,90));
    }];
    
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:@"更改头像" forState:UIControlStateNormal];
    [changeBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [changeBtn addTarget:self action:@selector(changeIconImage) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:changeBtn];
    
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV.mas_bottom).with.offset(10);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(60 ,11));
    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"用户名";
    titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(changeBtn.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(70 ,11));
    }];
    
    
    UITextField *nameTextF = [[UITextField alloc]init];
    nameTextF.font = [UIFont systemFontOfSize:15];
    nameTextF.textColor = [UIColor colorWithHexString:@"333333"];
    nameTextF.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    nameTextF.layer.borderWidth = 1;
    nameTextF.layer.cornerRadius = 2.5;
    nameTextF.clipsToBounds = YES;
    nameTextF.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:nameTextF];
    
    [nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(185 ,30));
    }];
    
    
    UILabel *genderLabel = [[UILabel alloc]init];
    genderLabel.text = @"性 别";
    genderLabel.textColor = [UIColor colorWithHexString:@"666666"];
    genderLabel.font = [UIFont systemFontOfSize:14];
    genderLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:genderLabel];
    
    [genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextF.mas_bottom).with.offset(30);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(70 ,11));
    }];
    
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"男",@"女",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
//    segmentedControl.frame = CGRectMake((kScreenW -150 -20)/2.0, 7,150, 30.0);
    /*
     这个是设置按下按钮时的颜色
     */
    segmentedControl.tintColor = [UIColor colorWithHexString:@"00bfff"];
    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引、
    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
//    self.segmentedControl = segmentedControl;
    /*
     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
     */
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor colorWithHexString:@"666666"], NSForegroundColorAttributeName, nil];
    
    
    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    
    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"666666"] forKey:NSForegroundColorAttributeName];
    
    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
    
    //设置分段控件点击相应事件
    [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    

    [self.view addSubview:segmentedControl];
    
    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(genderLabel.mas_bottom).with.offset(15);
        make.centerX.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(150 ,30));
    }];

}
- (void)changeIconImage{
    
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
