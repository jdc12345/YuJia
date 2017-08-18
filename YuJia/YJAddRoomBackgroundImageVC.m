//
//  YJAddRoomBackgroundImageVC.m
//  YuJia
//
//  Created by 万宇 on 2017/8/16.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJAddRoomBackgroundImageVC.h"
#import "UILabel+Addition.h"
#import <Photos/Photos.h>
@interface YJAddRoomBackgroundImageVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,assign)NSInteger picNum;//相机胶卷图片数量
@property(nonatomic,weak)UIButton *albumBtn;//相机胶卷选择按钮
@property(nonatomic,weak)UIImageView *imageView;//选中图片以后显示的view
@property(nonatomic,weak)UIImage *image;//选中图片
@end

@implementation YJAddRoomBackgroundImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"房间照片";
    self.navigationController.navigationBar.translucent = false;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        // 这里便是无访问权限
        //可以弹出个提示框，叫用户去设置打开相册权限
        [SVProgressHUD showErrorWithStatus:@"请设置打开相册的权限"];
    }  else {
        //这里就是用权限,获取相册信息
        [self getAlbumImage];
    }
    
    [self setupUI];
}
- (void)setupUI{
    //默认图片
    UILabel *defaultImageLabel = [UILabel labelWithText:@"默认图片" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    [self.view addSubview:defaultImageLabel];
    [defaultImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.offset(25*kiphone6);
    }];
    UIButton *oneImageBtn = [[UIButton alloc]init];
    oneImageBtn.tag = 11;
    [oneImageBtn setImage:[UIImage imageNamed:roomBackImages[0]] forState:UIControlStateNormal];
    [self.view addSubview:oneImageBtn];
    [oneImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(defaultImageLabel.mas_bottom).offset(15*kiphone6);
        make.width.offset(112.5*kiphone6);
        make.height.offset(200*kiphone6);
    }];
    UIButton *twoImageBtn = [[UIButton alloc]init];
    twoImageBtn.tag = 12;
    [twoImageBtn setImage:[UIImage imageNamed:roomBackImages[1]] forState:UIControlStateNormal];
    [self.view addSubview:twoImageBtn];
    [twoImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(oneImageBtn.mas_right).offset(10*kiphone6);
        make.top.equalTo(defaultImageLabel.mas_bottom).offset(15*kiphone6);
        make.width.offset(112.5*kiphone6);
        make.height.offset(200*kiphone6);
    }];
    [oneImageBtn addTarget:self action:@selector(selectDefaultImage:) forControlEvents:UIControlEventTouchUpInside];
    [twoImageBtn addTarget:self action:@selector(selectDefaultImage:) forControlEvents:UIControlEventTouchUpInside];
    //拍摄照片
    UILabel *shotPhotoLabel = [UILabel labelWithText:@"拍摄照片" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    [self.view addSubview:shotPhotoLabel];
    [shotPhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(oneImageBtn.mas_bottom).offset(25*kiphone6);
    }];
    UIView *shotView = [[UIView alloc]init];
    shotView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shotView];
    [shotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(shotPhotoLabel.mas_bottom).offset(15*kiphone6);
        make.height.offset(75*kiphone6);
    }];
    UIButton *cameraBtn = [[UIButton alloc]init];
    [cameraBtn setImage:[UIImage imageNamed:@"roomPic_camera"] forState:UIControlStateNormal];
    [shotView addSubview:cameraBtn];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.centerY.equalTo(shotView);
        make.width.height.offset(60*kiphone6);
    }];
    [cameraBtn addTarget:self action:@selector(addCamera) forControlEvents:UIControlEventTouchUpInside];
    UILabel *shotLabel = [UILabel labelWithText:@"拍摄" andTextColor:[UIColor colorWithHexString:@"#0ddcbc"] andFontSize:18];
    [shotView addSubview:shotLabel];
    [shotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cameraBtn.mas_right).offset(20*kiphone6);
        make.centerY.equalTo(shotView);
    }];
    //从相册选取
    UILabel *fromAlbumLabel = [UILabel labelWithText:@"从相册选取" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:14];
    [self.view addSubview:fromAlbumLabel];
    [fromAlbumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.top.equalTo(shotView.mas_bottom).offset(25*kiphone6);
    }];
    UIView *albumView = [[UIView alloc]init];
    albumView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:albumView];
    [albumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(fromAlbumLabel.mas_bottom).offset(15*kiphone6);
        make.height.offset(75*kiphone6);
    }];
    UIButton *albumBtn = [[UIButton alloc]init];
//    [albumBtn setImage:self.image forState:UIControlStateNormal];
    [albumView addSubview:albumBtn];
    [albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20*kiphone6);
        make.centerY.equalTo(albumView);
        make.width.height.offset(60*kiphone6);
    }];
    self.albumBtn = albumBtn;
    [albumBtn addTarget:self action:@selector(addAlbum) forControlEvents:UIControlEventTouchUpInside];
    UILabel *albumLabel = [UILabel labelWithText:@"相机胶卷" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:18];
    [albumView addSubview:albumLabel];
    [albumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(albumBtn.mas_right).offset(20*kiphone6);
        make.bottom.equalTo(albumView.mas_centerY).offset(-5*kiphone6);
    }];
    UILabel *numLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%ld",self.picNum] andTextColor:[UIColor colorWithHexString:@"#999999"] andFontSize:12];
    [albumView addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(albumBtn.mas_right).offset(20*kiphone6);
        make.top.equalTo(albumView.mas_centerY).offset(5*kiphone6);
    }];
    UIImageView *moreView = [[UIImageView alloc]init];
    moreView.image = [UIImage imageNamed:@"roomPic_more"];
    [albumView addSubview:moreView];
    [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20*kiphone6);
        make.centerY.equalTo(albumView);
    }];
}
//选择本地存储的房间图片
-(void)selectDefaultImage:(UIButton*)sender{
    if (sender.tag==11) {
       self.itemClick(sender.imageView.image,1);//1代表选择了第一张默认图片
    }else if (sender.tag==12){
       self.itemClick(sender.imageView.image,2);//2代表选择了第二张默认图片
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 相册操作
//访问相册，取得相机胶卷的数量和首张图片
-(void)getAlbumImage{
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    //获取相机胶卷所有图片
    PHFetchResult *assets = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    
    //设置显示模式
    /*
     PHImageRequestOptionsResizeModeNone    //选了这个就不会管传如的size了 ，要自己控制图片的大小，建议还是选Fast
     PHImageRequestOptionsResizeModeFast    //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
     PHImageRequestOptionsResizeModeExact    //精确的加载与传入size相匹配的图像
     */
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.synchronous = NO;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    typeof(self)weakSelf = self;
    self.picNum = assets.count;
    if (assets.count>0) {
    PHAsset *asset = assets[0];
//    for (PHAsset *asset in assets) {//获取所有照片
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(screenSize.width*scale, screenSize.height*scale) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            //我这里用个模型接储存了图片的 localIdentifier 和图片本身
            //还有很多信息，根据自己的需求来取
//            CellModel * model = [CellModel new];
//            model.localIdentifier = asset.localIdentifier;
            UIImage *image = [UIImage imageWithData:UIImageJPEGRepresentation(result, 0.5)];
//
//            [weakSelf.cellImageArray addObject:model];
//            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.albumBtn setImage:image forState:UIControlStateNormal];
            });
            
        }];
    
    }
}
//触发事件：拍照
- (void)addCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //可编辑
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //摄像头
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum:相机胶卷
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        picker.showsCameraControls = NO;//自定义相机界面
//        UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
//        view.backgroundColor = [UIColor clearColor];
//        UIButton *albumBtn = [[UIButton alloc]init];
//        [albumBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [view addSubview:albumBtn];
//        [albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.offset(20*kiphone6);
//            make.bottom.offset(-20*kiphone6);
//            make.width.height.offset(60*kiphone6);
//        }];
//        self.albumBtn = albumBtn;
//        [albumBtn addTarget:self action:@selector(imagePickerControllerDidCancel:) forControlEvents:UIControlEventTouchUpInside];
//        picker.cameraOverlayView = view;
    } else { //否则打开照片库
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)addAlbum
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //可编辑
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
  
}
#pragma mark - UIImagePickerControllerDelegate

//拍摄完成后要执行的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//    BOOL success;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([mediaType isEqualToString:@"public.image"]) {
        //得到照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {//新拍摄图片才需要存储
                //图片存入相册
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
            }
        }
        //选中图片以后的设置页面
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        self.imageView = imageView;
        [[UIApplication sharedApplication].keyWindow addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.offset(0);
        }];
        imageView.image = image;
        UIButton *cancleBtn = [[UIButton alloc]init];
        cancleBtn.backgroundColor = [UIColor darkGrayColor];
        cancleBtn.alpha = 0.7;
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setTitleColor:[UIColor colorWithHexString:@"#acacac"] forState:UIControlStateNormal];
        cancleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [imageView addSubview:cancleBtn];
        [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.offset(0);
            make.height.offset(55*kiphone6);
            make.width.offset(kScreenW*0.5-1);
        }];
        [cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
        [imageView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cancleBtn.mas_right);
            make.bottom.offset(0);
            make.width.offset(1);
            make.height.offset(55*kiphone6);
        }];
        UIButton *setBtn = [[UIButton alloc]init];
        setBtn.backgroundColor = [UIColor darkGrayColor];
        setBtn.alpha = 0.7;
        [setBtn setTitle:@"设置" forState:UIControlStateNormal];
        [setBtn setTitleColor:[UIColor colorWithHexString:@"#0ddcbc"] forState:UIControlStateNormal];
        setBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [imageView addSubview:setBtn];
        [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.offset(0);
            make.height.offset(55*kiphone6);
            make.width.offset(kScreenW*0.5-1);
        }];
        [setBtn addTarget:self action:@selector(setBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.image = image;//给要设定的照片赋值
       
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//取消设置图片
-(void)cancleBtnClick{
    [self.imageView removeFromSuperview];
}
//确定设置图片
-(void)setBtnClick{
    [self.imageView removeFromSuperview];
    self.itemClick(self.image,0);//0代表选择了相册和拍照的图片
    [self.navigationController popViewControllerAnimated:YES];
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
