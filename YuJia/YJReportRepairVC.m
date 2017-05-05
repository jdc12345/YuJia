//
//  YJReportRepairVC.m
//  YuJia
//
//  Created by 万宇 on 2017/5/3.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJReportRepairVC.h"
#import "UIColor+colorValues.h"
#import "YJHeaderTitleBtn.h"
#import "UILabel+Addition.h"
#import "YJRepairBaseInfoTableViewCell.h"
#import "BRPlaceholderTextView.h"
#import "YJPhotoFlowLayout.h"
#import "YJPhotoAddBtnCollectionViewCell.h"
#import <HUImagePickerViewController.h>
#import "YJPhotoDisplayCollectionViewCell.h"
#import <HUPhotoBrowser.h>
#import "YJRepairSectionTwoTableViewCell.h"
#import "YJRepairRecordTableViewCell.h"


static NSString* tableCellid = @"table_cell";
static NSString* collectionCellid = @"collection_cell";
static NSString* photoCellid = @"photo_cell";
@interface YJReportRepairVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,HUImagePickerViewControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)UITextField *telNumberField;
@property(nonatomic,weak)UITextField *passWordField;
@property(nonatomic,weak)UIButton *repairBtn;
@property(nonatomic,weak)UIButton *recordBtn;
@property(nonatomic,weak)UIButton *firstTypeBtn;
@property(nonatomic,weak)UIButton *secondTypeBtn;
@property(nonatomic,weak)UIButton *thirdTypeBtn;
@property(nonatomic,weak)UIView *typeView;
@property(nonatomic,strong)NSString *repairType;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property(nonatomic,weak)UICollectionView *collectionView;
@property(nonatomic,weak)BRPlaceholderTextView *titleView;
@property(nonatomic, strong)NSString *content;
@property(nonatomic, assign)NSInteger flag;//我要报修和报修记录按钮标记
@property(nonatomic, assign)NSInteger stateFlag;//报修状态按钮标记
//
@property(nonatomic,weak)UITableView *recordTableView;
@end

@implementation YJReportRepairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报事报修";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = false;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:15],
       NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setBtnWithFrame:CGRectMake(0, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"我要报修"andTag:101];
    [self setBtnWithFrame:CGRectMake(kScreenW*0.5, 0, kScreenW*0.5, 44*kiphone6) WithTitle:@"报修记录"andTag:102];
}
-(void)setBtnWithFrame:(CGRect)frame WithTitle:(NSString*)title andTag:(CGFloat)tag{
    YJHeaderTitleBtn *btn = [[YJHeaderTitleBtn alloc]initWithFrame:frame and:title];
    [self.view addSubview:btn];
    btn.tag = tag;
    if (btn.tag==101) {
        self.repairBtn = btn;
    }else{
        self.recordBtn = btn;
    }
    [btn addTarget:self action:@selector(selectRepairItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)selectRepairItem:(UIButton*)sender{
    self.flag = sender.tag;//记录是我要报修还是报修记录按钮
    self.tableView.hidden = true;
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setImage:[UIImage imageNamed:@"selected_open"] forState:UIControlStateNormal];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    if (sender.tag == 101) {
        self.recordTableView.hidden = true;
        self.recordBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.recordBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.recordBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        NSArray *typeArr = @[@"房屋报修",@"水电燃气",@"公共设施"];
        if (self.typeView) {
            [self.firstTypeBtn setTitle:typeArr[0] forState:UIControlStateNormal];
            [self.secondTypeBtn setTitle:typeArr[1] forState:UIControlStateNormal];
            [self.secondTypeBtn setTitle:typeArr[2] forState:UIControlStateNormal];
            self.typeView.hidden = false;
        }else{
            
            [self addTypeViewWith:typeArr];

        }
    }else{
        self.tableView.hidden = true;
        self.recordTableView.hidden = true;
        self.repairBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.repairBtn setImage:[UIImage imageNamed:@"unselected_open"] forState:UIControlStateNormal];
        [self.repairBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        NSArray *typeArr = @[@"待维修",@"处理中",@"已完成"];
        if (self.typeView) {
            [self.firstTypeBtn setTitle:typeArr[0] forState:UIControlStateNormal];
            [self.secondTypeBtn setTitle:typeArr[1] forState:UIControlStateNormal];
            [self.thirdTypeBtn setTitle:typeArr[2] forState:UIControlStateNormal];
            self.typeView.hidden = false;
        }else{
            
            [self addTypeViewWith:typeArr];
        }
    }
    }
-(void)addTypeViewWith:(NSArray*)typeArr{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self.view addSubview:view];
    self.typeView = view;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.repairBtn.mas_bottom).offset(42*kiphone6);
        make.width.offset(325*kiphone6);
        make.height.offset(102*kiphone6);
    }];
    UILabel *allTypeLabel = [UILabel labelWithText:@"全部类型" andTextColor:[UIColor colorWithHexString:@"#333333"] andFontSize:15];
    [view addSubview:allTypeLabel];
    [allTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view.mas_top).offset(16*kiphone6);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
    [view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(32*kiphone6);
        make.height.offset(1*kiphone6);
    }];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [[UIButton alloc]init];
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor colorWithHexString:@"#01c0ff"].CGColor;
        btn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [btn setTitle:typeArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [view addSubview:btn];
        btn.frame = CGRectMake(35*kiphone6+i*95*kiphone6, 56*kiphone6, 70*kiphone6, 25*kiphone6);
        btn.tag = 51+i;
        if (btn.tag == 51) {
            self.firstTypeBtn = btn;
        }else if (btn.tag == 52){
            self.secondTypeBtn = btn;
        }else{
            self.thirdTypeBtn = btn;
        }
        [btn addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)selectType:(UIButton*)sender{
    self.stateFlag = sender.tag;//记录保修状态
    sender.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.typeView.hidden = true;
    if (sender.tag == 51) {
        self.secondTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.secondTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.thirdTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.thirdTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }else if (sender.tag == 52){
        self.firstTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.firstTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.thirdTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.thirdTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }else{
        self.firstTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.firstTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        self.secondTypeBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [self.secondTypeBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }

    if (self.flag==101) {
    self.repairType = sender.titleLabel.text;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];  //你需要更新的组数中的cell
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        if (self.tableView) {
        self.tableView.hidden = false;
    }else{
        //添加tableView
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        self.tableView = tableView;
        [self.view addSubview:tableView];
        self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.repairBtn.mas_bottom);
            make.left.right.bottom.offset(0);
        }];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [tableView registerClass:[YJRepairBaseInfoTableViewCell class] forCellReuseIdentifier:tableCellid];
//        [tableView registerClass:[YJRepairSectionTwoTableViewCell class] forCellReuseIdentifier:tableCellid];
        tableView.delegate =self;
        tableView.dataSource = self;
    }
    }else{
        if (self.stateFlag==51) {
            //加载 待维修 数据
        }else if (self.stateFlag==52){
            //加载 处理中 数据
        }else if (self.stateFlag==53){
            //加载 已完成 数据
        }
        if (self.recordTableView) {
            self.recordTableView.hidden = false;
            [self.recordTableView reloadData];
        }else{
            //添加tableView
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
            self.recordTableView = tableView;
            [self.view addSubview:tableView];
            self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.repairBtn.mas_bottom);
                make.left.right.bottom.offset(0);
            }];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [tableView registerClass:[YJRepairRecordTableViewCell class] forCellReuseIdentifier:tableCellid];
            //        [tableView registerClass:[YJRepairSectionTwoTableViewCell class] forCellReuseIdentifier:tableCellid];
            tableView.delegate =self;
            tableView.dataSource = self;
        }
    }
}
#pragma mark - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableView) {
        return 2;
    }else{
        return 1;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        if (section==0) {
            return 1;
        }
        return 2;
    }else{
        return 3;//根据请求回来的数据定
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
    if (indexPath.section==0) {
        YJRepairBaseInfoTableViewCell *cell = [[YJRepairBaseInfoTableViewCell alloc]init];
        return cell;
    }
    
    YJRepairSectionTwoTableViewCell *cell = [[YJRepairSectionTwoTableViewCell alloc]init];;
    if (indexPath.section==1&&indexPath.row==0) {
        cell.item = self.repairType;
    }else{
        
    }
    return cell;
    }else{
        YJRepairRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellid forIndexPath:indexPath];
        
        return cell;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5*kiphone6)];
    if (section==0) {
        backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }else{
        backView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        //输入框
        BRPlaceholderTextView *titleView = [[BRPlaceholderTextView alloc]init];
        [backView addSubview:titleView];
        self.titleView = titleView;
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10*kiphone6);
            make.bottom.equalTo(backView.mas_top).offset(70*kiphone6);
            make.right.offset(-10*kiphone6);
            make.height.offset(70*kiphone6);
        }];
        [titleView layoutIfNeeded];
        titleView.delegate = self;
//        self.titleView = titleView;
        titleView.placeholder = @"请描述您要保修的详情...";
//        titleView.imagePlaceholder = @"title";
        titleView.font=[UIFont boldSystemFontOfSize:13];
        [titleView setBackgroundColor:[UIColor whiteColor]];
        [titleView setPlaceholderFont:[UIFont systemFontOfSize:13]];
        [titleView setPlaceholderColor:[UIColor colorWithHexString:@"#999999"]];
        //    titleField.borderStyle = UITextBorderStyleNone;
        //    //边框宽度
        //    [titleField.layer setBorderWidth:0.01f];
        [titleView setPlaceholderOpacity:0.6];
        [titleView addMaxTextLengthWithMaxLength:300 andEvent:^(BRPlaceholderTextView *text) {
//            [self.titleView endEditing:YES];
            
            NSLog(@"----------");
        }];
        
        [titleView addTextViewBeginEvent:^(BRPlaceholderTextView *text) {
            NSLog(@"begin");
        }];
        
        [titleView addTextViewEndEvent:^(BRPlaceholderTextView *text) {
            self.content = self.titleView.text;
            NSLog(@"end");
        }];

        //photoCollectionView
        UICollectionView *photoCollectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[YJPhotoFlowLayout alloc]init]];
        [backView addSubview:photoCollectionView];
        self.collectionView = photoCollectionView;
        photoCollectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        [photoCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleView.mas_bottom);
            make.left.bottom.offset(0);
            make.width.offset(216*kiphone6);
        }];
        photoCollectionView.dataSource = self;
        photoCollectionView.delegate = self;
        // 注册单元格
        [photoCollectionView registerClass:[YJPhotoAddBtnCollectionViewCell class] forCellWithReuseIdentifier:collectionCellid];
        [photoCollectionView registerClass:[YJPhotoDisplayCollectionViewCell class] forCellWithReuseIdentifier:photoCellid];
        photoCollectionView.showsHorizontalScrollIndicator = false;
        photoCollectionView.showsVerticalScrollIndicator = false;

    }
     return backView;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.tableView) {
    if (section==0) {
        return 5*kiphone6;
    }else{
        if (self.imageArr.count>3) {
            return 173*kiphone6;
        }
        return 123*kiphone6;
    }
    }else{
        return 0;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5*kiphone6)];
    backView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    if (section==1) {
        UIButton *btn = [[UIButton alloc]init];
        btn.backgroundColor = [UIColor colorWithHexString:@"#01c0ff"];
        [btn setTitle:@"提交" forState:UIControlStateNormal];
        btn.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.masksToBounds = true;
        btn.layer.cornerRadius = 3;
        [backView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(backView);
            make.width.offset(324.5*kiphone6);
            make.height.offset(45*kiphone6);
        }];
    }
    return backView;
    }else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
    if (section==0) {
        return 5*kiphone6;
    }else{
        return 140*kiphone6;
    }
    }else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
    if (indexPath.section==0) {
        return 135*kiphone6;
    }
    return 45*kiphone6;
    }else{
       return 178*kiphone6;//自动计算并缓存行高
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section==1&&indexPath.row==0) {
        [self resignFirstResponder];
        tableView.hidden = true;
        self.typeView.hidden = false;
        
    }
  }
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
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                self.titleView.text = self.content;//刷新后保存报修内容
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
            self.titleView.text = self.content;//刷新后保存报修内容
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
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    self.titleView.text = self.content;//刷新后保存报修内容
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
