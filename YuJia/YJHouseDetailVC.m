//
//  YJHouseDetailVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/23.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJHouseDetailVC.h"
#import "SDCycleScrollView.h"
#import "UILabel+Addition.h"
#import "YJHouseConfigurePicModel.h"
#import "NSArray+Addition.h"
#import "YJHouseListModel.h"

@interface YJHouseDetailVC ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray *imagesURLStrings;
@property(nonatomic,weak)UILabel *numberLabel;
@property(nonatomic,strong)YJHouseListModel *houseModel;//房屋数据
@property(nonatomic,weak)UIView *noticeView;
@property(nonatomic,weak)UIView *backView;
@property (nonatomic, assign) long recodeNum;//每天已联系房源的记录次数
@end

@implementation YJHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationController.navigationBar.translucent = false;
    self.title = @"详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
 
}
-(void)setInfo_id:(long)info_id{
    _info_id = info_id;
    //   http://localhost:8080/smarthome/mobileapi/rental/get.do?token=EC9CDB5177C01F016403DFAAEE3C1182&rentalID=1
    [SVProgressHUD show];// 动画开始
    NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/rental/get.do?token=%@&rentalID=%ld",mPrefixUrl,mDefineToken1,info_id];
    
    [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        [SVProgressHUD dismiss];// 动画结束
       
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
             NSDictionary *dic = responseObject[@"result"];
             YJHouseListModel *infoModel = [YJHouseListModel mj_objectWithKeyValues:dic];
            self.houseModel = infoModel;
            NSString *recodNum = responseObject[@"Recordnumber"];
            self.recodeNum = [recodNum integerValue];//赋值今天已联系次数
            [self setupUI];
        }else{
            [SVProgressHUD showErrorWithStatus:@"该城市暂未覆盖"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
        return ;
    }];
}
- (void)setupUI{
    if (![self.houseModel.picture isEqualToString:@""]) {
        
        NSArray *array = [self.houseModel.picture componentsSeparatedByString:@";"];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
        [arr removeLastObject];
        
        for (int i = 0; i<arr.count; i++) {
            NSString *picUrl = [NSString stringWithFormat:@"%@%@",mPrefixUrl,array[i]];
            [self.imagesURLStrings addObject:picUrl];
        }
    }
    // 轮播器
//    NSArray *imagesURLStrings = @[
//                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
//                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
//                                  ];
//    self.imagesURLStrings = imagesURLStrings;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenW, 273*kiphone6) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    [self.view addSubview:cycleScrollView];
    UILabel *numberLabel = [UILabel labelWithText:[NSString stringWithFormat:@"1 / %ld",self.imagesURLStrings.count] andTextColor:[UIColor colorWithHexString:@"#ffffff"] andFontSize:12];
    [cycleScrollView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10*kiphone6);
        make.bottom.offset(-5*kiphone6);
        make.width.offset(30);
        make.height.offset(14);
    }];
    self.numberLabel = numberLabel;
    cycleScrollView.showPageControl = false;
    cycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
    
    UILabel *addressLabel = [UILabel labelWithText:self.houseModel.residentialQuarters?self.houseModel.residentialQuarters:@"涿州名流一品" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:17];
    [self.view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.bottom.equalTo(cycleScrollView.mas_bottom).offset(23*kiphone6);
    }];
    NSString *postTime = [NSString stringWithFormat:@"发布：%@",self.houseModel.createTimeString];
    UILabel *timeLabel = [UILabel labelWithText:postTime andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:12];
    [self.view addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(addressLabel.mas_bottom).offset(12*kiphone6);
    }];
    UIView *line1 = [[UIView alloc]init];//添加line
    line1.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(cycleScrollView.mas_bottom).offset(57*kiphone6);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    UILabel *priceItemLabel = [UILabel labelWithText:@"租金" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:15];
    [self.view addSubview:priceItemLabel];
    [priceItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).offset(kScreenW/3/2);
        make.bottom.equalTo(line1.mas_bottom).offset(29*kiphone6);
    }];
    NSString *price = [NSString stringWithFormat:@"%ld元/月",self.houseModel.rent];
 
    UILabel *priceLabel = [UILabel labelWithText:price andTextColor:[UIColor colorWithHexString:@"#00eac6"] andFontSize:15];
    [self.view addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(priceItemLabel);
        make.top.equalTo(priceItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UIView *vline1 = [[UIView alloc]init];//添加line
    vline1.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.view addSubview:vline1];
    [vline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.height.offset(68*kiphone6);
        make.left.offset(kScreenW/3);
        make.width.offset(1/[UIScreen mainScreen].scale);
    }];
    UILabel *typeItemLabel = [UILabel labelWithText:@"户型" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:15];
    [self.view addSubview:typeItemLabel];
    [typeItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vline1.mas_left).offset(kScreenW/3/2);
        make.bottom.equalTo(line1.mas_bottom).offset(29*kiphone6);
    }];
    UILabel *typeLabel = [UILabel labelWithText:self.houseModel.apartmentLayout andTextColor:[UIColor colorWithHexString:@"#00eac6"] andFontSize:15];
    [self.view addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(typeItemLabel);
        make.top.equalTo(typeItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UIView *vline2 = [[UIView alloc]init];//添加line
    vline2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.view addSubview:vline2];
    [vline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.height.offset(68*kiphone6);
        make.left.equalTo(vline1.mas_right).offset(kScreenW/3);
        make.width.offset(1/[UIScreen mainScreen].scale);
    }];
    UILabel *areaItemLabel = [UILabel labelWithText:@"面积" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:15];
    [self.view addSubview:areaItemLabel];
    [areaItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(vline2.mas_left).offset(kScreenW/3/2);
        make.bottom.equalTo(line1.mas_bottom).offset(29*kiphone6);
    }];
    NSString *area = [NSString stringWithFormat:@"%ld㎡",self.houseModel.housingArea];
    UILabel *areaLabel = [UILabel labelWithText:area andTextColor:[UIColor colorWithHexString:@"#00eac6"] andFontSize:15];
    [self.view addSubview:areaLabel];
    [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(areaItemLabel);
        make.top.equalTo(areaItemLabel.mas_bottom).offset(10*kiphone6);
    }];
    UIView *line2 = [[UIView alloc]init];//添加line
    line2.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(line1.mas_bottom).offset(68*kiphone6);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    UILabel *floorLabel = [UILabel labelWithText:@"楼层：" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:15];
    [self.view addSubview:floorLabel];
    [floorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.centerY.equalTo(line2.mas_bottom).offset(22*kiphone6);
    }];
    NSString *floor = [NSString stringWithFormat:@"%@/%@",self.houseModel.floor,self.houseModel.floord];
    UILabel *curruntFloorLabel = [UILabel labelWithText:floor andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [self.view addSubview:curruntFloorLabel];
    [curruntFloorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(floorLabel.mas_right);
        make.centerY.equalTo(floorLabel);
    }];
    UILabel *directionLabel = [UILabel labelWithText:@"朝向：" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:15];
    [self.view addSubview:directionLabel];
    [directionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(curruntFloorLabel.mas_right).offset(63*kiphone6);
        make.centerY.equalTo(floorLabel);
    }];
    UILabel *curruntDirectionLabel = [UILabel labelWithText:self.houseModel.direction andTextColor:[UIColor colorWithHexString:@"333333"] andFontSize:15];
    [self.view addSubview:curruntDirectionLabel];
    [curruntDirectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(directionLabel.mas_right);
        make.centerY.equalTo(floorLabel);
    }];
    UIView *line3 = [[UIView alloc]init];//添加line
    line3.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.view addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(line2.mas_bottom).offset(44*kiphone6);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    UILabel *configureLabel = [UILabel labelWithText:@"房屋配置：" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:15];
    [self.view addSubview:configureLabel];
    [configureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(line3.mas_bottom).offset(10*kiphone6);
    }];
    [self.view layoutSubviews];
    [configureLabel layoutIfNeeded];
    NSArray *configureArr = [NSArray objectListWithPlistName:@"HouseConfigureList.plist" clsName:@"YJHouseConfigurePicModel"];
    int columnCount=4;
    //每个格子的宽度和高度
    CGFloat appW=63.0;
    CGFloat appH=17.0;
    //计算间隙
    CGFloat appMargin=(kScreenW-20-columnCount*appW)/(columnCount+1);

    for (int i=0; i<10; i++) {
        YJHouseConfigurePicModel *model = configureArr[i];
        UIButton *btn = [[UIButton alloc]init];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:model.icon_n] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:model.icon_sed] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        //计算列号和行号
        int colX=i%columnCount;
        int rowY=i/columnCount;
        //计算坐标
        CGFloat appX=10*kiphone6+colX*(appW+appMargin);
        CGFloat appY= CGRectGetMaxY(configureLabel.frame)+13*kiphone6+rowY*(appH+15*kiphone6);
        
        btn.frame=CGRectMake(appX, appY, appW, appH);
        
        [self.view addSubview:btn];
        if (![self.houseModel.houseAllocation isEqualToString:@""]) {
            NSArray *array = [self.houseModel.houseAllocation componentsSeparatedByString:@"；"];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
//            [arr removeLastObject];
            for (NSString *str in arr) {//当条件匹配时候改变按钮的选中状态
                if ([str isEqualToString:model.name]) {
                    btn.selected = !btn.isSelected;
                }
            }
        }
        //添加button的点击事件
//        btn.tag = [model.id intValue];
//        [btn addTarget:self action:@selector(medicinalClick:) forControlEvents:UIControlEventTouchUpInside];
//        if (i==nameArray.count-1) {
//            self.allBtn = btn;
//        }
    }
    UIView *line4 = [[UIView alloc]init];//添加line
    line4.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [self.view addSubview:line4];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(line3.mas_bottom).offset(117*kiphone6);
        make.height.offset(1/[UIScreen mainScreen].scale);
    }];
    UIButton *btn = [[UIButton alloc]init];
    btn.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
    [btn setTitle:@"预约看房" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.masksToBounds = true;
    btn.layer.cornerRadius = 3;
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(45*kiphone6);
    }];
    [btn addTarget:self action:@selector(bookingRoom) forControlEvents:UIControlEventTouchUpInside];

}
-(void)bookingRoom{
        //大蒙布View
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        backView.alpha = 0.3;
        [self.view addSubview:backView];
        self.backView = backView;
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        backView.userInteractionEnabled = YES;
        //添加tap手势：
        //    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(event:)];
        //将手势添加至需要相应的view中
        //    [backView addGestureRecognizer:tapGesture];
        
        //提示框
        UIView *noticeView = [[UIView alloc]init];
        noticeView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:noticeView];
        self.noticeView = noticeView;
        [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backView);
            make.width.offset(300*kiphone6);
            make.height.offset(178*kiphone6);
        }];
        //contentLabel
        UILabel *contentLabel = [[UILabel alloc]init];
    contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        //提示内容
     NSString *str = @"";
    if (self.recodeNum<6) {
        str = [NSString stringWithFormat:@"您今日还有%ld次房源机会，联系房东将扣除1次，确认联系房东",6-self.recodeNum];
        NSMutableAttributedString *strF = [[NSMutableAttributedString alloc] initWithString:str];
        //颜色 设置
        [strF addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#00eac6"] range:NSMakeRange(5, 1)];
        contentLabel.attributedText = strF;
        
    }else{
        str = @"您今日6次房源机会已经用完，请明天再联系房东";
        contentLabel.text =str;
    }
        contentLabel.numberOfLines = 2;
        contentLabel.font = [UIFont systemFontOfSize:17];
        [noticeView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(18*kiphone6);
            make.top.offset(35*kiphone6);
            make.right.offset(-18*kiphone6);
        }];
        //confirmButton
        UIButton *contactButton = [[UIButton alloc]init];
    contactButton.tag = 31;
        [contactButton setTitle:@"马上联系" forState:UIControlStateNormal];
        [contactButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        contactButton.titleLabel.font = [UIFont systemFontOfSize:17];
    if (self.recodeNum<6) {
        contactButton.backgroundColor = [UIColor colorWithHexString:@"#00eac6"];
    }else{
        contactButton.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }
    
        [noticeView addSubview:contactButton];
        [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-18*kiphone6);
            make.top.equalTo(contentLabel.mas_bottom).offset(26*kiphone6);
            make.height.offset(45*kiphone6);
            make.width.offset(120*kiphone6);
        }];
        //添加关闭提示框按钮的点击事件
        [contactButton addTarget:self action:@selector(closeNoticeView:) forControlEvents:UIControlEventTouchUpInside];
    //confirmButton
    UIButton *closeButton = [[UIButton alloc]init];
    closeButton.tag = 32;
    [closeButton setTitle:@"再考虑下" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:17];
    closeButton.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [noticeView addSubview:closeButton];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(18*kiphone6);
        make.top.equalTo(contentLabel.mas_bottom).offset(26*kiphone6);
        make.height.offset(45*kiphone6);
        make.width.offset(120*kiphone6);
    }];
    //添加关闭提示框按钮的点击事件
    [closeButton addTarget:self action:@selector(closeNoticeView:) forControlEvents:UIControlEventTouchUpInside];
    
    }

-(void)closeNoticeView:(UIButton*)sender{
    if (sender.tag==31) {//联系一次记录加一次
        
        NSString *str=[[NSMutableString alloc] initWithFormat:@"tel:%ld",self.houseModel.telephone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        http://localhost:8080/smarthome//mobileapi/contactrecord/addContactrecord.do?token=EC9CDB5177C01F016403DFAAEE3C1182&RentalId=1
//        [SVProgressHUD show];// 动画开始
        NSString *bussinessUrlStr = [NSString stringWithFormat:@"%@/mobileapi/contactrecord/addContactrecord.do?token=%@&RentalId=%ld",mPrefixUrl,mDefineToken1,self.info_id];
        [[HttpClient defaultClient]requestWithPath:bussinessUrlStr method:0 parameters:nil prepareExecute:^{
        } success:^(NSURLSessionDataTask *task, id responseObject) {
//            [SVProgressHUD dismiss];// 动画结束
            
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                self.recodeNum+=1;
//                if (self.recodeNum==6) {
//                    sender.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
//                }
            }else{
                
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            return ;
        }];
    }
        for (UIView *view in self.noticeView.subviews) {//移除阴影
            [view removeFromSuperview];
        }
        [self.noticeView removeFromSuperview];
        [self.backView removeFromSuperview];
    }

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.numberLabel.text = [NSString stringWithFormat:@"%ld / %ld",index+1,self.imagesURLStrings.count];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSMutableArray *)imagesURLStrings{
    if (_imagesURLStrings==nil) {
        _imagesURLStrings = [NSMutableArray array];
    }
    return _imagesURLStrings;
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
