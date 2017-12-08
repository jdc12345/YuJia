//
//  YJInputPayNumberVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/8.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJInputPayNumberVC.h"
#import "UILabel+Addition.h"

static NSString* payCellid = @"pay_cell";
@interface YJInputPayNumberVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *payTableView;

@property(nonatomic,weak)UITextField *numberField;
@property(nonatomic,weak)UIView *payView;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UIButton *select1Btn;
@property(nonatomic,weak)UIButton *select2Btn;
@property(nonatomic,weak)UIButton *select3Btn;
@property(nonatomic,weak)UIButton *nowPayBtn;//立即支付按钮

@end

@implementation YJInputPayNumberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费金额";
//    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//    [self loadData];
}
-(void)setInfoModel:(YJLifePayInfiModel *)infoModel{
    _infoModel = infoModel;
    [self setupUI];
}
- (void)setupUI {
    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Actiondo:)];
    [self.view addGestureRecognizer:tapGesture];
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    tableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    self.payTableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:payCellid];
    
    tableView.delegate =self;
    tableView.dataSource = self;
    
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:payCellid];;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    NSArray *itemArr = @[@"缴费单位",@"客户编号",@"户名",@"用电地址",@"缴费类型",@"入表金额"];
    cell.textLabel.text = itemArr[indexPath.row];
    NSArray *contentArr = @[self.infoModel.propertyName,self.infoModel.customerNum,self.infoModel.ownerName,self.infoModel.detailAddress,self.infoModel.payType,@"0.00元"];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        cell.detailTextLabel.text = contentArr[indexPath.row];
            return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    //添加缴费金额textField
    UITextField *numberField = [[UITextField alloc]init];
    UIView *leftView = [[UIView alloc]init];
    leftView.bounds = CGRectMake(0, 0, 10*kiphone6, 45*kiphone6);
    numberField.leftView = leftView;
    numberField.leftViewMode = UITextFieldViewModeAlways;
    numberField.font = [UIFont boldSystemFontOfSize:13];
    numberField.placeholder = @"请输入缴费金额";
    [numberField setValue:[UIColor colorWithHexString:@"#999999"] forKeyPath:@"_placeholderLabel.textColor"];
    [numberField setValue:[UIFont boldSystemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    numberField.layer.borderWidth = 1*kiphone6;
    numberField.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    numberField.layer.masksToBounds = true;
    numberField.layer.cornerRadius = 3;
    numberField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘的样式
    self.numberField = numberField;
    numberField.delegate = self;
    [view addSubview:numberField];
    [numberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.offset(15*kiphone6);
        make.right.offset(-15*kiphone6);
        make.height.offset(45*kiphone6);
    }];
    [numberField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100*kiphone6)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    UIImageView *flagImageView = [[UIImageView alloc]init];
    flagImageView.image = [UIImage imageNamed:@"flag_pay"];
    [footerView addSubview:flagImageView];
    [flagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(35*kiphone6);
        make.top.offset(20*kiphone6);
    }];
    UILabel *flagLabel = [UILabel labelWithText:@"本次缴费由宇家平台代收，24小时内向保定市供水总公司转账" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:10];
    flagLabel.numberOfLines = 0;
    [footerView addSubview:flagLabel];
    [flagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(flagImageView.mas_right).offset(5*kiphone6);
        make.centerY.equalTo(flagImageView);
        make.right.offset(-35*kiphone6);
    }];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    [btn setTitle:@"立即缴费" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    btn.layer.borderWidth =  1;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.nowPayBtn = btn;
    btn.userInteractionEnabled = false;
    [footerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(72*kiphone6);
        make.centerX.equalTo(footerView);
        make.width.offset(325*kiphone6);
        make.height.offset(45*kiphone6);
    }];
    [footerView addSubview:btn];
    return footerView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 200*kiphone6;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}

#pragma  mark - textField delegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
////    NSLog(@"string:%@,string.length:%ld,textField.text:%@,&&textField.text.length:%ld",string,string.length,textField.text,textField.text.length);
//    if (string) {
//        [self.nowPayBtn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
//        self.nowPayBtn.layer.borderColor = [UIColor colorWithHexString:@"#00eac6"].CGColor;
//        self.nowPayBtn.userInteractionEnabled = true;
//    }
//    if(string.length==0&&textField.text.length==1){
//        [self.nowPayBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//        self.nowPayBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
//        self.nowPayBtn.userInteractionEnabled = false;
//    }
//    //    NSLog(@"1");//输入文字时 一直监听
//    return YES;
//}
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    UITableViewCell *cell = [self.payTableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",theTextField.text];
    if (theTextField.text.length>0) {
        [self.nowPayBtn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
        self.nowPayBtn.layer.borderColor = [UIColor colorWithHexString:@"#00eac6"].CGColor;
        self.nowPayBtn.userInteractionEnabled = true;
    }else{
        [self.nowPayBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.nowPayBtn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        self.nowPayBtn.userInteractionEnabled = false;
    }
    
}
-(void)Actiondo:(id)sender{
    [self.numberField resignFirstResponder];
}
-(void)goPay{
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    self.backView = backView;
    UIView *payView = [[UIView alloc]init];
    payView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:payView];
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(443*kiphone6);
    }];
    self.payView = payView;
    UIButton *closeBtn = [[UIButton alloc]init];
    [closeBtn setImage:[UIImage imageNamed:@"chahao"] forState:UIControlStateNormal];
    [payView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(payView.mas_top).offset(28*kiphone6);
        make.width.height.offset(30*kiphone6);
    }];
    [closeBtn addTarget:self action:@selector(closePay) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLabel = [UILabel labelWithText:@"确认付款" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:17];
    [payView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(payView);
        make.centerY.equalTo(payView.mas_top).offset(28*kiphone6);
    }];
    //添加line1
    UIView *line1 = [self addLineWithFrame:CGRectMake(0, 56*kiphone6, kScreenW, 1*kiphone6)];
    NSString *payNumber = [NSString stringWithFormat:@"¥ %@元",self.numberField.text];
    UILabel *payNumberLabel = [UILabel labelWithText:payNumber andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:25];
    [payView addSubview:payNumberLabel];
    [payNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(payView);
        make.centerY.equalTo(line1.mas_bottom).offset(44*kiphone6);
    }];
    //添加line2
    UIView *line2 = [self addLineWithFrame:CGRectMake(0, 144*kiphone6, kScreenW, 1*kiphone6)];
    UILabel *payTypeLabel = [UILabel labelWithText:@"选择支付方式" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:15];
    [payView addSubview:payTypeLabel];
    [payTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(line2.mas_bottom).offset(22.5*kiphone6);
    }];
    //添加line3
    UIView *line3 = [self addLineWithFrame:CGRectMake(0, 189*kiphone6, kScreenW, 1*kiphone6)];
    UIImageView *alipayView = [[UIImageView alloc]init];
    alipayView.image = [UIImage imageNamed:@"alipay"];
    [payView addSubview:alipayView];
    [alipayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(line3.mas_bottom).offset(22.5*kiphone6);
    }];
    UILabel *payTypeItemLabel = [UILabel labelWithText:@"支付宝" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [payView addSubview:payTypeItemLabel];
    [payTypeItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayView.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(line3.mas_bottom).offset(22.5*kiphone6);
    }];
    UIButton *select1Btn = [[UIButton alloc]init];
    select1Btn.tag = 101;
    [select1Btn setImage:[UIImage imageNamed:@"pay_unselected"] forState:UIControlStateNormal];
    [select1Btn setImage:[UIImage imageNamed:@"pay_selected"] forState:UIControlStateSelected];
    [payView addSubview:select1Btn];
    self.select1Btn = select1Btn;
    [select1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.centerY.equalTo(line3.mas_bottom).offset(22.5*kiphone6);
    }];
    //添加line4
    UIView *line4 = [self addLineWithFrame:CGRectMake(0, 234*kiphone6, kScreenW, 1*kiphone6)];
    UIImageView *weiChatView = [[UIImageView alloc]init];
    weiChatView.image = [UIImage imageNamed:@"weiChat"];
    [payView addSubview:weiChatView];
    [weiChatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(line4.mas_bottom).offset(22.5*kiphone6);
    }];
    UILabel *weiChatLabel = [UILabel labelWithText:@"微信" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [payView addSubview:weiChatLabel];
    [weiChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayView.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(line4.mas_bottom).offset(22.5*kiphone6);
    }];
    UIButton *select2Btn = [[UIButton alloc]init];
    select2Btn.tag = 102;
    [select2Btn setImage:[UIImage imageNamed:@"pay_unselected"] forState:UIControlStateNormal];
    [select2Btn setImage:[UIImage imageNamed:@"pay_selected"] forState:UIControlStateSelected];
    [payView addSubview:select2Btn];
    self.select2Btn = select2Btn;
    [select2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.centerY.equalTo(line4.mas_bottom).offset(22.5*kiphone6);
    }];
    //添加line5
    UIView *line5 = [self addLineWithFrame:CGRectMake(0, 279*kiphone6, kScreenW, 1*kiphone6)];
    UIImageView *bankCardView = [[UIImageView alloc]init];
    bankCardView.image = [UIImage imageNamed:@"bankCard"];
    [payView addSubview:bankCardView];
    [bankCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(line5.mas_bottom).offset(22.5*kiphone6);
    }];
    UILabel *bankCardLabel = [UILabel labelWithText:@"银行卡" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [payView addSubview:bankCardLabel];
    [bankCardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(alipayView.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(line5.mas_bottom).offset(22.5*kiphone6);
    }];
    UIButton *select3Btn = [[UIButton alloc]init];
    [select3Btn setImage:[UIImage imageNamed:@"pay_unselected"] forState:UIControlStateNormal];
    [select3Btn setImage:[UIImage imageNamed:@"pay_selected"] forState:UIControlStateSelected];
    [payView addSubview:select3Btn];
    select3Btn.tag = 103;
    self.select3Btn = select3Btn;
    [select3Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.centerY.equalTo(line5.mas_bottom).offset(22.5*kiphone6);
    }];
    [select1Btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [select2Btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [select3Btn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //添加line5
    UIView *line6 = [self addLineWithFrame:CGRectMake(0, 324*kiphone6, kScreenW, 1*kiphone6)];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [btn setTitle:@"立即缴费" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(nowPayMoney:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    btn.layer.borderWidth =  1;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#00eac6"].CGColor;
    [payView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line6.mas_bottom).offset(40*kiphone6);
        make.centerX.equalTo(payView);
        make.width.offset(325*kiphone6);
        make.height.offset(45*kiphone6);
    }];
 
}
-(void)nowPayMoney:(UIButton*)sender{
    [SVProgressHUD showInfoWithStatus:@"此功能暂时还未开放"];
    //如果成功支付就添加缴费记录
//    添加生活缴费缴费记录接口
//http://localhost:8080/smarthome/mobileapi/detailrecord/AddDetailRecord.do?token=49491B920A9DD107E146D961F4BDA50E&drType=1&drNumber=dianfei1111&propertyId=1&detailHomeId=12&paymentAmount=200&paymentMethod=1
//    参数：       参数名                     参数类型                             备注
//    token                       String                    令牌
//    drType              Integer          缴费类型1=电费2=水费3=燃气费4=物业费
//    drNumber               Long        表的编号，缴物业费的时候用上传家的地址ID
//    propertyId               Long        物业单位ID
//    detailHomeId             Long          缴费地址ID
//    paymentAmount             Long            缴费金额
//    paymentMethod            String    支付方式1=微信支付2=支付宝支付
//    code                              0表示成功-1失败
//    message                    失败原因描述
    
}
-(void)selectBtnClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        if (sender.tag==101) {
            self.select2Btn.selected = false;
            self.select3Btn.selected = false;
            //标记为支付宝支付
        }else if (sender.tag==102){
            self.select1Btn.selected = false;
            self.select3Btn.selected = false;
            //标记为微信支付
        }else{
            self.select2Btn.selected = false;
            self.select1Btn.selected = false;
            //标记为银行卡支付
        }
    }
}
-(void)closePay{
    [self.backView removeFromSuperview];
}
-(UIView*)addLineWithFrame:(CGRect)frame{
    UIView *line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.payView addSubview:line];
    return line;
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
