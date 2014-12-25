//
//  MobileStoreViewController.m
//  XSHCar
//
//  Created by clei on 14/12/19.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MobileStoreViewController.h"

@interface MobileStoreViewController ()
{
    int currentPage;
}
@end

@implementation MobileStoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加backitem
    [self addBackItem];
    //初始化数据
    currentPage = 1;
    //加载数据
    [self getMobileStoreListWithCatagory:0];
    // Do any additional setup after loading the view.
}


#pragma mark 获取移动商城列表
- (void)getMobileStoreListWithCatagory:(int)catagoryID
{
    //__weak typeof(self) weakSelf = self;
    if (currentPage == 1)
    {
        [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    }

    NSDictionary *requestDic = @{@"shop_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] shopID]],@"catagory_id":[NSNumber numberWithInt:catagoryID],@"pageno":[NSNumber numberWithInt:currentPage]};
    NSLog(@"MOBILE_STORE_URL===%@",MOBILE_STORE_URL);
    NSLog(@"requestDic===%@",requestDic);
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:MOBILE_STORE_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"storeResponseDic===%@",responseDic);
        NSLog(@"storeResponseDic===%@",operation.responseString);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
         }
         else
         {
             //失败
             if (currentPage == 1)
             {
                 [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
             }
             if (currentPage > 1)
             {
                 currentPage--;
             }
         }
    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
         if (currentPage > 1)
         {
             currentPage--;
         }
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
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
