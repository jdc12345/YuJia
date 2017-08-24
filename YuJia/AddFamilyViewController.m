//
//  AddFamilyViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "AddFamilyViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "AddFamilyInfoViewController.h"
#import "PersonalModel.h"

@interface AddFamilyViewController ()
@property(nonatomic, weak) UITextField *phoneTF;
@property(nonatomic, weak) UITextField *vcodeTF;
@end

@implementation AddFamilyViewController


- (void)viewDidLoad {
    [super viewDidLoad];
        self.title = @"添加家人";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认添加" normalColor:[UIColor colorWithHexString:@"#0ddcbc"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(pushToAdd)];
    [self createSubViews];
    // Do any additional setup after loading the view.
}
- (void)createSubViews{
    UIImageView *iconImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"avatar.jpg"]];
    iconImageV.layer.cornerRadius = 15*kiphone6;
    iconImageV.clipsToBounds = YES;
    
    [self.view addSubview:iconImageV];
    
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(20*kiphone6);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(30*kiphone6 ,30*kiphone6));
    }];
    
    
//    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [changeBtn setTitle:@"更改头像" forState:UIControlStateNormal];
//    [changeBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
//    changeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
//    [changeBtn addTarget:self action:@selector(changeIconImage) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:changeBtn];
//    
//    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(iconImageV.mas_bottom).with.offset(10);
//        make.centerX.equalTo(self.view).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(60 ,11));
//    }];
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"家人手机号";
    titleLabel.textColor = [UIColor colorWithHexString:@"666666"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageV.mas_bottom).offset(20*kiphone6);
        make.centerX.equalTo(self.view).offset(0);
        make.size.mas_equalTo(CGSizeMake(170*kiphone6 ,14*kiphone6));
    }];
    
    
    UITextField *nameTextF = [[UITextField alloc]init];
    nameTextF.font = [UIFont systemFontOfSize:14];
    nameTextF.textColor = [UIColor colorWithHexString:@"#333333"];
    nameTextF.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    nameTextF.layer.borderWidth = 1;
    nameTextF.layer.cornerRadius = 2.5;
    nameTextF.clipsToBounds = YES;
    nameTextF.textAlignment = NSTextAlignmentCenter;
    
    
    self.phoneTF = nameTextF;
    [self.view addSubview:nameTextF];
    
    [nameTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15*kiphone6);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(270*kiphone6 ,30*kiphone6));
    }];
    
    
    UITextField *phoneTextF = [[UITextField alloc]init];
    phoneTextF.font = [UIFont systemFontOfSize:14];
    phoneTextF.textColor = [UIColor colorWithHexString:@"#333333"];
    phoneTextF.layer.borderColor = [UIColor colorWithHexString:@"#cccccc"].CGColor;
    phoneTextF.layer.borderWidth = 1;
    phoneTextF.layer.cornerRadius = 2.5;
    phoneTextF.clipsToBounds = YES;
    phoneTextF.textAlignment = NSTextAlignmentCenter;
    phoneTextF.placeholder = @"输入验证码";
    
    
    self.vcodeTF = phoneTextF;
    [self.view addSubview:phoneTextF];
    
    [phoneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameTextF.mas_bottom).with.offset(25*kiphone6);
        make.centerX.equalTo(self.view).offset(-50*kiphone6);
        make.size.mas_equalTo(CGSizeMake(170*kiphone6 ,30*kiphone6));
    }];
    

    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, 190, 44);
    [sureBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#0ddcbc"];
    [sureBtn addTarget:self action:@selector(surePost) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    
    
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(phoneTextF);
        make.left.equalTo(phoneTextF.mas_right).with.offset(-1);
        make.width.offset(100*kiphone6);
    }];
//    
//    
//    
//    UILabel *genderLabel = [[UILabel alloc]init];
//    genderLabel.text = @"性 别";
//    genderLabel.textColor = [UIColor colorWithHexString:@"666666"];
//    genderLabel.font = [UIFont systemFontOfSize:14];
//    genderLabel.textAlignment = NSTextAlignmentCenter;
//    
//    [self.view addSubview:genderLabel];
//    
//    [genderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(nameTextF.mas_bottom).with.offset(30);
//        make.centerX.equalTo(self.view).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(70 ,11));
//    }];
//    
//    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"男",@"女",nil];
//    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
//    //    segmentedControl.frame = CGRectMake((kScreenW -150 -20)/2.0, 7,150, 30.0);
//    /*
//     这个是设置按下按钮时的颜色
//     */
//    segmentedControl.tintColor = [UIColor colorWithHexString:@"00bfff"];
//    segmentedControl.selectedSegmentIndex = 0;//默认选中的按钮索引、
//    [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
//    
//    //    self.segmentedControl = segmentedControl;
//    /*
//     下面的代码实同正常状态和按下状态的属性控制,比如字体的大小和颜色等
//     */
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12],NSFontAttributeName,[UIColor colorWithHexString:@"666666"], NSForegroundColorAttributeName, nil];
//    
//    
//    [segmentedControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
//    
//    
//    NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithHexString:@"666666"] forKey:NSForegroundColorAttributeName];
//    
//    [segmentedControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
//    
//    //设置分段控件点击相应事件
//    [segmentedControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
//    
//    
//    [self.view addSubview:segmentedControl];
//    
//    [segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(genderLabel.mas_bottom).with.offset(15);
//        make.centerX.equalTo(self.view).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(150 ,30));
//    }];
    
}
- (void)changeIconImage{
    
}
- (void)surePost{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)pushToAdd{
    [self httpRequestInfo];
    
}
- (void)httpRequestInfo{
    NSDictionary *dict2 = @{
                           @"token":mDefineToken2,
                           @"telephone":self.phoneTF.text,
                           };
    
    
    [[HttpClient defaultClient]requestWithPath:mAddFamilyVcode method:1 parameters:dict2 prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"-1"]) {//号码没有注册
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            return ;
        }else{
            self.vcodeTF.text = responseObject[@"result"];
        }
        
        NSDictionary *dict = @{
                               @"token":mDefineToken2,
                               @"telephone":self.phoneTF.text,
                               @"addvcode":self.vcodeTF.text
                               };
        
        [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mAddFamilyUsers] method:1 parameters:dict prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            PersonalModel *personalModel = [PersonalModel mj_objectWithKeyValues:responseObject[@"homePersonal"]];
            AddFamilyInfoViewController *fInfo = [[AddFamilyInfoViewController alloc]init];
            fInfo.personalModel = personalModel;
            [self.navigationController pushViewController:fInfo animated:YES];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    

}
// 13717883008
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
