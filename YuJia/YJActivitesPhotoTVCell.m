//
//  YJActivitesPhotoTVCell.m
//  YuJia
//
//  Created by 万宇 on 2017/5/12.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJActivitesPhotoTVCell.h"
#import "UILabel+Addition.h"
#import "YJFriendLikeFlowLayout.h"
#import "YJFriendLikeCollectionViewCell.h"
#import <HUPhotoBrowser.h>
#import "YJPhotoAddBtnCollectionViewCell.h"
#import "YJPhotoDisplayCollectionViewCell.h"
#import "YJActivitesPhotoFlowLayout.h"
#import "YJImageDisplayCollectionViewCell.h"
static NSString* collectionCellid = @"collection_cell";
static NSString* photoCellid = @"photo_cell";
static NSString* imageCellid = @"image_cell";
@interface YJActivitesPhotoTVCell()<UICollectionViewDelegate,UICollectionViewDataSource,HUImagePickerViewControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak) UILabel* activitesLabel;
@property (nonatomic, weak) UICollectionView* photoCollectionView;
@property (nonatomic, strong) NSMutableArray *otherImageArr;//请求回来的数据
@property (nonatomic, strong) NSMutableArray *selfImageArr;//自己要上传的照片
@property (nonatomic, strong) NSMutableArray *totleImagesArr;//所有照片(collectionView的数据源)
@end
@implementation YJActivitesPhotoTVCell

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
//-(void)setImage:(NSString *)image{
//    _image = image;
//    [self.heartView setImage:[UIImage imageNamed:image]];
//}
-(void)setupUI{

    UIImage *image = [UIImage imageNamed:@"icon"];
    [self.otherImageArr addObject:image];
    [self.otherImageArr addObject:image];
    [self.totleImagesArr addObjectsFromArray:self.otherImageArr];
//-------------------------------需要传值-------------------------------
    
    
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
    UILabel *activitesLabel = [UILabel labelWithText:@"活动照片" andTextColor:[UIColor colorWithHexString:@"#666666"] andFontSize:14];//活动状态
    [backView addSubview:activitesLabel];
    [activitesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.offset(10*kiphone6);
    }];

    //photoCollectionView
    UICollectionView *photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJActivitesPhotoFlowLayout alloc]init]];
    photoCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [backView addSubview:photoCollectionView];
    [photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10*kiphone6);
        make.top.equalTo(activitesLabel.mas_bottom).offset(15*kiphone6);
        make.right.offset(-10*kiphone6);
        make.height.offset(130*kiphone6);
    }];
    self.photoCollectionView = photoCollectionView;
    photoCollectionView.dataSource = self;
    photoCollectionView.delegate = self;
    // 注册单元格
    [photoCollectionView registerClass:[YJPhotoAddBtnCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
    [photoCollectionView registerClass:[YJPhotoDisplayCollectionViewCell class] forCellWithReuseIdentifier:photoCellid];
    [photoCollectionView registerClass:[YJImageDisplayCollectionViewCell class] forCellWithReuseIdentifier:imageCellid];
    photoCollectionView.showsHorizontalScrollIndicator = false;
    photoCollectionView.showsVerticalScrollIndicator = false;
    UIView *line = [[UIView alloc]init];//添加line
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.offset(0);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(photoCollectionView.mas_bottom).offset(15*kiphone6);
        make.width.offset(kScreenW);
    }];
    
    
}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.totleImagesArr.count<20&&self.totleImagesArr.count>0) {
        return self.totleImagesArr.count+1;
    }else if(self.totleImagesArr.count==20){
        return self.totleImagesArr.count;
    }else{
        return 1;
    }
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    WS(ws);
    if (self.totleImagesArr.count==0) {
        // 去缓存池找
        YJPhotoAddBtnCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
        cell.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
//            if (<#condition#>) {根据是否参加活动+是否已上传过+已上传的图片数量来判断是否可以上传以及上传数量
//                <#statements#>别人上传的图片不能删除
//            }
            if (self.selfImageArr.count<2) {
                HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
                picker.delegate = ws;
                picker.maxAllowedCount = 2-ws.selfImageArr.count;
                picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
                ws.clickAddBlock(picker);
            }else{
                //提示：每个人最多上传两张图片
            }
            
        };
        return cell;
    }else if (self.totleImagesArr.count<20&&self.totleImagesArr.count>0){
        if (indexPath.row==self.totleImagesArr.count) {
            // 去缓存池找
            YJPhotoAddBtnCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
            cell.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
                if (self.selfImageArr.count<2) {
                    HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
                    picker.delegate = ws;
                    picker.maxAllowedCount = 2-ws.selfImageArr.count;
                    picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
                    ws.clickAddBlock(picker);
                    
                }else{
                    //提示：每个人最多上传两张图片
                }
            };
            return cell;
        }else{
            if (indexPath.row<self.otherImageArr.count) {
                YJImageDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellid forIndexPath:indexPath];
                cell.photo = self.totleImagesArr[indexPath.row];
                return cell;
            }
            // 去缓存池找
            YJPhotoDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
            cell.imageView.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
                [ws.totleImagesArr removeObjectAtIndex:indexPath.row];
                if (ws.selfImageArr.count>0) {
                    [ws.selfImageArr removeObjectAtIndex:(indexPath.row-ws.otherImageArr.count)];
                }
                [ws.photoCollectionView reloadData];
            };
            cell.photo = self.totleImagesArr[indexPath.row];
            return cell;
        }
    }
    // 去缓存池找
    YJPhotoDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
    
    cell.imageView.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
        [ws.totleImagesArr removeObjectAtIndex:indexPath.row];
        [ws.selfImageArr removeObjectAtIndex:(indexPath.row-ws.otherImageArr.count)];
        [ws.photoCollectionView reloadData];
    };
    cell.photo = self.totleImagesArr[indexPath.row];
    return cell;
}

//当选择一张图片后进入这里
- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{
    NSInteger count=0;
    //    self.imageArr = info[kHUImagePickerThumbnailImage];//缩小图
    NSMutableArray *arr = info[kHUImagePickerOriginalImage];//源图
    for (int i = 0; i<arr.count; i++) {
        [self.selfImageArr addObject:arr[i]];
        count+=1;//可确定这次选了几张图片
    }
    if (count==1&&self.selfImageArr.count==2){
        [self.totleImagesArr addObject:self.selfImageArr.lastObject];
    }else{
        [self.totleImagesArr addObjectsFromArray:self.selfImageArr];
    }
    [self.photoCollectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row<self.otherImageArr.count) {
        YJImageDisplayCollectionViewCell*cell = (YJImageDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.totleImagesArr atIndex:indexPath.row];
    }else{
        YJPhotoDisplayCollectionViewCell *cell = (YJPhotoDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.totleImagesArr atIndex:indexPath.row];
    }
 
}

-(NSMutableArray *)otherImageArr{
    if (_otherImageArr == nil) {
        _otherImageArr = [[NSMutableArray alloc]init];
    }
    return _otherImageArr;
}
-(NSMutableArray *)selfImageArr{
    if (_selfImageArr == nil) {
        _selfImageArr = [[NSMutableArray alloc]init];
    }
    return _selfImageArr;
}
-(NSMutableArray *)totleImagesArr{
    if (_totleImagesArr == nil) {
        _totleImagesArr = [[NSMutableArray alloc]init];
    }
    return _totleImagesArr;
 
}
@end
