//
//  YJBindingEquipmentVC.m
//  YuJia
//
//  Created by 万宇 on 2017/12/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJBindingEquipmentVC.h"
#import "YJSuccessConnectVC.h"

@interface YJBindingEquipmentVC ()
@property(nonatomic,weak)UIImageView *imageV;
@property(nonatomic,weak)UITextField *deviceNameText;
@property(nonatomic,assign)NSInteger iconId;//设备类型序号
@end

@implementation YJBindingEquipmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定设备";
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"empty_nodevice"];
    [imageV sizeToFit];
    self.imageV = imageV;
    
    UILabel *itemLabel = [[UILabel alloc]init];
    itemLabel.text = @"当前设备类型";
    itemLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    itemLabel.font = [UIFont systemFontOfSize:15];
    itemLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UITextField  *deviceNameText = [[UITextField alloc]init];
    deviceNameText.textColor = [UIColor colorWithHexString:@"#333333"];
    deviceNameText.font = [UIFont systemFontOfSize:14];
    deviceNameText.text = @"当前设备类型";
    [deviceNameText setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    deviceNameText.layer.cornerRadius = 2.5;
    deviceNameText.clipsToBounds = YES;
    deviceNameText.layer.borderWidth = 1;
    deviceNameText.layer.borderColor = [UIColor colorWithHexString:@"#e9e9e9"].CGColor;
    self.deviceNameText = deviceNameText;
    
    [self.view addSubview:imageV];
    [self.view addSubview:itemLabel];
    [self.view addSubview:deviceNameText];
    
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(130*kiphone6);
        make.centerX.equalTo(self.view);
    }];
    
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageV.mas_bottom).offset(30*kiphone6);
        make.left.offset(20*kiphone6);
    }];
    
    [deviceNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(itemLabel.mas_bottom).offset(10*kiphone6);
        make.left.offset(20*kiphone6);
        make.right.offset(-20*kiphone6);
        make.height.offset(50*kiphone6);
    }];

    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(10, 16, 190, 44);
    [sureBtn setTitle:@"连接设备" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [sureBtn addTarget:self action:@selector(connectAction) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.cornerRadius = 5;
    sureBtn.clipsToBounds = YES;
    
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deviceNameText.mas_bottom).offset(30*kiphone6);
        make.centerX.offset(0);
        make.size.mas_equalTo(CGSizeMake(190, 44));
    }];
    //根据传过来的扫描二维码信息判断是否是设备信息
    NSString *resultStr = [self.scanStr substringToIndex:73];
    if ([resultStr isEqualToString:@"http://192.168.1.168:8080/smarthome/mobileapi/equipment/adddef.do?iconId="])
    {//是设备信息
        NSString *iconId = [self.scanStr substringFromIndex:73];
        NSInteger equipmentId = [self getDeviceEnumWithIconid:iconId];
        self.iconId = equipmentId;
        //根据对应标签显示对应设备图标
        self.imageV.image = [UIImage imageNamed:mIcon[equipmentId]];
        //根据对应标签显示对应设备名称
        switch (equipmentId) {
            case mDeviceNameUnidentified:{// 未识别的设备
                self.deviceNameText.text = @"未识别的设备";
            }
                break;
            case mDeviceNameMagnetometer:{// 门磁
                self.deviceNameText.text = @"门磁";
            }
                break;
            case mDeviceNameDoorLock:{// 门锁
                self.deviceNameText.text = @"门锁";
            }
                break;
            case mDeviceNameSwitch:{// 开关
                self.deviceNameText.text = @"开关";
            }
                break;
            case mDeviceNameSocket:{// 插座
                self.deviceNameText.text = @"插座";
            }
                break;
            case mDeviceNameLight:{// 灯
                self.deviceNameText.text = @"灯";
            }
                break;
            case mDeviceNameTv:{//电视
                self.deviceNameText.text = @"电视";
            }
                break;
            case mDeviceNameWindowCurtains:{// 窗帘
                self.deviceNameText.text = @"窗帘";
            }
                break;
                
            case mDeviceNameAirConditioner:{// 空调
               self.deviceNameText.text = @"空调";
            }
                break;
            case mDeviceNameHygrothermograph:{// 温湿度计
                self.deviceNameText.text = @"温湿度计";
            }
                break;
            case mDeviceNameScenePanel:{// 情景面板
                self.deviceNameText.text = @"情景面板";
            }
                break;
            case mDeviceNameHumanInfrared:{// 人体红外
                self.deviceNameText.text = @"人体红外";
            }
                break;
            case mDeviceNameGateway:{// 网关
                self.deviceNameText.text = @"网关";
            }
                break;
                
            default:
                break;
        }
        sureBtn.backgroundColor = [UIColor colorWithHexString:@"#0ddcbc"];
        sureBtn.enabled = true;
    }else{//不是设备信息
        self.imageV.image = [UIImage imageNamed:@"empty_nodevice"];
        self.deviceNameText.text = self.scanStr;
        [SVProgressHUD showErrorWithStatus:@"设备二维码不正确"];
        sureBtn.backgroundColor = [UIColor lightGrayColor];
        sureBtn.enabled = false;
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
//把扫描结果赋值传过来
-(void)setScanStr:(NSString *)scanStr{
    _scanStr = scanStr;
    
}
/*连接设备
0=设备已经添加成功！
10001=请重新登录
1=家庭编号不能为空
2=设备类型编号 iconId 不能为空
3=设备类型编号 iconId 无效
4=设备类型编号 iconId 超出有效范围
5=请先添加/连接网关！
6=没有获取到你的外网IP
7=未找到相关设备！*/
- (void)connectAction{
    [[HttpClient defaultClient]requestWithPath:[NSString stringWithFormat:@"%@token=%@&iconId=%ld",mConnectEquipment,mDefineToken,self.iconId] method:0 parameters:nil prepareExecute:^{
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"%@",responseObject);
        switch ([responseObject[@"code"] integerValue]) {
            case 0:
                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
                break;
            case 2:
            case 3:
            case 4:
                [SVProgressHUD showErrorWithStatus:@"未找到相关设备"];
                break;
            case 5:
                [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
                break;
            case 10001:
                [SVProgressHUD showInfoWithStatus:responseObject[@"message"]];
                break;
            default:
                break;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络请求失败,请重试"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
