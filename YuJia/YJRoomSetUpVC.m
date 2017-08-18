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
#import "YJEquipmentrCollectionVCell.h"
#import "YJEquipmentModel.h"
#import "YJAddEquipmentToCurruntSceneOrRoomVC.h"
#import "YJAddRoomBackgroundImageVC.h"
#import <SDWebImageManager.h>
#import <AFNetworking.h>

static NSString* collectionCellid = @"collection_cell";
static NSString *headerViewIdentifier =@"hederview";
static NSString* eqCellid = @"eq_cell";
@interface YJRoomSetUpVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate>
@property(nonatomic, weak) UITextField *roomNameTF;//房间名称
@property(nonatomic,weak)UICollectionView *equipmentColView;//情景collectionView
@property (nonatomic, strong) NSMutableArray* addedEquipmentListData;//添加过设备的房间设备列表，也是数据源
@property(nonatomic, strong) UIImage *selectImage;//选中背景图片
@end

@implementation YJRoomSetUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房间设置";
//    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" normalColor:[UIColor colorWithHexString:@"#333333"] highlightedColor:[UIColor colorWithHexString:@"#00bfff"] target:self action:@selector(changeInfo:)];
    self.view.backgroundColor = [UIColor whiteColor];
    
}
-(void)changeInfo:(UIButton*)sender{
//    保存或更新房间信息接口
//    添加或修改房间信息接口
//http://192.168.1.55:8080/smarthome/mobileapi/room/save.do?token=9DB2FD6FDD2F116CD47CE6C48B3047EE
//Method:POST
//    参数列表:
//    |参数名          |类型      |必需  |描述
//    |-----          |----     |---- |----
//    |token          |String   |Y    |令牌
//    |id             |Long     |Y    |编号
//    |roomName       |String   |Y    |房间名称
//    |pictures       |String   |N    |房间图片
//    |oid            |Integer  |N    |序号
//    |familyId       |Long     |Y    |家的编号--外键--家庭表
//    返回值：
//    |参数名          |类型      |描述
//    |code           |String   |响应代码
//    |result         |String   |响应说明
//    |Room           |Object   |房间实体类
    sender.enabled = false;
    NSMutableArray *equipmentList = [[NSMutableArray alloc]initWithCapacity:2];
    [self.addedEquipmentListData removeLastObject];
    // NSMutableArray --> NSArray
    self.roomModel.equipmentList = [self.addedEquipmentListData copy];
    for (YJEquipmentModel *equipment in self.roomModel.equipmentList) {
        [equipmentList addObject: [equipment properties_aps]];
    }
    NSLog(@"%@",equipmentList);
    NSData *dictData = [NSJSONSerialization dataWithJSONObject:equipmentList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:dictData encoding:NSUTF8StringEncoding];//设备列表
    if (self.roomNameTF.text.length >0) {
        self.roomModel.roomName = self.roomNameTF.text;
    }

    if (!self.roomModel.roomName) {
        [SVProgressHUD showErrorWithStatus:@"请填写房间名字"];
        sender.enabled = true;
        return;
    }
    NSData *picData;
    if (!self.roomModel.pictures) {//用户自定义图片或者没有选择图片
        if (self.selectImage) {
            picData = UIImageJPEGRepresentation(self.selectImage, 0.5);
        }else{
            [SVProgressHUD showErrorWithStatus:@"请选择房间背景图片"];
            sender.enabled = true;
            return;
        }
    }
    NSString *postUrlStr;
    if (self.roomModel.info_id&&self.roomModel.oid&&self.roomModel.oid) {//添加房间
        postUrlStr = [NSString stringWithFormat:@"%@&token=%@&id=%@&equipmentList=%@&roomName=%@&oid=%@&familyId=%@&pictures=%@",mRoomSave,mDefineToken2,self.roomModel.info_id,jsonString,self.roomModel.roomName,self.roomModel.oid,self.roomModel.familyId,self.roomModel.pictures];
    }else{//修改房间
        postUrlStr = [NSString stringWithFormat:@"%@&token=%@&equipmentList=%@&roomName=%@&pictures=%@",mRoomSave,mDefineToken2,jsonString,self.roomModel.roomName,self.roomModel.pictures];
    }
    postUrlStr = [postUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    [SVProgressHUD show];
        [manager POST:postUrlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (picData) {
                //  图片上传
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *fileName = [NSString stringWithFormat:@"room%@.png", [formatter stringFromDate:[NSDate date]]];
                [formData appendPartWithFileData:picData name:@"uploadFile" fileName:fileName mimeType:@"image/png"];
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                    [SVProgressHUD dismiss];
            NSString *message = responseObject[@"message"];
            [message stringByRemovingPercentEncoding];
            NSLog(@"房间图片上传== %@,%@", responseObject,message);
            if ([responseObject[@"code"] isEqualToString:@"0"]) {
                [SVProgressHUD showSuccessWithStatus:@"修改成功!"];
                [self.navigationController popViewControllerAnimated:true];//修改添加房间成功后返回上级页面
                sender.enabled = true;
            }else{
                [SVProgressHUD showErrorWithStatus:message];
                sender.enabled = true;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"错误信息=====%@", error.description);
                    [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"请求失败!"];
            sender.enabled = true;
            YJEquipmentModel *model = [[YJEquipmentModel alloc]init];//添加按钮的model
            model.name = @"添加";
            model.iconId = @"0";
            [self.addedEquipmentListData addObject:model];//失败了需要停留在这个页面，所以需要在最后保留添加按钮
        }];
//    }
//    else{
//        [[HttpClient defaultClient]requestWithPath:postUrlStr method:0 parameters:nil prepareExecute:^{
//            
//        } success:^(NSURLSessionDataTask *task, id responseObject) {
//            NSString *message = responseObject[@"message"];
//            [message stringByRemovingPercentEncoding];
//            NSLog(@"%@,%@", responseObject,message);
//            if ([responseObject[@"code"] isEqualToString:@"0"]) {
//                [SVProgressHUD showSuccessWithStatus:@"修改成功!"];
//                [self.navigationController popViewControllerAnimated:true];//修改添加房间成功后返回上级页面
//                sender.enabled = true;
//            }else{
//                [SVProgressHUD showErrorWithStatus:message];
//                sender.enabled = true;
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            NSLog(@"错误信息=====%@", error.description);
//            //        [SVProgressHUD dismiss];
//            [SVProgressHUD showErrorWithStatus:@"请求失败!"];
//            sender.enabled = true;
//            YJEquipmentModel *model = [[YJEquipmentModel alloc]init];//添加按钮的model
//            model.name = @"添加";
//            model.iconId = @"0";
//            [self.addedEquipmentListData addObject:model];//失败了需要停留在这个页面，所以需要在最后保留添加按钮
//        }];
//
//    }
    
}
//传过来的房间实体类
-(void)setRoomModel:(YJRoomDetailModel *)roomModel{
    _roomModel = roomModel;
    YJEquipmentModel *model = [[YJEquipmentModel alloc]init];//添加按钮的model
    model.name = @"添加";
    model.iconId = @"0";
    self.addedEquipmentListData = [NSMutableArray arrayWithArray:roomModel.equipmentList];
    [self.addedEquipmentListData addObject:model];
    [self setUPUI];
}

- (void)setUPUI{
    if (self.roomModel.pictures.length>0) {//把控制器背景设为当前房间背景图片
        if ([self.roomModel.pictures isEqualToString:@"1"]) {
            [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
        }else if ([self.roomModel.pictures isEqualToString:@"2"]){
            [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[1]]];
        }else{
            NSString *imageUrl = [NSString stringWithFormat:@"%@%@",mPrefixUrl,self.roomModel.pictures];
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                NSLog(@"当前进度%ld",receivedSize/expectedSize);
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                NSLog(@"下载完成");
                if (image) {
                    [self setBackGroundColorWithImage:image];
                }else{
                    [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
                }
            }];
        }
    }else{
        [self setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
    }
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
        make.top.offset(0);
        make.left.right.offset(0);
        make.bottom.offset(0);
    }];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    self.equipmentColView = collectionView;
    // 注册单元格
    [collectionView registerClass:[YJEquipmentrCollectionVCell class] forCellWithReuseIdentifier:eqCellid];
    [collectionView registerClass:[YJHomeSceneCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];[collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    collectionView.showsHorizontalScrollIndicator = false;
    collectionView.showsVerticalScrollIndicator = false;
    //长按手势添加到self.collectionView上面
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressDelete:)];
    [collectionView addGestureRecognizer:longPress];
    [self.view addSubview:collectionView];

}
//长按删除设备
- (void)lonePressDelete:(UILongPressGestureRecognizer *)longPress
{
    //获取目标cell
    NSIndexPath *selectIndexPath = [self.equipmentColView indexPathForItemAtPoint:[longPress locationInView:self.equipmentColView]];
    YJEquipmentrCollectionVCell *cell = (YJEquipmentrCollectionVCell *)[self.equipmentColView cellForItemAtIndexPath:selectIndexPath];
    if(longPress.state==UIGestureRecognizerStateBegan){
        //删除操作
        if(self.addedEquipmentListData.count>1){//已添加了设备
            NSIndexPath *index =[self.equipmentColView indexPathForCell:cell];
            if (index.row!=self.addedEquipmentListData.count-1) {//不能是最后一个添加设备的按钮
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除该设备" message:@"你确定要删除该设备?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [self.addedEquipmentListData removeObjectAtIndex:index.row];
                    NSArray* deletearr=@[index];
                    [self.equipmentColView deleteItemsAtIndexPaths:deletearr];
                }];
                [alert addAction:cancelAction];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}
//产生collectionview头部试图
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
    sightNameText.text = self.roomModel.roomName;
    sightNameText.layer.cornerRadius = 2.5;
    sightNameText.clipsToBounds = YES;
    sightNameText.delegate = self;
    sightNameText.layer.borderWidth = 1;
    sightNameText.layer.borderColor = [UIColor colorWithHexString:@"#f1f1f1"].CGColor;
    self.roomNameTF = sightNameText;
    
    UIButton *selectPictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPictureBtn setTitle:@"选择" forState:UIControlStateNormal];
    [selectPictureBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [selectPictureBtn setBackgroundColor:[UIColor colorWithHexString:@"#00eac6"]];
    [selectPictureBtn addTarget:self action:@selector(selectBackgroundImage) forControlEvents:UIControlEventTouchUpInside];
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
        make.size.mas_equalTo(CGSizeMake(100*kiphone6 ,30*kiphone6));
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
//确保刷新collectionview后已经设置的房间名字还在
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.roomModel.roomName = textField.text;
}

//把控制器背景设为图片
- (void)setBackGroundColorWithImage:(UIImage *)image
{
    UIImage *oldImage = image;
    
    UIGraphicsBeginImageContextWithOptions((CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)), NO, 0.0);
    [oldImage drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:newImage];
}
//选择背景图片
-(void)selectBackgroundImage{
    YJAddRoomBackgroundImageVC *addImageVC = [[YJAddRoomBackgroundImageVC alloc]init];
    addImageVC.itemClick = ^(UIImage *selectImage,NSInteger defaultImageNum) {
        WS(ws);
        if (defaultImageNum==1) {
            [ws setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[0]]];
            ws.roomModel.pictures=@"1";
        }else if (defaultImageNum==2){
            [ws setBackGroundColorWithImage:[UIImage imageNamed:roomBackImages[1]]];
            ws.roomModel.pictures=@"2";
        }else{
            [ws setBackGroundColorWithImage:selectImage];//把block回传的图片设置为房间背景
            ws.roomModel.pictures=NULL;//NULL代表要传的是图片数据
            ws.selectImage = selectImage;//要上传的背景照片
        }
    };
    [self.navigationController pushViewController:addImageVC animated:true];
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
    cell.equipmentModel = self.addedEquipmentListData[indexPath.row];
    //    cell.selected = false;
    return cell;
}

// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    WS(ws);
    if (indexPath.row==self.addedEquipmentListData.count-1) {//添加设备按钮点击事件
        YJAddEquipmentToCurruntSceneOrRoomVC *sVC = [[YJAddEquipmentToCurruntSceneOrRoomVC alloc]init];
        sVC.equipmentList = self.addedEquipmentListData;//把已有设备传过去
        sVC.itemClick = ^(YJEquipmentModel *index) {//选择了要添加的设备回传到房间设置页面
            if (ws.addedEquipmentListData.count>0) {
                [ws.addedEquipmentListData insertObject:index atIndex:self.addedEquipmentListData.count-1];
            }else{
                [ws.addedEquipmentListData insertObject:index atIndex:0];
            }
            [ws.equipmentColView reloadData];
            self.roomNameTF.text = self.roomModel.roomName;
        };
        [self.navigationController pushViewController:sVC animated:true];
    }
    
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
    self.navigationController.navigationBar.translucent = false;
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
