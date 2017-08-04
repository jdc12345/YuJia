//
//  YJRoomSetUpVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/1.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJRoomSetUpVC.h"
#import "UIBarButtonItem+Helper.h"
#import "UIViewController+Cloudox.h"
#import "YJHomeSceneFlowLayout.h"
#import "YJHomeSceneCollectionViewCell.h"
#import "YJEquipmentListModel.h"

static NSString* collectionCellid = @"collection_cell";
static NSString *headerViewIdentifier =@"hederview";
@interface YJRoomSetUpVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic, weak) UITextField *roomNameTF;//房间名称
@property(nonatomic,weak)UICollectionView *equipmentColView;//情景collectionView
@property (nonatomic, strong) NSMutableArray* addedEquipmentListData;//添加过设备的房间设备列表，也是数据源
@end

@implementation YJRoomSetUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房间设置";
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" normalColor:[UIColor colorWithHexString:@"#333333"] highlightedColor:[UIColor colorWithHexString:@"#00bfff"] target:self action:@selector(action:)];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)setEquipmentListData:(NSArray *)equipmentListData{
    _equipmentListData = equipmentListData;
    YJEquipmentListModel *model = [[YJEquipmentListModel alloc]init];//添加按钮的model
    model.name = @"添加";
    model.icon = @"add_home";
    self.addedEquipmentListData = [NSMutableArray arrayWithArray:equipmentListData];
    [self.addedEquipmentListData addObject:model];
    [self setUPUI];
}
- (void)setUPUI{
    [self imageBg];//添加背景图
    UIView *backGrayView = [[UIView alloc]init];//添加模糊视图
    backGrayView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    backGrayView.alpha = 0.5;
    [self.view addSubview:backGrayView];
    [backGrayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
        make.top.offset(130*kiphone6);
    }];
    backGrayView.userInteractionEnabled = YES;
    //添加设备列表
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJHomeSceneFlowLayout alloc]init]];
    collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(headerView.mas_bottom);
        make.top.offset(64);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.equipmentColView = collectionView;
    // 注册单元格
    [collectionView registerClass:[YJHomeSceneCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
    //注册头视图
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];

    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.showsVerticalScrollIndicator = false;

}
- (void)action:(NSString *)actionStr{
    NSLog(@"点什么点");
}
- (UIView *)personInfomation{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 130*kiphone6)];
    headView.backgroundColor = [UIColor whiteColor];
    
    NSString *sightName = @"房 间 名 称";
    NSString *startW = @"添 加 照 片";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGRect rect = [sightName boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:attributes
                                          context:nil];
    UITextField  *sightNameText = [[UITextField alloc]init];
    sightNameText.textColor = [UIColor colorWithHexString:@"#333333"];
    sightNameText.font = [UIFont systemFontOfSize:14];
    sightNameText.text = self.roomName;
    sightNameText.layer.cornerRadius = 2.5;
    sightNameText.clipsToBounds = YES;
    sightNameText.layer.borderWidth = 1;
    sightNameText.layer.borderColor = [UIColor colorWithHexString:@"#f1f1f1"].CGColor;
    self.roomNameTF = sightNameText;
    
    UIButton *selectPictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPictureBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectPictureBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [selectPictureBtn setBackgroundColor:[UIColor colorWithHexString:@"#00eac6"]];
    [selectPictureBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    selectPictureBtn.layer.masksToBounds = YES;
    selectPictureBtn.layer.cornerRadius = 3;
    
    CGRect frame = CGRectMake(0, 0, 10.0, 30*kiphone6);
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    sightNameText.leftViewMode = UITextFieldViewModeAlways;
    sightNameText.leftView = leftview;
    
    UILabel *sightNameLabel = [[UILabel alloc]init];
    sightNameLabel.text = sightName;
    sightNameLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    sightNameLabel.font = [UIFont systemFontOfSize:14];
    
    UILabel *startWLabel = [[UILabel alloc]init];
    startWLabel.text = startW;
    startWLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    startWLabel.font = [UIFont systemFontOfSize:14];
    
    [headView addSubview:sightNameText];
    [headView addSubview:selectPictureBtn];
    [headView addSubview:sightNameLabel];
    [headView addSubview:startWLabel];
    
//    WS(ws);
    [sightNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).with.offset(25*kiphone6);
        make.left.equalTo(headView).with.offset(35*kiphone6 +rect.size.width*kiphone6);
        make.size.mas_equalTo(CGSizeMake(254*kiphone6 ,30*kiphone6));
    }];
    [selectPictureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sightNameText.mas_bottom).with.offset(20*kiphone6);
        make.left.equalTo(headView).with.offset(35*kiphone6 +rect.size.width*kiphone6);
        make.size.mas_equalTo(CGSizeMake(100*kiphone6 ,40*kiphone6));
    }];
    
    [sightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sightNameText.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(20*kiphone6);
        make.size.mas_equalTo(CGSizeMake((rect.size.width +5)*kiphone6,14*kiphone6));
    }];
    [startWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(selectPictureBtn.mas_centerY).with.offset(0);
        make.left.equalTo(headView).with.offset(20*kiphone6);
        make.size.mas_equalTo(CGSizeMake((rect.size.width +5)*kiphone6,14*kiphone6));
    }];
    
    return headView;
}
- (void)imageBg//把控制器背景设为图片
{
    UIImage *oldImage = [UIImage imageNamed:@"home_back"];
    
    UIGraphicsBeginImageContextWithOptions((CGSizeMake(self.view.frame.size.width, kScreenH)), NO, 0.0);
    [oldImage drawInRect:CGRectMake(0, 64, self.view.frame.size.width, kScreenH-64)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.addedEquipmentListData.count;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    // 去缓存池找
    YJHomeSceneCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
    cell.equipmentListModels = self.addedEquipmentListData[indexPath.row];
//    cell.selected = false;
    return cell;
}

// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
  
    
}
//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        } // 防止复用分区头
        //添加头视图的内容
        UIView *headerView = [self personInfomation];
        [header addSubview:headerView];

        UIButton *addBtn = [[UIButton alloc]init];
        NSString *btnTitle = @"所 属 设 备";
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect rect = [btnTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, 14)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil];
        [addBtn setTitle:btnTitle forState:UIControlStateNormal];
        [addBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        addBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [header addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(16*kiphone6);
//            make.top.equalTo(headerView.mas_bottom).offset(10*kiphone6);
            make.centerY.equalTo(headerView.mas_bottom).offset(25*kiphone6);
            make.size.mas_equalTo(CGSizeMake((rect.size.width +5)*kiphone6,14*kiphone6));
        }];
//        [addBtn addTarget:self action:@selector(roomBtnClick) forControlEvents:UIControlEventTouchUpInside];//设备添加按钮的点击事件
//        self.roomBtn = roomBtn;
        return header;
    }
    //如果底部视图
    //    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
    //
    //    }
    return nil;
}
//设置宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(kScreenW,180*kiphone6);
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navBarBgAlpha = @"1.0";    
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
