//
//  YJLikeActivitiesTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJLikeActivitiesTVCell.h"
#import "UILabel+Addition.h"
#import "YJFriendLikeFlowLayout.h"
#import "YJFriendLikeCollectionViewCell.h"
#import <HUPhotoBrowser.h>

static NSString* photoCellid = @"photo_cell";
@interface YJLikeActivitiesTVCell()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) UIImageView* heartView;
@property (nonatomic, weak) UICollectionView* likeCollectionView;


@end
@implementation YJLikeActivitiesTVCell

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
//----------根据评论内容计算tableView的高度，从新布局tableView的高度-------------------
//-(void)setModel:(YYPropertyItemModel *)model{
//    _model = model;
//    self.itemLabel.text = model.item;
//    [self.btn setTitle:model.event forState:UIControlStateNormal];
//}
-(void)setImage:(NSString *)image{
    _image = image;
    [self.heartView setImage:[UIImage imageNamed:image]];
}
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
    UIImageView *heaterView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blue-like"]];
//    heaterView.frame = CGRectMake(27*kiphone6, 5*kiphone6, 11*kiphone6, 11*kiphone6);
    [backView addSubview:heaterView];
    [heaterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(8*kiphone6);
        make.left.offset(26*kiphone6);
    }];
    self.heartView = heaterView;
        //photoCollectionView
    UICollectionView *likeCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJFriendLikeFlowLayout alloc]init]];
//        likeCollectionView.frame = CGRectMake(46*kiphone6, 0, 300*kiphone6, 45*kiphone6);
    [backView addSubview:likeCollectionView];
    [likeCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(heaterView.mas_right).offset(5*kiphone6);
        make.top.bottom.offset(0);
        make.right.offset(-10*kiphone6);
    }];
        self.likeCollectionView = likeCollectionView;
        likeCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        likeCollectionView.dataSource = self;
        likeCollectionView.delegate = self;
        // 注册单元格
        [likeCollectionView registerClass:[YJFriendLikeCollectionViewCell class] forCellWithReuseIdentifier:photoCellid];
        likeCollectionView.showsHorizontalScrollIndicator = false;
        likeCollectionView.showsVerticalScrollIndicator = false;
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];



}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    // 去缓存池找
    YJFriendLikeCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
    
    cell.photo = [UIImage imageNamed:@"icon"];
    return cell;
    
}
// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    YJFriendLikeCollectionViewCell *cell = (YJFriendLikeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UIImage *image = [UIImage imageNamed:@"icon"];
    NSArray *imageArr = @[image,image,image,image,image];
    [HUPhotoBrowser showFromImageView:cell.imageView withImages:imageArr atIndex:indexPath.row];
    
}

@end
