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


@interface YJHouseDetailVC ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong)NSArray *imagesURLStrings;
@property(nonatomic,weak)UILabel *numberLabel;
@end

@implementation YJHouseDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = false;
    self.title = @"详情";
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self setupUI];
    
}
- (void)setupUI{
    // 轮播器
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    self.imagesURLStrings = imagesURLStrings;
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
    
    UILabel *addressLabel = [UILabel labelWithText:@"涿州名流一品" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:17];
    [self.view addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.bottom.equalTo(cycleScrollView.mas_bottom).offset(23*kiphone6);
    }];
    UILabel *timeLabel = [UILabel labelWithText:@"发布： 1天前" andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:12];
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
    UILabel *priceLabel = [UILabel labelWithText:@"1000元/月" andTextColor:[UIColor colorWithHexString:@"#00bfff"] andFontSize:15];
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
    UILabel *typeLabel = [UILabel labelWithText:@"1室1厅1卫" andTextColor:[UIColor colorWithHexString:@"#00bfff"] andFontSize:15];
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
    UILabel *areaLabel = [UILabel labelWithText:@"40.0㎡" andTextColor:[UIColor colorWithHexString:@"#00bfff"] andFontSize:15];
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
    UILabel *curruntFloorLabel = [UILabel labelWithText:@"3层/共6层" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
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
    UILabel *curruntDirectionLabel = [UILabel labelWithText:@"南北" andTextColor:[UIColor colorWithHexString:@"333333"] andFontSize:15];
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
    btn.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
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
//        self.backView = backView;
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
//        self.noticeView = noticeView;
        [noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backView);
            make.width.offset(300*kiphone6);
            make.height.offset(178*kiphone6);
        }];
        //contentLabel
        UILabel *contentLabel = [[UILabel alloc]init];
        //提示内容
    NSInteger i = 6;
    NSString *str = [NSString stringWithFormat:@"您今日还有%ld次房源机会，联系房东将扣除1次，确认联系房东",i];
    NSMutableAttributedString *strF = [[NSMutableAttributedString alloc] initWithString:str];
    //颜色 设置
    [strF addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#00bfff"] range:NSMakeRange(5, 1)];
    contentLabel.attributedText = strF;
        contentLabel.numberOfLines = 2;
        contentLabel.font = [UIFont systemFontOfSize:17];
        contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [noticeView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(18*kiphone6);
            make.top.offset(35*kiphone6);
            make.right.offset(-18*kiphone6);
        }];
        //confirmButton
        UIButton *confirmButton = [[UIButton alloc]init];
        [confirmButton setTitle:@"马上联系" forState:UIControlStateNormal];
        [confirmButton setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        confirmButton.titleLabel.font = [UIFont systemFontOfSize:17];
        confirmButton.backgroundColor = [UIColor colorWithHexString:@"#00bfff"];
        [noticeView addSubview:confirmButton];
        [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-18*kiphone6);
            make.top.equalTo(contentLabel.mas_bottom).offset(26*kiphone6);
            make.height.offset(45*kiphone6);
            make.width.offset(120*kiphone6);
        }];
        //添加关闭提示框按钮的点击事件
        [confirmButton addTarget:self action:@selector(closeNoticeView:) forControlEvents:UIControlEventTouchUpInside];
    //confirmButton
    UIButton *closeButton = [[UIButton alloc]init];
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
    [confirmButton addTarget:self action:@selector(closeNoticeView:) forControlEvents:UIControlEventTouchUpInside];
    
    }
-(void)closeNoticeView:(UIButton*)sender{
    
//        for (UIView *view in self.noticeView.subviews) {
//            [view removeFromSuperview];
//        }
//        [self.noticeView removeFromSuperview];
//        [self.backView removeFromSuperview];
    }

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    self.numberLabel.text = [NSString stringWithFormat:@"%ld / %ld",index+1,self.imagesURLStrings.count];
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
