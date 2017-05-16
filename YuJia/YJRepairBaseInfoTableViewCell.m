//
//  YJRepairBaseInfoTableViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/3.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJRepairBaseInfoTableViewCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import <Masonry.h>
@interface YJRepairBaseInfoTableViewCell()<UITextFieldDelegate>
@property (nonatomic, weak) UIImageView* icon;


@end
@implementation YJRepairBaseInfoTableViewCell

-(instancetype)init{
    if (self = [super init]) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    //添加姓名imageView图标
    UIImageView *nameImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"name"]];
    [self.contentView addSubview:nameImageView];
    [nameImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(self.contentView.mas_top).offset(22*kiphone6);
    }];
    //添加nameTextField
    UITextField *nameTextField = [[UITextField alloc]init];
    nameTextField.font = [UIFont boldSystemFontOfSize:13];
    nameTextField.placeholder = @"姓名";
    [nameTextField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [nameTextField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.contentView addSubview:nameTextField];
    [nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameImageView.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(nameImageView);
        make.width.offset(self.contentView.bounds.size.width-40*kiphone6);
        make.height.equalTo(nameImageView);
    }];
    self.nameField = nameTextField;
    nameTextField.delegate = self;
    //添加line1
    UIView *line1 = [[UIView alloc]init];
    line1.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(44*kiphone6);
        make.height.offset(1*kiphone6);
    }];
    //添加电话imageView图标
    UIImageView *telImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"telePhone"]];
    [self.contentView addSubview:telImageView];
    [telImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(line1.mas_bottom).offset(22*kiphone6);
    }];
    //添加电话textField
    UITextField *telNumberField = [[UITextField alloc]init];
    telNumberField.font = [UIFont boldSystemFontOfSize:13];
    telNumberField.placeholder = @"电话";
    [telNumberField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [telNumberField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    telNumberField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘的样式
    [self.contentView addSubview:telNumberField];
    [telNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(telImageView.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(telImageView);
        make.width.offset(self.contentView.bounds.size.width-40*kiphone6);
        make.height.equalTo(telImageView);
    }];
    self.telNumberField = telNumberField;
    telNumberField.delegate = self;
    
    //添加line2
    UIView *line2 = [[UIView alloc]init];
    line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(line1.mas_bottom).offset(44*kiphone6);
        make.height.offset(1*kiphone6);
    }];
    //添加地址imageView图标
    UIImageView *addressImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_repair"]];
    [self.contentView addSubview:addressImageView];
    [addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(line2.mas_bottom).offset(22*kiphone6);
    }];
    //添加地址textField
    UITextField *addressField = [[UITextField alloc]init];
    addressField.font = [UIFont boldSystemFontOfSize:13];
    addressField.placeholder = @"地址";
    [addressField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [addressField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.contentView addSubview:addressField];
    [addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressImageView.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(addressImageView);
        make.width.offset(self.contentView.bounds.size.width-40*kiphone6);;
        make.height.equalTo(addressImageView);
    }];
    self.addressField = addressField;
    addressField.delegate = self;

}
#pragma UItextdelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (self.telNumberField == textField)  //判断是否是我们想要限定的那个输入框
    {
        if ([toBeString length] > 11) { //如果输入框内容大于20则弹出警告
            textField.text = [textField.text substringToIndex:11];
//            [self showAlertWithMessage:@"您输入的电话号码超过11位"];
            [SVProgressHUD showErrorWithStatus:@"您输入的电话号码超过11位"];
            return NO;
        }
    }
    return YES;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSString * toBeString = textField.text; //得到输入框的内容
    if (self.telNumberField == textField)  //判断是否是我们想要限定的那个输入框
        
    {

        if ([textField.text length] < 11){
//            [self showAlertWithMessage:@"您输入的电话号码少于11位"];
            [SVProgressHUD showErrorWithStatus:@"您输入的电话号码少于11位"];
            
        }else if ([textField.text length] == 11){
            if (![self valiMobile:toBeString]) {
//                [self showAlertWithMessage:@"请输入正确的11位电话号码"];
                [SVProgressHUD showErrorWithStatus:@"请输入正确的11位电话号码"];
                
            }
        }
    }
}
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    NSString * toBeString = textField.text; //得到输入框的内容
//    if ([textField.text length] == 11){
//        if (![self valiMobile:toBeString]) {
//            [self showAlertWithMessage:@"请输入正确的11位电话号码"];
//            return false;
//        }
//    }
//    return true;
//
//}
//判断手机号码格式是否正确
- (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
