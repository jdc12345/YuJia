//
//  YJHomeSceneCollectionViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/7/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHomeSceneCollectionViewCell.h"

@interface YJHomeSceneCollectionViewCell ()

@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;

@end
@implementation YJHomeSceneCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUI];
}

- (void)setSceneDetailModel:(YJSceneDetailModel*)sceneDetailModel
{
    _sceneDetailModel = sceneDetailModel;
    // 把数据放在控件上
    NSString *imageName;
    switch ([sceneDetailModel.sceneIcon integerValue]) {
        case 0:
            imageName = @"getup";
            break;
        case 1:
            imageName = @"rest";
            break;
        case 2:
            imageName = @"leave";
            break;
        case 3:
            imageName = @"gohome";
            break;
        case 4:
            imageName = @"playgame";
            break;
        case 5:
            imageName = @"time_scene";
            break;
        case 6:
            imageName = @"rain_scene";
            break;
        case 7:
            imageName = @"eatting_scene";
            break;
        case 8:
            imageName = @"music_scene";
            break;
        case 9:
            imageName = @"fire_scene";
            break;
        case 10:
            imageName = @"sunning_scene";
            break;
        default:
            break;
    }
    self.iconView.image = [UIImage imageNamed:imageName];
    self.nameLabel.text = sceneDetailModel.sceneName;
    if ([sceneDetailModel.sceneState isEqualToString:@"0"]) {
        self.selected = true;
    }else if ([sceneDetailModel.sceneState isEqualToString:@"1"]){
        self.selected = false;
    }
}
-(void)setEquipmentModel:(YJEquipmentModel *)equipmentModel{
    _equipmentModel = equipmentModel;
    // 把数据放在控件上
    NSString *imageName;
    switch ([equipmentModel.iconId integerValue]) {
        case 0:
            imageName = @"add_home";
            break;
        case 1:
            imageName = @"socket";
            break;
        case 2:
            imageName = @"light";
            break;
        case 3:
            imageName = @"tv";
            break;
        case 4:
            imageName = @"curtain";
            break;
        case 5:
            imageName = @"aircondition";
            break;
        case 6:
            imageName = @"lock";
            break;
        default:
            break;
    }
    self.iconView.image = [UIImage imageNamed:imageName];
    self.nameLabel.text = equipmentModel.name;
}
- (void)setupUI
{
    [self setSelected:false];
    // 设置整个cell的背景颜色
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 7.5;
    self.layer.masksToBounds = true;
    // 创建子控件
    UIImageView* iconView = [[UIImageView alloc] init];
    iconView.image = [UIImage imageNamed:@"housekeeping"];
    [self.contentView addSubview:iconView];
    //    CALayer *layer = [iconView layer];
    //    layer.shadowOffset = CGSizeMake(0, 3);
    //    layer.shadowRadius = 5.0;
    //    layer.shadowColor = [UIColor blackColor].CGColor;
    //    layer.shadowOpacity = 0.8;
    
    UILabel* nameLabel = [[UILabel alloc] init];
    nameLabel.font = [UIFont systemFontOfSize:17];
    nameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    nameLabel.text = @"家政服务";
    [self.contentView addSubview:nameLabel];
    
    // 自动布局
    [iconView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(15*kiphone6);
        make.width.height.offset(56*kiphone6);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(iconView.mas_right).offset(15*kiphone6);
    }];
    
    self.iconView = iconView;
    self.nameLabel = nameLabel;
}
-(void)setSelected:(BOOL)selected{
//    [super setSelected:selected];
    if (selected) {
        self.alpha = 1;
    }else{
        self.alpha = 0.7;
    }
}
@end
