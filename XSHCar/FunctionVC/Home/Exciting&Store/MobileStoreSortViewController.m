//
//  MobileStoreSortViewController.m
//  XSHCar
//
//  Created by chenlei on 15/1/1.
//  Copyright (c) 2015年 chenlei. All rights reserved.
//

#import "MobileStoreSortViewController.h"
#import "MobileStoreListViewController.h"

@interface MobileStoreSortViewController ()

@end

@implementation MobileStoreSortViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加backitem
    [self addBackItem];
    //初始化UI
    [self createUI];
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



#pragma mark - tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"sortCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *string = @"";
    if (self.level == 2)
    {
        string = [dic objectForKeyedSubscript:@"twospc_name"];
    }
    if (self.level == 3)
    {
        string = [dic objectForKeyedSubscript:@"thirdspc_name"];
    }
    cell.textLabel.text = (string) ? string : @"";
    //cell.textLabel.font = FONT(16.0);
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = self.dataArray[indexPath.row];
    if (self.level == 2)
    {
        NSArray *array = [dic objectForKey:@"thirdShopCatagorys"];
        if (!array || [array count] == 0)
        {
            //直接查询
            [self selectListWithData:dic];
        }
        else
        {
            //下一级
            MobileStoreSortViewController *sortViewController = [[MobileStoreSortViewController alloc] init];
            sortViewController.level = 3;
            sortViewController.dataArray = [NSMutableArray arrayWithArray:array];
            sortViewController.hidesBottomBarWhenPushed = YES;
            NSString *title = [dic objectForKey:@"twospc_name"];
            sortViewController.title = (title && ![@"" isEqualToString:title]) ? title : @"分类";
            [self.navigationController pushViewController:sortViewController animated:YES];
        }
    }
    else if (self.level == 3)
    {
        //直接查询
        [self selectListWithData:dic];
    }
}


- (void)selectListWithData:(NSDictionary *)dic
{
    NSString *title = @"";
    NSString *spcID = @"";
    if (self.level == 2)
    {
        title = [dic objectForKeyedSubscript:@"twospc_name"];
    }
    if (self.level == 3)
    {
        spcID = [dic objectForKey:@"thirdspc_id"];
        title = [dic objectForKeyedSubscript:@"thirdspc_name"];
    }
    
    MobileStoreListViewController *listViewController = [[MobileStoreListViewController alloc] init];
    listViewController.spcID = [spcID intValue];
    listViewController.title = title;
    listViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listViewController animated:YES];
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
