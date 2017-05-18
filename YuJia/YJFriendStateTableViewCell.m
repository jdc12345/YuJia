//
//  YJFriendStateTableViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/9.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJFriendStateTableViewCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import "YJImageDisplayCollectionViewCell.h"
#import "YJRepairRecordFlowLayout.h"
#import <HUPhotoBrowser.h>
#import <UIImageView+WebCache.h>

static NSString* collectionCellid = @"collection_cell";
static NSString* photoCellid = @"photo_cell";
@interface YJFriendStateTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UILabel* areaLabel;
@property (nonatomic, weak) UILabel* typeLabel;
@property (nonatomic, weak) UILabel* conentLabel;
@property(nonatomic,weak)UICollectionView *collectionView;
@property (nonatomic, weak) UILabel* timeLabel;
@property (nonatomic, weak) UIButton* likeBtn;
@property (nonatomic, weak) UILabel* likeNumberLabel;
@property (nonatomic, weak) UILabel* commentNumberLabel;
@end
@implementation YJFriendStateTableViewCell

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
-(void)setModel:(YJFriendNeighborStateModel *)model{
    _model = model;
    NSString *iconStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,model.avatar];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"icon"]];
    self.typeLabel.text = model.cname;
    self.conentLabel.text = model.content;
    self.timeLabel.text = model.createTimeString;
    self.areaLabel.text = model.rname;
    self.commentNumberLabel.text = [NSString stringWithFormat:@"%ld",model.commentNum];
    self.likeNumberLabel.text = [NSString stringWithFormat:@"%ld",model.LikeNum];
}

-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    UIImageView *iconView = [[UIImageView alloc]init];//头像图片
    iconView.image = [UIImage imageNamed:@"icon"];
    iconView.layer.masksToBounds = true;
    iconView.layer.cornerRadius = 20*kiphone6;
    [self.contentView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.offset(10*kiphone6);
        make.width.height.offset(40*kiphone6);
    }];
    UILabel *nameLabel = [UILabel labelWithText:@"TIAN" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];//维修时间
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(24*kiphone6);
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
    }];
    UILabel *areaLabel = [UILabel labelWithText:@"名流一品" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:10];//维修类型
    [self.contentView addSubview:areaLabel];
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(25*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    UILabel *typeLabel = [UILabel labelWithText:@"居家" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//维修类型
    [self.contentView addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameLabel.mas_bottom).offset(15*kiphone6);
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
    }];
    UILabel *contentLabel = [UILabel labelWithText:@"期望处理时间:2017-5-2期望处理时间:2017-5-2期望处理时间:2017-5-2期望处理时间:2017-5-2" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:13];//报修内容
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15*kiphone6);
        make.left.equalTo(nameLabel);
        make.top.equalTo(typeLabel.mas_bottom).offset(7*kiphone6);
    }];
    //photoCollectionView
    UICollectionView *photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJRepairRecordFlowLayout alloc]init]];
    [self.contentView addSubview:photoCollectionView];
    self.collectionView = photoCollectionView;
    photoCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    // 注册单元格
    [photoCollectionView registerClass:[YJImageDisplayCollectionViewCell class] forCellWithReuseIdentifier:photoCellid];
    photoCollectionView.bounces = false;
    photoCollectionView.scrollEnabled = false;
    photoCollectionView.showsHorizontalScrollIndicator = false;
    photoCollectionView.showsVerticalScrollIndicator = false;
    [photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom).offset(10*kiphone6);
        make.left.equalTo(nameLabel);
        make.right.offset(-10*kiphone6);
        make.height.offset(65*kiphone6);
    }];
    UILabel *timeLabel = [UILabel labelWithText:@"1小时前" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:10];//维修时间
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoCollectionView.mas_bottom).offset(19*kiphone6);
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
    }];
    UILabel *commentNumberLabel = [UILabel labelWithText:@"1" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//维修类型
    [self.contentView addSubview:commentNumberLabel];
    [commentNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoCollectionView.mas_bottom).offset(15*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    UIButton *commentBtn = [[UIButton alloc]init];//取消维修按钮
    [commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self.contentView addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentNumberLabel);
        make.right.equalTo(commentNumberLabel.mas_left).offset(-5*kiphone6);
    }];
    UILabel *likeNumberLabel = [UILabel labelWithText:@"1" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//维修类型
    [self.contentView addSubview:likeNumberLabel];
    [likeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoCollectionView.mas_bottom).offset(15*kiphone6);
        make.right.equalTo(commentBtn.mas_left).offset(-15*kiphone6);
    }];
   
    [self.contentView addSubview:commentNumberLabel];
    UIButton *likeBtn = [[UIButton alloc]init];//完成维修按钮
    [likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.contentView addSubview:likeBtn];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentNumberLabel);
        make.right.equalTo(likeNumberLabel.mas_left).offset(-5*kiphone6);
        make.bottom.offset(-15*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(likeBtn.mas_bottom).offset(15*kiphone6);
//        make.width.offset(kScreenW);
//    }];
    self.iconView = iconView;
    self.areaLabel = areaLabel;
    self.typeLabel = typeLabel;
    self.conentLabel = contentLabel;
    self.collectionView = photoCollectionView;
    self.timeLabel = timeLabel;
    self.likeBtn = likeBtn;
    self.likeNumberLabel = likeNumberLabel;
    self.commentNumberLabel = commentNumberLabel;
    [likeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
//- (void)btnClick:(UIButton *)sender{
//    if (self.clickBtnBlock) {
//        self.clickBtnBlock(sender.tag);
//    }
//}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    // 去缓存池找
    YJImageDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
    
    cell.photo = [UIImage imageNamed:@"icon"];
    return cell;
    
}
// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    YJImageDisplayCollectionViewCell *cell = (YJImageDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"icon"];
    NSArray *imageArr = @[image,image,image,image,image];
    [HUPhotoBrowser showFromImageView:cell.imageView withImages:imageArr atIndex:indexPath.row];
    
}
@end
