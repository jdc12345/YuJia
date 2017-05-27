//
//  YJSearchHourseVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJSearchHourseVC.h"
#import "YJSearchHouseDetailResultModel.h"

static NSString *dentifier=@"cellforappliancelist";
@interface YJSearchHourseVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong,nonatomic) NSMutableArray  *searchingList;//新搜索出的数据
@property (strong,nonatomic) NSMutableArray  *searchedList;//搜索记录数据
@property(nonatomic,strong)NSUserDefaults *defaults;
@property(nonatomic,weak)UITableView *tableView;//显示数据的列表
@property(nonatomic,weak)UITextField *searchField;//输入框
@property(nonatomic,assign)NSInteger flag;//判断点击cell是否跳转的标记
@property(nonatomic,assign)NSInteger sectionHeight;//组尾高度
@property(nonatomic,assign)BOOL active;//更新新搜索的数据的开关

@end

@implementation YJSearchHourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //搜索框
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 35)];
    [self.view addSubview:headerView];
    //取消按钮
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"25f368"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.offset(0);
        make.width.offset(50);
    }];
    //输入框
    UITextField *searchField = [[UITextField alloc]init];
    [headerView addSubview:searchField];
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.bottom.offset(0);
        make.right.equalTo(btn.mas_left);
    }];
    searchField.delegate = self;
    self.searchField = searchField;
    if (self.searchCayegory==1) {
        searchField.placeholder = @"请输入城市名称";
    }else{
        searchField.placeholder = @"请输入小区名称";
    }
    
    searchField.clearButtonMode = UITextFieldViewModeAlways;//删除内容的❎
    [searchField setBackgroundColor:[UIColor colorWithHexString:@"#f2f2f2"]];
    //输入框左侧放大镜
    UIImage *image = [UIImage imageNamed:@"search"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [imageView sizeToFit];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width+5, imageView.frame.size.height)];
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.top.right.bottom.offset(0);
    }];
    searchField.leftView = view;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    [searchField.layer setMasksToBounds:YES];
    [searchField.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    //边框宽度
    [searchField.layer setBorderWidth:0.8];
    searchField.layer.borderColor=[UIColor colorWithHexString:@"#f3f3f3"].CGColor;
    //tableView
    //解决状态栏透明
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIView *stateView = [[UIView alloc]init];
    stateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:stateView];
    [stateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(25);
    }];
    //tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 25, kScreenW, kScreenH-25)];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:dentifier];
    self.navigationController.navigationBar.hidden = true;
    [UIApplication sharedApplication].statusBarHidden = false;

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.active) {
        return [self.searchingList count];
    }else{
        return [self.searchedList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:dentifier forIndexPath:indexPath];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:dentifier];
    }
    if (self.active) {//处于搜索出新数据状态
        
        if (indexPath.row<self.searchingList.count) {
            if (self.searchCayegory==0) {
//                YYMedinicalDetailModel *model = self.searchingList[indexPath.row];
//                [cell.textLabel setText:model.drugsName];
            }else if (self.searchCayegory==1){
                YJSearchHouseDetailResultModel *ingModel = self.searchingList[indexPath.row];
                [cell.textLabel setText:ingModel.rname];
            }
        }
        
    }
    else{
        if (indexPath.row<self.searchedList.count) {
            NSString *recodeName = self.searchedList[indexPath.row];
            [cell.textLabel setText:recodeName];
        }
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //持续持久化
//    self.flag = 0;
//    //去重复
//    if (self.searchedList.count>0) {
//        if (self.searchingList.count>0) {//判断是处于显示新搜索数据状态下的点击
//            if (self.searchCayegory==0) {
//                YYMedinicalDetailModel *ingModel = self.searchingList[indexPath.row];
//                NSArray *arr = [NSArray arrayWithArray: self.searchedList];
//                for (NSString *recodeName in arr) {
//                    if ([recodeName isEqualToString:ingModel.drugsName] ) {
//                        [self.searchedList removeObject:recodeName];
//                    }
//                    
//                }
//                [self.searchedList insertObject:ingModel.drugsName atIndex:0];
//            }else if (self.searchCayegory==1){
//                YYInfomationModel *ingModel = self.searchingList[indexPath.row];
//                NSArray *arr = [NSArray arrayWithArray: self.searchedList];
//                for (NSString *recodeName in arr) {
//                    if ([recodeName isEqualToString:ingModel.hospitalName] ) {
//                        [self.searchedList removeObject:recodeName];
//                    }
//                    
//                }
//                [self.searchedList insertObject:ingModel.hospitalName atIndex:0];
//            }
//            
//            //数组转化为data持久化
//            NSData *encodeList = [NSKeyedArchiver archivedDataWithRootObject:self.searchedList];
//            if (self.searchCayegory==0) {
//                [self.defaults setObject:encodeList forKey:@"searchedList"];
//            }else if (self.searchCayegory==1){
//                [self.defaults setObject:encodeList forKey:@"searchedHospitalList"];
//            }
//            
//            [self.defaults synchronize];
//        }else{//判断是处于显示搜索记录状态下的点击
//            NSString *recodeName = self.searchedList[indexPath.row];
//            self.searchField.text = recodeName;
//            self.active = true;
//            [self textFieldShouldReturn:self.searchField];
//            self.flag = 1;
//            
//        }
//    }
//    if (self.searchCayegory==0 && self.flag == 0) {//跳转医药详情页面
//        YYMedicinalDetailVC *detailVC = [[YYMedicinalDetailVC alloc]init];
//        
//        YYMedinicalDetailModel *model = self.searchingList[indexPath.row];
//        detailVC.id = model.id;
//        [self.navigationController pushViewController:detailVC animated:true];
//        
//    }else if (self.searchCayegory == 1 && self.flag == 0){//跳转医院详情页面
//        YYHospitalInfoViewController *hospitaiVC = [[YYHospitalInfoViewController alloc]init];
//        //传递model---------------------
//        hospitaiVC.yyInfomationModel = self.searchingList[indexPath.row];
//        [self.navigationController pushViewController:hospitaiVC animated:true];
//        
//    }
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    if (self.searchedList.count>0) {
        UIButton *clearBtn = [[UIButton alloc]init];
        [clearBtn addTarget:self action:@selector(clearSearedList:) forControlEvents:UIControlEventTouchUpInside];
        [clearBtn setTitle:@"清除全部记录" forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor colorWithHexString:@"25f368"] forState:UIControlStateNormal];
        clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [clearBtn sizeToFit];
        [footView addSubview:clearBtn];
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(footView);
            make.left.offset(25);
            make.width.offset(90);
        }];
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kScreenW, 0.5)];
        //line1.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(15, 53, kScreenW, 0.5)];
        //line2.backgroundColor = [UIColor colorWithHexString:@"#f2f2f2"];
        line1.backgroundColor = [UIColor lightGrayColor];
        line2.backgroundColor = [UIColor lightGrayColor];
        line1.alpha = 0.8;
        line2.alpha = 0.8;
        [footView addSubview:line1];
        [footView addSubview:line2];
        return footView;
    }else{
        
        return nil;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.searchedList.count>0&&self.active==false) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.sectionHeight = 54;
    }else{
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.sectionHeight = 0;
    }
    return self.sectionHeight;
}
#pragma searchResultUpdating
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *searchString = [self.searchField text];
    
    if (self.searchingList!= nil) {
        [self.searchingList removeAllObjects];
    }
//    http://192.168.1.55:8080/smarthome/mobilepub/residentialQuarters/findRname.do?city=涿州市&rname=名流
    //向数据库请求搜索结果
    NSString *urlStr = [NSString string];
    if (self.searchCayegory==1) {//输入小区
        urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,searchString];
    }else if(self.searchCayegory==0){
//        urlStr = [medicinalSearchInfo stringByAppendingString:searchString];
    }
    [SVProgressHUD show];// 动画开始
    //把搜索中文转义
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HttpClient *client = [HttpClient defaultClient];
    [client requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSArray *arr = responseObject[@"result"];
            NSMutableArray *resultArr = [NSMutableArray array];
            for (NSDictionary *dic in arr) {
                if (self.searchCayegory==1) {
                    YJSearchHouseDetailResultModel *infoModel = [YJSearchHouseDetailResultModel mj_objectWithKeyValues:dic];
                    [resultArr addObject:infoModel];
                }else if (self.searchCayegory==0){
                    //            resultArr = [NSArray yy_modelArrayWithClass:[YYMedinicalDetailModel class] json:responseArr];
                }
                
            }
            self.searchingList  = resultArr;
            if (self.searchingList.count==0) {
                
                [SVProgressHUD showInfoWithStatus:@"什么也没有,请重新搜索"];
                [self textFieldShouldClear:self.searchField];
            }else{
                //刷新表格
                self.active = true;//开启数据源为搜索出来的新数据的开关
                [self.tableView reloadData];
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            //记录搜索过的内容
            if (self.searchingList.count>0) {//只有搜索结果不为空才本地保存
                
                NSArray *arr = [NSArray arrayWithArray: self.searchedList];
                for (NSString *recodeName in arr) {
                    if ([recodeName isEqualToString:self.searchField.text] ) {
                        [self.searchedList removeObject:recodeName];
                    }
                    
                }
                [self.searchedList insertObject:self.searchField.text atIndex:0];//记录写入内存
                NSData *encodeList = [NSKeyedArchiver archivedDataWithRootObject:self.searchedList];
                if (self.searchCayegory==0) {
                    [self.defaults setObject:encodeList forKey:@"searchedList"];
                    
                }else if (self.searchCayegory==1){
                    [self.defaults setObject:encodeList forKey:@"searchedHouseDetailList"];
                }
                [self.defaults synchronize];//记录写入缓存
            }

        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
    
    
    
    return true;
}
-(BOOL)textFieldShouldClear:(UITextField *)textField{
    self.active = false;
    [self.tableView reloadData];//在清除搜索框内容时候显示搜索记录
    return true;
}

#pragma btnClicks
-(void)back:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)clearSearedList:(UIButton*)sender{
    //    if (self.searchCayegory==0) {
    //
    //    }else if (self.searchCayegory==1){
    //
    //    }
    if (self.searchCayegory==0) {
        [self.defaults removeObjectForKey:@"searchedList"];
        NSData *saveSearchedListData = [self.defaults objectForKey:@"searchedList"];
        if (saveSearchedListData == nil) {
            self.searchedList = [NSMutableArray array];
        }else{
            self.searchedList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveSearchedListData];
        }
        
    }else if (self.searchCayegory==1){
        [self.defaults removeObjectForKey:@"searchedHouseDetailList"];
        NSData *saveSearchedListData = [self.defaults objectForKey:@"searchedHouseDetailList"];
        if (saveSearchedListData == nil) {
            self.searchedList = [NSMutableArray array];
        }else{
            self.searchedList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveSearchedListData];
        }
        
    }
    [self.tableView reloadData];
}
#pragma 懒加载
-(NSMutableArray *)searchingList{
    if (_searchingList==nil) {
        _searchingList = [NSMutableArray array];
    }
    return _searchingList;
}
//页面出现和消失
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.searchingList removeAllObjects];
    //加载搜索记录
    if (self.searchCayegory==0) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        NSData *saveSearchedListData = [self.defaults objectForKey:@"searchedList"];
        if (saveSearchedListData == nil) {
            self.searchedList = [NSMutableArray array];
        }else{
            self.searchedList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveSearchedListData];
            
        }
    }else if(self.searchCayegory==1){
        self.defaults = [NSUserDefaults standardUserDefaults];
        NSData *saveSearchedListData = [self.defaults objectForKey:@"searchedHouseDetailList"];
        if (saveSearchedListData == nil) {
            self.searchedList = [NSMutableArray array];
        }else{
            self.searchedList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveSearchedListData];
            
        }
        
    }
    
    [self.tableView reloadData];//页面出现时候刷新数据
    self.searchField.text = nil;//页面出现时候清空搜索框数据
    self.navigationController.navigationBar.hidden = true;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.active = false;//在页面跳转时候关闭显示搜索新数据的开关，以便在页面从新出现时候为搜索记录数据;
    self.navigationController.navigationBar.hidden = false;
    
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
