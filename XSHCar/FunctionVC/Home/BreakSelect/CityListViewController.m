//
//  CityListViewController.m
//  XSHCar
//
//  Created by clei on 14/11/19.
//  Copyright (c) 2014年 john. All rights reserved.
//

#import "CityListViewController.h"

@interface CityListViewController ()
{
    UITableView *table;
}
@property(nonatomic,retain)NSArray *dataArray;
@end

@implementation CityListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"选择城市";
    //添加返回item
    [self addBackItem];

    NSArray *array = [[XSH_Application shareXshApplication] cityArray];
    if (array)
    {
        self.dataArray = array;
    }
    else
    {
        [self getCityData];
    }
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


#pragma mark 返回按钮响应事件
- (void)backButtonPressed:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark 保存城市列表数据
- (void)saveCityArray
{
    [[XSH_Application shareXshApplication] setCityArray:self.dataArray];
}


#pragma mark 获取城市列表
- (void)getCityData
{
    typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:CITY_LIST_URL requestParamas:nil requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"cityListResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             NSMutableArray *array = (NSMutableArray *)[responseDic objectForKey:@"configs"];
             if (array && [array count] > 0)
             {
                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
                 weakSelf.dataArray = array;
                 [weakSelf.table reloadData];
                 [weakSelf saveCityArray];
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:@"暂无数据"];
             }
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


#pragma mark tableDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    NSString *headerStr = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"province_short_name"],[dic objectForKey:@"province_name"]];
    return headerStr;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    NSArray *array = [dic objectForKey:@"citys"];
    if (array && [array count] > 0)
    {
        return [array count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:@"citys"];
    if (array && [array count] > 0)
    {
        NSDictionary *cityDic = [array objectAtIndex:indexPath.row];
        NSString *carHeader = [cityDic objectForKey:@"car_head"];
        NSString *cityName = [cityDic objectForKey:@"city_name"];
        NSString *textString = [NSString stringWithFormat:@"%@     %@",carHeader,cityName];
        if (!carHeader || [@"" isEqualToString:carHeader])
        {
            textString = cityName;
        }
        cell.textLabel.text = textString;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *array = [dic objectForKey:@"citys"];
    if (array && [array count] > 0)
    {
        NSDictionary *cityDic = [array objectAtIndex:indexPath.row];
        [[XSH_Application  shareXshApplication] setCarCity:[NSNumber numberWithInt:[[cityDic objectForKey:@"city_id"] intValue]]];
        [[XSH_Application shareXshApplication] setShortName:[dic objectForKey:@"province_short_name"]];
        [[XSH_Application shareXshApplication] setCarHeader:[cityDic objectForKey:@"car_head"]];
        [self backButtonPressed:nil];
    }
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
