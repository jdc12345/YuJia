//
//  YJPostActivitesCommentVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/13.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPostActivitesCommentVC.h"
#import "BRPlaceholderTextView.h"
#import "YJActivitiesDetailsVC.h"
#import "YJCommunityCarDetailVC.h"

@interface YJPostActivitesCommentVC ()<UITextViewDelegate>
@property(nonatomic,weak)BRPlaceholderTextView *contentView;
@end

@implementation YJPostActivitesCommentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发评论";
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    
        //添加右侧发送按钮
        UIButton *deleateBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [deleateBtn setTitle:@"发表" forState:UIControlStateNormal];
        deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleateBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        deleateBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        deleateBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
        //        postBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
        deleateBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [deleateBtn addTarget:self action:@selector(postBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:deleateBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    
    [self setupUIWithType:@"写新评论..."];

}
-(void)setupUIWithType:(NSString*)type{
    //输入框
    BRPlaceholderTextView *titleView = [[BRPlaceholderTextView alloc]init];
    titleView.tag = 101;
    [self.view addSubview:titleView];
    self.contentView = titleView;
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
        make.height.offset(200*kiphone6);
    }];
    [titleView layoutIfNeeded];
    titleView.delegate = self;
    titleView.placeholder = type;
    //        titleView.imagePlaceholder = @"title";
    titleView.font=[UIFont boldSystemFontOfSize:14];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [titleView setPlaceholderFont:[UIFont systemFontOfSize:14]];
    [titleView setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
    //    titleField.borderStyle = UITextBorderStyleNone;
    //    //边框宽度
    //    [titleField.layer setBorderWidth:0.01f];
    [titleView setPlaceholderOpacity:0.6];
    [titleView addMaxTextLengthWithMaxLength:500 andEvent:^(BRPlaceholderTextView *text) {
        //            [self.titleView endEditing:YES];
        
        NSLog(@"----------");
    }];
    
    [titleView addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
        NSLog(@"begin");
    }];
    
    [titleView addTextViewEndEvent:^(BRPlaceholderTextView *text) {
        
        NSLog(@"end");
    }];
 
}
-(void)setReplyType:(NSString *)replyType{
    _replyType = replyType;
    for (UIView *subview in [self.view subviews]) {
        if (subview.tag==101) {
            [subview removeFromSuperview];
        }
    }
    NSRange range = [replyType rangeOfString:@"{"];
    NSString *str = [replyType substringToIndex:range.location];
    [self setupUIWithType:[NSString stringWithFormat:@"回复 %@:",str]];
}
-(void)setModel:(YJActivitiesDetailModel *)model{
    _model = model;
    
}
-(void)postBtnClick:(UIButton*)sender{
    if (self.model) {//添加活动评论
//http://localhost:8080/smarthome/mobileapi/activity/addcomment.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//    &ActivityId=2
//    &coverPersonalId=10
//    &content=%E6%88%91%E6%83%B3%E6%89%93%E4%BD%A0评论内容
    if (self.coverPersonalId == self.userId) {//当点击评论名字进来时候需要判断名字人的id和用户是否一样
        self.coverPersonalId = 0;//0指的直接评论，其他指回复某个人
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/addcomment.do?token=%@&ActivityId=%ld&coverPersonalId=%ld&content=%@",mPrefixUrl,mDefineToken1,self.model.info_id,self.coverPersonalId,[self.contentView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    [SVProgressHUD show];// 动画开始
    [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[YJActivitiesDetailsVC class]]) {
                    YJActivitiesDetailsVC *revise =(YJActivitiesDetailsVC *)controller;
                    [revise refrish];
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"评论未成功，请稍后再试"];
        return ;
    }];
        
}
    if (self.carModel) {//添加社区拼车评论
    http://localhost:8080/smarthome/mobileapi/carpooling/addcommentCarpooling.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//        &carpoolingId=1
//        &coverPersonalId=10
//        &content=%E6%97%A9%E4%B8%8A%E6%97%A9%E7%82%B9%E8%B5%B0%EF%BC%8C%E4%B8%8D%E7%84%B6%E8%B5%B6%E4%B8%8D%E4%B8%8A%E9%A3%9E%E6%9C%BA
        if (self.coverPersonalId == self.userId) {//当点击评论名字进来时候需要判断名字人的id和用户是否一样
            self.coverPersonalId = 0;//0指的直接评论，其他指回复某个人
        }
        NSString *urlStr = [NSString stringWithFormat:@"%@/mobileapi/carpooling/addcommentCarpooling.do?token=%@&carpoolingId=%ld&coverPersonalId=%ld&content=%@",mPrefixUrl,mDefineToken1,self.carModel.info_id,self.coverPersonalId,[self.contentView.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        [SVProgressHUD show];// 动画开始
        [[HttpClient defaultClient]requestWithPath:urlStr method:HttpRequestPost parameters:nil prepareExecute:^{
            
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                for (UIViewController *controller in self.navigationController.viewControllers) {
                    if ([controller isKindOfClass:[YJCommunityCarDetailVC class]]) {
                        YJCommunityCarDetailVC *revise =(YJCommunityCarDetailVC *)controller;
                        [revise refrish];
                        [self.navigationController popToViewController:revise animated:YES];
                    }
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"评论未成功，请稍后再试"];
            return ;
        }];

    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
