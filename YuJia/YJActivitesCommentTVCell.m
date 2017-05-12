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
//-----根据评论内容计算tableView的高度，从新布局tableView的高度-----
//-(void)setModel:(YYPropertyItemModel *)model{
//    _model = model;
//    self.itemLabel.text = model.item;
//    [self.btn setTitle:model.event forState:UIControlStateNormal];
//}

-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.contentView addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(10*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    UITableView *commentTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    commentTableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [backView addSubview:commentTableView];
    [commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(100*kiphone6);
    }];
    self.tableView = commentTableView;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [commentTableView registerClass:[YJFriendCommentTableViewCell class] forCellReuseIdentifier:friendCommentCellid];
    [commentTableView registerClass:[YJSelfReplyTableViewCell class] forCellReuseIdentifier:selfReplyCellid];
    commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentTableView.delegate =self;
    commentTableView.dataSource = self;
    commentTableView.rowHeight = UITableViewAutomaticDimension;
    commentTableView.estimatedRowHeight = 38*kiphone6;
    
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];

    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(commentTableView.mas_bottom).offset(5*kiphone6);
        make.width.offset(kScreenW);
    }];
    
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;//根据请求回来的数据定
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *listArr = @[@0,@1,@0,@1];//判断是用户评论还是自己回复评论
    if (![listArr[indexPath.row] integerValue]) {
        YJFriendCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:friendCommentCellid forIndexPath:indexPath];
        cell.model = @"用户";
        cell.clickBtnBlock = ^(NSString *str){
            NSLog(@"%@",str);
        };
        if (indexPath.row==0) {
            cell.iconView.hidden = false;
        }
        return cell;
    }else{
        YJSelfReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selfReplyCellid forIndexPath:indexPath];
        cell.model = @[@"TIAN",@"用户"];
        cell.clickBtnBlock = ^(NSString *str){
            NSLog(@"%@",str);
        };
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
    
}


@end
