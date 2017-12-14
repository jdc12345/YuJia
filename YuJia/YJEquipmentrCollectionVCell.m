//
//  YJEquipmentrCollectionVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/7/31.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJEquipmentrCollectionVCell.h"
@interface YJEquipmentrCollectionVCell ()

@property (nonatomic, weak) UIImageView* iconView;
@property (nonatomic, weak) UILabel* nameLabel;
@property (nonatomic, weak) UISwitch *switch0;
@end
@implementation YJEquipmentrCollectionVCell
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
-(void)setEquipmentModel:(YJEquipmentModel *)equipmentModel{
    _equipmentModel = equipmentModel;
    // 把数据放在控件上
    //设备类型序号枚举标签
    NSInteger equmentTag = [self getDeviceEnumWithIconid:equipmentModel.iconId];
    NSString *imageName = mIcon[equmentTag];//根据类型序号确定图标
    self.iconView.image = [UIImage imageNamed:imageName];
    self.nameLabel.text = equipmentModel.name;
    if ([equipmentModel.state isEqualToString:@"0"]) {
        [self.switch0 setOn:true];
        self.alpha = 1;
    }else if ([equipmentModel.state isEqualToString:@"1"]){
        [self.switch0 setOn:false];
        self.alpha = 0.7;
    }
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
//    [self setSelected:false];
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
    UISwitch *switch0 = [[UISwitch alloc]init];
    switch0.onTintColor= [UIColor colorWithHexString:@"#0ddcbc"];
    switch0.tintColor = [UIColor colorWithHexString:@"#8e9096"];
    // 控件大小，不能设置frame，只能用缩放比例
    switch0.transform= CGAffineTransformMakeScale(0.8,0.75);
    [self.contentView addSubview:switch0];
    [switch0 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [switch0 setOn:NO];
    [self switchAction:switch0];
    // 自动布局
    [iconView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(15*kiphone6);
        make.width.height.offset(56*kiphone6);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-6*kiphone6);
        make.left.equalTo(iconView.mas_right).offset(15*kiphone6);
    }];
    [switch0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(6*kiphone6);
        make.left.equalTo(iconView.mas_right).offset(15*kiphone6);
    }];
    self.iconView = iconView;
    self.nameLabel = nameLabel;
    self.switch0 = switch0;
}
-(void)setSelected:(BOOL)selected{
    //    [super setSelected:selected];
//    if (selected) {
//        self.alpha = 1;
//    }else{
//        self.alpha = 0.7;
//    }
}
- (void)controlSwitch0{
//    NSLog(@"123123");
//    if (self.switch0.on) {
//        self.equipmentModel.state = @"0";
//    }else{
//        self.equipmentModel.state = @"1";
//    }
    
//    [self httpRequestInfo];
}
-(void)switchAction:(UISwitch*)sener{
    if (sener.isOn) {
//        self.visibleRange = [NSString stringWithFormat:@"%d",2];
        self.alpha = 1;
    }else{
//        self.visibleRange = [NSString stringWithFormat:@"%d",1];
        self.alpha = 0.7;
    }
}
@end
