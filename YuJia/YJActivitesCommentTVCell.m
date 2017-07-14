//
//  YJActivitesCommentTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJActivitesCommentTVCell.h"
#import "YJFriendCommentTableViewCell.h"
#import "YJSelfReplyTableViewCell.h"
#import "YJActiviesAddPersonModel.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
static NSString* friendCommentCellid = @"friendComment_cell";
static NSString* selfReplyCellid = @"selfReply_cell";
@interface YJActivitesCommentTVCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) UIImageView* heartView;
@property (nonatomic, weak) UITableView* tableView;


@end
@implementation YJActivitesCommentTVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}
-(void)setCommentList:(NSArray *)commentList{
    _commentList = commentList;
    [self.tableView reloadData];
}

-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    
    UITableView *commentTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    commentTableView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    self.tableView = commentTableView;
    [commentTableView registerClass:[YJFriendCommentTableViewCell class] forCellReuseIdentifier:friendCommentCellid];
    [commentTableView registerClass:[YJSelfReplyTableViewCell class] forCellReuseIdentifier:selfReplyCellid];
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentTableView.delegate =self;
    commentTableView.dataSource = self;
    commentTableView.rowHeight = UITableViewAutomaticDimension;
    commentTableView.estimatedRowHeight = 38*kiphone6;
    [backView addSubview:commentTableView];
    [commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        // make.height.offset(100*kiphone6);
        make.bottom.offset(0);
    }];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
    }];

    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    self.hyb_lastViewInCell = backView;
    self.hyb_bottomOffsetToCell = 10;

        
}

#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.commentList.count;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WS(ws);
    YJActiviesAddPersonModel *model = self.commentList[indexPath.row];
    if (model.coverPersonalId == 0) {//判断是用户评论还是自己回复评论
        YJFriendCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCommentCellid forIndexPath:indexPath];
        cell.activiesModel = model;
        cell.clickBtnBlock = ^(NSString *str){
//            NSRange range = [str rangeOfString:@"{"];
//            NSString *strs = [str substringToIndex:range.location];
            ws.clickForReplyBlock(str,model.personalId);//第二个参数用来在评论时候传给后台确认被回复人的id
//            [ws.commentField setPlaceholder:[NSString stringWithFormat:@"回复 %@:",strs]];
//            ws.coverPersonalId = model.coverPersonalId;
//            [ws.commentField becomeFirstResponder];
            
        };
//        if (indexPath.row==0) {
//            cell.iconView.hidden = false;
//        }
        return cell;
    }else{
        YJSelfReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selfReplyCellid forIndexPath:indexPath];
        cell.activiesModel = model;
        
        cell.clickBtnBlock = ^(NSString *str){
//            NSRange range = [str rangeOfString:@"{"];
//            NSString *strs = [str substringToIndex:range.location];
            if ([str containsString:@"me://"]) {//代表点击了第一个名字，这个名字的id是personalId
                if (model.personalId == self.userId) {
                    ws.clickForReplyBlock(str,0);
                }else{
                    ws.clickForReplyBlock(str,model.personalId);
                }
            }
            if ([str containsString:@"user://"]) {//代表点击了第二个名字，这个名字的id是coverPersonalId
                if (model.coverPersonalId == self.userId) {
                    ws.clickForReplyBlock(str,0);
                }else{
                    ws.clickForReplyBlock(str,model.coverPersonalId);
                }
            }

//            if ([model.userName isEqualToString:strs]) {//当点击的是当前用户的名字
//                ws.clickForReplyBlock(str,0);
//            }else{
//                ws.clickForReplyBlock(str,model.coverPersonalId);
//            }

        };
        return cell;
    }

//    NSArray *listArr = @[@0,@1,@0,@1];//判断是用户评论还是自己回复评论
//    if (![listArr[indexPath.row] integerValue]) {
//        YJFriendCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCommentCellid forIndexPath:indexPath];
//        cell.model = @"用户";
//        WS(ws);
//        cell.clickBtnBlock = ^(NSString *str){
//            NSLog(@"%@",str);
//            ws.clickForReplyBlock(str);
//        };
//        if (indexPath.row==0) {
//            cell.iconView.hidden = false;
//        }
//        return cell;
//    }else{
//        YJSelfReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selfReplyCellid forIndexPath:indexPath];
//        cell.model = @[@"TIAN",@"用户"];
//        WS(ws);
//        cell.clickBtnBlock = ^(NSString *str){
//            //NSLog(@"%@",str);
//            ws.clickForReplyBlock(str);
//        };
//        return cell;
//    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
    
}


@end
