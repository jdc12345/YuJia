//
//  YJPostFriendStateVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/9.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJPostFriendStateVC.h"
#import "YJHeaderTitleBtn.h"
#import "BRPlaceholderTextView.h"
#import "YJPhotoFlowLayout.h"
#import "YJPhotoAddBtnCollectionViewCell.h"
#import <HUImagePickerViewController.h>
#import "YJPhotoDisplayCollectionViewCell.h"
#import <HUPhotoBrowser.h>
#import "UIColor+colorValues.h"
#import "UILabel+Addition.h"

static NSString* collectionCellid = @"collection_cell";
static NSString* photoCellid = @"photo_cell";
@interface YJPostFriendStateVC ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,HUImagePickerViewControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UIButton *typeBtn;
@property(nonatomic,weak)BRPlaceholderTextView *contentView;
@property(nonatomic, strong)NSString *content;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)UIView *backView;
@property(nonatomic,weak)UIView *selectView;
@end

@implementation YJPostFriendStateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"友邻圈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    //添加右侧发送按钮
    UIButton *postBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    [postBtn setTitle:@"发送" forState:UIControlStateNormal];
    [postBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    postBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    postBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    postBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    [postBtn addTarget:self action:@selector(informationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:postBtn];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    //添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate =self;
    tableView.dataSource = self;

    
}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    YJHeaderTitleBtn *btn = [[YJHeaderTitleBtn alloc]initWithFrame:frame and:title];
    btn.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self.backView addSubview:btn];
    btn.tag = tag;
    self.typeBtn = btn;
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setImage:[UIImage imageNamed:@"selected_open"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    if (self.selectView) {
        if (self.selectView.hidden==false) {
            self.selectView.hidden=true;
        }else{
            self.selectView.hidden=false;
        }
        
    }else{
        UIView *selectView = [[UIView alloc]init];
        selectView.backgroundColor = [UIColor whiteColor];
        selectView.layer.borderColor = [UIColor colorWithHexString:@"#cccaca"].CGColor;
        selectView.layer.borderWidth =1*kiphone6/[UIScreen mainScreen].scale;
        [self.backView addSubview:selectView];
        [selectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(sender);
            make.top.equalTo(sender.mas_bottom);
            make.height.offset(168*kiphone6);
        }];
        self.selectView =selectView;
        NSArray *itemArr = @[@"健康",@"居家",@"母婴",@"旅游",@"美食",@"宠物"];
        for (int i=0; i<itemArr.count; i++) {
            UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, i*28*kiphone6, 130*kiphone6, 28*kiphone6)];
            btn.tag = 51+i;
            [btn setTitle:itemArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [selectView addSubview:btn];
            [btn addTarget:self action:@selector(updateType:) forControlEvents:UIControlEventTouchUpInside];
        }
    }    
}
-(void)updateType:(UIButton*)sender{
    [self.typeBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    [sender setBackgroundColor:[UIColor colorWithHexString:@"#cccaca"]];
    self.selectView.hidden = true;
    
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return 0;//根据请求回来的数据定

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//        YJRepairRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
    
        return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5*kiphone6)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.backView = backView;
    [self setBtnWithFrame:CGRectMake(0, 0, 130*kiphone6, 35*kiphone6) WithTitle:@"选择分类"andTag:101];
            //输入框
            BRPlaceholderTextView *titleView = [[BRPlaceholderTextView alloc]init];
            [backView addSubview:titleView];
            self.contentView = titleView;
            [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset(10*kiphone6);
                make.bottom.equalTo(backView.mas_top).offset(145*kiphone6);
                make.right.offset(-10*kiphone6);
                make.height.offset(100*kiphone6);
            }];
            [titleView layoutIfNeeded];
            titleView.delegate = self;
            //        self.titleView = titleView;
            titleView.placeholder = @"内容...";
            //        titleView.imagePlaceholder = @"title";
            titleView.font=[UIFont boldSystemFontOfSize:13];
            [titleView setBackgroundColor:[UIColor whiteColor]];
            [titleView setPlaceholderFont:[UIFont systemFontOfSize:13]];
            [titleView setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
            //    titleField.borderStyle = UITextBorderStyleNone;
            //    //边框宽度
            //    [titleField.layer setBorderWidth:0.01f];
            [titleView setPlaceholderOpacity:0.6];
            [titleView addMaxTextLengthWithMaxLength:500 andEvent:^(BRPlaceholderTextView *text) {
                //            [self.titleView endEditing:YES];
                
                NSLog(@"----------");
            }];
            
            [titleView addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
                NSLog(@"begin");
            }];
            
            [titleView addTextViewEndEvent:^(BRPlaceholderTextView *text) {
                self.content = self.contentView.text;
                NSLog(@"end");
            }];
            
            //photoCollectionView
            UICollectionView *photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJPhotoFlowLayout alloc]init]];
            [backView addSubview:photoCollectionView];
            self.collectionView = photoCollectionView;
            photoCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
            [photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleView.mas_bottom);
                make.left.offset(0);
                make.bottom.offset(-38*kiphone6);
                make.width.offset(216*kiphone6);
            }];
            photoCollectionView.dataSource = self;
            photoCollectionView.delegate = self;
            // 注册单元格
            [photoCollectionView registerClass:[YJPhotoAddBtnCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
            [photoCollectionView registerClass:[YJPhotoDisplayCollectionViewCell class] forCellWithReuseIdentifier:photoCellid];
            photoCollectionView.showsHorizontalScrollIndicator = false;
            photoCollectionView.showsVerticalScrollIndicator = false;
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.offset(0);
        make.top.equalTo(photoCollectionView.mas_bottom);
        make.height.offset(1*kiphone6/[UIScreen mainScreen].scale);
    }];
    UISwitch *switchButton = [[UISwitch alloc]init];
    switchButton.onTintColor= [UIColor colorWithHexString:@"00bfff"];
    switchButton.tintColor = [UIColor colorWithHexString:@"cccccc"];
    // 控件大小，不能设置frame，只能用缩放比例
    switchButton.transform= CGAffineTransformMakeScale(0.8,0.75);
    [backView addSubview:switchButton];
    [switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(line.mas_bottom).offset(19*kiphone6);
        make.right.offset(-10 *kiphone6);
    }];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    UILabel *itemLabel = [UILabel labelWithText:@"其他小区可看" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:12];
    [backView addSubview:itemLabel];
    [itemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(switchButton.mas_left).offset(-5*kiphone6);
        make.centerY.equalTo(switchButton);
    }];
        return backView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.imageArr.count>3) {
        return 281*kiphone6;
        }
    return 231*kiphone6;
           
}
#pragma mark - UICollectionView
// 有多少行
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.imageArr.count<8&&self.imageArr.count>0) {
        return self.imageArr.count+1;
    }else if(self.imageArr.count==8){
        return self.imageArr.count;
    }else{
        return 1;
    }
}

// cell内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.imageArr.count==0) {
        // 去缓存池找
        YJPhotoAddBtnCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
        cell.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
            HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
            picker.delegate = self;
            picker.maxAllowedCount = 8-self.imageArr.count;
            picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
            [self presentViewController:picker animated:YES completion:nil];
        };
        return cell;
    }else if (self.imageArr.count<8&&self.imageArr.count>0){
        if (indexPath.row==self.imageArr.count) {
            // 去缓存池找
            YJPhotoAddBtnCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionCellid forIndexPath:indexPath];
            cell.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
                HUImagePickerViewController *picker = [[HUImagePickerViewController alloc] init];
                picker.delegate = self;
                picker.maxAllowedCount = 8-self.imageArr.count;
                picker.originalImageAllowed = YES; //想要获取高清图设置为YES,默认为NO
                [self presentViewController:picker animated:YES completion:nil];
            };
            return cell;
        }else{
            // 去缓存池找
            YJPhotoDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
            cell.imageView.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
                [self.imageArr removeObjectAtIndex:indexPath.row];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                self.contentView.text = self.content;//刷新后保存报修内容
                [self.collectionView reloadData];
            };
            cell.photo = self.imageArr[indexPath.row];
            return cell;
        }
    }
    // 去缓存池找
    YJPhotoDisplayCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoCellid forIndexPath:indexPath];
    cell.imageView.clickBtnBlock = ^(NSInteger tag) {//cell上按钮点击事件
        [self.imageArr removeObjectAtIndex:indexPath.row];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        self.contentView.text = self.content;//刷新后保存报修内容
        [self.collectionView reloadData];
    };
    cell.photo = self.imageArr[indexPath.row];
    return cell;
}

//当选择一张图片后进入这里
- (void)imagePickerController:(HUImagePickerViewController *)picker didFinishPickingImagesWithInfo:(NSDictionary *)info{
    //    self.imageArr = info[kHUImagePickerThumbnailImage];//缩小图
    NSMutableArray *arr = info[kHUImagePickerOriginalImage];//源图
    for (int i = 0; i<arr.count; i++) {
        [self.imageArr addObject:arr[i]];
    }
    //    self.imageArr = [NSMutableArray arrayWithArray:arr];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    self.contentView.text = self.content;//刷新后保存报修内容
    [self.collectionView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
// cell点击事件
- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    YJPhotoDisplayCollectionViewCell *cell = (YJPhotoDisplayCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [HUPhotoBrowser showFromImageView:cell.imageView withImages:self.imageArr atIndex:indexPath.row];
    
}
-(NSMutableArray *)imageArr{
    if (_imageArr == nil) {
        _imageArr = [[NSMutableArray alloc]init];
    }
    return _imageArr;
}
-(void)switchAction:(UISwitch*)sener{
    
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
