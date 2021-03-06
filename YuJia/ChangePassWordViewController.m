//
//  ChangePassWordViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/18.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "ChangePassWordViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "MMTextField.h"
@interface ChangePassWordViewController ()
@property  (nonatomic, strong) MMTextField *phoneTF;
@property  (nonatomic, strong) MMTextField *re_pwTF;
@property  (nonatomic, strong) MMTextField *pwTF;
@end

@implementation ChangePassWordViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认更改" normalColor:[UIColor colorWithHexString:@"#0ddcbc"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(pushToAdd)];
    [self settingSubView];
    // Do any additional setup after loading the view.
}
- (void)pushToAdd{
    [self httpRequestInfo];
}
- (void)settingSubView{
//    UIView *headView = [[UIView alloc]init];
//    headView.backgroundColor = [UIColor whiteColor];
//    
//    [self.view addSubview:headView];
//    [headView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(74);
//        make.left.equalTo(self.view).with.offset(0);
//        make.size.mas_equalTo(CGSizeMake(kScreenW, 60));
//    }];
//    
//    
//    UILabel *titleLabel = [[UILabel alloc]init];
//    titleLabel.text = @"当前手机号：17600000000";
//    //    titleLabel.backgroundColor = [UIColor redColor];
//    [titleLabel sizeToFit];
//    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    titleLabel.font = [UIFont systemFontOfSize:14];
//    
//    [headView addSubview:titleLabel];
//    
//    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(headView).with.offset(0);
//        make.left.equalTo(headView).with.offset(15);
//        //        make.size.mas_equalTo(CGSizeMake(kScreenW -30, 14));
//    }];
//    
//    UILabel *changeLabel = [[UILabel alloc]init];
//    changeLabel.text = @"修改绑定";
//    //    changeLabel.backgroundColor = [UIColor redColor];
//    [changeLabel sizeToFit];
//    changeLabel.textColor = [UIColor colorWithHexString:@"333333"];
//    changeLabel.font = [UIFont systemFontOfSize:13];
//    
//    [self.view addSubview:changeLabel];
//    
//    [changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headView.mas_bottom).with.offset(13.5);
//        make.left.equalTo(self.view).with.offset(15);
//        //        make.size.mas_equalTo(CGSizeMake(kScreenW -30, 14));
//    }];
    
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:footView];
//    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(74);
//        make.left.right.bottom.equalTo(self.view).with.offset(0);
//        
//    }];
//
    
    
    NSMutableParagraphStyle *paraStyle3 = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic3 = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle3, NSKernAttributeName:@4.0f
                           };
    
    NSAttributedString *attributeStr3 = [[NSAttributedString alloc] initWithString:@"填写旧密码" attributes:dic3];
  
    UILabel *newNumberLabel = [[UILabel alloc]init];
    newNumberLabel.text = @"填写旧密码";
    //    newNumberLabel.backgroundColor = [UIColor redColor];
    newNumberLabel.textColor = [UIColor colorWithHexString:@"333333"];
    newNumberLabel.font = [UIFont systemFontOfSize:14];
    newNumberLabel.attributedText = attributeStr3;
    [footView addSubview:newNumberLabel];
    
    [newNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footView).with.offset(22);
        make.left.equalTo(footView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 14));
    }];
    
    UILabel *passwordLabel = [[UILabel alloc]init];
    //    passwordLabel.backgroundColor = [UIColor redColor];
    passwordLabel.textColor = [UIColor colorWithHexString:@"333333"];
    passwordLabel.font = [UIFont systemFontOfSize:14];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@4.0f
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:@"填写新密码" attributes:dic];
    passwordLabel.attributedText = attributeStr;
    
    [footView addSubview:passwordLabel];
    
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(newNumberLabel.mas_bottom).with.offset(36);
        make.left.equalTo(footView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 14));
    }];
    
    UILabel *yanLabel = [[UILabel alloc]init];
    //    yanLabel.backgroundColor = [UIColor redColor];
    yanLabel.textColor = [UIColor colorWithHexString:@"333333"];
    yanLabel.font = [UIFont systemFontOfSize:14];
    
    NSMutableParagraphStyle *paraStyle2 = [[NSMutableParagraphStyle alloc] init];
    NSDictionary *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paraStyle2, NSKernAttributeName:@4.0f
                           };
    
    NSAttributedString *attributeStr2 = [[NSAttributedString alloc] initWithString:@"重复新密码" attributes:dic2];
    yanLabel.attributedText = attributeStr2;
    
    [footView addSubview:yanLabel];
    
    [yanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordLabel.mas_bottom).with.offset(36);
        make.left.equalTo(footView).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(90, 14));
    }];
    
    MMTextField *newNumberTextF = [[MMTextField alloc]init];
    newNumberTextF.font = [UIFont systemFontOfSize:15];
    newNumberTextF.textColor = [UIColor colorWithHexString:@"333333"];
    newNumberTextF.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    newNumberTextF.layer.borderWidth = 1;
    newNumberTextF.layer.cornerRadius = 2.5;
    newNumberTextF.clipsToBounds = YES;
    newNumberTextF.textAlignment = NSTextAlignmentLeft;
    newNumberTextF.secureTextEntry = YES;
    
    [footView addSubview:newNumberTextF];
    
    [newNumberTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(newNumberLabel).with.offset(0);
        make.left.equalTo(footView).with.offset(115);
        make.right.equalTo(footView).with.offset(-15);
        make.height.offset(30);
    }];
    
    
    MMTextField *passwordTextF = [[MMTextField alloc]init];
    passwordTextF.font = [UIFont systemFontOfSize:15];
    passwordTextF.textColor = [UIColor colorWithHexString:@"333333"];
    passwordTextF.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    passwordTextF.layer.borderWidth = 1;
    passwordTextF.layer.cornerRadius = 2.5;
    passwordTextF.clipsToBounds = YES;
    passwordTextF.textAlignment = NSTextAlignmentLeft;
    passwordTextF.secureTextEntry = YES;
    
    [footView addSubview:passwordTextF];
    
    [passwordTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passwordLabel).with.offset(0);
        make.left.equalTo(footView).with.offset(115);
        make.right.equalTo(footView).with.offset(-15);
        make.height.offset(30);
    }];
    
    MMTextField *yanLabelTextF = [[MMTextField alloc]init];
    yanLabelTextF.font = [UIFont systemFontOfSize:15];
    yanLabelTextF.textColor = [UIColor colorWithHexString:@"333333"];
    yanLabelTextF.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    yanLabelTextF.layer.borderWidth = 1;
    yanLabelTextF.layer.cornerRadius = 2.5;
    yanLabelTextF.clipsToBounds = YES;
    yanLabelTextF.textAlignment = NSTextAlignmentLeft;
    yanLabelTextF.secureTextEntry = YES;
    
    [footView addSubview:yanLabelTextF];
    
    [yanLabelTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(yanLabel).with.offset(0);
        make.left.equalTo(footView).with.offset(115);
        make.right.equalTo(footView).with.offset(-15);
        make.height.offset(30);
    }];
    
//    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    sureBtn.frame = CGRectMake(10, 16, 190, 44);
//    [sureBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
//    [sureBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    sureBtn.backgroundColor = [UIColor colorWithHexString:@"00bfff"];
//    [sureBtn addTarget:self action:@selector(surePost) forControlEvents:UIControlEventTouchUpInside];
//    sureBtn.layer.cornerRadius = 2.5;
//    sureBtn.clipsToBounds = YES;
//    
//    
//    [footView addSubview:sureBtn];
//    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.top.equalTo(yanLabelTextF).with.offset(0);
//        make.left.equalTo(yanLabelTextF.mas_right).with.offset(-1);
//        make.right.equalTo(footView).with.offset(-15);
//    }];
    
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(74);
        make.left.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(yanLabelTextF.mas_bottom).with.offset(10);
    }];
    
    self.phoneTF = newNumberTextF;
    self.pwTF = passwordTextF;
    self.re_pwTF = yanLabelTextF;
    
    
}
//- (void)surePost{
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)httpRequestInfo{
    
    NSDictionary *dict = @{
                           @"token":mDefineToken,
                           @"oldPwd":self.phoneTF.text,
                           @"newPwd":self.pwTF.text
                           };
    
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@",mChangePSW] method:1 parameters:dict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
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
