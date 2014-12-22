//
//  ExcitingActivitiesViewController.m
//  XSHCar
//
//  Created by clei on 14/12/19.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "ExcitingActivitiesViewController.h"

@interface ExcitingActivitiesViewController ()
{
    int currentPage;
}
@end

@implementation ExcitingActivitiesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加backitem
    [self addBackItem];
    //初始化数据
    currentPage = 1;
    //初始化UI
    [self createUI];
    //获取数据
    [self getDataList];
    // Do any additional setup after loading the view.
}


#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
}

#pragma mark 获取数据
- (void)getDataList
{
    __weak typeof(self) weakSelf = self;
    NSDictionary *requestDic = @{@"shop_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] shopID]],@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"currentPage":[NSNumber numberWithInt:currentPage],@"pageNum":[NSNumber numberWithInt:10]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:EXCITING_LIST_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"excitingResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSArray class]] || [responseDic isKindOfClass:[NSMutableArray class]])
         {
             NSMutableArray *tempArray = (NSMutableArray *)responseDic;
             if ([tempArray count] == 0)
             {
                 //最后一页
             }
             else
             {
                 if (!weakSelf.dataArray)
                 {
                     weakSelf.dataArray = tempArray;
                 }
                 if ([tempArray count] < 10)
                 {
                     //最后一页
                     [weakSelf.dataArray addObjectsFromArray:tempArray];
                 }
                 else if ([tempArray count] == 10)
                 {
                     [weakSelf.dataArray addObjectsFromArray:tempArray];
                 }
             }
             [self.table reloadData];
         }
         else
         {
             //失败
         }
     }
     requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         NSLog(@"error===%@",error);
     }];
}



#pragma mark - tableView代理


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"excitingCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsZero;
        //cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
    }
    
    NSDictionary *rowDataDic = self.dataArray[indexPath.row];
    
    NSString *imageUrl = [rowDataDic objectForKey:@"mdtTopimage"];
    imageUrl = @"http://211.154.155.29:8086/epg30/selfadaimg.do?path=/pgicon/20141222/3066944/144209.jpg";
    if (imageUrl && ![@"" isEqualToString:imageUrl])
    {
        [cell.imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
    }
    
    cell.textLabel.text = [rowDataDic objectForKey:@"mdtTitle"];
    cell.detailTextLabel.text = [rowDataDic objectForKey:@"mdtContent"];
    cell.textLabel.font = FONT(16.0);
    cell.detailTextLabel.font = FONT(14.0);
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
