//
//  BugsTipViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "BugsTipViewController.h"
#import "BugTipListCell.h"

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
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
}



- (void)viewDidAppear:(BOOL)animated
{
    [self getBugListData];
}


#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark 获取故障提示
- (void)getBugListData
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:TROUBLE_TIPS_URL requestParamas:@{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"currentPage":[NSNumber numberWithInt:currentPage],@"pageNum":[NSNumber numberWithInt:100]} requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
        NSLog(@"loginResponseDic===%@",responseDic);
        if ([responseDic isKindOfClass:[NSArray class]] || [responseDic isKindOfClass:[NSMutableArray class]])
        {
            [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
            weakSelf.dataArray = (NSMutableArray *)responseDic; 
            [weakSelf.table reloadData];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:LOADING_WEBERROR_TIP];
        }

    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
        [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
        NSLog(@"error===%@",error);
    }];
}


#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0) placeholderImage:nil];
    imageView.backgroundColor = [UIColor clearColor];
    return imageView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowDic = self.dataArray[indexPath.section];
    NSString *textString = [[[rowDic objectForKey:@"smsName"] stringByAppendingString:@": "] stringByAppendingString: [rowDic objectForKey:@"smsinforContent"]];
    float height = [CommonTool labelHeightWithText:textString textFont:FONT(15.0) labelWidth:SCREEN_WIDTH - 10 * 2] + 20;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"bugTipCellID";
    
    BugTipListCell *cell = (BugTipListCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[BugTipListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *rowDic = self.dataArray[indexPath.section];
    [cell setLabelTextWithTitle:[[rowDic objectForKey:@"smsName"] stringByAppendingString:@": "] contentText:[rowDic objectForKey:@"smsinforContent"]];
    return cell;
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
