//
//  BugsTipViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "BugsTipViewController.h"

@interface BugsTipViewController ()
{
    int currentPage;
}
@end

@implementation BugsTipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加backitem
    [self addBackItem];
    //初始化数据
    currentPage = 1;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getBugListData];
}

#pragma mark 获取故障提示
- (void)getBugListData
{
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:TROUBLE_TIPS_URL requestParamas:@{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"currentPage":[NSNumber numberWithInt:currentPage],@"pageNum":[NSNumber numberWithInt:10]} requestType:RequestTypeSynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
        NSLog(@"loginResponseDic===%@",responseDic);

    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
        NSLog(@"error===%@",error);
    }];
}

- (void)didReceiveMemoryWarning
{
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
