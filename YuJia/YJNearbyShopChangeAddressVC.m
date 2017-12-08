//
//  YJNearbyShopChangeAddressVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJNearbyShopChangeAddressVC.h"
#import "YJSearchHouseDetailResultModel.h"

static NSString *dentifier=@"cellforappliancelist";
@interface YJNearbyShopChangeAddressVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (strong,nonatomic) NSMutableArray  *searchingList;//新搜索出的数据
@property (strong,nonatomic) NSMutableArray  *searchedList;//搜索记录数据
@property(nonatomic,strong)NSUserDefaults *defaults;
@property(nonatomic,weak)UITableView *tableView;//显示数据的列表
@property(nonatomic,weak)UITextField *searchField;//输入框
@property(nonatomic,assign)NSInteger flag;//判断点击cell是否跳转的标记
@property(nonatomic,assign)NSInteger sectionHeight;//组尾高度
@property(nonatomic,assign)BOOL active;//更新新搜索的数据的开关

@end

@implementation YJNearbyShopChangeAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"切换地址";
    //给导航条添加一个返回按钮
   self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close_shop"] style:UIBarButtonItemStylePlain target:self action:@selector(change)];
//    self.navigationController.navigationBar.translucent = false;
    //搜索框+定位
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 115)];
    [self.view addSubview:headerView];
    //输入框
    UITextField *searchField = [[UITextField alloc]init];
    [headerView addSubview:searchField];
    [searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.height.offset(35);
        make.right.offset(-10);
    }];
    searchField.delegate = self;
    self.searchField = searchField;
    searchField.clearButtonMode = UITextFieldViewModeAlways;//删除内容的❎
    [searchField setBackgroundColor:[UIColor colorWithHexString:@"#f2f2f2"]];
    //输入框左侧放大镜
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.backgroundColor = [UIColor clearColor];
    [leftBtn setTitle:@"请输入地址" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-20, 35)];
    [view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];
    [leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
    searchField.leftView = view;
    searchField.leftViewMode = UITextFieldViewModeAlways;
    [searchField.layer setMasksToBounds:YES];
    [searchField.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    //设置键盘右侧按钮的样式,将会覆盖之前的return按钮
    searchField.returnKeyType =UIReturnKeySearch;
    searchField.clearsOnInsertion=YES;//设置为YES。那么再一次输入内容的时候，会清楚之前的内容，显示最新的内容
//    //边框宽度
    [searchField.layer setBorderWidth:0.8];
    searchField.layer.borderColor=[UIColor colorWithHexString:@"#f3f3f3"].CGColor;
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [headerView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(searchField.mas_bottom).offset(10);
        make.height.offset(10);
    }];
    UIButton *recodeBtn = [[UIButton alloc]init];
    recodeBtn.backgroundColor = [UIColor whiteColor];
    [recodeBtn setTitle:@"点击定位当前地址" forState:UIControlStateNormal];
    [recodeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    recodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [recodeBtn setImage:[UIImage imageNamed:@"Location"] forState:UIControlStateNormal];
    [recodeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [headerView addSubview:recodeBtn];
    [recodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom);
        make.left.right.bottom.offset(0);
    }];
    [recodeBtn addTarget:self action:@selector(clickForLocation:) forControlEvents:UIControlEventTouchUpInside];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 25, kScreenW, kScreenH-25)];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.equalTo(headerView.mas_bottom);
    }];
    self.tableView = tableView;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:dentifier];
    
}
-(void)change {
//编写点击返回按钮的点击事件
//点击返回按钮，移除当前模态窗口
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"移除模态窗口");
//    }];
// 如果一个控制器是以模态的形式展现出来的, 可以调用该控制器以及该控制器的子控制器让让控制器消失
  [self dismissViewControllerAnimated:YES completion:^{
    NSLog(@"移除");
  }];
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
            
        YJSearchHouseDetailResultModel *model = self.searchingList[indexPath.row];
            [cell.textLabel setText:model.rname];
            
        }
        
    }
    else{
        if (indexPath.row<self.searchedList.count) {
            NSString *recodeName = self.searchedList[indexPath.row];
            [cell.textLabel setText:recodeName];
        }
        
    }
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //    持续持久化
    self.flag = 0;
    //去重复
    if (self.searchedList.count>0) {
        if (self.searchingList.count>0) {//判断是处于显示新搜索数据状态下的点击
                YJSearchHouseDetailResultModel *ingModel = self.searchingList[indexPath.row];
                NSArray *arr = [NSArray arrayWithArray: self.searchedList];
                for (NSString *recodeName in arr) {
                    if ([recodeName isEqualToString:ingModel.rname] ) {
                        [self.searchedList removeObject:recodeName];
                    }
                    
                }
                [self.searchedList insertObject:ingModel.rname atIndex:0];
            
            //数组转化为data持久化
            NSData *encodeList = [NSKeyedArchiver archivedDataWithRootObject:self.searchedList];
            
                [self.defaults setObject:encodeList forKey:@"searchedShopList"];
            
            [self.defaults synchronize];
        }else{//判断是处于显示搜索记录状态下的点击,
            NSString *recodeName = self.searchedList[indexPath.row];
            if (!self.searchField.placeholder) {
                [self clickLeftBtn];
            }
            self.searchField.text = recodeName;
            self.active = true;
            [self textFieldShouldReturn:self.searchField];
            self.flag = 1;//点击之后会再搜索，不会直接跳转
            
        }
    }
    if ( self.flag == 0) {//跳转详情页面
        YJSearchHouseDetailResultModel *model = self.searchingList[indexPath.row];
        self.popVCBlock(model.rname);//给bolock赋值
        [self change];
        
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIView*headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.top.offset(10);
    }];
        UIButton *recodeBtn = [[UIButton alloc]init];
        [recodeBtn setTitle:@"历史地址" forState:UIControlStateNormal];
        [recodeBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        recodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [recodeBtn setImage:[UIImage imageNamed:@"time"] forState:UIControlStateNormal];
        [recodeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [headerView addSubview:recodeBtn];
        [recodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView);
            make.left.offset(10);
            make.width.offset(100);
        }];
        
        UIButton *clearBtn = [[UIButton alloc]init];
        [clearBtn addTarget:self action:@selector(clearSearedList:) forControlEvents:UIControlEventTouchUpInside];
        [clearBtn setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [headerView addSubview:clearBtn];
        [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(recodeBtn);
            make.right.offset(-10);
            //            make.width.offset(90);
        }];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
        [headerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
            make.height.offset(1/[UIScreen mainScreen].scale);
        }];
        return backView;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight = 0.f;
    if (self.searchedList.count>0&&self.active==false) {
        headerHeight = 55.f;
    }else{
        headerHeight = 0.f;
    }
    return headerHeight;
}
#pragma searchResultUpdating
-(void)clickLeftBtn{
    
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

    [UIView animateWithDuration:0.1 animations:^{
        self.searchField.leftView = view;
        self.searchField.placeholder = @"请输入地址";
        [self.searchField becomeFirstResponder];
    }];
    
}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    //输入框左侧放大镜
//    UIButton *leftBtn = [[UIButton alloc]init];
//    leftBtn.backgroundColor = [UIColor clearColor];
//    [leftBtn setTitle:@"请输入地址" forState:UIControlStateNormal];
//    [leftBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
//    leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [leftBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
//    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-20, 35)];
//    [view addSubview:leftBtn];
//    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(view);
//    }];
//    [leftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
//    textField.leftView = view;
// 
//}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString *searchString = [self.searchField text];
    
    if (self.searchingList!= nil) {
        [self.searchingList removeAllObjects];
    }
    
    //向数据库请求搜索结果
    NSString *urlStr = [NSString string];
    //输入小区
//           http://192.168.1.55:8080/smarthome/mobilepub/residentialQuarters//FuzzyQuery.do?rname=%E5%B0%8F%E5%8C%BA
        urlStr = [NSString stringWithFormat:@"%@/mobilepub/residentialQuarters//FuzzyQuery.do?rname=%@",mPrefixUrl,searchString];
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
            YJSearchHouseDetailResultModel *infoModel = [YJSearchHouseDetailResultModel mj_objectWithKeyValues:dic];
            [resultArr addObject:infoModel];
            }
            self.searchingList  = resultArr;
            if (self.searchingList.count==0) {
                
                [SVProgressHUD showInfoWithStatus:@"什么也没有,请重新搜索"];
                [self textFieldShouldClear:self.searchField];
            }else{
                //刷新表格
                self.active = true;//开启数据源为搜索出来的新数据的开关
                [self.tableView reloadData];
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
                
                    [self.defaults setObject:encodeList forKey:@"searchedShopList"];
                    
                
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
    if (self.searchingList.count>0) {
        [self.searchingList removeAllObjects];
    }
    self.active = false;
    [self.tableView reloadData];//在清除搜索框内容时候显示搜索记录
    return true;
}

#pragma btnClicks
-(void)back:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:true];
}
-(void)clearSearedList:(UIButton*)sender{
   
        [self.defaults removeObjectForKey:@"searchedShopList"];
        NSData *saveSearchedListData = [self.defaults objectForKey:@"searchedShopList"];
        if (saveSearchedListData == nil) {
            self.searchedList = [NSMutableArray array];
        }else{
            self.searchedList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveSearchedListData];
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
        self.defaults = [NSUserDefaults standardUserDefaults];
        NSData *saveSearchedListData = [self.defaults objectForKey:@"searchedShopList"];
        if (saveSearchedListData == nil) {
            self.searchedList = [NSMutableArray array];
        }else{
            self.searchedList = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:saveSearchedListData];
            
        }
    
    [self.tableView reloadData];//页面出现时候刷新数据
    self.searchField.text = nil;//页面出现时候清空搜索框数据
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.active = false;//在页面跳转时候关闭显示搜索新数据的开关，以便在页面从新出现时候为搜索记录数据;
    
    
}
-(void)clickForLocation:(UIButton*)sender{//返回重新定位
    [self change];
    self.presentVCBlock();
}

@end
