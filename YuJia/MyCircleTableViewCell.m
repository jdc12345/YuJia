//
//  MyCircleTableViewCell.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "MyCircleTableViewCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import "YJImageDisplayCollectionViewCell.h"
#import "YJRepairRecordFlowLayout.h"
#import <HUPhotoBrowser.h>
#import <UIImageView+WebCache.h>
#import "YJFriendStatesFlowLayout.h"
static NSString* collectionCellid = @"collection_cell";
static NSString* photoCellid = @"photo_cell";
@interface MyCircleTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
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
@property(nonatomic,strong)NSArray *imagesArr;
@property(nonatomic,strong)NSMutableArray *urlStrs;
@end
@implementation MyCircleTableViewCell

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
    self.nameLabel.text = model.userName;
    self.typeLabel.text = model.cname;
    self.conentLabel.text = model.content;
    CGSize textSize = [model.content boundingRectWithSize:CGSizeMake(kScreenW-20*kiphone6, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size;
    [self.conentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(textSize.height);
    }];//计算文字内容高度，更新约束
    self.timeLabel.text = model.createTimeString;
    self.areaLabel.text = model.rname;
    self.commentNumberLabel.text = [NSString stringWithFormat:@"%ld",model.commentNum];
    self.likeNumberLabel.text = [NSString stringWithFormat:@"%ld",model.likeNum];
    if (![model.picture isEqualToString:@""]) {
        NSArray *array = [model.picture componentsSeparatedByString:@";"];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
        [arr removeLastObject];
        self.imagesArr = arr;
        for (int i=0; i<arr.count; i++) {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,arr[i]];
            [self.urlStrs addObject:urlStr];
        }
        if (self.imagesArr.count<4&&self.imagesArr.count>0) {
            if (self.collectionView.frame.size.height != 103*kiphone6) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(103*kiphone6);
                }];
            }
        }else if (self.imagesArr.count>3&&self.imagesArr.count<7){
            if (self.collectionView.frame.size.height != 206*kiphone6) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(206*kiphone6);
                }];
            }
        }else if (self.imagesArr.count>6){
            if (self.collectionView.frame.size.height != 310*kiphone6) {
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.offset(310*kiphone6);
                }];
            }
        }
        [self.collectionView reloadData];
    }else{
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
        }];
        [self.collectionView reloadData];
    }
    if (self.model.islike) {
        [self.likeBtn setImage:[UIImage imageNamed:@"click-like"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    [self layoutIfNeeded];//更新cell整体约束
    
    self.cellHeight = CGRectGetMaxY(self.likeBtn.frame) + 15*kiphone6;//取最底部的空间最大Y值加距离底部的距离为cell的高度
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
    iconView.userInteractionEnabled = true;
    //添加滑动手势
    UITapGestureRecognizer *pan = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [iconView addGestureRecognizer:pan];
    pan.delegate = self;
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
    UICollectionView *photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJFriendStatesFlowLayout alloc]init]];
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
        make.height.offset(0);
    }];
    UILabel *timeLabel = [UILabel labelWithText:@"1小时前" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:10];//维修时间
    [self.contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoCollectionView.mas_bottom).offset(8*kiphone6);
        make.left.equalTo(iconView.mas_right).offset(10*kiphone6);
    }];
    UILabel *commentNumberLabel = [UILabel labelWithText:@"1" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//维修类型
    [self.contentView addSubview:commentNumberLabel];
    [commentNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoCollectionView.mas_bottom).offset(5*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    UIButton *commentBtn = [[UIButton alloc]init];//评论按钮
    [commentBtn setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self.contentView addSubview:commentBtn];
    [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentNumberLabel);
        make.right.equalTo(commentNumberLabel.mas_left).offset(-5*kiphone6);
    }];
    UILabel *likeNumberLabel = [UILabel labelWithText:@"1" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:14];//维修类型
    [self.contentView addSubview:likeNumberLabel];
    [likeNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(photoCollectionView.mas_bottom).offset(5*kiphone6);
        make.right.equalTo(commentBtn.mas_left).offset(-15*kiphone6);
    }];
    [self.contentView addSubview:commentNumberLabel];
    UIButton *likeBtn = [[UIButton alloc]init];//点赞按钮
    [likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.contentView addSubview:likeBtn];
    [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentNumberLabel);
        make.right.equalTo(likeNumberLabel.mas_left).offset(-5*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    self.iconView = iconView;
    self.nameLabel = nameLabel;
    self.areaLabel = areaLabel;
    self.typeLabel = typeLabel;
    self.conentLabel = contentLabel;
    self.collectionView = photoCollectionView;
    self.timeLabel = timeLabel;
    self.likeBtn = likeBtn;
    self.likeNumberLabel = likeNumberLabel;
    self.commentNumberLabel = commentNumberLabel;
    [likeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [commentBtn addTarget:self action:@selector(commentClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnClick:(UIButton *)sender{
    
    NSInteger likeNumber = [self.likeNumberLabel.text integerValue];
    if (self.model.islike) {
        [sender setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        if (likeNumber>0) {
            self.likeNumberLabel.text = [NSString stringWithFormat:@"%ld",likeNumber-1];
            self.model.likeNum -=1;
        }
        self.model.islike = false;
    }else{
        [sender setImage:[UIImage imageNamed:@"click-like"] forState:UIControlStateNormal];
        self.likeNumberLabel.text = [NSString stringWithFormat:@"%ld",likeNumber+1];
        self.model.likeNum +=1;
        self.model.islike = true;
    }
    //    http://192.168.1.55:8080/smarthome/mobileapi/state/LikeStat.do?token=EC9CDB5177C01F016403DFAAEE3C1182&stateId=9
    //    [SVProgressHUD show];// 动画开始
    NSString *likeUrlStr = [NSString stringWithFormat:@"%@/mobileapi/state/LikeStat.do?token=%@&stateId=%@",mPrefixUrl,mDefineToken1,self.model.info_id];
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
- (void)commentClick:(UIButton *)sender{//评论按钮点击事件
//    if (self.isDetailCell) {
//        self.detailCommentBtnBlock(self.model);//详情页面评论
//    }else{
//        self.commentBtnBlock(self.model);//列表页面评论
//    }
}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imagesArr.count;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    // 去缓存池找
    YJImageDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.imagesArr[indexPath.row]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    return cell;
    
}
// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    YJImageDisplayCollectionViewCell *cell = (YJImageDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:self.urlStrs placeholderImage:[UIImage imageNamed:@"icon"] atIndex:indexPath.row dismiss:nil];
    
}

-(NSMutableArray *)urlStrs{
    if (_urlStrs == nil) {
        _urlStrs = [NSMutableArray array];
    }
    return _urlStrs;
}
@end
