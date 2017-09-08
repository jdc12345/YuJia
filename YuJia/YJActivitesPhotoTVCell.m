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
#import "YJActiviesPictureModel.h"
#import <UIImageView+WebCache.h>
#import <AFNetworking.h>

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
-(void)setActivitypicturelist:(NSArray *)activitypicturelist{
    _activitypicturelist = activitypicturelist;
    if (activitypicturelist.count==0) {
        return;
    }
    [self.otherImageArr removeAllObjects];
    [self.totleImagesArr removeAllObjects];
    for (int i=0;i < activitypicturelist.count; i++) {
        YJActiviesPictureModel *model = activitypicturelist[i];
        if (![model.picture isEqualToString:@""]) {
            NSArray *array = [model.picture componentsSeparatedByString:@";"];
            NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
            [arr removeLastObject];
            [self.otherImageArr addObjectsFromArray:arr];
     }
}
        [self.totleImagesArr addObjectsFromArray:self.otherImageArr];
        if (self.totleImagesArr.count<4&&self.totleImagesArr.count>0) {
            [self.photoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(130*kiphone6);
            }];
        }else if (self.totleImagesArr.count>3){
            [self.photoCollectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(160*kiphone6);
            }];
        }
        
        [self.photoCollectionView reloadData];
 
}
-(void)setupUI{

    [self.totleImagesArr addObjectsFromArray:self.otherImageArr];

    [self setSelectionStyle:UITableViewCellSelectionStyleNone];//去除cell点击效果
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
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
    photoCollectionView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
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
//    [photoCollectionView registerClass:[YJPhotoDisplayCollectionViewCell class] forCellWithReuseIdentifier:photoCellid];
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
//    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(photoCollectionView.mas_bottom).offset(15*kiphone6);
//        make.width.offset(kScreenW);
//    }];
    
    
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
            if (self.isJoined) {//根据是否参加活动+是否已上传过+已上传的图片数量来判断是否可以上传以及上传数量
                //上传图片(根据isnumber判断上传的数量)
                if (self.isnumber==0) {
                    HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
                    picker.delegate = ws;
                    picker.maxAllowedCount = 2-ws.selfImageArr.count;
                    picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
                    ws.clickAddBlock(picker);
                }else if (self.isnumber==1) {
                    HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
                    picker.delegate = ws;
                    picker.maxAllowedCount = 1-ws.selfImageArr.count;
                    picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
                    ws.clickAddBlock(picker);
                }else if (self.isnumber==2) {
                    [SVProgressHUD showInfoWithStatus:@"你最多可以上传两张图片"];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:@"你还没有参加该活动，不能上传图片"];
            }
//            if (self.selfImageArr.count<2) {
//                HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
//                picker.delegate = ws;
//                picker.maxAllowedCount = 2-ws.selfImageArr.count;
//                picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
//                ws.clickAddBlock(picker);
//            }else{
//                //提示：每个人最多上传两张图片
//            }
            
        };
        return cell;
    }else if (self.totleImagesArr.count<20&&self.totleImagesArr.count>0){
        if (indexPath.row==self.totleImagesArr.count) {
            // 去缓存池找
            YJPhotoAddBtnCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
            cell.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
                if (self.isJoined) {//根据是否参加活动+是否已上传过+已上传的图片数量来判断是否可以上传以及上传数量
                    //上传图片(根据isnumber判断上传的数量)
                    if (self.isnumber==0) {
                        if (self.totleImagesArr.count==19) {//已经19张，用户最多传1张
                            HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
                            picker.delegate = ws;
                            picker.maxAllowedCount = 1-ws.selfImageArr.count;
                            picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
                            ws.clickAddBlock(picker);
                        }else{
                            HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
                            picker.delegate = ws;
                            picker.maxAllowedCount = 2-ws.selfImageArr.count;
                            picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
                            ws.clickAddBlock(picker);
                        }
                        
                    }else if (self.isnumber==1) {
                        HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
                        picker.delegate = ws;
                        picker.maxAllowedCount = 1-ws.selfImageArr.count;
                        picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
                        ws.clickAddBlock(picker);
                    }else if (self.isnumber==2) {
                        [SVProgressHUD showInfoWithStatus:@"你最多可以上传两张图片"];
                    }
                }else{
                    [SVProgressHUD showInfoWithStatus:@"你还没有参加该活动，不能上传图片"];
                }
            };
            return cell;
        }else{
            if (indexPath.row<self.otherImageArr.count) {
                YJImageDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellid forIndexPath:indexPath];
                NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.totleImagesArr[indexPath.row]];
                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
//                cell.photo = self.totleImagesArr[indexPath.row];
                return cell;
            }
            // 去缓存池找
            YJImageDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCellid forIndexPath:indexPath];
//            cell.imageView.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
//                [ws.totleImagesArr removeObjectAtIndex:indexPath.row];
//                if (ws.selfImageArr.count>0) {
//                    [ws.selfImageArr removeObjectAtIndex:(indexPath.row-ws.otherImageArr.count)];
//                }
//                [ws.photoCollectionView reloadData];
//            };
//            cell.photo = self.totleImagesArr[indexPath.row];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.totleImagesArr[indexPath.row]];
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];

            return cell;
        }
    }
    // 去缓存池找
    YJPhotoDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
    
//    cell.imageView.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
//        [ws.totleImagesArr removeObjectAtIndex:indexPath.row];
//        [ws.selfImageArr removeObjectAtIndex:(indexPath.row-ws.otherImageArr.count)];
//        [ws.photoCollectionView reloadData];
//    };
    cell.photo = self.totleImagesArr[indexPath.row];
    return cell;
}

//当选择一张图片后进入这里
- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{
//    NSInteger count=0;
    //    self.imageArr = info[kHUImagePickerThumbnailImage];//缩小图
    NSMutableArray *arr = info[kHUImagePickerOriginalImage];//源图
//http://192.168.1.55:8080/smarthome/mobileapi/activity/AddactivityPictrue.do？
    NSString *postUrlStr = [NSString stringWithFormat:@"%@/mobileapi/activity/AddactivityPictrue.do?&token=%@&activity_id=%ld&number=%ld",mPrefixUrl,mDefineToken1,self.activity_id,arr.count];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager POST:postUrlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //  图片上传
        for (NSInteger i = 0; i < arr.count; i ++) {
            UIImage *images = arr[i];
            NSData *picData = UIImageJPEGRepresentation(images, 0.5);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *fileName = [NSString stringWithFormat:@"%@%ld.png", [formatter stringFromDate:[NSDate date]], (long)i];
            [formData appendPartWithFileData:picData name:[NSString stringWithFormat:@"uploadFile%ld",(long)i] fileName:fileName mimeType:@"image/png"];
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [SVProgressHUD dismiss];
        NSString *message = responseObject[@"message"];
        [message stringByRemovingPercentEncoding];
        NSLog(@"宝宝头像上传== %@,%@", responseObject,message);
        if ([responseObject[@"code"] isEqualToString:@"0"]) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功!"];
            self.isnumber += arr.count;//本地修改已上传图片数，确保当前页面上传两张以后不会再调起图片选择器

        }else if ([responseObject[@"code"] isEqualToString:@"1"]){
            [SVProgressHUD showErrorWithStatus:@"你已经上传过1张照片，现在只能再添加1张"];
        }else if ([responseObject[@"code"] isEqualToString:@"2"]){
            [SVProgressHUD showErrorWithStatus:@"你已经上传过2张照片，不能再上传了"];
        }else if ([responseObject[@"code"] isEqualToString:@"-1"]){
            [SVProgressHUD showErrorWithStatus:@"你还没参加该活动"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"错误信息=====%@", error.description);
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:@"上传失败!"];
    }];

    [self.selfImageArr addObjectsFromArray:arr];
    [self.totleImagesArr addObjectsFromArray:self.selfImageArr];
    [self.photoCollectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row<self.otherImageArr.count) {//别人的图片(网络请求的照片)
        YJImageDisplayCollectionViewCell*cell = (YJImageDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        NSMutableArray *urlStrs = [NSMutableArray array];
        for (int i = 0; i<self.otherImageArr.count; i++) {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.otherImageArr[i]];
            [urlStrs addObject:urlStr];
        }
        [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:urlStrs atIndex:indexPath.row];
    }else{
        if (self.totleImagesArr.count>0) {
            YJPhotoDisplayCollectionViewCell *cell = (YJPhotoDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.totleImagesArr atIndex:indexPath.row];
        }
        
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
