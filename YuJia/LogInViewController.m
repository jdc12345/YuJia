//
//  LogInViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "LogInViewController.h"

@interface LogInViewController ()


/**
 登陆页面
 */
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, strong) UIView *loginView;

// 密码
@property (nonatomic, strong) UILabel *passWordLabel;
@property (nonatomic, strong) UITextField *passWordTextF;
// 验证码
@property (nonatomic, strong) UILabel *vcodeLabel;
@property (nonatomic, strong) UITextField *vcodeTextF;
@property (nonatomic, strong) UIButton *postBtn;
/**
 注册页面
 */
@property (nonatomic, strong) UIButton *resignBtn;
@property (nonatomic, strong) UIView *resignView;






@property (nonatomic, assign) BOOL isPassWord;//or vcode
@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    
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
    loginBtn.backgroundColor = [UIColor colorWithHexString:@"4dbfcd"];
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [loginBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *resignBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resignBtn.backgroundColor = [UIColor colorWithHexString:@"9ae8e8"];
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
    self.loginView.backgroundColor = [UIColor colorWithHexString:@"1ab3e3"];
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(0);
        make.left.right.bottom.equalTo(self.view).with.offset(0);
    }];
    
    self.resignView = [[UIView alloc]init];
    [self createResignView];
    self.resignView.backgroundColor = [UIColor colorWithHexString:@"38d5d5"];
    self.resignView.hidden = YES;
    [self.view addSubview:self.resignView];
    [self.resignView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).with.offset(0);
        make.left.right.bottom.equalTo(self.view).with.offset(0);
    }];
}
- (void)createLoginView{
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
    
    UITextField *newNumberTextF = [[UITextField alloc]init];
    newNumberTextF.font = [UIFont systemFontOfSize:15];
    newNumberTextF.textColor = [UIColor colorWithHexString:@"333333"];
    newNumberTextF.layer.borderColor = [UIColor colorWithHexString:@"3899a5"].CGColor;
    newNumberTextF.layer.borderWidth = 1;
    newNumberTextF.layer.cornerRadius = 2.5;
    newNumberTextF.clipsToBounds = YES;
    newNumberTextF.textAlignment = NSTextAlignmentLeft;
    
    [self.loginView addSubview:newNumberTextF];
    
    [newNumberTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newNumberLabel).with.offset(0);
        make.left.equalTo(self.loginView).with.offset(100);
        make.right.equalTo(self.loginView).with.offset(-25);
        make.size.height.mas_equalTo(40);
    }];
    
    
    UITextField *passwordTextF = [[UITextField alloc]init];
    passwordTextF.font = [UIFont systemFontOfSize:15];
    passwordTextF.textColor = [UIColor colorWithHexString:@"333333"];
    passwordTextF.layer.borderColor = [UIColor colorWithHexString:@"3899a5"].CGColor;
    passwordTextF.layer.borderWidth = 1;
    passwordTextF.layer.cornerRadius = 2.5;
    passwordTextF.clipsToBounds = YES;
    passwordTextF.textAlignment = NSTextAlignmentLeft;
    
    [self.loginView addSubview:passwordTextF];
    
    [passwordTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordLabel).with.offset(0);
        make.left.equalTo(self.loginView).with.offset(100);
        make.right.equalTo(self.loginView).with.offset(-25);
        make.size.height.mas_equalTo(40);
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
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [sureBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
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
    [changeBtn setTitleColor:[UIColor colorWithHexString:@"267e89"] forState:UIControlStateNormal];
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
    yanLabelTextF.layer.borderColor = [UIColor colorWithHexString:@"3899a5"].CGColor;
    yanLabelTextF.layer.borderWidth = 1;
    yanLabelTextF.layer.cornerRadius = 2.5;
    yanLabelTextF.clipsToBounds = YES;
    yanLabelTextF.textAlignment = NSTextAlignmentCenter;
    yanLabelTextF.placeholder = @"输入验证码";
    
    [self.loginView addSubview:yanLabelTextF];
    
    [yanLabelTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yanLabel).with.offset(0);
        make.left.equalTo(self.loginView).with.offset(100);
        make.right.equalTo(self.loginView).with.offset(-25 -100);
        make.size.height.mas_equalTo(40);;
    }];
    
    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame = CGRectMake(10, 16, 190, 44);
    [postBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    postBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [postBtn addTarget:self action:@selector(surePost) forControlEvents:UIControlEventTouchUpInside];
    postBtn.layer.cornerRadius = 2.5;
    postBtn.clipsToBounds = YES;
    
    
    [self.loginView addSubview:postBtn];
    [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(yanLabelTextF).with.offset(0);
        make.left.equalTo(yanLabelTextF.mas_right).with.offset(-1);
        make.right.equalTo(self.loginView).with.offset(-25);
    }];

    
    
    self.passWordLabel = passwordLabel;
    self.passWordTextF = passwordTextF;
    
    
    self.vcodeLabel = yanLabel;
    self.vcodeTextF = yanLabelTextF;
    self.postBtn = postBtn;
    
    self.vcodeLabel.hidden = YES;
    self.vcodeTextF.hidden = YES;
    self.postBtn.hidden = YES;
}

// 注册页面
- (void)createResignView{
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
    
    UITextField *newNumberTextF = [[UITextField alloc]init];
    newNumberTextF.font = [UIFont systemFontOfSize:15];
    newNumberTextF.textColor = [UIColor colorWithHexString:@"333333"];
    newNumberTextF.layer.borderColor = [UIColor colorWithHexString:@"3899a5"].CGColor;
    newNumberTextF.layer.borderWidth = 1;
    newNumberTextF.layer.cornerRadius = 2.5;
    newNumberTextF.clipsToBounds = YES;
    newNumberTextF.textAlignment = NSTextAlignmentLeft;
    
    [self.resignView addSubview:newNumberTextF];
    
    [newNumberTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newNumberLabel).with.offset(0);
        make.left.equalTo(self.resignView).with.offset(100);
        make.right.equalTo(self.resignView).with.offset(-25);
        make.size.height.mas_equalTo(40);
    }];
    
    
    UITextField *yanLabelTextF = [[UITextField alloc]init];
    yanLabelTextF.font = [UIFont systemFontOfSize:15];
    yanLabelTextF.textColor = [UIColor colorWithHexString:@"333333"];
    yanLabelTextF.layer.borderColor = [UIColor colorWithHexString:@"3899a5"].CGColor;
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
        make.size.height.mas_equalTo(40);;
    }];

    UIButton *postBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    postBtn.frame = CGRectMake(10, 16, 190, 44);
    [postBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    postBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [postBtn addTarget:self action:@selector(surePost) forControlEvents:UIControlEventTouchUpInside];
    postBtn.layer.cornerRadius = 2.5;
    postBtn.clipsToBounds = YES;
    
    
    [self.resignView addSubview:postBtn];
    [postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.equalTo(yanLabelTextF).with.offset(0);
        make.left.equalTo(yanLabelTextF.mas_right).with.offset(-1);
        make.right.equalTo(self.resignView).with.offset(-25);
    }];
    
    UITextField *passwordTextF = [[UITextField alloc]init];
    passwordTextF.font = [UIFont systemFontOfSize:15];
    passwordTextF.textColor = [UIColor colorWithHexString:@"333333"];
    passwordTextF.layer.borderColor = [UIColor colorWithHexString:@"3899a5"].CGColor;
    passwordTextF.layer.borderWidth = 1;
    passwordTextF.layer.cornerRadius = 2.5;
    passwordTextF.clipsToBounds = YES;
    passwordTextF.textAlignment = NSTextAlignmentLeft;
    
    [self.resignView addSubview:passwordTextF];
    
    [passwordTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordLabel).with.offset(0);
        make.left.equalTo(self.resignView).with.offset(100);
        make.right.equalTo(self.resignView).with.offset(-25);
        make.size.height.mas_equalTo(40);
    }];
    
    
    UITextField *fistPWTextF = [[UITextField alloc]init];
    fistPWTextF.font = [UIFont systemFontOfSize:15];
    fistPWTextF.textColor = [UIColor colorWithHexString:@"333333"];
    fistPWTextF.layer.borderColor = [UIColor colorWithHexString:@"3899a5"].CGColor;
    fistPWTextF.layer.borderWidth = 1;
    fistPWTextF.layer.cornerRadius = 2.5;
    fistPWTextF.clipsToBounds = YES;
    fistPWTextF.textAlignment = NSTextAlignmentLeft;
    
    [self.resignView addSubview:fistPWTextF];
    
    [fistPWTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(fistPWLabel).with.offset(0);
        make.left.equalTo(self.resignView).with.offset(100);
        make.right.equalTo(self.resignView).with.offset(-25);
        make.size.height.mas_equalTo(40);
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
    sureBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
    [sureBtn addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 2.5;
    sureBtn.clipsToBounds = YES;
    
    [self.resignView addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreeMoreBtn.mas_bottom).with.offset(66);
        make.centerX.equalTo(self.resignView);
        make.size.mas_equalTo(CGSizeMake(150, 44));
    }];
    
}


- (void)btnClick:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:@"登陆"]) {
        self.loginView.hidden = NO;
        self.resignView.hidden = YES;
        
        
        self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"4dbfcd"];
        self.resignBtn.backgroundColor = [UIColor colorWithHexString:@"9ae8e8"];
    }else{
        self.loginView.hidden = YES;
        self.resignView.hidden = NO;
        
        
        self.resignBtn.backgroundColor = [UIColor colorWithHexString:@"4dbfcd"];
        self.loginBtn.backgroundColor = [UIColor colorWithHexString:@"9ae8e8"];
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
    }else{
        self.passWordLabel.hidden = NO;
        self.passWordTextF.hidden = NO;
        
        self.vcodeLabel.hidden = YES;
        self.vcodeTextF.hidden = YES;
        self.postBtn.hidden = YES;
    }
    self.isPassWord = sender.selected;
    sender.selected = !sender.selected;
    
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
