//
//  YJHomeSceneCollectionViewCell.m
//  YuJia
//
//  Created by 万宇 on 2017/7/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHomeSceneCollectionViewCell.h"

@interface YJHomeSceneCollectionViewCell ()

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
//    NSString *imageName;
    //设备类型序号枚举标签
    NSInteger equmentTag = [self getDeviceEnumWithIconid:equipmentModel.iconId];
//    homeTableViewCell.iconV.image = [UIImage imageNamed:mIcon[equmentTag]];//根据类型序号确定图标
//    switch ([equipmentModel.iconId integerValue]) {
//        case 0:
//            imageName = @"add_home";
//            break;
//        case 1:
//            imageName = @"socket";
//            break;
//        case 2:
//            imageName = @"light";
//            break;
//        case 3:
//            imageName = @"tv";
//            break;
//        case 4:
//            imageName = @"curtain";
//            break;
//        case 5:
//            imageName = @"aircondition";
//            break;
//        case 6:
//            imageName = @"lock";
//            break;
//        default:
//            break;
//    }
    self.iconView.image = [UIImage imageNamed:mIcon[equmentTag]];//根据类型序号确定图标
    self.nameLabel.text = equipmentModel.name;
}
//public static int[]mIconId={0,1,2,3,4,5,6,7,8,9,10,11,12};
//public static String[]mDeviceName={"未识别的设备","门磁","门锁","开关","插座","灯","电视","窗帘","空调","温湿度计","情景面板","人体红外","网关"};
//根据设备iconid(类型序号)取对应图片
-(NSInteger)getDeviceEnumWithIconid:(NSString*)iconId{
    
    switch ([iconId integerValue]) {
        case 0:
            return mDeviceNameUnidentified;// 未识别的设备
        case 1:
            return mDeviceNameMagnetometer;// 门磁
        case 2:
            return mDeviceNameDoorLock;// 门锁
        case 3:
            return mDeviceNameSwitch;// 开关
        case 4:
            return mDeviceNameSocket;// 插座
        case 5:
            return mDeviceNameLight;// 灯
        case 6:
            return mDeviceNameTv;// 电视
        case 7:
            return mDeviceNameWindowCurtains;// 窗帘
        case 8:
            return mDeviceNameAirConditioner;// 空调
            
        case 9:
            return mDeviceNameHygrothermograph;// 温湿度计
            
        case 10:
            return mDeviceNameScenePanel;// 情景面板
            
        case 11:
            return mDeviceNameHumanInfrared;// 人体红外
            
        case 12:
            return mDeviceNameGateway;// 网关
            
            
        default:
            return mDeviceNameUnidentified;// 未识别的设备
    }
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
