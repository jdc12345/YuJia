//
//  YJPayPropertyVC.m
//  YuJia
//
//  Created by 万宇 on 2017/7/21.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPayPropertyVC.h"
#import "UILabel+Addition.h"
#import "YJInputPayNumberVC.h"
#import "YJModifyAddressVC.h"

static NSString* payCellid = @"pay_cell";
@interface YJPayPropertyVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *payTableView;
@property(nonatomic,strong)NSArray *payItemArr;
@property(nonatomic,weak)UITextField *numberField;
@property(nonatomic,weak)UIButton *btn;//下一步按钮
@property(nonatomic,weak)UIView *payView;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UIButton *select1Btn;
@property(nonatomic,weak)UIButton *select2Btn;
@property(nonatomic,weak)UIButton *select3Btn;
@property(nonatomic,strong)YJLifePayInfiModel *infoModel;//该地址的缴费信息


@end

@implementation YJPayPropertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    
}
-(void)setCurrentAddressModel:(YJLifePayAddressModel *)currentAddressModel{
    _currentAddressModel = currentAddressModel;
http://localhost:8080/smarthome/mobileapi/detailHome/findPayment.do?token=49491B920A9DD107E146D961F4BDA50E&DhId=12  //根据缴费地址ID查询缴费单位，缴费地址，用户名（生活缴费用户输入编号后点击下一步需要显示的信息）
    [SVProgressHUD show];// 动画开始
    NSString *addressUrlStr = [NSString stringWithFormat:@"%@/mobileapi/detailHome/findPayment.do?token=%@&DhId=%ld",mPrefixUrl,mDefineToken1,currentAddressModel.info_id];
    [[HttpClient defaultClient]requestWithPath:addressUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSDictionary *dic = responseObject[@"result"];
            YJLifePayInfiModel *infoModel = [YJLifePayInfiModel mj_objectWithKeyValues:dic];
            self.infoModel = infoModel;
            [self setupUI];
        }else{
            if ([responseObject[@"code"] isEqualToString:@"-1"]) {
                [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
            }
        }
        [SVProgressHUD dismiss];// 动画结束
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
}
- (void)setupUI {
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
    
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:payCellid];;
    //添加line
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6);
    }];
    
    if (indexPath.row==0) {
        //添加编号textField
        UITextField *numberField = [[UITextField alloc]init];
        numberField.font = [UIFont boldSystemFontOfSize:22];
        numberField.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;//垂直居中
        numberField.textAlignment = NSTextAlignmentCenter; //水平居中
        
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"输入缴费金额" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#999999"],NSFontAttributeName:[UIFont boldSystemFontOfSize:22], NSParagraphStyleAttributeName:style}];
        numberField.attributedPlaceholder = attri;
        numberField.keyboardType = UIKeyboardTypeNumberPad;//设置键盘的样式
        [cell.contentView addSubview:numberField];
        [numberField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
        numberField.leftViewMode = UITextFieldViewModeWhileEditing;
        self.numberField = numberField;
        numberField.delegate = self;
    }else{
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.textLabel.text = @"缴费单位";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        cell.detailTextLabel.text = self.infoModel.propertyName;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 76*kiphone6)];
    view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    UIButton *headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 76*kiphone6)];
    [headerBtn setImage:[UIImage imageNamed:@"address_backPhoto"] forState:UIControlStateNormal];
    [view addSubview:headerBtn];
    //    headerBtn.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_info"]];
    [headerBtn addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(headerBtn);
    }];
    UILabel *addressLabel = [UILabel labelWithText:self.currentAddressModel.detailAddress andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:14];
    [headerBtn addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_centerY).offset(2.5*kiphone6);
        make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
    }];
    UILabel *cityLabel = [UILabel labelWithText:self.currentAddressModel.city andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:17];
    [headerBtn addSubview:cityLabel];
    [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addressLabel.mas_top).offset(-5*kiphone6);
        make.left.equalTo(imageView.mas_right).offset(10*kiphone6);
    }];
    self.clickBtnBlock = ^(YJLifePayAddressModel *model) {//将地址管理页面返回的地址更新
        addressLabel.text = model.detailAddress;
        cityLabel.text = model.city;
        //此处需要根据新地址请求编号和收费单位
        
        
        
    };
    UIImageView *gray_forward = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"gray_forward"]];
    [headerBtn addSubview:gray_forward];
    [gray_forward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.centerY.equalTo(headerBtn);
    }];
    [headerBtn addTarget:self action:@selector(goAddAddress) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 76*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100*kiphone6)];
    footerView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    btn.layer.borderWidth =  1;
    btn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    [btn setTitle:@"立即缴费" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(goPay) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    [footerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(40*kiphone6);
        make.centerX.equalTo(footerView);
        make.width.offset(325*kiphone6);
        make.height.offset(45*kiphone6);
    }];
    btn.userInteractionEnabled = false;
    self.btn = btn;
    [footerView addSubview:btn];
    
    return footerView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 100*kiphone6;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
}
- (void)goAddAddress{
    YJModifyAddressVC *vc = [[YJModifyAddressVC alloc]init];
    [self.navigationController pushViewController:vc animated:true];
    
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
#pragma  mark - textField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    NSLog(@"string:%@,string.length:%ld,textField.text:%@,&&textField.text.length:%ld",string,string.length,textField.text,textField.text.length);
    if (string) {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
        self.btn.layer.borderColor = [UIColor colorWithHexString:@"#00eac6"].CGColor;
        self.btn.userInteractionEnabled = true;
    }
    if(string.length==0&&textField.text.length==1){
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        self.btn.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
        self.btn.userInteractionEnabled = false;
    }
    //    NSLog(@"1");//输入文字时 一直监听
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"¥";
    NSLog(@"2");// 准备开始输入  文本字段将成为第一响应者
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
