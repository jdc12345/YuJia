//
//  YJRepairRecordTableViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/4.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJRepairRecordTableViewCell.h"
#import "UILabel+Addition.h"
#import "UIColor+colorValues.h"
#import <Masonry.h>
#import "YJImageDisplayCollectionViewCell.h"
#import "YJRepairRecordFlowLayout.h"
#import <HUPhotoBrowser.h>
#import <UIImageView+WebCache.h>

static NSString* collectionCellid = @"collection_cell";
static NSString* photoCellid = @"photo_cell";
@interface YJRepairRecordTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>
@property (nonatomic, weak) UILabel* typeLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@property (nonatomic, weak) UILabel* stateLabel;
@property (nonatomic, weak) UILabel* contentLabel;
@property(nonatomic,weak)UICollectionView *collectionView;
@property (nonatomic, weak) UIButton *finishBtn;
@property (nonatomic, weak) UIButton *cancelBtn;
@property(nonatomic,strong)NSArray *imagesArr;
@property(nonatomic,strong)NSMutableArray *urlStrs;
@end
@implementation YJRepairRecordTableViewCell

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
-(void)setModel:(YJReportRepairRecordModel *)model{
    _model = model;
    if (model.repairType == 1) {
        self.typeLabel.text = @"水电燃气";
    }else if (model.repairType == 2) {
        self.typeLabel.text = @"房屋报修";
    }else if (model.repairType == 3) {
        self.typeLabel.text = @"公共设施报修";
    }
    self.timeLabel.text =[NSString stringWithFormat:@"期望处理时间:%@",model.processingTimeString];
    if (model.state == 1) {
        self.stateLabel.text = @"待维修";
    }else if (model.state == 2) {
        self.stateLabel.text = @"处理中";
    }else if (model.state == 3) {
        self.stateLabel.text = @"已完成";
    }
    self.contentLabel.text = model.details;
    if (model.state == 1) {
        self.finishBtn.hidden = false;
        self.cancelBtn.hidden = false;
    }else if (model.state == 2) {
        self.finishBtn.hidden = false;
        self.cancelBtn.hidden = true;
    }else if (model.state == 3) {
        self.finishBtn.hidden = true;
        self.cancelBtn.hidden = true;
    }
    if (![model.picture isEqualToString:@""]) {
        NSArray *array = [model.picture componentsSeparatedByString:@";"];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
        [arr removeLastObject];
        self.imagesArr = arr;
        if (self.imagesArr.count<5) {
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(70*kiphone6);
            }];
        }else{
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(140*kiphone6);
            }];
        }
    }else{
        self.imagesArr = [NSArray array];
    }
    [self.collectionView reloadData];
}

-(void)setupUI{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    UIView *spaceView = [[UIView alloc]init];//添加分割view
    spaceView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.contentView addSubview:spaceView];
    UIImageView *typeView = [[UIImageView alloc]init];//类型图片
    typeView.image = [UIImage imageNamed:@"house_repair"];
    [self.contentView addSubview:typeView];
    UILabel *typeLabel = [UILabel labelWithText:@"水电维修" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];//维修类型
    [self.contentView addSubview:typeLabel];
    UILabel *timeLabel = [UILabel labelWithText:@"期望处理时间:2017-5-2" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:12];//维修时间
    [self.contentView addSubview:timeLabel];
    UILabel *stateLabel = [UILabel labelWithText:@"维修中" andTextColor:[UIColor colorWithHexString:@"#00eac6"] andFontSize:12];//维修状态
    [self.contentView addSubview:stateLabel];
    UIView *line1 = [[UIView alloc]init];//添加line1
    line1.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line1];
    UILabel *contentLabel = [UILabel labelWithText:@"期望处理时间:2017-5-2期望处理时间:2017-5-2期望处理时间:2017-5-2期望处理时间:2017-5-2" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:12];//报修内容
    contentLabel.numberOfLines = 0;
    [self.contentView addSubview:contentLabel];
    
    //photoCollectionView
    UICollectionView *photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJRepairRecordFlowLayout alloc]init]];
    [self.contentView addSubview:photoCollectionView];
    self.collectionView = photoCollectionView;
    photoCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    // 注册单元格
    [photoCollectionView registerClass:[YJImageDisplayCollectionViewCell class] forCellWithReuseIdentifier:photoCellid];
    photoCollectionView.showsHorizontalScrollIndicator = false;
    photoCollectionView.showsVerticalScrollIndicator = false;
    
    UIView *line2 = [[UIView alloc]init];//添加line2
    line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.contentView addSubview:line2];
    

    UIButton *finishBtn = [[UIButton alloc]init];//完成维修按钮
//    finishBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [finishBtn setTitle:@"完成维修" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    finishBtn.layer.masksToBounds = true;
    finishBtn.layer.cornerRadius = 3;
    finishBtn.layer.borderColor = [UIColor colorWithHexString:@"#01c0ff"].CGColor;
    finishBtn.layer.borderWidth = 1;
    [self.contentView addSubview:finishBtn];
    UIButton *cancelBtn = [[UIButton alloc]init];//取消维修按钮
    cancelBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [cancelBtn setTitle:@"取消维修" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.layer.masksToBounds = true;
    cancelBtn.layer.cornerRadius = 3;
    cancelBtn.layer.borderWidth = 1;
    cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"#01c0ff"].CGColor;
    [self.contentView addSubview:cancelBtn];
    //约束
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(5*kiphone6);
    }];
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(spaceView.mas_bottom).offset(17.5*kiphone6);
    }];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeView.mas_right).offset(5*kiphone6);
        make.centerY.equalTo(typeView);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(typeLabel.mas_right).offset(5*kiphone6);
        make.centerY.equalTo(typeView);
    }];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.centerY.equalTo(typeView);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1*kiphone6);
        make.top.offset(40*kiphone6);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(line1.mas_bottom).offset(9*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    [photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentLabel.mas_bottom);
        make.left.offset(0);
        make.bottom.offset(-45*kiphone6);
        make.width.offset(290*kiphone6);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.height.offset(1*kiphone6);
        make.top.equalTo(photoCollectionView.mas_bottom);
    }];
    [finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_bottom).offset(-22.5*kiphone6);
        make.width.offset(70*kiphone6);
        make.height.offset(25*kiphone6);
        make.right.offset(-10*kiphone6);
    }];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_bottom).offset(-22.5*kiphone6);
        make.width.offset(70*kiphone6);
        make.height.offset(25*kiphone6);
        make.right.equalTo(finishBtn.mas_left).offset(-10*kiphone6);
    }];
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(line2.mas_bottom).offset(45*kiphone6);
//        make.width.offset(kScreenW);
//    }];
    self.typeLabel = typeLabel;
    self.timeLabel = timeLabel;
    self.stateLabel = stateLabel;
    self.contentLabel = contentLabel;
    self.collectionView = photoCollectionView;
    self.finishBtn = finishBtn;
    self.cancelBtn = cancelBtn;
    cancelBtn.tag = 31;
    finishBtn.tag = 32;
    [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)btnClick:(UIButton *)sender{
    NSString *state ;
    if (sender.tag == 31) {
        state = @"4";
    }else if (sender.tag == 32){
        state = @"3";
    }
    if (self.clickBtnBlock) {
        self.clickBtnBlock(state);
    }
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
    [self.urlStrs addObject:urlStr];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    return cell;

}
// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    YJImageDisplayCollectionViewCell *cell = (YJImageDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:self.urlStrs placeholderImage:[UIImage imageNamed:@"icon"] atIndex:indexPath.row dismiss:nil];
//    [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.imagesArr atIndex:indexPath.row];
    
}
-(NSMutableArray *)urlStrs{
    if (_urlStrs == nil) {
        _urlStrs = [NSMutableArray array];
    }
    return _urlStrs;
}
@end
