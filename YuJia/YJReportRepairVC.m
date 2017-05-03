//
//  YJReportRepairVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/3.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJReportRepairVC.h"
#import "UIColor+colorValues.h"
#import "YJHeaderTitleBtn.h"
#import "UILabel+Addition.h"
#import "YJRepairBaseInfoTableViewCell.h"
static NSString* tableCellid = @"table_cell";
static NSString* collectionCellid = @"collection_cell";
@interface YJReportRepairVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UITextField *telNumberField;
@property(nonatomic,weak)UITextField *passWordField;
@property(nonatomic,weak)UIButton *repairBtn;
@property(nonatomic,weak)UIButton *recordBtn;
@property(nonatomic,weak)UIButton *houseRepairBtn;
@property(nonatomic,weak)UIButton *waterRepairBtn;
@property(nonatomic,weak)UIButton *publicRepairBtn;
@property(nonatomic,weak)UIView *typeView;
@property(nonatomic,strong)NSString *repairType;

@end

@implementation YJReportRepairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报事报修";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"我要报修"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"报修记录"andTag:102];
}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    YJHeaderTitleBtn *btn = [[YJHeaderTitleBtn alloc]initWithFrame:frame and:title];
    [self.view addSubview:btn];
    btn.tag = tag;
    if (btn.tag==101) {
        self.repairBtn = btn;
    }else{
        self.recordBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    self.tableView.hidden = true;
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setImage:[UIImage imageNamed:@"selected_open"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    if (sender.tag == 101) {
        self.recordBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.recordBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.recordBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        if (self.typeView) {
            self.typeView.hidden = false;
        }else{
            UIView *view = [[UIView alloc]init];
            view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            [self.view addSubview:view];
            self.typeView = view;
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.view);
                make.top.equalTo(sender.mas_bottom).offset(42*kiphone6);
                make.width.offset(325*kiphone6);
                make.height.offset(102*kiphone6);
            }];
            UILabel *allTypeLabel = [UILabel labelWithText:@"全部类型" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
            [view addSubview:allTypeLabel];
            [allTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(view);
                make.centerY.equalTo(view.mas_top).offset(16*kiphone6);
            }];
            UIView *line = [[UIView alloc]init];
            line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
            [view addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset(0);
                make.top.offset(32*kiphone6);
                make.height.offset(1*kiphone6);
            }];
            //类型btn
            NSArray *typeArr = @[@"房屋报修",@"水电燃气",@"公共设施"];
            for (int i = 0; i<3; i++) {
                UIButton *btn = [[UIButton alloc]init];
                btn.layer.masksToBounds = true;
                btn.layer.cornerRadius = 3;
                btn.layer.borderWidth = 1;
                btn.layer.borderColor = [UIColor colorWithHexString:@"#01c0ff"].CGColor;
                btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
                [btn setTitle:typeArr[i] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:15];
                [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                [view addSubview:btn];
                btn.frame = CGRectMake(35*kiphone6+i*95*kiphone6, 56*kiphone6, 70*kiphone6, 25*kiphone6);
                btn.tag = 51+i;
                if (btn.tag == 51) {
                    self.houseRepairBtn = btn;
                }else if (btn.tag == 52){
                    self.waterRepairBtn = btn;
                }else{
                    self.publicRepairBtn = btn;
                }
                [btn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }else{
        self.repairBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.repairBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.repairBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        
    }
    }
-(void)selectType:(UIButton*)sender{
    self.repairType = sender.titleLabel.text;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:1];  //你需要更新的组数中的cell
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.typeView.hidden = true;
    if (sender.tag == 51) {
        self.waterRepairBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.waterRepairBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.publicRepairBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.publicRepairBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }else if (sender.tag == 52){
        self.houseRepairBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.houseRepairBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.publicRepairBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.publicRepairBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }else{
        self.houseRepairBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.houseRepairBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.waterRepairBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.waterRepairBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }
    if (self.tableView) {
        self.tableView.hidden = false;
    }else{
        
        //添加tableView
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        self.tableView = tableView;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.repairBtn.mas_bottom);
            make.left.right.bottom.offset(0);
        }];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[YJRepairBaseInfoTableViewCell class] forCellReuseIdentifier:tableCellid];
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellid];
        tableView.delegate =self;
        tableView.dataSource = self;
    }
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        YJRepairBaseInfoTableViewCell *cell = [[YJRepairBaseInfoTableViewCell alloc]init];
        return cell;
    }
    if (indexPath.section==1&&indexPath.row==1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        cell.textLabel.text = self.repairType;
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5*kiphone6)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5*kiphone6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 135*kiphone6;
    }
    if (indexPath.section==1&&indexPath.row==0) {
        return 123*kiphone6;
    }
    return 45*kiphone6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section==1&&indexPath.row==1) {
        [self resignFirstResponder];
        tableView.hidden = true;
        self.typeView.hidden = false;
        
    }
    
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
