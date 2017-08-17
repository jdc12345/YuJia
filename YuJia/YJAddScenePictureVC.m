//
//  YJAddScenePictureVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/14.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJAddScenePictureVC.h"
#import "YJScenePicCollectionVCell.h"
#import "UIBarButtonItem+Helper.h"
#import "YJAddScenePicFlowLayout.h"

static NSString* collectionCellid = @"collection_cell";
@interface YJAddScenePictureVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,weak)UICollectionView *collectionView;
@property (nonatomic, strong) NSArray* picNameList;//图片列表
@property (nonatomic, strong) NSArray* items;//初始化事项列表
@property (nonatomic, strong) NSArray* itemsData;//事项列表
@property(nonatomic,strong)NSArray *personalExpresss;//未收取快递


@end

@implementation YJAddScenePictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" normalColor:[UIColor colorWithHexString:@"#0ddcbc"] highlightedColor:[UIColor colorWithHexString:@"#0ddcbc"] target:self action:@selector(changeInfo)];
    self.picNameList = @[@"getup",@"rest",@"leave",@"gohome",@"playgame",@"time_scene",@"rain_scene",@"eatting_scene",@"music_scene",@"fire_scene",@"sunning_scene"];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) collectionViewLayout:[[YJAddScenePicFlowLayout alloc]init]];
    collectionView.backgroundColor = [UIColor colorWithHexString:@"#ececec"];
    [self.view addSubview:collectionView];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    // 注册单元格
    [collectionView registerClass:[YJScenePicCollectionVCell class] forCellWithReuseIdentifier:collectionCellid];
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.showsVerticalScrollIndicator = false;
    self.collectionView = collectionView;
    
}

#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.picNameList.count;
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    // 去缓存池找
    YJScenePicCollectionVCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
    cell.picName = self.picNameList[indexPath.row];
    return cell;
}

// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    self.curruntPicNum = indexPath.row;//约定序号对应图片
}
-(void)changeInfo{
    self.clickBtnBlock(self.curruntPicNum);//把改变的图标序号传回去
    [self.navigationController popViewControllerAnimated:true];
}
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    if (self.curruntPicNum||self.curruntPicNum==0) {
//        [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForRow:self.curruntPicNum inSection:0]];
//       YJScenePicCollectionVCell *cell = (YJScenePicCollectionVCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.curruntPicNum inSection:0]];
//        cell.selected = true;
//    }
//}
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
