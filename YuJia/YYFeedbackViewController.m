//
//  YYFeedbackViewController.m
//  YuYi_Client
//
//  Created by wylt_ios_1 on 2017/2/28.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YYFeedbackViewController.h"
#import "UIBarButtonItem+Helper.h"
#import "HttpClient.h"
#import "CcUserModel.h"

@interface YYFeedbackViewController ()
@property (nonatomic, strong) UITextView *feedTextView;
@property (nonatomic, strong) UITextField *phoneTextF;
@end

@implementation YYFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.title = @"意见反馈";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" normalColor:[UIColor colorWithHexString:@"#0ddcbc"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(sendFeedBack)];
    [self createSubView];
    // Do any additional setup after loading the view.
}
- (void)createSubView{
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"您的意见";
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    
    
    UITextView *feedTextView = [[UITextView alloc]init];
//    feedTextView.scrollEnabled = NO;
    feedTextView.font = [UIFont systemFontOfSize:14];
    feedTextView.textColor = [UIColor colorWithHexString:@"333333"];
    feedTextView.layer.cornerRadius = 2.5;
    feedTextView.clipsToBounds = YES;
    feedTextView.backgroundColor = [UIColor whiteColor];
    feedTextView.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
    
    
    UILabel *wordCount = [[UILabel alloc]init];
    wordCount.text = @"0/200";
    wordCount.textColor = [UIColor colorWithHexString:@"b4b4b4"];
    wordCount.font = [UIFont systemFontOfSize:12];
    wordCount.textAlignment = NSTextAlignmentRight; 
    
    
    UILabel *phoneLabel = [[UILabel alloc]init];
    phoneLabel.text = @"您的联系方式";
    phoneLabel.textColor = [UIColor colorWithHexString:@"333333"];
    phoneLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *cardLabel = [[UILabel alloc]init];
    cardLabel.backgroundColor = [UIColor whiteColor];
    cardLabel.layer.cornerRadius = 2.5;
    cardLabel.clipsToBounds = YES;
    
    UITextField *phoneTextF = [[UITextField alloc]init];
    phoneTextF.font = [UIFont systemFontOfSize:14];
    phoneTextF.textColor = [UIColor colorWithHexString:@"333333"];
    phoneTextF.placeholder = @"输入邮箱或者电话";
    
    
    [self.view addSubview:titleLabel];
    [self.view addSubview:feedTextView];
    [self.view addSubview:wordCount];
    [self.view addSubview:phoneLabel];
    [self.view addSubview:cardLabel];
    [self.view addSubview:phoneTextF];
    
    WS(ws);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.view).with.offset(78 *kiphone6);
        make.left.equalTo(ws.view).with.offset(20 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(300 ,14));
    }];
    [feedTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(14 *kiphone6);
        make.left.equalTo(ws.view).with.offset(10 );
        make.size.mas_equalTo(CGSizeMake(kScreenW -20, 240 *kiphone6 ));
    }];
    [wordCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(feedTextView.mas_bottom).with.offset(10 *kiphone6);
        make.right.equalTo(ws.view).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 12 *kiphone6 ));
    }];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(wordCount.mas_bottom).with.offset(15 *kiphone6);
        make.left.equalTo(ws.view).with.offset(20 *kiphone6);
        make.size.mas_equalTo(CGSizeMake(300 ,14));
    }];
    
    [cardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneLabel.mas_bottom).with.offset(15 *kiphone6);
        make.left.equalTo(ws.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(kScreenW -20, 60 *kiphone6 ));
    }];
    
    [phoneTextF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cardLabel.mas_centerY);
        make.centerX.equalTo(cardLabel.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenW -40, 14 *kiphone6 ));
    }];
    
    self.feedTextView = feedTextView;
    self.phoneTextF = phoneTextF;
    
}
- (void)sendFeedBack{
//    NSString *tokenStr = [CcUserModel defaultClient].userToken;
    
    NSDictionary *dict = @{
                           @"token":mDefineToken,
                           @"id":_personalModel.myFamilyId,
                           @"content":self.feedTextView.text,
                           @"contact":self.phoneTextF.text
                           };
    
    [[HttpClient defaultClient]requestWithPath:mFeedBack method:1 parameters:dict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"提交成功%@",responseObject);

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"反馈意见提交成功" preferredStyle:UIAlertControllerStyleAlert];
        //       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        //       [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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
