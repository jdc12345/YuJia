//
//  HomePageViewController.m
//  YuJia
//
//  Created by wylt_ios_1 on 2017/5/2.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "HomePageViewController.h"
#import "UIColor+Extension.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController{
    UIImageView *navBarHairlineImageView;
    UIImageView *tabBarHairlineImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"家";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // Left item
    UIButton *leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavBtn.frame = CGRectMake(10, 16, 60, 12);
    [leftNavBtn setTitle:@"切换实景" forState:UIControlStateNormal];
    [leftNavBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    leftNavBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [leftNavBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:leftNavBtn];
    
    
    // Left item
    UIButton *rightNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightNavBtn.frame = CGRectMake(kScreenW -22, 16, 12, 12);
    [rightNavBtn setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    [rightNavBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:rightNavBtn];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    // 改变navBar 下面的线
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
    UILabel *coverView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 1)];
    coverView.backgroundColor = [UIColor colorWithHexString:@"e9e9e9"];
    [navBarHairlineImageView removeFromSuperview];
    [navBarHairlineImageView addSubview:coverView];
    
    
    // Do any additional setup after loading the view.
}
/**
 * PS:navigation  下面的线
 */
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
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
