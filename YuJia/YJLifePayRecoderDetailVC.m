//
//  YJLifePayRecoderDetailVC.m
//  YuJia
//
//  Created by 万宇 on 2017/7/28.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJLifePayRecoderDetailVC.h"
#import "UILabel+Addition.h"

static NSString* payCellid = @"pay_cell";
@interface YJLifePayRecoderDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,weak)UITableView *payTableView;

@property(nonatomic,weak)UITextField *numberField;
@property(nonatomic,weak)UIView *payView;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UIButton *select1Btn;
@property(nonatomic,weak)UIButton *select2Btn;
@property(nonatomic,weak)UIButton *select3Btn;
@property(nonatomic,weak)UIButton *nowPayBtn;//立即支付按钮

@end

@implementation YJLifePayRecoderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费金额";
//    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
}
-(void)setInfoModel:(YJLifePayRecoderModel *)infoModel{
    _infoModel = infoModel;
    [self setupUI];
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
    if (self.infoModel.paymentStatus==1) {//支付成功
        return 6;
    }else if (self.infoModel.paymentStatus==2) {//退款成功
        return 8;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:payCellid];;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    NSString *paymentMethod = @"";
    if (self.infoModel.paymentMethod==1) {
     paymentMethod = @"微信";
    }else if (self.infoModel.paymentMethod==2){
     paymentMethod = @"支付宝";
    }
    if (self.infoModel.paymentStatus==1) {//支付成功
        NSArray *itemArr = @[@"缴费说明",@"户号",@"支付方式",@"当前状态",@"支付时间",@"订单号"];
        cell.textLabel.text = itemArr[indexPath.row];
        NSArray *contentArr = @[self.infoModel.paymentInstruction,[NSString stringWithFormat:@"%ld",self.infoModel.personalId],paymentMethod,@"支付成功",self.infoModel.paymentTimeString,self.infoModel.orderNumber];
        cell.detailTextLabel.text = contentArr[indexPath.row];
    }else if (self.infoModel.paymentStatus==2) {//退款成功
    
        NSArray *itemArr = @[@"退款金额",@"退款时间",@"缴费说明",@"户号",@"支付方式",@"当前状态",@"支付时间",@"订单号"];
        cell.textLabel.text = itemArr[indexPath.row];
        NSArray *contentArr = @[[NSString stringWithFormat:@"%ld",self.infoModel.refundAmount],self.infoModel.refundTimeString,self.infoModel.paymentInstruction,[NSString stringWithFormat:@"%ld",self.infoModel.personalId],paymentMethod,[NSString stringWithFormat:@"已退款(¥%ld)",self.infoModel.refundAmount],self.infoModel.paymentTimeString,self.infoModel.orderNumber];
        cell.detailTextLabel.text = contentArr[indexPath.row];
    }
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#999999"];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 32*kiphone6;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    //添加收费单位名字Lable
    UILabel *nameLabel = [UILabel labelWithText:self.infoModel.propertyName andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(22*kiphone6);
        make.centerX.equalTo(view);
    }];
    //添加缴费项目图片
    UIImageView *itemView = [[UIImageView alloc]init];
    switch (self.infoModel.drType) {
        case 1:
            itemView.image = [UIImage imageNamed:@"electric_payed"];//电费
            break;
        case 2:
            itemView.image = [UIImage imageNamed:@"water_payed"];//水费
            break;
        case 3:
            itemView.image = [UIImage imageNamed:@"Gas_payed"];//燃气费
            break;
        case 4:
            itemView.image = [UIImage imageNamed:@"Property_payed"];//物业费
            break;
        default:
            break;
    }
    [view addSubview:itemView];
    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15*kiphone6);
        make.right.equalTo(nameLabel.mas_left).offset(-10*kiphone6);
    }];
    //添加缴费金额Lable
    UILabel *moneyLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%02ld",self.infoModel.paymentAmount] andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:30];
    [view addSubview:moneyLabel];
    [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(33*kiphone6);
        make.centerX.equalTo(view);
    }];
    view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 130*kiphone6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
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
