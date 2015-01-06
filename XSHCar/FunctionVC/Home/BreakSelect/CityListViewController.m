//
//  CityListViewController.m
//  XSHCar
//
//  Created by clei on 14/11/19.
//  Copyright (c) 2014年 john. All rights reserved.
//

#import "CityListViewController.h"

@interface CityListViewController ()

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

    NSArray *array = (self.cityScource == CityScourceFromThird) ? [[XSH_Application shareXshApplication] cityArray] : [[XSH_Application shareXshApplication] xshCityArray];
    
    if (array)
    {
        self.dataArray = (NSMutableArray *)array;
        if (self.cityScource == CityScourceFromThird)
        {
            [self saveCityArray];
        }
    }
    else
    {
        if (self.cityScource == CityScourceFromThird)
        {
            [self getCityData];
        }
        else if (self.cityScource == CityScourceFromXSH)
        {
            [self getXSHCityData];
        }
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
    for (NSDictionary *dic in self.dataArray)
    {
        NSArray *cityArray = [dic objectForKey:@"citys"];
        for (NSDictionary *cityDic in  cityArray)
        {
            NSString *serverHeader = [[XSH_Application shareXshApplication] shortName];
            NSString *carHeader = [cityDic objectForKey:@"car_head"];
            NSLog(@"serverHeader====%@====carHeader===%@",serverHeader,carHeader);
            if ([serverHeader isEqualToString:carHeader])
            {
                int cityID = [[cityDic objectForKey:@"city_id"] intValue];
                [[XSH_Application shareXshApplication] setCarCity:[NSNumber numberWithInt:cityID]];
            }
        }
    }
    [[XSH_Application shareXshApplication] setCityArray:self.dataArray];
}


#pragma mark 获取城市列表
- (void)getCityData
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:CITY_LIST_URL requestParamas:nil requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"cityListResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             weakSelf.dataArray = [NSMutableArray arrayWithArray:[responseDic objectForKey:@"configs"]];
             if (weakSelf.dataArray && [weakSelf.dataArray count] > 0)
             {
                 [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
                 NSLog(@"weakSelf.dataArray===%@",weakSelf.dataArray);
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

- (void)getXSHCityData
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    NSDictionary *requestDic = @{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"sms_id":[NSNumber numberWithInt:weakSelf.smsID],@"uss_id":[NSNumber numberWithInt:weakSelf.ussID]};
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:PEACE_INFO_URL requestParamas:requestDic requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"peaceInfoResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             NSMutableArray *array = [NSMutableArray arrayWithArray:[responseDic objectForKey:@"cityBeanList"]];
             [[XSH_Application shareXshApplication] setSisID:[[responseDic objectForKey:@"sis_id"] intValue]];
             if (array && [array count] > 0)
             {
                 for (int i = 0; i < [array count]; i ++)
                 {
                     NSMutableDictionary *dic = [NSMutableDictionary  dictionaryWithDictionary:array[i]];
                     NSMutableArray *cityArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"citys"]];
                     if (cityArray && [cityArray count] == 0)
                     {
                         NSDictionary *cityDic = @{@"cityName":[dic objectForKey:@"province"],@"cityParentId":[dic objectForKey:@"p_id"],@"cityStatus":@"1",@"cityId":[dic objectForKey:@"p_id"]};
                         [cityArray addObject:cityDic];
                     }
                     [dic setObject:cityArray forKey:@"citys"];
                     [array replaceObjectAtIndex:i withObject:dic];
                 }
                 [[XSH_Application shareXshApplication] setXshCityArray:array];
                 self.dataArray = [NSMutableArray arrayWithArray:array];
                 [self.table reloadData];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
     {
         
         NSLog(@"error===%@",error);
     }];
}

#pragma mark tableDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = [self.dataArray objectAtIndex:section];
    NSString *headerStr = (self.cityScource == CityScourceFromThird) ? [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"province_short_name"],[dic objectForKey:@"province_name"]] : [dic objectForKey:@"province"];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
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
        NSString *carHeader = (self.cityScource == CityScourceFromThird) ? [cityDic objectForKey:@"car_head"] : @"";
        NSString *cityName = (self.cityScource == CityScourceFromThird) ?[cityDic objectForKey:@"city_name"] : [cityDic objectForKey:@"cityName"];
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
        if (self.cityScource == CityScourceFromThird)
        {
            [[XSH_Application  shareXshApplication] setCarCity:[NSNumber numberWithInt:[[cityDic objectForKey:@"city_id"] intValue]]];
            [[XSH_Application shareXshApplication] setShortName:[dic objectForKey:@"province_short_name"]];
            [[XSH_Application shareXshApplication] setCarHeader:[cityDic objectForKey:@"car_head"]];
        }
        else if (self.cityScource == CityScourceFromXSH)
        {
            NSString *province = [dic objectForKey:@"province"];
            NSString *cityName = [cityDic objectForKey:@"cityName"];
            NSString *totleString = [NSString stringWithFormat:@"%@-%@",province,cityName];
            [[XSH_Application shareXshApplication] setCityString:([province isEqualToString:cityName]) ? province : totleString];
            [[XSH_Application shareXshApplication] setXshCityID:[[cityDic objectForKey:@"cityId"] intValue]];
        }
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
