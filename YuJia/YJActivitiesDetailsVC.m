//
//  YJActivitiesDetailsVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJActivitiesDetailsVC.h"
#import "YJActivitiesDetailsTVCell.h"
#import "YJLikeActivitiesTVCell.h"
#import "YJActivitesCommentTVCell.h"
#import <HUImagePickerViewController.h>
#import "YJActivitesPhotoTVCell.h"
#import "YJPostActivitesCommentVC.h"
#import "YJActiviesLikeModel.h"
#import "YJActiviesAddPersonModel.h"
#import "YJActiviesPictureModel.h"
#import "YJCommunityActivitiesVC.h"
#import "OtherPeopleInfoViewController.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "YJFriendCommentTableViewCell.h"
#import "YJSelfReplyTableViewCell.h"

static NSString* tableDetailsCell = @"tableDetailsCell_cell";
static NSString* LikeCell = @"Like_cell";
static NSString* friendCommentCellid = @"friendComment_cell";
static NSString* photoCellid = @"photo_cell";
@interface YJActivitiesDetailsVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIButton *communityBtn;
@property(nonatomic,weak)UIButton *likeBtn;
@property(nonatomic,weak)UIButton *joinBtn;
@property(nonatomic,strong)NSMutableArray *likeList;//感兴趣人们
@property(nonatomic,strong)NSMutableArray *commentList;//评论的人们
@property(nonatomic,strong)NSMutableArray *addList;//参加的人们
@property(nonatomic,strong)NSMutableArray *activitypicturelist;//用户上传的图片
@property(nonatomic,assign)long isnumber;//用户在该活动已上传的图片数
@end

@implementation YJActivitiesDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"社区活动";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];

}
-(void)setActivitiesDetailUI{
    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    [tableView registerClass:[YJActivitiesDetailsTVCell class] forCellReuseIdentifier:tableDetailsCell];
    [tableView registerClass:[YJLikeActivitiesTVCell class] forCellReuseIdentifier:LikeCell];
    [tableView registerClass:[YJActivitesCommentTVCell class] forCellReuseIdentifier:friendCommentCellid];
    [tableView registerClass:[YJActivitesPhotoTVCell class] forCellReuseIdentifier:photoCellid];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate =self;
    tableView.dataSource = self;
//    tableView.rowHeight = UITableViewAutomaticDimension;
//    tableView.estimatedRowHeight = 235*kiphone6;
    //底部bar
    [self setBtnWithFrame:CGRectMake(0, kScreenH-102*kiphone6, kScreenW/3, 38*kiphone6) WithTitle:@"评论"andTag:101 andImage:@"comment"];
    [self setBtnWithFrame:CGRectMake(kScreenW/3, kScreenH-102*kiphone6, kScreenW/3, 38*kiphone6) WithTitle:@"兴趣"andTag:102 andImage:@"like"];
    [self setBtnWithFrame:CGRectMake(kScreenW/3*2, kScreenH-102*kiphone6, kScreenW/3, 38*kiphone6) WithTitle:@"参加"andTag:103 andImage:@"click_add"];

}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag andImage:(NSString*)image{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-1, 0, 1*kiphone6,38*kiphone6)];
    [btn addSubview:line];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width,1*kiphone6)];
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
    }else if(btn.tag==102){
        self.likeBtn = btn;
    }else{
        self.joinBtn = btn;
    }
    [btn addTarget:self action:@selector(toolBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)toolBarItemClick:(UIButton*)sender{
    if (sender.tag==101) {
        YJPostActivitesCommentVC *vc = [[YJPostActivitesCommentVC alloc]init];
        vc.model = self.model;
        vc.coverPersonalId = 0;
        [self.navigationController pushViewController:vc animated:true];
    }else if (sender.tag==102) {
        if (self.model.islike) {
            [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            self.model.islike = false;
        }else{
            [sender setImage:[UIImage imageNamed:@"click-like"] forState:UIControlStateNormal];
            
            self.model.islike = true;
        }
        //http://localhost:8080/smarthome/mobileapi/upVote/updateActivityLikeNum.do?token=EC9CDB5177C01F016403DFAAEE3C1182
        //    &ActivityId=5
        //    [SVProgressHUD show];// 动画开始
        NSString *likeUrlStr = [NSString stringWithFormat:@"%@/mobileapi/upVote/updateActivityLikeNum.do?token=%@&ActivityId=%ld",mPrefixUrl,mDefineToken1,self.model.info_id];
        [[HttpClient defaultClient]requestWithPath:likeUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            //        [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [sender setImage:[UIImage imageNamed:@"click-like"] forState:UIControlStateNormal];
                [self refrish];//可以换成把用户的头像赋给点赞实体类，需要后台给------------------
            }else if ([responseObject[@"code"] isEqualToString:@"1"]){
                [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
                [self refrish];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //        [SVProgressHUD dismiss];// 动画结束
            return ;
        }];

    }
    else if (sender.tag==103) {
        [SVProgressHUD show];// 动画开始
        NSString *likeUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activityLog/updateActivityparticipateNumber.do?token=%@&ActivityId=%ld",mPrefixUrl,mDefineToken1,self.model.info_id];
        [[HttpClient defaultClient]requestWithPath:likeUrlStr method:0 parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            [SVProgressHUD dismiss];// 动画结束
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [sender setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
                sender.userInteractionEnabled = false;
                self.model.joined = true;
                [self refrish];
            }else{
                [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            //        [SVProgressHUD dismiss];// 动画结束
            return ;
        }];

    }
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(ws);
    if (indexPath.row == 0) {
        
        YJActivitiesDetailsTVCell *cell = [tableView dequeueReusableCellWithIdentifier:tableDetailsCell forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }else if (indexPath.row == 1) {
        
        YJLikeActivitiesTVCell *cell = [tableView dequeueReusableCellWithIdentifier:LikeCell forIndexPath:indexPath];
        cell.image = @"blue-like";
        cell.likeList = self.likeList;
        
        cell.clickAddBlock = ^(NSString *personalId) {
            OtherPeopleInfoViewController *vc = [[OtherPeopleInfoViewController alloc]init];
            vc.info_id = personalId;
            [ws.navigationController pushViewController:vc animated:true];
        };
        return cell;
    }else if (indexPath.row == 2) {
        
        YJLikeActivitiesTVCell *cell = [tableView dequeueReusableCellWithIdentifier:LikeCell forIndexPath:indexPath];
        cell.likeList = self.addList;
        cell.image = @"blue-add";
        cell.clickAddBlock = ^(NSString *personalId) {
            OtherPeopleInfoViewController *vc = [[OtherPeopleInfoViewController alloc]init];
            vc.info_id = personalId;
            [ws.navigationController pushViewController:vc animated:true];
        };
        return cell;
    }else if (indexPath.row == 3) {
        
        YJActivitesCommentTVCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCommentCellid forIndexPath:indexPath];
        cell.userId = self.userId;//传给cell用来判断当点击了A回复B类型的cell中的名字时候判断评论类型
        cell.commentList = self.commentList;
        WS(ws);
        cell.clickForReplyBlock = ^(NSString *str,long coverPersonalId){
            YJPostActivitesCommentVC *vc = [[YJPostActivitesCommentVC alloc]init];
            vc.model = self.model;
            vc.userId = self.userId;
            vc.coverPersonalId = coverPersonalId;
            if (coverPersonalId!=0) {//当回复的不是本人时候才需要设置评论框placeholder
                vc.replyType = [NSString stringWithFormat:@"%@",str];
            }
            
            [ws.navigationController pushViewController:vc animated:true];
                    };
        return cell;
    }else{
        
        YJActivitesPhotoTVCell *cell = [tableView dequeueReusableCellWithIdentifier:photoCellid forIndexPath:indexPath];//活动照片cell
        cell.activity_id = self.model.info_id;
        cell.isJoined = self.model.joined;
        cell.isnumber = self.isnumber;
        cell.activitypicturelist = self.activitypicturelist;
        cell.clickAddBlock = ^(HUImagePickerViewController *picker){
            [self presentViewController:picker animated:YES completion:nil];
        };
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        YJActivitiesDetailModel *model = self.model;
        return[YJActivitiesDetailsTVCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
            YJActivitiesDetailsTVCell *cell = (YJActivitiesDetailsTVCell *)sourceCell;
            
            // 配置数据
            [cell configCellWithModel:model indexPath:indexPath];
        }];

    }
    if (indexPath.row == 1||indexPath.row == 2) {
        if (self.likeList.count<8) {
            return 45*kiphone6;
        }else{
            return 90*kiphone6;
        }
    }
    if (indexPath.row == 3) {
        if (self.commentList.count==0) {
            return 0;
        }
//        CGFloat cellHeight = [YJActivitesCommentTVCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
//            YJActivitesCommentTVCell *cell = (YJActivitesCommentTVCell *)sourceCell;
//            [cell setCommentList:self.commentList];
//            }];
//        return cellHeight;

        return (self.commentList.count*38)*kiphone6>76?(self.commentList.count*38)*kiphone6:76;
    }
    return 200*kiphone6;
    
}

#pragma mark - set属性
-(void)setActivityId:(long)activityId{
    _activityId = activityId;
    [self loadData];
}
-(void)setModel:(YJActivitiesDetailModel *)model{
    _model = model;
    if (self.userId == self.model.personalId) {
        //添加右侧发送按钮
        UIButton *deleateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [deleateBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deleateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        deleateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        deleateBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        //        postBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleateBtn addTarget:self action:@selector(deleateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:deleateBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
}
-(void)loadData{
//http://192.168.1.55:8080/smarthome/mobileapi/activity/findActivityOne.do?token=EC9CDB5177C01F016403DFAAEE3C1182&ActivityId=5
    [SVProgressHUD show];// 动画开始
    NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/findActivityOne.do?token=%@&ActivityId=%ld",mPrefixUrl,mDefineToken1,self.activityId];
    [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSDictionary *bigDic = responseObject[@"result"];
            NSDictionary *detailDic = bigDic[@"activityEntity"];
            YJActivitiesDetailModel *model = [YJActivitiesDetailModel mj_objectWithKeyValues:detailDic];
            if (!self.userId) {//第一次加载数据需要判断userId是否为空,空的代表从消息列表点赞过来
                self.userId = model.info_id;
            }
            self.model = model;//解析状态详情数据
            NSArray *likeArr = bigDic[@"upVptelist"];
            NSMutableArray *likemArr = [NSMutableArray array];
            for (NSDictionary *dic in likeArr) {
                YJActiviesLikeModel *infoModel = [YJActiviesLikeModel mj_objectWithKeyValues:dic];
                [likemArr addObject:infoModel];
            }
            self.likeList = likemArr;//解析点赞人们数据
            NSArray *addArr = bigDic[@"activityLoglist"];
            NSMutableArray *addmArr = [NSMutableArray array];
            for (NSDictionary *dic in addArr) {
                YJActiviesLikeModel *infoModel = [YJActiviesLikeModel mj_objectWithKeyValues:dic];
                [addmArr addObject:infoModel];
            }
            self.addList = addmArr;//解析参加活动人们数据
            NSArray *commentArr = bigDic[@"commentlist"];
            NSMutableArray *commentmArr = [NSMutableArray array];
            for (NSDictionary *dic in commentArr) {
                YJActiviesAddPersonModel *infoModel = [YJActiviesAddPersonModel mj_objectWithKeyValues:dic];
                [commentmArr addObject:infoModel];
            }
            self.commentList = commentmArr;//解析评论数据
            NSArray *pictureArr = bigDic[@"activitypicturelist"];
            NSMutableArray *picturemArr = [NSMutableArray array];
            for (NSDictionary *dic in pictureArr) {
                YJActiviesPictureModel *infoModel = [YJActiviesPictureModel mj_objectWithKeyValues:dic];
                [picturemArr addObject:infoModel];
            }
            self.activitypicturelist = picturemArr;//解析评论数据
            NSString *isnumber = bigDic[@"isnumber"];
            self.isnumber = [isnumber integerValue];
            [self setActivitiesDetailUI];
//            [self.tableView reloadData];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
    
}

//-(void)setUserId:(long)userId{
//    _userId = userId;
//    if (userId == self.model.personalId) {
//            //添加右侧发送按钮
//            UIButton *deleateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
//            [deleateBtn setTitle:@"删除" forState:UIControlStateNormal];
//            [deleateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
//            deleateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
//            deleateBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
//            //        postBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
//            deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//            [deleateBtn addTarget:self action:@selector(deleateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:deleateBtn];
//            self.navigationItem.rightBarButtonItem = rightBarItem;
//    }
//}
-(void)deleateBtnClick:(UIButton *)sender{
    //http://localhost:8080/smarthome/mobileapi/activity/delete.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//    &PublisherPersonalId=11
//    &AvtivityId=1
    [SVProgressHUD show];// 动画开始
    NSString *deleUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/delete.do?token=%@&PublisherPersonalId=%ld&ActivityId=%ld",mPrefixUrl,mDefineToken1,self.model.personalId,self.model.info_id];
    [[HttpClient defaultClient]requestWithPath:deleUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[YJCommunityActivitiesVC class]]) {
                    YJCommunityActivitiesVC *revise =(YJCommunityActivitiesVC *)controller;
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
-(void)refrish{
    [SVProgressHUD show];// 动画开始
    NSString *activiesUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/findActivityOne.do?token=%@&ActivityId=%ld",mPrefixUrl,mDefineToken1,self.model.info_id];
    [[HttpClient defaultClient]requestWithPath:activiesUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            NSDictionary *bigDic = responseObject[@"result"];
            NSArray *likeArr = bigDic[@"upVptelist"];
            NSMutableArray *likemArr = [NSMutableArray array];
            for (NSDictionary *dic in likeArr) {
                YJActiviesLikeModel *infoModel = [YJActiviesLikeModel mj_objectWithKeyValues:dic];
                [likemArr addObject:infoModel];
            }
            self.likeList = likemArr;//解析点赞人们数据
            NSArray *addArr = bigDic[@"activityLoglist"];
            NSMutableArray *addmArr = [NSMutableArray array];
            for (NSDictionary *dic in addArr) {
                YJActiviesLikeModel *infoModel = [YJActiviesLikeModel mj_objectWithKeyValues:dic];
                [addmArr addObject:infoModel];
            }
            self.addList = addmArr;//解析参加活动人们数据
            NSArray *commentArr = bigDic[@"commentlist"];
            NSMutableArray *commentmArr = [NSMutableArray array];
            for (NSDictionary *dic in commentArr) {
                YJActiviesAddPersonModel *infoModel = [YJActiviesAddPersonModel mj_objectWithKeyValues:dic];
                [commentmArr addObject:infoModel];
            }
            self.commentList = commentmArr;//解析评论数据
            NSArray *pictureArr = bigDic[@"activitypicturelist"];
            NSMutableArray *picturemArr = [NSMutableArray array];
            for (NSDictionary *dic in pictureArr) {
                YJActiviesPictureModel *infoModel = [YJActiviesPictureModel mj_objectWithKeyValues:dic];
                [picturemArr addObject:infoModel];
            }
            self.activitypicturelist = picturemArr;//解析评论数据
            NSString *isnumber = bigDic[@"isnumber"];
            self.isnumber = [isnumber integerValue];
            [self.tableView reloadData];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
 
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
