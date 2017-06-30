
//  Copyright (c) 2016年 __MyCompanyName__. All rights reserved.
//
#import "YYTabBarController.h"
// #import "UIImage+Common.h"
#import "YYTabBar.h"
#import "YYNavigationController.h"
#import "HomePageViewController.h"
#import "PropertyViewController.h"
#import "CircleGroupViewController.h"
#import "PersonalViewController.h"

#define kTabbarItemTag 100
@interface YYTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) YYTabBar *tabBarView;


@end

@implementation YYTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tabBarView = [YYTabBar initWithTabs:4 systemTabBarHeight:self.tabBar.bounds.size.height selected:^(NSUInteger index) {
        self.selectedIndex = index;
    }];
    [self setupMainContents];
    [self setValue:self.tabBarView forKey:@"tabBar"];
}


-(void)viewWillAppear:(BOOL)animated {
    [self.selectedViewController beginAppearanceTransition: YES animated: animated];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.selectedViewController endAppearanceTransition];
}

-(void) viewWillDisappear:(BOOL)animated {
    [self.selectedViewController beginAppearanceTransition: NO animated: animated];
}

-(void) viewDidDisappear:(BOOL)animated {
    [self.selectedViewController endAppearanceTransition];
}

- (void)setupMainContents {
    // 首页
    HomePageViewController *homeVC = [[HomePageViewController alloc] init];
    [self addChildViewControllerAtIndex:0 childViewController:homeVC title:@"家" normalImage:@"home" selectedImage:@"homeselected"];
    
    // 物业管家
    PropertyViewController *measureVC = [[PropertyViewController alloc] init];
    [self addChildViewControllerAtIndex:1 childViewController:measureVC title:@"物业管家" normalImage:@"realestatemanagement" selectedImage:@"realestatemanagement-Selected"];
    
    // 圈子
    CircleGroupViewController *consultVC = [[CircleGroupViewController alloc] init];
    [self addChildViewControllerAtIndex:2 childViewController:consultVC title:@"圈子" normalImage:@"circle" selectedImage:@"circle-Selected"];
    
    // 个人
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    [self addChildViewControllerAtIndex:3 childViewController:personalVC title:@"个人" normalImage:@"MyCenter" selectedImage:@"MyCenter-Selected"];
}

/**
 *  Add a child view controller.
 *
 *  @param index                index of the child Controller
 *  @param childViewController  child Controller
 *  @param title                title for item within TabBar
 *  @param normalImage          unselected image for item within TabBar
 *  @param selectedImage        selected image for item within TabBar
 */
- (void)addChildViewControllerAtIndex:(NSInteger)index childViewController:(UIViewController *)childViewController title:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage {
    // Set content of the corresponding tab bar item for child controller.
    
    [self.tabBarView setTabAtIndex:index title:title normalImage:normalImage selectedImage:selectedImage];
    
    // Add child Controller to TabBarController.
    YYNavigationController *navigationVc = [[YYNavigationController alloc] initWithRootViewController:childViewController];
    [self addChildViewController:navigationVc];
}

#pragma mark - Actions.
- (void)switchTab:(NSUInteger)index {
    self.selectedIndex = index;
    [self.tabBarView selectTab:index];
}

@end
