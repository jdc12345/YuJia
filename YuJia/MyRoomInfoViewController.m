//
//  MyRoomInfoViewController.m
//  TestDemo
//
//  Created by Qian on 2017/5/15.
//  Copyright © 2017年 Qian. All rights reserved.
//

#import "MyRoomInfoViewController.h"
#import "PickViewController.h"
#import "MyRoomInfoModel.h"
#import "UIBarButtonItem+Helper.h"

@interface MyRoomInfoViewController ()<UITextViewDelegate>

/**姓名*/
@property (strong, nonatomic) IBOutlet UITextField *nameField;
/**联系电话*/
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
/**我是 */
@property (strong, nonatomic) IBOutlet UILabel *myIsLabel;
/**选择地址*/
@property (strong, nonatomic) IBOutlet UILabel *adressLabel;
/**详细地址*/
@property (strong, nonatomic) IBOutlet UITextView *detailAdressTextView;
@property (strong, nonatomic) IBOutlet UILabel *placeHolderLabel;


@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *city;
@property (copy, nonatomic) NSString *area;


@property (nonatomic, strong) MyRoomInfoModel *myRoomInfoModel;

@property (nonatomic, weak) PickViewController *userType;

@end

@implementation MyRoomInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self httpRequestHomeInfo];
    self.detailAdressTextView.delegate = self;
    self.title = @"我的房屋信息";
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" normalColor:[UIColor colorWithHexString:@"00bfff"] highlightedColor:[UIColor colorWithHexString:@"00bfff"] target:self action:@selector(httpRequestSaveHomeInfo)];
//    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];

}

- (IBAction)myIsChooseBtnAction:(UIButton *)sender {
    PickViewController *alertVC = [[PickViewController alloc]init];
    alertVC.count = 1;
    alertVC.dataArr = @[@"业主",@"租户",@"访客"];
    alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.userType = alertVC;
    [self presentViewController:alertVC animated:YES completion:nil];
    alertVC.blocksureBtn = ^(id arr) {
        self.myIsLabel.text = arr[0];
    };
}

- (IBAction)adressChooseBtnAction:(UIButton *)sender {
    PickViewController *alertVC = [[PickViewController alloc]init];
    alertVC.type = @"城市";
    alertVC.count = 3;
    alertVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
    alertVC.blocksureBtn = ^(id arr) {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@",arr[0],arr[1],arr[2]];
        self.province = arr[0];
        self.city = arr[1];
        self.area = arr[2];
        self.adressLabel.text = str;
    };
  
}

/**
 点击提交按钮 进行上传地址前检查各项信息是否填写

 @param sender 按钮
 */
- (void)subBtnAction:(UIButton *)sender {
    if (_nameField.text.length == 0) {
//        [self.view makeToast:@"请填写姓名"];
        return;
    }
    if (_phoneField.text.length == 0) {
//        [self.view makeToast:@"请填写手机号码"];
        
        return;
    }
    if (self.province.length == 0) {
//        [self.view makeToast:@"请选择收货人所在地区"];
        return;
    }
    if (self.detailAdressTextView.text.length == 0) {
//        [self.view makeToast:@"请填写详细收货地址"];
        return;
    }
    
    [self postAdressHttp];

}


/**
 提交上传网络请求
 */
- (void)postAdressHttp {
    
}

#pragma mark --
#pragma mark --UITextViewDelegate


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSLog(@"123123");
    if (![text isEqualToString:@""]) {
        self.placeHolderLabel.hidden = YES;
    }
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        self.placeHolderLabel.hidden = NO;
    }
    return YES;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.placeHolderLabel.hidden = YES;
    //该判断用于联想输入
    if (textView.text.length > 50)
    {
        textView.text = [textView.text substringToIndex:50];
    }
    if ([textView.text isEqualToString:@""] ) {
        self.placeHolderLabel.hidden = NO;
    }
}
- (void)httpRequestHomeInfo{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mMyHomeInfo,mDefineToken] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = responseObject[@"Family"];
        self.myRoomInfoModel = [MyRoomInfoModel mj_objectWithKeyValues:dict];
        
        NSString *userType;
        switch ([self.myRoomInfoModel.userType integerValue]) {
            case 0:
                userType = @"业主";
                break;
            case 1:
                userType = @"租客";
                break;
            case 2:
                userType = @"访客";
                break;
            default:
                userType = @"啥玩意";
                break;
        }
    
        self.nameField.text = self.myRoomInfoModel.ownerName;
        self.phoneField.text = self.myRoomInfoModel.ownerTelephone;
        self.myIsLabel.text = userType;
        self.adressLabel.text = self.myRoomInfoModel.areaName;
        self.detailAdressTextView.text = self.myRoomInfoModel.address;
        if (self.myRoomInfoModel.address.length >0) {
            self.placeHolderLabel.hidden = YES;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)httpRequestSaveHomeInfo{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:2];
    // userType
    NSString *userType;
    if ([self.myIsLabel.text isEqualToString:@"业主"]) {
        userType = @"0";
    }else  if ([self.myIsLabel.text isEqualToString:@"租户"]){
        userType = @"1";
    }else{
        userType = @"2";
    }
    [dict setValue:mDefineToken forKey:@"token"];
    [dict setValue:self.nameField.text forKey:@"ownerName"];
    [dict setValue:self.phoneField.text forKey:@"ownerTelephone"];
    [dict setValue:self.myIsLabel.text forKey:@"userType"];
    [dict setValue:self.adressLabel.text forKey:@"areaName"];
    [dict setValue:self.detailAdressTextView.text forKey:@"address"];
    
    NSLog(@"%@",dict);
    
    
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@",mSaveMyHomeInfo,mDefineToken] method:1 parameters:dict prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
