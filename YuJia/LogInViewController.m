//
//  LogInViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "LogInViewController.h"
#import "CcUserModel.h"
#import "YYTabBarController.h"
#import "MMTextField.h"
@interface LogInViewController ()

/**
 登陆页面
 */
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIView *loginView;

@property(nonatomic, weak) MMTextField *phoneTF_login;
// 密码
@property (nonatomic, strong) UILabel *passWordLabel;
@property (nonatomic, strong) MMTextField *passWordTextF;
// 验证码
@property (nonatomic, strong) UILabel *vcodeLabel;
@property (nonatomic, strong) UITextField *vcodeTextF;
@property (nonatomic, strong) UIButton *postBtn;


@property (nonatomic, assign) BOOL isPSW;//是否是密码登录
/**
 注册页面
 */
@property (nonatomic, strong) UIButton *resignBtn;
@property (nonatomic, strong) UIView *resignView;

@property(nonatomic, weak) MMTextField *phoneTF_resign;
@property(nonatomic, weak) UITextField *vcodeTF_resign;

@property(nonatomic, weak) MMTextField *psw_resign;
@property(nonatomic, weak) MMTextField *repsw_resign;





@property (nonatomic, assign) BOOL isPassWord;//or vcode
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    
    self.isPSW = YES;
    [self setSubView];
    // Do any additional setup after loading the view.
}
- (void)setSubView{
    
    
    //selected-login
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"tu-login"];
    
    [self.view addSubview:imageV];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(kScreenW, 121));
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = [UIColor colorWithHexString:@"#0ddcbc"];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resignBtn.backgroundColor = [UIColor colorWithHexString:@"#9ff1e4"];
    [resignBtn setTitle:@"注册" forState:UIControlStateNormal];
    resignBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [resignBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [resignBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:loginBtn];
    [self.view addSubview:resignBtn];
    self.resignBtn = resignBtn;
    self.loginBtn = loginBtn;
    
    
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(121);
        make.left.equalTo(self.view).with.offset(0 );
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 44));
    }];
    [resignBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn);
        make.left.equalTo(loginBtn.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 44));
    }];
    
    
    self.loginView = [[UIView alloc]init];
    [self createLoginView];
    self.loginView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(0);
        make.left.right.bottom.equalTo(self.view).with.offset(0);
    }];
    
    self.resignView = [[UIView alloc]init];
    [self createResignView];
    self.resignView.backgroundColor = [UIColor whiteColor];
    self.resignView.hidden = YES;
    [self.view addSubview:self.resignView];
    [self.resignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(0);
        make.left.right.bottom.equalTo(self.view).with.offset(0);
    }];
    
    
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    [topView setBarStyle:UIBarStyleBlackTranslucent];
    
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 30, 30);
    [btn addTarget:self action:@selector(dismissKeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:@"键盘"] forState:UIControlStateNormal];
//    btn.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    
    [self.phoneTF_login setInputAccessoryView:topView];
    [self.passWordTextF setInputAccessoryView:topView];
    [self.vcodeTextF setInputAccessoryView:topView];
    [self.phoneTF_resign setInputAccessoryView:topView];
    [self.vcodeTF_resign setInputAccessoryView:topView];
    [self.psw_resign setInputAccessoryView:topView];
    [self.repsw_resign setInputAccessoryView:topView];
}
- (void)createLoginView{
//    渐变色
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"38d5cf"].CGColor, (__bridge id)[UIColor colorWithHexString:@"1ab4dc"].CGColor];
//    gradientLayer.locations = @[@0 ,@1.0];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1.0);
//    gradientLayer.frame = CGRectMake(0, 0, kScreenW, kScreenH - 121 -44);;
//    [self.loginView.layer addSublayer:gradientLayer];
    
    NSMutableParagraphStyle *paraStyle3 = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic3 = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle3, NSKernAttributeName:@0.0f
                           };
    
    NSAttributedString *attributeStr3 = [[NSAttributedString alloc] initWithString:@"手机号" attributes:dic3];
    
    UILabel *newNumberLabel = [[UILabel alloc]init];
    newNumberLabel.textColor = [UIColor colorWithHexString:@"333333"];
    newNumberLabel.font = [UIFont systemFontOfSize:14];
    newNumberLabel.attributedText = attributeStr3;
    [self.loginView addSubview:newNumberLabel];
    
    [newNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginView).with.offset(53);
        make.left.equalTo(self.loginView).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(55, 14));
    }];
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    passwordLabel.textColor = [UIColor colorWithHexString:@"333333"];
    passwordLabel.font = [UIFont systemFontOfSize:14];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@14.0f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"密码" attributes:dic];
    passwordLabel.attributedText = attributeStr;
    
    [self.loginView addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newNumberLabel.mas_bottom).with.offset(41);
        make.left.equalTo(self.loginView).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(55, 14));
    }];
    
    MMTextField *newNumberTextF = [[MMTextField alloc]init];
    newNumberTextF.font = [UIFont systemFontOfSize:15];
    newNumberTextF.textColor = [UIColor colorWithHexString:@"333333"];
    newNumberTextF.layer.borderColor = [UIColor colorWithHexString:@"#c4c4c4"].CGColor;
    newNumberTextF.layer.borderWidth = 1;
    newNumberTextF.layer.cornerRadius = 2.5;
    newNumberTextF.clipsToBounds = YES;
    newNumberTextF.textAlignment = NSTextAlignmentLeft;
    newNumberTextF.placeholder = @"请输入手机号";
    [self.loginView addSubview:newNumberTextF];
    
    [newNumberTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newNumberLabel).with.offset(0);
        make.left.equalTo(self.loginView).with.offset(100);
        make.right.equalTo(self.loginView).with.offset(-25);
        make.height.offset(40);
    }];
    
    
    MMTextField *passwordTextF = [[MMTextField alloc]init];
    passwordTextF.font = [UIFont systemFontOfSize:15];
    passwordTextF.textColor = [UIColor colorWithHexString:@"333333"];
    passwordTextF.layer.borderColor = [UIColor colorWithHexString:@"#c4c4c4"].CGColor;
    passwordTextF.layer.borderWidth = 1;
    passwordTextF.layer.cornerRadius = 2.5;
    passwordTextF.clipsToBounds = YES;
    passwordTextF.textAlignment = NSTextAlignmentLeft;
    passwordTextF.placeholder = @"输入6-12位数字、字母密码";
    [self.loginView addSubview:passwordTextF];
    
    [passwordTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordLabel).with.offset(0);
        make.left.equalTo(self.loginView).with.offset(100);
        make.right.equalTo(self.loginView).with.offset(-25);
        make.height.offset(40);
    }];
   
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setImage:[UIImage imageNamed:@"selected-login"] forState:UIControlStateNormal];
//    [agreeBtn sizeToFit];
    [self.loginView addSubview:agreeBtn];
    
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordTextF.mas_bottom).with.offset(10);
        make.left.equalTo(passwordTextF).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    UIButton *agreeMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeMoreBtn setTitle:@"我已确认阅读并同意《使用条款和隐私协议》" forState:UIControlStateNormal];
    [agreeMoreBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    agreeMoreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    agreeMoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.loginView addSubview:agreeMoreBtn];
    
    [agreeMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(agreeBtn).with.offset(0);
        make.left.equalTo(agreeBtn.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(250, 11));
    }];
    
    
    
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, 190, 44);
    [sureBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#0ddcbc"];
    [sureBtn addTarget:self action:@selector(httpRequestForLogin) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    
    [self.loginView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreeMoreBtn.mas_bottom).with.offset(66);
        make.centerX.equalTo(self.loginView);
        make.size.mas_equalTo(CGSizeMake(150, 44));
    }];
    
    UIButton *changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeBtn setTitle:@"手机验证码登录" forState:UIControlStateNormal];
    [changeBtn setTitle:@"密码登录" forState:UIControlStateSelected];
    [changeBtn setTitleColor:[UIColor colorWithHexString:@"#0ddcbc"] forState:UIControlStateNormal];
    changeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [changeBtn addTarget:self action:@selector(changeLoginStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView addSubview:changeBtn];
    
    [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loginView).with.offset(-50);
        make.centerX.equalTo(self.loginView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 13));
    }];
    
    
    ////  切换成 验证码模式
    NSMutableParagraphStyle *paraStyle4 = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic4 = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle4, NSKernAttributeName:@7.0f
                           };
    NSAttributedString *attributeStr4 = [[NSAttributedString alloc] initWithString:@"验证码" attributes:dic4];
    
    UILabel *yanLabel = [[UILabel alloc]init];
    yanLabel.textColor = [UIColor colorWithHexString:@"333333"];
    yanLabel.font = [UIFont systemFontOfSize:14];
    yanLabel.attributedText = attributeStr4;
    [self.loginView addSubview:yanLabel];
    
    [yanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newNumberLabel.mas_bottom).with.offset(41);
        make.left.equalTo(newNumberLabel).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(65, 14));
    }];
    
    UITextField *yanLabelTextF = [[UITextField alloc]init];
    yanLabelTextF.font = [UIFont systemFontOfSize:15];
    yanLabelTextF.textColor = [UIColor colorWithHexString:@"333333"];
    yanLabelTextF.layer.borderColor = [UIColor colorWithHexString:@"#c4c4c4"].CGColor;
    yanLabelTextF.layer.borderWidth = 1;
    yanLabelTextF.layer.cornerRadius = 2.5;
    yanLabelTextF.clipsToBounds = YES;
    yanLabelTextF.textAlignment = NSTextAlignmentCenter;
    yanLabelTextF.placeholder = @"输入验证码";
    
    [self.loginView addSubview:yanLabelTextF];
    
    [yanLabelTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yanLabel);
        make.left.equalTo(self.loginView).offset(100);
        make.right.equalTo(self.loginView).offset(-25 -100);
        make.height.offset(40);
    }];
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame = CGRectMake(10, 16, 190, 44);
    [postBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    postBtn.backgroundColor = [UIColor colorWithHexString:@"#0ddcbc"];
    postBtn.tag = 51;
    [postBtn addTarget:self action:@selector(surePost:) forControlEvents:UIControlEventTouchUpInside];
    postBtn.layer.cornerRadius = 2.5;
    postBtn.clipsToBounds = YES;
    
    [self.loginView addSubview:postBtn];
    [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(yanLabelTextF).with.offset(0);
        make.left.equalTo(yanLabelTextF.mas_right).with.offset(-1);
        make.right.equalTo(self.loginView).with.offset(-25);
    }];
    
    self.phoneTF_login = newNumberTextF;
    self.passWordLabel = passwordLabel;
    self.passWordTextF = passwordTextF;
    self.passWordTextF.secureTextEntry = YES;
    
    self.vcodeLabel = yanLabel;
    self.vcodeTextF = yanLabelTextF;
    self.postBtn = postBtn;
    
    self.vcodeLabel.hidden = YES;
    self.vcodeTextF.hidden = YES;
    self.postBtn.hidden = YES;
    
}

// 注册页面
- (void)createResignView{
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"38d5cf"].CGColor, (__bridge id)[UIColor colorWithHexString:@"1ab4dc"].CGColor];
//    gradientLayer.locations = @[@0 ,@1.0];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(0, 1.0);
//    gradientLayer.frame = CGRectMake(0, 0, kScreenW, kScreenH - 121 -44);;
//    [self.resignView.layer addSublayer:gradientLayer];
    NSMutableParagraphStyle *paraStyle3 = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic3 = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle3, NSKernAttributeName:@7.0f
                           };
    
    NSAttributedString *attributeStr3 = [[NSAttributedString alloc] initWithString:@"手机号" attributes:dic3];
    
    UILabel *newNumberLabel = [[UILabel alloc]init];
    newNumberLabel.textColor = [UIColor colorWithHexString:@"333333"];
    newNumberLabel.font = [UIFont systemFontOfSize:14];
    newNumberLabel.attributedText = attributeStr3;
    [self.resignView addSubview:newNumberLabel];
    
    [newNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resignView).with.offset(53);
        make.left.equalTo(self.resignView).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(65, 14));
    }];
    
    NSMutableParagraphStyle *paraStyle4 = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic4 = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle4, NSKernAttributeName:@7.0f
                           };
    NSAttributedString *attributeStr4 = [[NSAttributedString alloc] initWithString:@"验证码" attributes:dic4];
    
    UILabel *yanLabel = [[UILabel alloc]init];
    yanLabel.textColor = [UIColor colorWithHexString:@"333333"];
    yanLabel.font = [UIFont systemFontOfSize:14];
    yanLabel.attributedText = attributeStr4;
    [self.resignView addSubview:yanLabel];
    
    [yanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newNumberLabel.mas_bottom).with.offset(41);
        make.left.equalTo(newNumberLabel).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(65, 14));
    }];
    
    NSMutableParagraphStyle *paraStyle2 = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle2, NSKernAttributeName:@0.0f
                           };
    
    NSAttributedString *attributeStr2 = [[NSAttributedString alloc] initWithString:@"设置密码" attributes:dic2];
    
    UILabel *fistPWLabel = [[UILabel alloc]init];
    fistPWLabel.textColor = [UIColor colorWithHexString:@"333333"];
    fistPWLabel.font = [UIFont systemFontOfSize:14];
    fistPWLabel.attributedText = attributeStr2;
    [self.resignView addSubview:fistPWLabel];
    
    [fistPWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yanLabel.mas_bottom).with.offset(41);
        make.left.equalTo(newNumberLabel).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(65, 14));
    }];
    
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    passwordLabel.textColor = [UIColor colorWithHexString:@"333333"];
    passwordLabel.font = [UIFont systemFontOfSize:14];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@0.0f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"重复密码" attributes:dic];
    passwordLabel.attributedText = attributeStr;
    
    [self.resignView addSubview:passwordLabel];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fistPWLabel.mas_bottom).with.offset(41);
        make.left.equalTo(self.resignView).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(65, 14));
    }];
    
    MMTextField *newNumberTextF = [[MMTextField alloc]init];
    newNumberTextF.font = [UIFont systemFontOfSize:15];
    newNumberTextF.textColor = [UIColor colorWithHexString:@"333333"];
    newNumberTextF.layer.borderColor = [UIColor colorWithHexString:@"#c4c4c4"].CGColor;
    newNumberTextF.layer.borderWidth = 1;
    newNumberTextF.layer.cornerRadius = 2.5;
    newNumberTextF.clipsToBounds = YES;
    newNumberTextF.textAlignment = NSTextAlignmentLeft;
    newNumberTextF.placeholder = @"请输入手机号";
    [self.resignView addSubview:newNumberTextF];
    
    [newNumberTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newNumberLabel).with.offset(0);
        make.left.equalTo(self.resignView).with.offset(100);
        make.right.equalTo(self.resignView).with.offset(-25);
        make.height.offset(40);
    }];
    
    
    UITextField *yanLabelTextF = [[UITextField alloc]init];
    yanLabelTextF.font = [UIFont systemFontOfSize:15];
    yanLabelTextF.textColor = [UIColor colorWithHexString:@"333333"];
    yanLabelTextF.layer.borderColor = [UIColor colorWithHexString:@"#c4c4c4"].CGColor;
    yanLabelTextF.layer.borderWidth = 1;
    yanLabelTextF.layer.cornerRadius = 2.5;
    yanLabelTextF.clipsToBounds = YES;
    yanLabelTextF.textAlignment = NSTextAlignmentCenter;
    yanLabelTextF.placeholder = @"输入验证码";
    
    [self.resignView addSubview:yanLabelTextF];
    
    [yanLabelTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yanLabel).with.offset(0);
        make.left.equalTo(self.resignView).with.offset(100);
        make.right.equalTo(self.resignView).with.offset(-25 -100);
        make.height.offset(40);
    }];

    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame = CGRectMake(10, 16, 190, 44);
    [postBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    postBtn.backgroundColor = [UIColor colorWithHexString:@"#0ddcbc"];
    postBtn.tag = 52;
    [postBtn addTarget:self action:@selector(surePost:) forControlEvents:UIControlEventTouchUpInside];
    postBtn.layer.cornerRadius = 2.5;
    postBtn.clipsToBounds = YES;
    
    
    [self.resignView addSubview:postBtn];
    [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(yanLabelTextF).with.offset(0);
        make.left.equalTo(yanLabelTextF.mas_right).with.offset(-1);
        make.right.equalTo(self.resignView).with.offset(-25);
    }];
    
    MMTextField *passwordTextF = [[MMTextField alloc]init];
    passwordTextF.font = [UIFont systemFontOfSize:15];
    passwordTextF.textColor = [UIColor colorWithHexString:@"333333"];
    passwordTextF.layer.borderColor = [UIColor colorWithHexString:@"#c4c4c4"].CGColor;
    passwordTextF.layer.borderWidth = 1;
    passwordTextF.layer.cornerRadius = 2.5;
    passwordTextF.clipsToBounds = YES;
    passwordTextF.textAlignment = NSTextAlignmentLeft;
    passwordTextF.placeholder = @"输入6-12位数字、字母密码";
    [self.resignView addSubview:passwordTextF];
    
    [passwordTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordLabel).with.offset(0);
        make.left.equalTo(self.resignView).with.offset(100);
        make.right.equalTo(self.resignView).with.offset(-25);
        make.height.offset(40);
    }];
    
    
    MMTextField *fistPWTextF = [[MMTextField alloc]init];
    fistPWTextF.font = [UIFont systemFontOfSize:15];
    fistPWTextF.textColor = [UIColor colorWithHexString:@"333333"];
    fistPWTextF.layer.borderColor = [UIColor colorWithHexString:@"#c4c4c4"].CGColor;
    fistPWTextF.layer.borderWidth = 1;
    fistPWTextF.layer.cornerRadius = 2.5;
    fistPWTextF.clipsToBounds = YES;
    fistPWTextF.textAlignment = NSTextAlignmentLeft;
    fistPWTextF.placeholder = @"重复输入密码";
    [self.resignView addSubview:fistPWTextF];
    
    [fistPWTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fistPWLabel).with.offset(0);
        make.left.equalTo(self.resignView).with.offset(100);
        make.right.equalTo(self.resignView).with.offset(-25);
        make.height.offset(40);
    }];
    
    
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setImage:[UIImage imageNamed:@"selected-login"] forState:UIControlStateNormal];
    //    [agreeBtn sizeToFit];
    [self.resignView addSubview:agreeBtn];
    
    [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordTextF.mas_bottom).with.offset(10);
        make.left.equalTo(passwordTextF).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(12, 12));
    }];
    
    UIButton *agreeMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeMoreBtn setTitle:@"我已确认阅读并同意《使用条款和隐私协议》" forState:UIControlStateNormal];
    [agreeMoreBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    agreeMoreBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    agreeMoreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.resignView addSubview:agreeMoreBtn];
    
    [agreeMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(agreeBtn).with.offset(0);
        make.left.equalTo(agreeBtn.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(250, 11));
    }];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, 190, 44);
    [sureBtn setTitle:@"注册" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"#0ddcbc"];
    [sureBtn addTarget:self action:@selector(clickResign) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    
    [self.resignView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreeMoreBtn.mas_bottom).with.offset(66);
        make.centerX.equalTo(self.resignView);
        make.size.mas_equalTo(CGSizeMake(150, 44));
    }];

    self.phoneTF_resign = newNumberTextF;
    self.vcodeTF_resign = yanLabelTextF;
    self.psw_resign = passwordTextF;
    self.repsw_resign = fistPWTextF;
    self.psw_resign.secureTextEntry = YES;
    self.repsw_resign.secureTextEntry = YES;

}
//发验证码
-(void)surePost:(UIButton*)sender{
    NSString *codeUrlStr = @"";
    if (sender.tag == 51) {
        if (self.phoneTF_login.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
            return;
        }
        codeUrlStr = [NSString stringWithFormat:@"%@/mobilepub/personal/loginvcode.do?&telephone=%@",mPrefixUrl,self.phoneTF_login.text];
    }else{
        if (self.phoneTF_resign.text.length == 0) {
            [SVProgressHUD showInfoWithStatus:@"请输入手机号"];
            return;
        }
        codeUrlStr = [NSString stringWithFormat:@"%@/mobilepub/personal/vcode.do?&telephone=%@",mPrefixUrl,self.phoneTF_resign.text];
    }
    
    [[HttpClient defaultClient]requestWithPath:codeUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *code = responseObject[@"code"];
        if ([code isEqualToString:@"0"]) {
            if (sender.tag == 51) {//发送验证码登录
                self.vcodeTextF.text = responseObject[@"result"];
            }else{//注册登录
                
                self.vcodeTF_resign.text = responseObject[@"result"];
                
            }
        }else{
            [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD dismiss];//结束动画
    }];
}

- (void)btnClick:(UIButton *)sender{
    [self dismissKeyBoard];
    if ([sender.currentTitle isEqualToString:@"登录"]) {
        self.loginView.hidden = NO;
        self.resignView.hidden = YES;
        
        
        self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"#0ddcbc"];
        self.resignBtn.backgroundColor = [UIColor colorWithHexString:@"#9ff1e4"];
    }else{
        self.loginView.hidden = YES;
        self.resignView.hidden = NO;
        
        
        self.resignBtn.backgroundColor = [UIColor colorWithHexString:@"#0ddcbc"];
        self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"#9ff1e4"];
    }
}
- (void)changeLoginStyle:(UIButton *)sender{
    
    NSLog(@"current = %@",sender.currentTitle);
    if (!sender.selected) {
        // 变成 验证码
        self.passWordLabel.hidden = YES;
        self.passWordTextF.hidden = YES;
        
        self.vcodeLabel.hidden = NO;
        self.vcodeTextF.hidden = NO;
        self.postBtn.hidden = NO;
        
        self.isPSW = NO;
    }else{
        self.passWordLabel.hidden = NO;
        self.passWordTextF.hidden = NO;
        
        self.vcodeLabel.hidden = YES;
        self.vcodeTextF.hidden = YES;
        self.postBtn.hidden = YES;
        
        self.isPSW = YES;
    }
    self.isPassWord = sender.selected;
    sender.selected = !sender.selected;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)clickResign{
    [self httpRequestInfo];
}

- (void)httpRequestInfo{
//    NSDictionary *dict2 = @{
//                            @"telephone":self.phoneTF_resign.text,
//                            };
//    NSLog(@"%@",dict2);
//    
//    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"http://192.168.1.55:8080/smarthome/mobilepub/personal/vcode.do?"] method:1 parameters:dict2 prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        self.vcodeTF_resign.text = responseObject[@"result"];
        NSDictionary *dict = @{
                               @"password":self.psw_resign.text,
                               @"telephone":self.phoneTF_resign.text,
                               @"vcode":self.vcodeTF_resign.text
                               };
        NSLog(@"%@",dict);
        [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mResign] method:1 parameters:dict prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"%@",responseObject);
            //保存token
            CcUserModel *userModel = [CcUserModel defaultClient];
            userModel.userToken = responseObject[@"token"];
            userModel.telephoneNum = self.phoneTF_resign.text;
            [userModel saveAllInfo];
            
            YYTabBarController *firstVC = [[YYTabBarController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = firstVC;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
        }];
        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
    
}
- (void)httpRequestForLogin{
    [SVProgressHUD show];//开始加载
    if (self.isPSW) {
        NSLog(@"密码登录");
        if (self.phoneTF_login.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入电话号码"];
            return;
        }
        if (self.passWordTextF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请输入密码"];
            return;
        }
        NSDictionary *dict = @{
                               @"password":self.passWordTextF.text,
                               @"telephone":self.phoneTF_login.text,
//                               @"vcode":self.vcodeTF_resign.text
                               };
        NSLog(@"%@",dict);
        [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mLogin] method:1 parameters:dict prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];//结束动画
            NSLog(@"%@",responseObject);
            NSString *code = responseObject[@"code"];
            if ([code isEqualToString:@"0"]) {
                //保存token
                CcUserModel *userModel = [CcUserModel defaultClient];
                userModel.userToken = responseObject[@"token"];
                userModel.telephoneNum = self.phoneTF_login.text;
                [userModel saveAllInfo];
                
                [self.view resignFirstResponder];
                YYTabBarController *firstVC = [[YYTabBarController alloc]init];
                [UIApplication sharedApplication].keyWindow.rootViewController = firstVC;;
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@",error);
            [SVProgressHUD dismiss];//结束动画
        }];
    }else{
        NSLog(@"验证码登录");

        if (self.vcodeTextF.text.length == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写验证码"];
            return;
        }
            NSDictionary *dict = @{
//                                   @"password":self.passWordTextF.text,
                                   @"telephone":self.phoneTF_login.text,
                                   @"password":self.vcodeTextF.text
                                   };
            NSLog(@"%@",dict);
            [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mLogin] method:1 parameters:dict prepareExecute:^{
                
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                [SVProgressHUD dismiss];//结束动画
                NSLog(@"%@",responseObject);
                //保存token
                CcUserModel *userModel = [CcUserModel defaultClient];
                userModel.userToken = responseObject[@"token"];
                userModel.telephoneNum = self.phoneTF_login.text;
                [userModel saveAllInfo];
                
                
                YYTabBarController *firstVC = [[YYTabBarController alloc]init];
                [UIApplication sharedApplication].keyWindow.rootViewController = firstVC;
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"%@",error);
                [SVProgressHUD dismiss];//结束动画
            }];
        
    }
}
-(void)dismissKeyBoard
{
    [self.phoneTF_login resignFirstResponder];
    [self.passWordTextF resignFirstResponder];
    [self.vcodeTextF resignFirstResponder];
    [self.phoneTF_resign resignFirstResponder];
    [self.vcodeTF_resign resignFirstResponder];
    [self.psw_resign resignFirstResponder];
    [self.repsw_resign resignFirstResponder];
}
#pragma mark - 键盘通知
- (void)addNoticeForKeyboard {
    
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    //注册键盘消失的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}
///键盘显示事件
- (void) keyboardWillShow:(NSNotification *)notification {
    // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat height = rect.size.height;
    if (height <667.f) {//判断设备型号是6以下情况(此处是因为固定了屏幕方向，其他情况要判定屏幕方向)
        if (self.passWordTextF.isFirstResponder||self.vcodeTextF.isFirstResponder||self.vcodeTF_resign.isFirstResponder||self.psw_resign.isFirstResponder||self.repsw_resign.isFirstResponder) {
            //将视图上移计算好的偏移
            [UIView animateWithDuration:duration animations:^{
                [self.loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.view).with.offset(20);
                    make.left.equalTo(self.view).with.offset(0 );
                    make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 44));
                }];

            }];
        }
    }
}

///键盘消失事件
- (void) keyboardWillHide:(NSNotification *)notify {
    // 键盘动画时间
    double duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //视图下沉恢复原状
    [UIView animateWithDuration:duration animations:^{

        [self.loginBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(121);
            make.left.equalTo(self.view).with.offset(0 );
            make.size.mas_equalTo(CGSizeMake(kScreenW/2.0, 44));
        }];

    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //注册键盘通知
    [self addNoticeForKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //移除键盘监听
    //移除键盘监听 直接按照通知名字去移除键盘通知, 这是正确方式
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
