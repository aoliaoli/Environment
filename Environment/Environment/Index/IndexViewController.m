//
//  IndexViewController.m
//  Environment
//
//  Created by 奥莉 on 2017/3/13.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "IndexViewController.h"
#import "EnvironmentViewController.h"
#import "BmmViewController.h"
#import "UpsViewController.h"
#import "ViedoViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EnvironmentViewController *environVC = [[EnvironmentViewController alloc] init];
    UINavigationController *naVC1 = [[UINavigationController alloc] initWithRootViewController:environVC];
    naVC1.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"环境监测" image:[UIImage imageNamed:@"监测"] selectedImage:[[UIImage imageNamed:@"监测-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    BmmViewController *bmmVC = [[BmmViewController alloc] init];
    UINavigationController *naVC2 = [[UINavigationController alloc]initWithRootViewController:bmmVC];
    naVC2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"BMM" image:[UIImage imageNamed:@"设备"] selectedImage:[[UIImage imageNamed:@"设备-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UpsViewController *upsVC = [[UpsViewController alloc] init];
    UINavigationController *naVC3 = [[UINavigationController alloc] initWithRootViewController:upsVC];
    naVC3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"UPS" image:[UIImage imageNamed:@"UPS"] selectedImage:[[UIImage imageNamed:@"UPS-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    ViedoViewController *viedoVC = [[ViedoViewController alloc] init];
    UINavigationController *naVC4 = [[UINavigationController alloc] initWithRootViewController:viedoVC];
    naVC4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"视频监控" image:[UIImage imageNamed:@"视频"] selectedImage:[[UIImage imageNamed:@"视频-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.viewControllers = @[naVC1,naVC2,naVC3,naVC4];
    
    
    // Do any additional setup after loading the view.
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
