//
//  LockTextViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/11.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "LockTextViewController.h"

@interface LockTextViewController ()

@end

@implementation LockTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setSubViewInThis];
    // Do any additional setup after loading the view.
}
- (void)setSubViewInThis{
    UIImageView *keyBoardImageV = [[UIImageView alloc]init];
    keyBoardImageV.backgroundColor = [UIColor colorWithHexString:@"38d5cf"];
    keyBoardImageV.userInteractionEnabled = YES;
    
    [self.view addSubview:keyBoardImageV];
    
    [keyBoardImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        //        make.size.width.mas_equalTo(kScreenW);
    }];
    
    UILabel *textLabel = [[UILabel alloc]init];
    textLabel.text = @"*******";
    textLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
    textLabel.font = [UIFont systemFontOfSize:15];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.layer.cornerRadius = 16.5;
    textLabel.clipsToBounds = YES;
    textLabel.layer.borderColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
    textLabel.layer.borderWidth = 1;
    
    [keyBoardImageV addSubview:textLabel];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(keyBoardImageV).with.offset(35);
        make.centerX.equalTo(keyBoardImageV);
        make.size.mas_equalTo(CGSizeMake(275, 33));
    }];
    
    
    NSArray *btnNameList = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"*",@"0",@"清除"];
    NSInteger rowCount;
    NSInteger comment;
    for (int i = 0; i<12; i++) {
        
        rowCount = i/3;
        comment = i%3;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnNameList[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 16.5;
        btn.clipsToBounds = YES;
        btn.layer.borderColor = [UIColor colorWithHexString:@"f1f1f1"].CGColor;
        btn.layer.borderWidth = 1;
        
        [keyBoardImageV addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textLabel.mas_bottom).with.offset(34 +rowCount *53);
            make.left.equalTo(keyBoardImageV).with.offset(48 + comment *99);
            make.size.mas_equalTo(CGSizeMake(75 ,33));
        }];
        
    }

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
