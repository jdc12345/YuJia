//
//  YJNoticeListTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/10.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJNoticeListTVCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import <UIImageView+WebCache.h>
#import "RKNotificationHub.h"

@interface YJNoticeListTVCell()
@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UILabel* itemLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@property(nonatomic,strong)RKNotificationHub *barHub;//bage
@property (nonatomic, weak) UIView* backBage;
@end
@implementation YJNoticeListTVCell

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
-(void)setModel:(YJNoticeListModel *)model{
    _model = model;
    NSString *iconUrl = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.avatar];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"icon"]];
//    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    // borderWidth 表示边框的宽度
//        CGFloat borderWidth = 0;
////        UIImage *image = self.iconView.image;
//        CGFloat imageW = image.size.width + 2 * borderWidth;
//        CGFloat imageH = imageW;
//        CGSize imageSize = CGSizeMake(imageW, imageH);
//        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGFloat bigRadius = imageW * 0.5;
//        CGFloat centerX = bigRadius;
//        CGFloat centerY = bigRadius;
//        CGContextAddArc(context, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
//        CGContextFillPath(context);
//        CGFloat smallRadius = bigRadius - borderWidth;
//        CGContextAddArc(context, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
//        CGContextClip(context);
//        [image drawInRect:CGRectMake(borderWidth, borderWidth, image.size.width, image.size.height)];
//        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//        self.iconView.image = newImage;
//        UIGraphicsEndImageContext();
//
//    }];
        self.itemLabel.text = model.content;
    self.nameLabel.text = model.title;
    self.timeLabel.text = model.createTimeString;
    if (!model.isRead) {
        self.barHub = [[RKNotificationHub alloc] initWithView:self.backBage];//初始化bageView
        [self.barHub setCircleAtFrame:CGRectMake(0, 0, 5, 5)];//bage的frame
        [self.barHub increment];//显示count+1
        [self.barHub hideCount];//隐藏数字
        
    }else{
        [self.barHub setCircleAtFrame:CGRectMake(0, 0, 0, 0)];//bage的frame
    }
    
}
-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    UIImageView *iconView = [[UIImageView alloc]init];
    iconView.image = [UIImage imageNamed:@"icon"];
    iconView.layer.masksToBounds = true;
    iconView.layer.cornerRadius = 20*kiphone6;
    [self.contentView addSubview:iconView];
    UILabel *nameLabel = [UILabel labelWithText:@"TIAN" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [self.contentView addSubview:nameLabel];

    UILabel *itemLabel = [UILabel labelWithText:@"用户TIAN给你点赞了" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];
    [self.contentView addSubview:itemLabel];
    UILabel *timeLabel = [UILabel labelWithText:@"10:00" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:12];
    timeLabel.numberOfLines = 0;
    [self.contentView addSubview:timeLabel];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(self.contentView);
        make.width.height.offset(40*kiphone6);
    }];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2.5*kiphone6);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.offset(-10*kiphone6);
        make.width.offset(80*kiphone6);
    }];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
        make.top.equalTo(self.contentView.mas_centerY).offset(2.5*kiphone6);
        make.right.equalTo(timeLabel.mas_left).offset(-5*kiphone6);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(1*kiphone6);
    }];
    UIView *backBage = [[UIView alloc]init];//bage的背景
    backBage.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:backBage];
    [backBage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(-6);
        make.top.equalTo(iconView.mas_top).offset(2);
        make.width.height.offset(5*kiphone6);
    }];
    self.backBage = backBage;
    self.itemLabel = itemLabel;
    self.nameLabel = nameLabel;
    self.iconView = iconView;
    self.timeLabel = timeLabel;
}



@end
