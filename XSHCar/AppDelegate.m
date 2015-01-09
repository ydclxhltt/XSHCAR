//
//  AppDelegate.m
//  XSHCar
//
//  Created by clei on 14/12/18.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MessageManageViewController.h"
#import "SettingViewController.h"
#import "MineViewController.h"
#import "LoginViewController.h"
#import "BMapKit.h"
#import "CheckUpdateTool.h"


@interface AppDelegate()<BMKGeneralDelegate>
{
    UITabBarController *mainTabbarViewController;
    BMKMapManager *mapManager;
    CheckUpdateTool *tool;
}
@property(nonatomic, strong) NSString *tokenString;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.tokenString = @"";
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exit) name:@"Exit" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendToken) name:@"SendToken" object:nil];
    //注册远程通知
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];
    
    //注册百度地图
    mapManager = [[BMKMapManager alloc] init];
    [mapManager start:BAIDU_MAP_KEY generalDelegate:self];
    
    //设置tabbar字颜色
    //[[UITabBar appearance] setBarTintColor:[UIColor lightGrayColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName : RGB(113.0, 113.0, 113.0)} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11],NSForegroundColorAttributeName : APP_MAIN_COLOR} forState:UIControlStateSelected];
    
    
    //添加主视图
    [self addMainView];
    
    //添加登录视图
    [self addLoginViewWithAnimation:NO];
    
    //添加引导视图
    //[self addTechView];
    
    //检查更新
    [self checkUpdate];
    
    return YES;
}

#pragma mark 退出后响应事件
- (void)exit
{
    [self addLoginViewWithAnimation:YES];
}


#pragma mark 添加登录界面
- (void)addLoginViewWithAnimation:(BOOL)isAnimation
{
    LoginViewController *loginViewController = [[LoginViewController  alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [mainTabbarViewController presentViewController:nav animated:isAnimation completion:^{if(isAnimation)[self selectedIndex:0];}];
}

#pragma mark 添加主界面
//添加主界面
- (void)addMainView
{
    /*
     *  去掉tabbar上方黑线
     *  1⃣️ [mianTabbarViewController.tabBar setClipsToBounds:YES];
     *  2⃣️ [mainTabbarViewController.tabBar setShadowImage:[[UIImage alloc]init]];
     */
     mainTabbarViewController =[[UITabBarController alloc]init];
     //[mainTabbarViewController.tabBar setClipsToBounds:YES];
    
     MineViewController *mineViewController = [[MineViewController alloc]init];
     HomeViewController *homeViewController = [[HomeViewController alloc]init];
     SettingViewController *settingViewController = [[SettingViewController alloc]init];
     MessageManageViewController *messageManageViewController = [[MessageManageViewController alloc]init];
     UINavigationController *homeNavViewController = [[UINavigationController alloc]initWithRootViewController:homeViewController];
     UINavigationController *messageManageNavViewController = [[UINavigationController alloc]initWithRootViewController:messageManageViewController];
     UINavigationController *settingNavViewController = [[UINavigationController alloc]initWithRootViewController:settingViewController];
     UINavigationController *mineNavViewController = [[UINavigationController alloc]initWithRootViewController:mineViewController];
    UIImage *image1 = [UIImage imageNamed:@"tabbar_home1"];
    //image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
     UITabBarItem *homeTabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:image1 selectedImage:[UIImage imageNamed:@"tabbar_home1"]];
     UITabBarItem *messageManageTabBarItem = [[UITabBarItem alloc]initWithTitle:@"消息管理" image:[UIImage imageNamed:@"tabbar_message1"] selectedImage:[UIImage imageNamed:@"tabbar_message1"]];
    UITabBarItem *settingTabBarItem = [[UITabBarItem alloc]initWithTitle:@"设置" image:[UIImage imageNamed:@"tabbar_setting1"] selectedImage:[UIImage imageNamed:@"tabbar_setting1"]];
     UITabBarItem *mineTabBarItem = [[UITabBarItem alloc]initWithTitle:@"我" image:[UIImage imageNamed:@"tabbar_mine1"] selectedImage:[UIImage imageNamed:@"tabbar_mine1"]];
     mainTabbarViewController.tabBar.tintColor = APP_MAIN_COLOR;
     [homeNavViewController setTabBarItem:homeTabBarItem];
     [messageManageNavViewController setTabBarItem:messageManageTabBarItem];
     [settingNavViewController setTabBarItem:settingTabBarItem];
     [mineNavViewController setTabBarItem:mineTabBarItem];
     mainTabbarViewController.viewControllers = [NSArray arrayWithObjects:homeNavViewController,messageManageNavViewController,settingNavViewController,mineNavViewController,nil];
    self.window.rootViewController = mainTabbarViewController;
    
}

- (void)selectedIndex:(int)index
{
    mainTabbarViewController.selectedIndex = index;
}

#pragma mark 检查更新
- (void)checkUpdate
{
    tool = [[CheckUpdateTool alloc] init];
    [tool checkUpdateWithTip:NO];
}



#pragma mark 百度SDK启动地图认证Delegate
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"联网成功");
    }
    else
    {
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


#pragma mark sendToken
- (void)sendToken
{
    NSNumber *userID = [NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]];
    RequestTool *request = [[RequestTool alloc] init];
    NSDictionary *requestDic = @{@"user_id":userID,@"flag":[NSNumber numberWithInt:APPLICATION_PLATFORM],@"dervidetoken":self.tokenString};
    NSLog(@"requestDic===%@",requestDic);
    [request requestWithUrl1:SEND_TOKEN_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"loginResponseDic===%@",responseDic);
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         NSLog(@"error===%@",error);
     }];

}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    self.tokenString = [[[[NSString stringWithFormat:@"%@",deviceToken]stringByReplacingOccurrencesOfString:@"<"withString:@""]
                         stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceToken: %@====tokenString=====%@", deviceToken,self.tokenString.description);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    application.applicationIconBadgeNumber = 0;
 
    /*这里需要处理推送来的消息*/
    NSDictionary *auserInfo = [userInfo objectForKey:@"aps"];
    NSLog(@"userInfo====%@",auserInfo);
    NSString *message = [auserInfo objectForKey:@"alert"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送" message:message delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"error====%@",error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [mapManager stop];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
