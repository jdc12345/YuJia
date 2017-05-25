//
//  YJCommunityActivitiesTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJCommunityActivitiesTVCell.h"
#import "UILabel+Addition.h"
#import <UIImageView+WebCache.h>

@interface YJCommunityActivitiesTVCell()
@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UILabel* creatTimeLabel;
@property (nonatomic, weak) UILabel* typeLabel;
@property (nonatomic, weak) UILabel* addressLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@property (nonatomic, weak) UILabel* limiteNumberLabel;
@property (nonatomic, weak) UIButton* likeBtn;
@property (nonatomic, weak) UILabel* likeNumberLabel;
@property (nonatomic, weak) UIButton* addBtn;
@property (nonatomic, weak) UILabel* addNumberLabel;
@property (nonatomic, weak) UILabel* activitieStateLabel;
@property (nonatomic, assign) BOOL isLike;
@end
@implementation YJCommunityActivitiesTVCell

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
//-----根据活动状态和已参加人数来确定活动是否还可以参加-----
-(void)setModel:(YJActivitiesDetailModel *)model{
    _model = model;
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.avatar];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.nameLabel.text = model.user_name;
    self.creatTimeLabel.text = model.createTimeString;
    self.typeLabel.text = model.activityTheme;
    self.timeLabel.text = [NSString stringWithFormat:@"%@-%@",model.starttimeString,model.endtimeString];
    self.addressLabel.text = model.activityAddress;
    self.limiteNumberLabel.text = [NSString stringWithFormat:@"%ld人",model.activityNumber];
    self.likeNumberLabel.text = [NSString stringWithFormat:@"%ld人感兴趣",model.likeNum];
    self.addNumberLabel.text = [NSString stringWithFormat:@"%ld人",model.participateNumber];
    if (model.islike) {
        [self.likeBtn setImage:[UIImage imageNamed:@"click-like"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
  
    if (model.over == 1) {
        self.activitieStateLabel.text = @"正在进行";
        self.likeBtn.userInteractionEnabled = true;
        if (model.joined) {//参加过不能参加
            [self.addBtn setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
            self.addBtn.userInteractionEnabled = false;
        }else{
            if (model.participateNumber<model.activityNumber) {
                [self.addBtn setImage:[UIImage imageNamed:@"click_add"] forState:UIControlStateNormal];
                self.addBtn.userInteractionEnabled = true;
            }else{//没参加过但是人数满了也不能参加
                [self.addBtn setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
                self.addBtn.userInteractionEnabled = false;
            }
        }
    }else if (model.over == 2) {
        self.activitieStateLabel.text = @"活动结束";
        [self.addBtn setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
        self.addBtn.userInteractionEnabled = false;
        self.likeBtn.userInteractionEnabled = false;
    }
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    UIView *headerView = [[UIView alloc]init];//添加line
    headerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(60*kiphone6);
    }];
    UIImageView *iconView = [[UIImageView alloc]init];//头像图片
    iconView.image = [UIImage imageNamed:@"icon"];
    iconView.layer.masksToBounds = true;
    iconView.layer.cornerRadius = 20*kiphone6;
    [headerView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(headerView);
        make.width.height.offset(40*kiphone6);
    }];
    UILabel *nameLabel = [UILabel labelWithText:@"TIAN" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//姓名
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
    }];
    UILabel *begainTimeLabel = [UILabel labelWithText:@"5月6日 6:30" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//开始时间
    [headerView addSubview:begainTimeLabel];
    [begainTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.right.offset(-10*kiphone6);
    }];
    UILabel *typeLabel = [UILabel labelWithText:@"烧烤聚会" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//活动类型
    [self.contentView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom).offset(10*kiphone6);
        make.left.offset(10*kiphone6);
    }];
    UILabel *timeItemLabel = [UILabel labelWithText:@"时间" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//时间标题
    [self.contentView addSubview:timeItemLabel];
    [timeItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(typeLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *timeLabel = [UILabel labelWithText:@"5.6 6:30-5.31 18:30" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//时间内容
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(timeItemLabel);
    }];
    UILabel *AddressItemLabel = [UILabel labelWithText:@"地点" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//地点标题
    [self.contentView addSubview:AddressItemLabel];
    [AddressItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(timeItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *AddressLabel = [UILabel labelWithText:@"风景区公园" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//地点内容
    [self.contentView addSubview:AddressLabel];
    [AddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(AddressItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(AddressItemLabel);
    }];
    UILabel *numberItemLabel = [UILabel labelWithText:@"人数" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//总人数标题
    [self.contentView addSubview:numberItemLabel];
    [numberItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(AddressItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *limiteNumberLabel = [UILabel labelWithText:@"3人" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//总人数
    [self.contentView addSubview:limiteNumberLabel];
    [limiteNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(numberItemLabel.mas_right).offset(10*kiphone6);
        make.centerY.equalTo(numberItemLabel);
    }];
    UIView *footerView = [[UIView alloc]init];//添加尾部视图
    footerView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.contentView addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(37*kiphone6);
        make.top.equalTo(numberItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UILabel *activitieStateLabel = [UILabel labelWithText:@"正在进行" andTextColor:[UIColor colorWithHexString:@"#00bfff"] andFontSize:14];//活动状态
    [footerView addSubview:activitieStateLabel];
    [activitieStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footerView);
        make.left.offset(10*kiphone6);
    }];
    UIButton *likeBtn = [[UIButton alloc]init];//点赞按钮
    [likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [footerView addSubview:likeBtn];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footerView);
        make.left.equalTo(activitieStateLabel.mas_right).offset(63*kiphone6);
    }];
    UILabel *likeNumberLabel = [UILabel labelWithText:@"1人感兴趣" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//感兴趣人数
    [footerView addSubview:likeNumberLabel];
    [likeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footerView);
        make.left.equalTo(likeBtn.mas_right).offset(10*kiphone6);
    }];
   
    UILabel *addNumberLabel = [UILabel labelWithText:@"1人参加" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//参加人数
    [footerView addSubview:addNumberLabel];
    [addNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footerView);
        make.right.offset(-10*kiphone6);
    }];
    UIButton *addBtn = [[UIButton alloc]init];//参加按钮
    [addBtn setImage:[UIImage imageNamed:@"blue-add"] forState:UIControlStateNormal];
    [footerView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footerView);
        make.right.equalTo(addNumberLabel.mas_left).offset(-10*kiphone6);
    }];

    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(footerView.mas_bottom).offset(13.5*kiphone6);
//        make.width.offset(kScreenW);
//    }];
    self.iconView = iconView;
    self.nameLabel = nameLabel;
    self.typeLabel = typeLabel;
    self.creatTimeLabel = begainTimeLabel;
    self.timeLabel = timeLabel;
    self.limiteNumberLabel = limiteNumberLabel;
    self.likeBtn = likeBtn;
    self.likeNumberLabel = likeNumberLabel;
    self.addBtn = addBtn;
    self.addNumberLabel = addNumberLabel;
    self.activitieStateLabel = activitieStateLabel;
    [likeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)addBtnClick:(UIButton*)sender{
//http://localhost:8080/smarthome/mobileapi/activityLog/updateActivityparticipateNumber.do?token=EC9CDB5177C01F016403DFAAEE3C1182
//    &ActivityId=3
//    NSInteger addNumber = [self.addNumberLabel.text integerValue];
//    if (!self.model.joined) {
//        [sender setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
//        sender.userInteractionEnabled = false;
//
//            self.addNumberLabel.text = [NSString stringWithFormat:@"%ld",addNumber+1];
//            self.model.participateNumber +=1;
//
//        self.model.joined = true;
//    }
    [SVProgressHUD show];// 动画开始
    NSString *likeUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activityLog/updateActivityparticipateNumber.do?token=%@&ActivityId=%ld",mPrefixUrl,mDefineToken1,self.model.info_id];
    [[HttpClient defaultClient]requestWithPath:likeUrlStr method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [sender setImage:[UIImage imageNamed:@"gray_add"] forState:UIControlStateNormal];
            sender.userInteractionEnabled = false;
            NSInteger addNumber = [self.addNumberLabel.text integerValue];
            self.addNumberLabel.text = [NSString stringWithFormat:@"%ld",addNumber+1];
            self.model.participateNumber +=1;
            self.model.joined = true;
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
 
}
-(void)btnClick:(UIButton*)sender{

    NSInteger likeNumber = [self.likeNumberLabel.text integerValue];
    if (self.model.islike) {
        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        if (likeNumber>0) {
            self.likeNumberLabel.text = [NSString stringWithFormat:@"%ld人感兴趣",likeNumber-1];
            self.model.likeNum -=1;
        }
        self.model.islike = false;
    }else{
        [sender setImage:[UIImage imageNamed:@"click-like"] forState:UIControlStateNormal];
        self.likeNumberLabel.text = [NSString stringWithFormat:@"%ld人感兴趣",likeNumber+1];
        self.model.likeNum +=1;
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
        }else if ([responseObject[@"code"] isEqualToString:@"1"]){
            [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            
        }else{
            [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        //        [SVProgressHUD dismiss];// 动画结束
        return ;
    }];
}

@end
