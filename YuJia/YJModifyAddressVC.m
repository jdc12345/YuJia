//
//  YJModifyAddressVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/5.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJModifyAddressVC.h"
#import "YJAddPropertyBillAddressVC.h"
#import "YJPropertyBillVC.h"
#import "YJLifepaymentVC.h"
//#import "YJPropertyAddressModel.h"
#import "YJLifePayAddressModel.h"
#import "YJChangePropertyBillAddressVC.h"

#import "manageAddressTVCell.h"
#import "YJEditNumberVC.h"
#import "YJPayPropertyVC.h"

static NSString* detailInfoCellid = @"detailInfo_cell";
@interface YJModifyAddressVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,strong)NSIndexPath *index;//选中的cell

@end

@implementation YJModifyAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址管理";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
//    [self setupUI];
    [self loadData];
}
- (void)loadData {
    //    CcUserModel *userModel = [CcUserModel defaultClient];
    //    NSString *token = userModel.userToken;
    //    http://192.168.1.55:8080/smarthome/mobileapi/family/findFamilyAddress.do?token=ACDCE729BCE6FABC50881A867CAFC1BC   查询业主地址
    [SVProgressHUD show];// 动画开始
    NSString *addressUrlStr = [NSString stringWithFormat:@"%@/mobileapi/family/findFamilyAddress.do?token=%@",mPrefixUrl,mDefineToken1];
    [[HttpClient defaultClient]requestWithPath:addressUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                YJLifePayAddressModel *infoModel = [YJLifePayAddressModel mj_objectWithKeyValues:dic];
                [mArr addObject:infoModel];
            }
            self.addresses = mArr;
            [self setupUI];
        }else{
            if ([responseObject[@"code"] isEqualToString:@"-1"]) {
            }
        }
        [SVProgressHUD dismiss];// 动画结束
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
}
//-(void)setAddresses:(NSMutableArray *)addresses{
//    _addresses = addresses;
//    [self setupUI];
//}
- (void)setupUI {
    NSMutableArray* rightItemArr = [NSMutableArray array];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]   initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -5;
    [rightItemArr addObject:negativeSpacer];//修正按钮离屏幕边缘位置的UIBarButtonItem应在按钮的前边加入数组
    UIButton *postAddressBtn = [[UIButton alloc]init];
    [postAddressBtn setTitle:@"添加" forState:UIControlStateNormal];
    postAddressBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [postAddressBtn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    [postAddressBtn sizeToFit];
    [postAddressBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:postAddressBtn];
    [rightItemArr addObject:rightBarItem];
    self.navigationItem.rightBarButtonItems = rightItemArr;//导航栏右侧按钮
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5*kiphone6);
        make.bottom.left.right.offset(0);
    }];
    tableView.bounces = false;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[manageAddressTVCell class] forCellReuseIdentifier:detailInfoCellid];
    tableView.delegate =self;
    tableView.dataSource = self;
    
}
- (void)addAddress{
    YJAddPropertyBillAddressVC *vc = [[YJAddPropertyBillAddressVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//弹出alert,删除地址时候用
-(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:message];
    
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#666666"] range:NSMakeRange(0, message.length)];
    
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, message.length)];
    
    [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YJLifePayAddressModel *model = self.addresses[_index.row];
        //        http://localhost:8080/smarthome/mobileapi/family/deleteDetailHomeAddress.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&AddressId=2
        NSString *urlStr = [NSString stringWithFormat:@"%@/mobileapi/family/deleteDetailHomeAddress.do?token=%@&AddressId=%ld",mPrefixUrl,mDefineToken1,model.info_id];
        //        [SVProgressHUD show];// 动画开始
        [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [self.addresses removeObjectAtIndex:self.index.row];
                [self.tableView deleteRowsAtIndexPaths:@[self.index] withRowAnimation:UITableViewRowAnimationAutomatic];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"删除未成功，请稍后再试"];
            return ;
        }];
    }];
    [cancelAction setValue:[UIColor colorWithHexString:@"#666666"] forKey:@"titleTextColor"];
    [okAction setValue:[UIColor colorWithHexString:@"#00eac6"] forKey:@"titleTextColor"];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addresses.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    manageAddressTVCell *cell = [tableView dequeueReusableCellWithIdentifier:detailInfoCellid forIndexPath:indexPath];
    YJLifePayAddressModel *model = self.addresses[indexPath.row];
    cell.model = model;
    cell.clickBtnBlock = ^(NSInteger tag, YJLifePayAddressModel *model) {
        if (tag==31) {//删除
            for (YJLifePayAddressModel *smodel in self.addresses) {
                if (smodel.info_id == model.info_id) {
                    NSInteger row = [self.addresses indexOfObject:smodel];
                    NSIndexPath *index = [NSIndexPath indexPathForRow:row inSection:0];
                    self.index = index;
                    [self showAlertWithMessage:@"你确定要删除该地址？"];
                }
            }
        }else{//编辑
            YJChangePropertyBillAddressVC *chanceVC = [[YJChangePropertyBillAddressVC alloc]init];
            chanceVC.info_id = model.info_id;//传给修改页面要修改地址的id
            [self.navigationController pushViewController:chanceVC animated:true];
        }
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    manageAddressTVCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selected) {
        cell.backView.layer.borderColor = [UIColor colorWithHexString:@"#00eac6"].CGColor;
    }else{
        cell.backView.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;

    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[YJEditNumberVC class]]) {
            YJEditNumberVC *revise =(YJEditNumberVC *)controller;//具体收费页面
            revise.clickBtnBlock(cell.model);
            [self.navigationController popToViewController:revise animated:YES];
        }
        
        if ([controller isKindOfClass:[YJPayPropertyVC class]]) {
            YJPayPropertyVC *revise =(YJPayPropertyVC *)controller;//物业缴费页面
            revise.clickBtnBlock(cell.model);
            [self.navigationController popToViewController:revise animated:YES];
        }
        if (self.navigationController.viewControllers.count<4) {
            if ([controller isKindOfClass:[YJLifepaymentVC class]]) {
                YJLifepaymentVC *revise =(YJLifepaymentVC *)controller;//生活缴费首页
                revise.clickBtnBlock(cell.model);
                [self.navigationController popToViewController:revise animated:YES];
            }
        }
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80*kiphone6;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return true;
}
/**
 *  左滑cell时出现什么按钮
 */
//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    YJPropertyAddressModel *model = self.addresses[indexPath.row];
//    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"修改" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//        NSLog(@"点击了修改");
//        // 收回左滑出现的按钮(退出编辑模式)
//        tableView.editing = NO;
//        YJChangePropertyBillAddressVC *chanceVC = [[YJChangePropertyBillAddressVC alloc]init];
//        chanceVC.info_id = model.info_id;//传给修改页面要修改地址的id
//        [self.navigationController pushViewController:chanceVC animated:true];
//    }];
//    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
////        http://localhost:8080/smarthome/mobileapi/family/deleteDetailHomeAddress.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&AddressId=2
//        NSString *urlStr = [NSString stringWithFormat:@"%@/mobileapi/family/deleteDetailHomeAddress.do?token=%@&AddressId=%ld",mPrefixUrl,mDefineToken1,model.info_id];
////        [SVProgressHUD show];// 动画开始
//        [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
//            
//        } success:^(NSURLSessionDataTask *task, id responseObject) {
//            if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                [self.addresses removeObjectAtIndex:indexPath.row];
//                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            }else{
//                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            [SVProgressHUD showErrorWithStatus:@"删除未成功，请稍后再试"];
//            return ;
//        }];
//        
//    }];
//    
//    return @[action1, action0];
////    return @[action1];
//}
//修改地址返回该页面更新对应地址
-(void)setAddressModel:(YJPropertyDetailAddressModel *)addressModel{
    _addressModel = addressModel;
    for (int i = 0; i<self.addresses.count; i++) {
        YJLifePayAddressModel *model = self.addresses[i];
        if (model.info_id == self.addressModel.info_id) {
            model.city = addressModel.city;
            model.detailAddress = [NSString stringWithFormat:@"%@%@%@%@%@",self.addressModel.residentialQuarters,self.addressModel.buildingNumber,self.addressModel.unitNumber,self.addressModel.floor,self.addressModel.roomNumber];
            [self.tableView reloadData];
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
