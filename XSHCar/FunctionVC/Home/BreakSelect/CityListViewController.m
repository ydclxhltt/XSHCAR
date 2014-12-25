//
//  ProviceListViewController.m
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
         if ([responseDic isKindOfClass:[NSArray class]] || [responseDic isKindOfClass:[NSMutableArray class]])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             weakSelf.dataArray = (NSMutableArray *)responseDic;
             //[weakSelf.table reloadData];
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
        cell.textLabel.text = [NSString stringWithFormat:@"%@     %@",[cityDic objectForKey:@"car_head"],[cityDic objectForKey:@"city_name"]];;
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
//       [[[XSHRequest sharedInstance] userInfo] setValue:cityDic forKeyPath:@"CarCity"];
//        [[[XSHRequest sharedInstance] userInfo] setValue:[dic objectForKey:@"province_short_name"] forKeyPath:@"ProString"];
//        [self blackBTN:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectCity" object:nil userInfo:nil];
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
