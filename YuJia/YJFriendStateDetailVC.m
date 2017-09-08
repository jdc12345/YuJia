//
//  YJFriendStateDetailVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/9.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJFriendStateDetailVC.h"
#import "UIColor+colorValues.h"
#import "UILabel+Addition.h"
#import "YJFriendStateTableViewCell.h"
#import "YJFriendLikeFlowLayout.h"
#import "YJFriendLikeCollectionViewCell.h"
#import "YJFriendCommentTableViewCell.h"
#import "YJSelfReplyTableViewCell.h"
#import "YJPhotoDisplayCollectionViewCell.h"
#import <HUPhotoBrowser.h>
#import "YJFriendStateLikeModel.h"
#import "YJFriendStateCommentModel.h"
#import <UIImageView+WebCache.h>
#import "YJFriendNeighborVC.h"
#import "YJOtherPersonalInfoVC.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

static NSString* tableCell = @"table_cell";
static NSString* commentCell = @"comment_cell";
static NSString* photoCellid = @"photo_cell";
static NSString* friendCommentCellid = @"friendComment_cell";
static NSString* selfReplyCellid = @"selfReply_cell";
@interface YJFriendStateDetailVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UITableView *commentTableView;
@property(nonatomic,weak)UIButton *typeBtn;
@property(nonatomic,weak)BRPlaceholderTextView *contentView;
@property(nonatomic, strong)NSString *content;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UIView *selectView;

@property(nonatomic, strong)NSMutableArray *commentList;
@property(nonatomic, strong)NSMutableArray *likeList;
@property(nonatomic,weak)UIView *fieldBackView;
@property(nonatomic,assign)long coverPersonalId;
@property(nonatomic,weak)UIView *footBackView;//评论tableView的背景view
@end

@implementation YJFriendStateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"友邻圈";
    self.navigationController.navigationBar.translucent = true;
//    self.edgesForExtendedLayout = UIRectEdgeBottom;     //从navigationBar下面开始计算一直到屏幕底部
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.coverPersonalId = 0;//设定默认是评论该状态
        //添加大tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.bottom.offset(0);
    }];
    [tableView registerClass:[YJFriendStateTableViewCell class] forCellReuseIdentifier:tableCell];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 235*kiphone6;

    //评论框
    UIView *fieldBackView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenH-49*kiphone6, kScreenW, 49*kiphone6)];
    fieldBackView.backgroundColor = [UIColor colorWithHexString:@"#f2f1f1"];
    self.fieldBackView = fieldBackView;
    self.fieldBackView.hidden = true;
    [self.view addSubview:fieldBackView];
    [self.view bringSubviewToFront:fieldBackView];
    //边框宽度
    [fieldBackView.layer setBorderWidth:1];
    fieldBackView.layer.borderColor=[UIColor colorWithHexString:@"#acb3bd"].CGColor;
    //键盘的Frame改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //输入框
    BRPlaceholderTextView *commentField = [[BRPlaceholderTextView alloc]init];
    commentField.frame = CGRectMake(15*kiphone6, 6.5*kiphone6, 288*kiphone6, 49*kiphone6);
    [fieldBackView addSubview:commentField];
    commentField.layer.masksToBounds = true;
    commentField.layer.cornerRadius = 3;
    commentField.delegate = self;
    commentField.returnKeyType = UIReturnKeySend;
    self.commentField = commentField;
    commentField.placeholder = @"评论...";
    commentField.font=[UIFont boldSystemFontOfSize:14];
    [commentField setBackgroundColor:[UIColor whiteColor]];
    [commentField setPlaceholderFont:[UIFont systemFontOfSize:15]];
    [commentField setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
    [commentField setPlaceholderOpacity:0.6];
    [commentField addMaxTextLengthWithMaxLength:200 andEvent:^(BRPlaceholderTextView *text) {
        [self.commentField endEditing:YES];
        
        NSLog(@"----------");
    }];
    [commentField addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"begin");
        [self textViewDidChange:self.commentField];
    }];
    [commentField addTextViewEndEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"end");
    }];
    //添加发送按钮
    UIButton *sendBtn = [[UIButton alloc]init];
    [fieldBackView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(commentField.mas_right).offset(7*kiphone6);
        make.right.offset(-15*kiphone6);
        make.centerY.equalTo(fieldBackView);
        make.height.offset(26*kiphone6);
    }];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendBtn setBackgroundColor:[UIColor colorWithHexString:@"#373840"]];
    [sendBtn addTarget:self action:@selector(sendBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)setStateId:(NSString*)stateId{
    _stateId = stateId;
    [self loadData];
}
-(void)setModel:(YJFriendNeighborStateModel *)model{
    _model = model;
    if (self.userId == model.personalId) {
        //添加右侧发送按钮
        UIButton *deleateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [deleateBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        deleateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        deleateBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        //        postBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleateBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:deleateBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    
//    [self loadData];
}

-(void)loadData{
http://192.168.1.55:8080/smarthome/mobileapi/state/findStateOne.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//    &stateId=1
    [SVProgressHUD show];// 动画开始
    NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findStateOne.do?token=%@&stateId=%@",mPrefixUrl,mDefineToken1,self.stateId];
    [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSDictionary *bigDic = responseObject[@"result"];
            NSDictionary *detailDic = bigDic[@"stateEntity"];
            YJFriendNeighborStateModel *model = [YJFriendNeighborStateModel mj_objectWithKeyValues:detailDic];
            if (!self.userId) {//第一次加载数据需要判断userId是否为空
                self.userId = [model.info_id integerValue];
            }
            self.model = model;//解析状态详情数据
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];//刷新状态数据
            NSArray *likeArr = bigDic[@"likeNum"];
            NSMutableArray *likemArr = [NSMutableArray array];
            for (NSDictionary *dic in likeArr) {
                YJFriendStateLikeModel *infoModel = [YJFriendStateLikeModel mj_objectWithKeyValues:dic];
                [likemArr addObject:infoModel];
            }
            self.likeList = likemArr;//解析点赞数据
            NSArray *commentArr = bigDic[@"comment"];
            NSMutableArray *commentmArr = [NSMutableArray array];
            for (NSDictionary *dic in commentArr) {
                YJFriendStateCommentModel *infoModel = [YJFriendStateCommentModel mj_objectWithKeyValues:dic];
                [commentmArr addObject:infoModel];
            }
            self.commentList = commentmArr;//解析评论数据
            [self setupCommentTableView];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){

            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
 
}
-(void)setupCommentTableView{

    //评论tableView中的头部试图
    UIView *commentHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 354*kiphone6, 45*kiphone6)];
    if (self.likeList.count>7) {
        commentHeaderView.frame = CGRectMake(0, 0, 354*kiphone6, 90*kiphone6);
    }else if (self.likeList.count<7&&self.likeList.count>0){
        commentHeaderView.frame = CGRectMake(0, 0, 354*kiphone6, 45*kiphone6);
    }else{
        commentHeaderView.frame = CGRectMake(0, 0, 354*kiphone6, 0);
    }

    commentHeaderView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    UIImageView *heaterView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"like-blue"]];
    heaterView.frame = CGRectMake(10*kiphone6, 5*kiphone6, 11*kiphone6, 11*kiphone6);
    [commentHeaderView addSubview:heaterView];

    //photoCollectionView
    UICollectionView *likeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJFriendLikeFlowLayout alloc]init]];
    if (self.likeList.count>7) {
        heaterView.hidden = false;
        likeCollectionView.frame = CGRectMake(31*kiphone6, 0, 300*kiphone6, 90*kiphone6);
    }else if (self.likeList.count<7&&self.likeList.count>0){
        heaterView.hidden = false;
        likeCollectionView.frame = CGRectMake(31*kiphone6, 0, 300*kiphone6, 45*kiphone6);
    }else{
        likeCollectionView.frame = CGRectMake(31*kiphone6, 0, 300*kiphone6, 0);
        heaterView.hidden = true;
    }
    [commentHeaderView addSubview:likeCollectionView];

    self.collectionView = likeCollectionView;
    likeCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    likeCollectionView.dataSource = self;
    likeCollectionView.delegate = self;
    // 注册单元格
    [likeCollectionView registerClass:[YJFriendLikeCollectionViewCell class] forCellWithReuseIdentifier:photoCellid];
    likeCollectionView.showsHorizontalScrollIndicator = false;
    likeCollectionView.showsVerticalScrollIndicator = false;
    
    //添加大tb尾部视图中的评论tableView
    UIView *footBackView = [[UIView alloc]init];
    self.footBackView = footBackView;
    footBackView.backgroundColor = [UIColor whiteColor];
    UITableView *commentTableView = [[UITableView alloc]init];
    [footBackView addSubview:commentTableView];
//    [commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.offset(0);
//        make.height.mas_equalTo(tableViewHeight+45);
//    }];
    self.commentTableView = commentTableView;
    [self updateCommentTableViewHeight];
    self.commentTableView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    [commentTableView registerClass:[YJFriendCommentTableViewCell class] forCellReuseIdentifier:friendCommentCellid];
    [commentTableView registerClass:[YJSelfReplyTableViewCell class] forCellReuseIdentifier:selfReplyCellid];
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentTableView.delegate =self;
    commentTableView.dataSource = self;
    commentTableView.rowHeight = UITableViewAutomaticDimension;
    commentTableView.estimatedRowHeight = 38*kiphone6;
//    commentTableView.scrollEnabled = false;
    commentTableView.showsHorizontalScrollIndicator = false;
    commentTableView.showsVerticalScrollIndicator = false;
    self.tableView.tableFooterView = footBackView;
    commentTableView.tableHeaderView = commentHeaderView;
    
}
-(void)updateCommentTableViewHeight{
    CGFloat tableViewHeight = 0;
    for (YJFriendStateCommentModel *commentModel in self.commentList) {
        CGFloat cellHeight = 0;
        if (commentModel.coverPersonalId == 0) {//判断是用户评论还是自己回复评论
            cellHeight = [YJSelfReplyTableViewCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
                YJSelfReplyTableViewCell *cell = (YJSelfReplyTableViewCell *)sourceCell;
                [cell configCellWithModel:commentModel];
            }];
            tableViewHeight += cellHeight;
        }else{
            cellHeight = [YJFriendCommentTableViewCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
                YJSelfReplyTableViewCell *cell = (YJSelfReplyTableViewCell *)sourceCell;
                [cell configCellWithModel:commentModel];
            }];
            tableViewHeight += cellHeight;
        }        
    }
    if (self.likeList.count<7&&self.likeList.count>0) {
        self.footBackView.frame = CGRectMake(0, 0, 354*kiphone6, tableViewHeight+50*kiphone6);
        self.commentTableView.frame = CGRectMake(59*kiphone6, 0, 306*kiphone6, tableViewHeight+50*kiphone6);
    }else if (self.likeList.count>7) {
        self.footBackView.frame = CGRectMake(0, 0, 354*kiphone6, tableViewHeight+100*kiphone6);
        self.commentTableView.frame = CGRectMake(59*kiphone6, 0, 306*kiphone6, tableViewHeight+100*kiphone6);
    }else{
        self.footBackView.frame = CGRectMake(0, 0, 354*kiphone6, tableViewHeight+10*kiphone6);
        self.commentTableView.frame = CGRectMake(59*kiphone6, 0, 306*kiphone6, tableViewHeight+10*kiphone6);
    }
    
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.tableView == tableView) {
        return 1;
    }
    return self.commentList.count;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView == tableView) {
        WS(ws);
    YJFriendStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCell forIndexPath:indexPath];
        cell.model = self.model;
        cell.isDetailCell = true;
        cell.detailCommentBtnBlock = ^(YJFriendNeighborStateModel *model){
            ws.fieldBackView.hidden = false;
            [ws.commentField becomeFirstResponder];
        };
        cell.iconViewTapgestureBlock = ^(YJFriendNeighborStateModel *model) {
//            if (ws.userId != model.personalId ) {//不是用户自己
                YJOtherPersonalInfoVC *detailVc = [[YJOtherPersonalInfoVC alloc]init];
                detailVc.info_id = [NSString stringWithFormat:@"%ld",model.personalId];
                [ws.navigationController pushViewController:detailVc animated:true];
//            }
        };
        return cell;
    }
    WS(ws);
    YJFriendStateCommentModel *model = self.commentList[indexPath.row];
    if (model.coverPersonalId == 0) {//判断是用户评论还是自己回复评论
        YJFriendCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCommentCellid forIndexPath:indexPath];
        cell.model = model;
        cell.clickBtnBlock = ^(NSString *str){
            NSRange range = [str rangeOfString:@"{"];
            NSString *strs = [str substringToIndex:range.location];
//            [ws.commentField setPlaceholder:[NSString stringWithFormat:@"回复 %@:",strs]];
//            ws.coverPersonalId = model.coverPersonalId;
            if (model.personalId == self.userId) {
                [ws.commentField setPlaceholder:@"评论"];
                ws.coverPersonalId = 0;
            }else{
                [ws.commentField setPlaceholder:[NSString stringWithFormat:@"回复 %@:",strs]];
                ws.coverPersonalId = model.personalId;
            }
            [ws.commentField becomeFirstResponder];
            
        };
//        if (indexPath.row==0) {
//            cell.iconView.hidden = false;
//        }
        return cell;
    }else{
        YJSelfReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selfReplyCellid forIndexPath:indexPath];
        cell.model = model;
        cell.clickBtnBlock = ^(NSString *str){
            NSRange range = [str rangeOfString:@"{"];
            NSString *strs = [str substringToIndex:range.location];
//            [ws.commentField setPlaceholder:[NSString stringWithFormat:@"回复 %@:",strs]];
//            YJSelfReplyTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            YJFriendStateCommentModel *model = cell.model;
//            if ([model.userName isEqualToString:strs]) {
//                [ws.commentField setPlaceholder:@"评论"];
//                ws.coverPersonalId = 0;
//            }else{
//                ws.coverPersonalId = model.coverPersonalId;
//            }
            if ([str containsString:@"me://"]) {//代表点击了第一个名字，这个名字的id是personalId
                if (model.personalId == self.userId) {
                    [ws.commentField setPlaceholder:@"评论"];
                    ws.coverPersonalId = 0;
                }else{
                    [ws.commentField setPlaceholder:[NSString stringWithFormat:@"回复 %@:",strs]];
                    ws.coverPersonalId = model.personalId;
                }
            }
            if ([str containsString:@"user://"]) {//代表点击了第二个名字，这个名字的id是coverPersonalId
                if (model.coverPersonalId == self.userId) {
                    [ws.commentField setPlaceholder:@"评论"];
                    ws.coverPersonalId = 0;
                }else{
                    [ws.commentField setPlaceholder:[NSString stringWithFormat:@"回复 %@:",strs]];
                    ws.coverPersonalId = model.coverPersonalId;
                }
            }
            [ws.commentField becomeFirstResponder];
        };
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        YJFriendStateTableViewCell *commentCell = [tableView dequeueReusableCellWithIdentifier:tableCell];        commentCell.model = self.model;//赋值并在cell中计算
        
        return commentCell.cellHeight;
    }
    return UITableViewAutomaticDimension;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.commentTableView == tableView) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 354*kiphone6, 5*kiphone6)];
        footerView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
        return footerView;
    }
   return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.commentTableView == tableView) {
        if (self.commentList.count>0) {
            return 5*kiphone6;
        }
           }
    return 0.0f;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.commentField resignFirstResponder];
}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.likeList.count;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    // 去缓存池找
    YJFriendLikeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
    YJFriendStateLikeModel *model = self.likeList[indexPath.row];
    NSString *iconUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.avatar];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"icon"]];
    return cell;
    
}
// cell点击(他人信息查看)事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    YJFriendStateLikeModel *model = self.likeList[indexPath.row];
    YJOtherPersonalInfoVC *vc = [[YJOtherPersonalInfoVC alloc]init];
    vc.info_id = [NSString stringWithFormat:@"%ld",model.personalId];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)keyboardWillChangeFrame:(NSNotification *)noti{
    
    //从userInfo里面取出来键盘最终的位置
    NSValue *rectValue = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rect = [rectValue CGRectValue];
    self.fieldBackView.frame = CGRectMake(0,rect.origin.y-49*kiphone6, kScreenW, 49*kiphone6);
}
-(void)sendBtnClick{
    
    [self.commentField resignFirstResponder];
    if (self.commentField.text!=nil&&![self.commentField.text isEqualToString:@""]) {
        //http://192.168.1.55:8080/smarthome/mobileapi/state/commentStat.do?token=EC9CDB5177C01F016403DFAAEE3C1182&stateId=1&content=评论内容
        if (self.coverPersonalId == self.userId) {
            self.coverPersonalId = 0;
        }
        NSString *urlStr = [NSString stringWithFormat:@"%@/mobileapi/state/commentStat.do?token=%@&stateId=%@&content=%@&coverPersonalId=%ld",mPrefixUrl,mDefineToken1,self.model.info_id,[self.commentField.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]],self.coverPersonalId];
        [SVProgressHUD show];// 动画开始
        [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                //更新评论数据源
                NSString *statesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/findStateOne.do?token=%@&stateId=%@",mPrefixUrl,mDefineToken1,self.model.info_id];
                [[HttpClient defaultClient]requestWithPath:statesUrlStr method:0 parameters:nil prepareExecute:^{
                    
                } success:^(NSURLSessionDataTask *task, id responseObject) {
                    [SVProgressHUD dismiss];// 动画结束
                    if ([responseObject[@"code"] isEqualToString:@"0"]) {
                        NSDictionary *bigDic = responseObject[@"result"];
                        NSArray *likeArr = bigDic[@"likeNum"];
                        NSMutableArray *likemArr = [NSMutableArray array];
                        for (NSDictionary *dic in likeArr) {
                            YJFriendStateLikeModel *infoModel = [YJFriendStateLikeModel mj_objectWithKeyValues:dic];
                            [likemArr addObject:infoModel];
                        }
                        self.likeList = likemArr;//解析点赞数据
                        NSArray *commentArr = bigDic[@"comment"];
                        NSMutableArray *commentmArr = [NSMutableArray array];
                        for (NSDictionary *dic in commentArr) {
                            YJFriendStateCommentModel *infoModel = [YJFriendStateCommentModel mj_objectWithKeyValues:dic];
                            [commentmArr addObject:infoModel];
                        }
                        self.commentList = commentmArr;//解析评论数据
                        [self updateCommentTableViewHeight];
                        [self.tableView reloadData];
                        [self.commentTableView reloadData];
                        
                        self.commentField.text = nil;
                        [self.commentField setPlaceholder:@"说点什么吧"];
                        
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [SVProgressHUD showErrorWithStatus:@"评论已上传,请下拉刷新"];
                    return ;
                }];
            }else{
                [SVProgressHUD showErrorWithStatus:@"评论已上传,请下拉刷新"];
                self.commentField.text = nil;
            }
            self.coverPersonalId = 0;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"评论未成功，请稍后再试"];
            return ;
        }];
        
    }else{
        [self showAlertWithMessage:@"评论内容不能为空，请重新输入"];
    }
}
#pragma - UItextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.fieldBackView.hidden = false;
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    self.fieldBackView.hidden = true;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    
    NSUInteger location = replacementTextRange.location;
    
    if (textView.text.length + text.length > 500){
        
        if (location != NSNotFound){
            
            [textView resignFirstResponder];
        }
        return NO;
        
    }  else if (location != NSNotFound){
        
        [textView resignFirstResponder];
        [self sendBtnClick];
        return NO;
    }
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    CGRect fieldBackFrame = self.fieldBackView.frame;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height<36*kiphone6) {
        size.height = 36*kiphone6;
    }
    if (size.height>85*kiphone6) {
        size.height = 85*kiphone6;
        textView.scrollEnabled = true;   // 允许滚动
        self.fieldBackView.frame = CGRectMake(0, fieldBackFrame.origin.y-(size.height-frame.size.height), kScreenW, size.height+13*kiphone6);
        textView.frame = CGRectMake(15*kiphone6, 6.5*kiphone6, 288*kiphone6, size.height);
        return;
    }
    textView.scrollEnabled = false;   // 不允许滚动
    self.fieldBackView.frame = CGRectMake(0, fieldBackFrame.origin.y-(size.height-frame.size.height), kScreenW, size.height+13*kiphone6);
    textView.frame = CGRectMake(15*kiphone6, 6.5*kiphone6, 288*kiphone6, size.height);
 
}
//弹出alert
-(void)showAlertWithMessage:(NSString*)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    //            [alert addAction:cancelAction];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)informationBtnClick:(UIButton *)sender{
http://192.168.1.55:8080/smarthome/mobileapi/state/delteState.do?token=ACDCE729BCE6FABC50881A867CAFC1BC&stateId=34
    [SVProgressHUD show];// 动画开始
    NSString *deleUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/delteState.do?token=%@&stateId=%@",mPrefixUrl,mDefineToken1,self.model.info_id];
    [[HttpClient defaultClient]requestWithPath:deleUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[YJFriendNeighborVC class]]) {
                    YJFriendNeighborVC *revise =(YJFriendNeighborVC *)controller;
//                    revise.clickBtnBlock(cell.textLabel.text);
                    [revise deleRefresh];
                    [self.navigationController popToViewController:revise animated:YES];
                }
               
            }
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
  
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self.commentField resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = false;
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
