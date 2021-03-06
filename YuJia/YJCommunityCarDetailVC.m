//
//  YJCommunityCarDetailVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJCommunityCarDetailVC.h"
#import "UILabel+Addition.h"
#import "UIButton+Badge.h"
#import "YJFriendCommentTableViewCell.h"
#import "YJSelfReplyTableViewCell.h"
#import "YJActivitesCommentTVCell.h"
#import "YJPostActivitesCommentVC.h"
#import <UIImageView+WebCache.h>
#import "RKNotificationHub.h"
#import "YJNoticeListTableVC.h"

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "YJLikeActivitiesTVCell.h"
#import "YJActiviesLikeModel.h"
#import "YJOtherPersonalInfoVC.h"

static NSString* tablecell = @"table_cell";
@interface YJCommunityCarDetailVC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIButton *communityBtn;

@property(nonatomic,weak)UIButton *joinBtn;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSMutableArray *commentList;//评论的人们
@property(nonatomic,strong)NSMutableArray *addList;//司机发起参与的乘客
@property(nonatomic,assign)long isLike;//用户是否参加
@property(nonatomic,strong)RKNotificationHub *barHub;//bage
@property(nonatomic,assign)Boolean isHasMessage;//是否有消息
@end

@implementation YJCommunityCarDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区拼车";
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self checkHasMessade];

}
//添加右侧消息中心按钮
-(void)checkHasMessade{
    UIButton *informationBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 16)];
    [informationBtn setImage:[UIImage imageNamed:@"remind"] forState:UIControlStateNormal];
    [informationBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:informationBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    //  http://192.168.1.55:8080/smarthome/mobileapi/message/hasmessage.do?msgType=&token=9DB2FD6FDD2F116CD47CE6C48B3047EE&msgTypeBegin=2&msgTypeEnd=3
    NSString *checkUrlStr = [NSString stringWithFormat:@"%@/mobileapi/message/hasmessage.do?msgType=&token=%@&msgTypeBegin=11&msgTypeEnd=30",mPrefixUrl,mDefineToken1];
    [[HttpClient defaultClient]requestWithPath:checkUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSString *isHasMessage = responseObject[@"hasMessage"];
            self.isHasMessage = [isHasMessage boolValue];
            if (self.isHasMessage) {
                self.barHub = [[RKNotificationHub alloc] initWithBarButtonItem: self.navigationItem.rightBarButtonItem];//初始化bageView
                [self.barHub setCircleAtFrame:CGRectMake(15, 1, 5, 5)];//bage的frame
                [self.barHub increment];//显示count+1
                [self.barHub hideCount];//隐藏数字
                
            }
        }else if ([responseObject[@"code"] isEqualToString:@"10000"]){
            [SVProgressHUD showErrorWithStatus:@"您还未登陆，请登录后再试"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
    
}
//消息按钮点击事件
-(void)informationBtnClick:(UIButton*)sender{
    YJNoticeListTableVC *vc = [[YJNoticeListTableVC alloc]init];
//    vc.noticeType = 3;
    [self.navigationController pushViewController:vc animated:true];
}
-(void)refrish{
    [SVProgressHUD show];// 动画开始
    NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/carpooling/findCarpoolingOne.do?token=%@&carpoolingId=%ld",mPrefixUrl,mDefineToken1,self.model.info_id];
    [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSDictionary *bigDic = responseObject[@"result"];
            self.addList = [NSMutableArray array];
            NSArray *addArr = bigDic[@"CarpoolingLogEntity"];//司机发起时候参加的人员信息集合
            for (NSDictionary *dic in addArr) {
                YJActiviesLikeModel *infoModel = [YJActiviesLikeModel mj_objectWithKeyValues:dic];
                [self.addList addObject:infoModel];
            }
            NSDictionary *detailDic = bigDic[@"carpoolingEntity"];
            self.model = [YJCommunityCarListModel mj_objectWithKeyValues:detailDic];
            NSArray *commentArr = bigDic[@"commentlist"];
            NSMutableArray *commentmArr = [NSMutableArray array];
            for (NSDictionary *dic in commentArr) {
                YJActiviesAddPersonModel *infoModel = [YJActiviesAddPersonModel mj_objectWithKeyValues:dic];
                [commentmArr addObject:infoModel];
            }
            self.commentList = commentmArr;//解析评论数据
            NSString *isLike = bigDic[@"IsLike"];
            self.isLike = [isLike integerValue];
            [self.tableView reloadData];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];

}
/**
 从消息列表传过来id
 
 @param carpoolingId 从消息列表传过来id
 */
-(void)setCarpoolingId:(long)carpoolingId{
    _carpoolingId = carpoolingId;
    //    self.model.info_id = carpoolingId;
    [self loadData];
}
-(void)loadData{
//http://localhost:8080/smarthome/mobileapi/carpooling/findCarpoolingOne.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//    &carpoolingId=1
    [SVProgressHUD show];// 动画开始
    NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/carpooling/findCarpoolingOne.do?token=%@&carpoolingId=%ld",mPrefixUrl,mDefineToken1,self.carpoolingId];
    [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSDictionary *bigDic = responseObject[@"result"];
            self.addList = [NSMutableArray array];
            NSArray *addArr = bigDic[@"CarpoolingLogEntity"];//司机发起时候参加的人员信息集合
            for (NSDictionary *dic in addArr) {
                YJActiviesLikeModel *infoModel = [YJActiviesLikeModel mj_objectWithKeyValues:dic];
                [self.addList addObject:infoModel];
            }
            NSDictionary *detailDic = bigDic[@"carpoolingEntity"];
            self.model = [YJCommunityCarListModel mj_objectWithKeyValues:detailDic];
            if (!self.userId) {//第一次加载数据需要判断userId是否为空
                self.userId = self.model.info_id;
            }
            NSArray *commentArr = bigDic[@"commentlist"];
            NSMutableArray *commentmArr = [NSMutableArray array];
            for (NSDictionary *dic in commentArr) {
                YJActiviesAddPersonModel *infoModel = [YJActiviesAddPersonModel mj_objectWithKeyValues:dic];
                [commentmArr addObject:infoModel];
            }
            self.commentList = commentmArr;//解析评论数据
            NSString *isLike = bigDic[@"IsLike"];
            self.isLike = [isLike integerValue];
            [self setupUI];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];

}
-(void)setupUI{
    //添加大tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [tableView registerClass:[YJActivitesCommentTVCell class] forCellReuseIdentifier:tablecell];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 265*kiphone6;
    //添加大tb头部试图
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 270*kiphone6)];
    headerView.backgroundColor = [UIColor whiteColor];
    UIImageView *iconView = [[UIImageView alloc]init];//头像图片
    NSString *iconUrlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.model.avatar];
    [iconView sd_setImageWithURL:[NSURL URLWithString:iconUrlStr] placeholderImage:[UIImage imageNamed:@"icon"]];
    iconView.layer.masksToBounds = true;
    iconView.layer.cornerRadius = 20*kiphone6;
    [headerView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(headerView.mas_top).offset(31*kiphone6);
        make.width.height.offset(40*kiphone6);
    }];
    iconView.userInteractionEnabled = true;
    //添加滑动手势
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [iconView addGestureRecognizer:pan];
    pan.delegate = self;
    UILabel *nameLabel = [UILabel labelWithText:self.model.user_name andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//姓名
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_top).offset(31*kiphone6);
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
    }];
    UILabel *stateLabel = [UILabel labelWithText:self.model.over==1?@"正在进行":@"已结束" andTextColor:[UIColor colorWithHexString:@"#00eac6"] andFontSize:14];//开始时间
    [headerView addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.right.offset(-10*kiphone6);
    }];
    UILabel *begainTimeLabel = [UILabel labelWithText:self.model.createTimeString andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//开始时间
    [headerView addSubview:begainTimeLabel];
    [begainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(iconView);
        make.right.equalTo(stateLabel.mas_left).offset(-10*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.equalTo(headerView.mas_top).offset(62*kiphone6);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    UILabel *typeLabel = [UILabel labelWithText:@"身份" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:15];//发起人类型标题
    [headerView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(29*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    UILabel *typeContentLabel = [UILabel labelWithText:self.model.ctype==1?@"乘客":@"司机" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//发起人类型
    [headerView addSubview:typeContentLabel];
    [typeContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(29*kiphone6);
        make.left.equalTo(typeLabel.mas_right).offset(10*kiphone6);
    }];
    UILabel *timeItemLabel = [UILabel labelWithText:@"出发时间" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//时间标题
    [headerView addSubview:timeItemLabel];
    [timeItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(typeLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *timeLabel = [UILabel labelWithText:self.model.departureTimeString andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//时间内容
    [headerView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(timeItemLabel);
    }];
    UILabel *AddressItemLabel = [UILabel labelWithText:@"出发地" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//地点标题
    [headerView addSubview:AddressItemLabel];
    [AddressItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(timeItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *AddressLabel = [UILabel labelWithText:self.model.departurePlace andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//地点内容
    [headerView addSubview:AddressLabel];
    [AddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(AddressItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(AddressItemLabel);
    }];
    UILabel *destinationItemLabel = [UILabel labelWithText:@"目的地" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//目的地标题
    [headerView addSubview:destinationItemLabel];
    [destinationItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(AddressItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *destinationLabel = [UILabel labelWithText:self.model.end andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//目的地内容
    [headerView addSubview:destinationLabel];
    [destinationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(destinationItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(destinationItemLabel);
    }];
    UILabel *numberItemLabel = [UILabel labelWithText:@"乘坐人数" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//目的地标题
    [headerView addSubview:numberItemLabel];
    [numberItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(destinationItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *numberLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%ld人",self.model.cnumber] andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//目的地内容
    [headerView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(numberItemLabel);
    }];

    tableView.tableHeaderView = headerView;
    //底部bar
    [self setBtnWithFrame:CGRectMake(0, kScreenH-47*kiphone6, kScreenW/2, 47*kiphone6) WithTitle:@"评论"andTag:101 andImage:@"comment"];
    if (self.model.ctype == 1) {
        [self setBtnWithFrame:CGRectMake(kScreenW/2, kScreenH-47*kiphone6, kScreenW/2, 47*kiphone6) WithTitle:@"接单"andTag:102 andImage:nil];
    }else{
        [self setBtnWithFrame:CGRectMake(kScreenW/2, kScreenH-47*kiphone6, kScreenW/2, 47*kiphone6) WithTitle:[NSString stringWithFormat:@"%ld人参加",self.model.participateNumber] andTag:102 andImage:@"click_add"];
    }

    
}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag andImage:(NSString*)image{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-1, 0, 1,47*kiphone6)];
    [btn addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,1)];
    [btn addSubview:line2];
    line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    //    btn.layer.borderColor = [UIColor colorWithHexString:@"#333333"].CGColor;
    //    btn.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    //    btn.contentEdgeInsets = UIEdgeInsetsMake(0, -5, 0, -5);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    btn.tag = tag;
    if (btn.tag==101) {
        self.communityBtn = btn;
        [btn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.joinBtn = btn;
        if (self.model.ctype == 1) {//乘客发的
            [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
            if (self.model.over==1) {
                if (self.model.isOrders) {
                    btn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
                    btn.userInteractionEnabled = false;
                }else{
                    btn.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
                    btn.userInteractionEnabled = true;
                    [btn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }else{
                btn.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
                btn.userInteractionEnabled = false;
            }
        }else{//司机发的
            if (self.model.over==1) {
                if (self.model.islike||(self.model.participateNumber>=self.model.cnumber)) {
                    [btn setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
                    btn.userInteractionEnabled = false;
                }else{
                    [btn setImage:[UIImage imageNamed:@"click_add"] forState:UIControlStateNormal];
                    btn.userInteractionEnabled = true;
                    [btn addTarget:self action:@selector(orderClick:) forControlEvents:UIControlEventTouchUpInside];
                }
            }else{
                [btn setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
                btn.userInteractionEnabled = false;
            }
        }
    }
    
}
-(void)commentClick:(UIButton*)sender{
    if (sender.tag==101) {
        YJPostActivitesCommentVC *vc = [[YJPostActivitesCommentVC alloc]init];
        vc.carModel = self.model;
        vc.userId = self.userId;
        vc.coverPersonalId = 0;
        [self.navigationController pushViewController:vc animated:true];
    }
}

#pragma mark - UITableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.model.ctype==2) {
        return 2;
    }
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model.ctype==2) {
        if (indexPath.row==0) {
            YJLikeActivitiesTVCell *cell = [[YJLikeActivitiesTVCell alloc]init];
            cell.likeList = self.addList;
            cell.image = @"blue-add";
            cell.clickAddBlock = ^(NSString *personalId) {
            WS(ws);
            YJOtherPersonalInfoVC *vc = [[YJOtherPersonalInfoVC alloc]init];
            vc.info_id = personalId;
            [ws.navigationController pushViewController:vc animated:true];
            };
            return cell;
        }        
    }
    YJActivitesCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tablecell forIndexPath:indexPath];
    cell.userId = self.userId;//传给cell用来判断当点击了A回复B类型的cell中的名字时候判断评论类型
    cell.commentList = self.commentList;
    WS(ws);
    cell.clickForReplyBlock = ^(NSString *str,long coverPersonalId){
        YJPostActivitesCommentVC *vc = [[YJPostActivitesCommentVC alloc]init];
        vc.carModel = self.model;
        vc.userId = self.userId;
        vc.coverPersonalId = coverPersonalId;
        if (coverPersonalId!=0) {//当回复的不是本人时候才需要设置评论框placeholder
            vc.replyType = [NSString stringWithFormat:@"%@",str];
        }
        
        [ws.navigationController pushViewController:vc animated:true];
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.model.ctype==2) {
        if (indexPath.row == 0) {
            //        if (self.likeList.count<8) {
            //            return 45*kiphone6;
            //        }else{
            //            return 90*kiphone6;
            //        }
            return 45*kiphone6;
        }
    }
    
    return [self updateCommentTableViewHeight];
//    return (self.commentList.count*38)*kiphone6>100?(self.commentList.count*38)*kiphone6:100;
    
}
-(CGFloat)updateCommentTableViewHeight{
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
    
    return tableViewHeight;
}



/**
 从拼车活动列表传过来实体类

 @param model <#model description#>
 */
//-(void)setModel:(YJCommunityCarListModel *)model{
//    _model = model;
////    self.carpoolingId = model.info_id;
//}
//参加拼车活动+接单按钮点击事件
-(void)orderClick:(UIButton*)sender{
    //    [sender setBackgroundColor:[UIColor colorWithHexString:@"#cccccc"]];
    //    self.clickForAddBlock(sender);
    //http://localhost:8080/smarthome/mobileapi/carpoolingLog/addCarpoolingLog.do?token=EC9CDB5177C01F016403DFAAEE3C1182
    //    &carpoolingId=4
    if (self.model.ctype==1) {
        [sender setImage:nil forState:UIControlStateNormal];
        [SVProgressHUD show];// 动画开始
        NSString *addUrlStr = [NSString stringWithFormat:@"%@/mobileapi/carpoolingLog/addCarpoolingLog.do?token=%@&carpoolingId=%ld",mPrefixUrl,mDefineToken1,self.model.info_id];
        [[HttpClient defaultClient]requestWithPath:addUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [sender setImage:nil forState:UIControlStateNormal];
                sender.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
                sender.userInteractionEnabled = false;
                self.model.isOrders = true;
            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];// 动画结束
            return ;
        }];
    }else if (self.model.ctype==2){
        //    self.clickForAddBlock(sender);
        //http://localhost:8080/smarthome/mobileapi/carpoolingLog/addCarpoolingLog.do?token=EC9CDB5177C01F016403DFAAEE3C1182
        //    &carpoolingId=4
        sender.backgroundColor = [UIColor clearColor];
        [SVProgressHUD show];// 动画开始
        NSString *addUrlStr = [NSString stringWithFormat:@"%@/mobileapi/carpoolingLog/addCarpoolingLog.do?token=%@&carpoolingId=%ld",mPrefixUrl,mDefineToken1,self.model.info_id];
        [[HttpClient defaultClient]requestWithPath:addUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                sender.backgroundColor = [UIColor clearColor];
                [sender setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
                NSInteger addNumber = [self.joinBtn.titleLabel.text integerValue];
                [sender setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
                [self.joinBtn setTitle:[NSString stringWithFormat:@"%ld参加",addNumber+1] forState:UIControlStateNormal];
                self.model.participateNumber +=1;
                self.model.islike = true;
                sender.userInteractionEnabled = false;
                [self refrish];//刷新参加列表
            }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
                
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD dismiss];// 动画结束
            return ;
        }];
 
    }
    
}
//设置点击手势
-(void)tapGesture:(UITapGestureRecognizer*)sender{//跳转到个人详情页面
    YJOtherPersonalInfoVC *detailVc = [[YJOtherPersonalInfoVC alloc]init];
    detailVc.info_id = [NSString stringWithFormat:@"%ld",self.model.personalId];
    [self.navigationController pushViewController:detailVc animated:true];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = false;
    
}
//-(void)addCar:(UIButton*)sender{
//    //    self.clickForAddBlock(sender);
//    //http://localhost:8080/smarthome/mobileapi/carpoolingLog/addCarpoolingLog.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//    //    &carpoolingId=4
//    sender.backgroundColor = [UIColor clearColor];
//    [SVProgressHUD show];// 动画开始
//    NSString *addUrlStr = [NSString stringWithFormat:@"%@/mobileapi/carpoolingLog/addCarpoolingLog.do?token=%@&carpoolingId=%ld",mPrefixUrl,mDefineToken1,self.model.info_id];
//    [[HttpClient defaultClient]requestWithPath:addUrlStr method:0 parameters:nil prepareExecute:^{
//        
//    } success:^(NSURLSessionDataTask *task, id responseObject) {
//        [SVProgressHUD dismiss];// 动画结束
//        if ([responseObject[@"code"] isEqualToString:@"0"]) {
//            sender.backgroundColor = [UIColor clearColor];
//            [sender setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
//            NSInteger addNumber = [self.joinBtn.titleLabel.text integerValue];
//            [sender setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
//            [self.joinBtn setTitle:[NSString stringWithFormat:@"%ld参加",addNumber+1] forState:UIControlStateNormal];
//            self.model.participateNumber +=1;
//            self.model.islike = true;
//            sender.userInteractionEnabled = false;
//        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
//            
//            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [SVProgressHUD dismiss];// 动画结束
//        return ;
//    }];
//    
//}

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
