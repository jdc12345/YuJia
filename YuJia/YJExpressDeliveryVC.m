//
//  YJExpressDeliveryVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJExpressDeliveryVC.h"
#import "UILabel+Addition.h"
#import "YJExpressReceiveTVCell.h"
#import "YJExpressSenderTVCell.h"
#import "YJExpressCompanyModel.h"
#import "YJExpressReceiveModel.h"
//#import "UIViewController+Cloudox.h"

static NSString* receiveCellid = @"receive_cell";
static NSString* senderCellid = @"sender_cell";
@interface YJExpressDeliveryVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIButton *receiveBtn;
@property(nonatomic,weak)UIButton *senderdBtn;
//
@property(nonatomic,weak)UITableView *senderTableView;
@property(nonatomic,weak)UITableView *receiveTableView;
@property(nonatomic,strong)NSArray *expressCompanys;
//改动又添加的
@property(nonatomic,weak)UIView *headerImageView;
@property(nonatomic,weak)UIView *scrollowView;//滚动条
@end

@implementation YJExpressDeliveryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"快递收发";
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    //添加头部视图
    UIImageView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 55*kiphone6)];
    headerView.userInteractionEnabled = true;
    [self.view addSubview:headerView];
    UIImage *oldImage = [UIImage imageNamed:@"express_header"];
    headerView.image = oldImage;
    self.headerImageView = headerView;
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 55*kiphone6) WithTitle:@"收快递"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 55*kiphone6) WithTitle:@"发快递"andTag:102];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#373840"];
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.right.left.offset(0);
        make.height.offset(2*kiphone6);
    }];
    UIView *scrollowView = [[UIView alloc]init];//添加滚动线
    scrollowView.backgroundColor = [UIColor colorWithHexString:@"#03c2a5"];
    [line addSubview:scrollowView];
    self.scrollowView = scrollowView;
    [scrollowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(0);
        make.height.offset(2*kiphone6);
        make.width.offset(kScreenW*0.5);
    }];

    [self loadData];
}
-(void)loadData{
    
    [self selectItem:self.receiveBtn];
}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    [self.headerImageView addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.tag = tag;
    if (btn.tag==101) {
        self.receiveBtn = btn;
        [btn setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    }else{
        self.senderdBtn = btn;
    }
    [btn addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectItem:(UIButton*)sender{
    [sender setTitleColor:[UIColor colorWithHexString:@"#00eac6"] forState:UIControlStateNormal];
    [self.scrollowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(sender);
        make.top.equalTo(sender.mas_bottom);
        make.height.offset(2*kiphone6);
    }];
    if (sender.tag == 101) {
        self.senderTableView.hidden = true;
//        self.senderdBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.senderdBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        http://192.168.1.55:8080/smarthome/mobileapi/takeExpress/findList.do?token=ACDCE729BCE6FABC50881A867CAFC1BC 查询个人快递
        [SVProgressHUD show];// 动画开始
        NSString *expressPersonalUrlStr = [NSString stringWithFormat:@"%@/mobileapi/takeExpress/findList.do?token=%@",mPrefixUrl,mDefineToken1];
        [[HttpClient defaultClient]requestWithPath:expressPersonalUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    YJExpressReceiveModel *infoModel = [YJExpressReceiveModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
                if (self.personalExpresss.count==0) {//判断当从首页进来不刷新数据源
                    self.personalExpresss = mArr;
                }
                

        if (self.receiveTableView) {
            self.receiveTableView.hidden = false;
            
        }else{
            //添加tableView
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
            self.receiveTableView = tableView;
            [self.view addSubview:tableView];
            self.receiveTableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.receiveBtn.mas_bottom).offset(2*kiphone6);
                make.left.right.bottom.offset(0);
            }];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
         [tableView registerClass:[YJExpressReceiveTVCell class] forCellReuseIdentifier:receiveCellid];
            tableView.delegate =self;
            tableView.dataSource = self;
            tableView.estimatedRowHeight =  172*kiphone6;
            tableView.rowHeight = UITableViewAutomaticDimension;
            UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 38*kiphone6)];
            headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            UILabel *noticeLabel = [UILabel labelWithText:@"提货码有效期为三天，失效后请到物业办公室处理。" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];
            [headerView addSubview:noticeLabel];
            [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(headerView);
                make.left.offset(10*kiphone6);
            }];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
            line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
            [headerView addSubview:line];
            UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 38*kiphone6, kScreenW, 1)];
            line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
            [headerView addSubview:line2];

            tableView.tableHeaderView = headerView;
        }
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            return ;
        }];

   
    }else{
        self.receiveTableView.hidden = true;
        self.senderTableView.hidden = false;
        [self.receiveBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
//        http://192.168.1.55:8080/smarthome/mobileapi/express/findList.do?token=EC9CDB5177C01F016403DFAAEE3C1182  快递公司列表
        [SVProgressHUD show];// 动画开始
        NSString *expressCompanyUrlStr = [NSString stringWithFormat:@"%@/mobileapi/express/findList.do?token=%@",mPrefixUrl,mDefineToken1];
        [[HttpClient defaultClient]requestWithPath:expressCompanyUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                NSArray *arr = responseObject[@"result"];
                NSMutableArray *mArr = [NSMutableArray array];
                for (NSDictionary *dic in arr) {
                    YJExpressCompanyModel *infoModel = [YJExpressCompanyModel mj_objectWithKeyValues:dic];
                    [mArr addObject:infoModel];
                }
                self.expressCompanys = mArr;
                if (self.senderTableView) {
                    self.senderTableView.hidden = false;
                    [self.senderTableView reloadData];
                }else{
                    //添加tableView
                    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
                    self.senderTableView = tableView;
                    [self.view addSubview:tableView];
                    self.senderTableView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
                    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.receiveBtn.mas_bottom).offset(2*kiphone6);
                        make.left.right.bottom.offset(0);
                    }];
                    tableView.estimatedRowHeight =  76*kiphone6;
                    tableView.rowHeight = UITableViewAutomaticDimension;

                    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    [tableView registerClass:[YJExpressSenderTVCell class] forCellReuseIdentifier:senderCellid];
                    tableView.delegate =self;
                    tableView.dataSource = self;
                }
                
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"加载失败"];
            return ;
        }];
    }
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.receiveTableView) {
        
        return self.personalExpresss.count;
//        return 4;
    }else{
        return self.expressCompanys.count;//根据请求回来的数据定
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.receiveTableView) {
        YJExpressReceiveTVCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveCellid forIndexPath:indexPath];
        cell.model = self.personalExpresss[indexPath.row];
        return cell;
    }else{
        YJExpressSenderTVCell *cell = [tableView dequeueReusableCellWithIdentifier:senderCellid forIndexPath:indexPath];
        cell.model = self.expressCompanys[indexPath.row];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.receiveTableView) {
        
        return 210*kiphone6;
    }else{
        return 76*kiphone6;//根据请求回来的数据定
    }
}
-(void)setPersonalExpresss:(NSArray *)personalExpresss{
    _personalExpresss = personalExpresss;
    [self.receiveTableView reloadData];//从首页进来刷新
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navBarBgAlpha = @"1.0";//添加了导航栏和控制器的分类实现了导航栏透明处理
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
