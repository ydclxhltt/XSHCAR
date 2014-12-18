//
//  MessageManageViewController.m
//  XSHCar
//
//  Created by clei on 14/12/18.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MessageManageViewController.h"

@interface MessageManageViewController ()
@property(nonatomic, retain) NSArray *imageArray;
@end

@implementation MessageManageViewController

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
    self.title = @"消息管理";
    //初始化数据
    self.imageArray = @[@"abnormal vibration_alert",@"deployment_of the_boot prompt",@"collision_warning",@"rollover_alarm",@"electronic_fence",@"peace_family",@"maintenance_tips"];
    self.dataArray = (NSMutableArray *)@[@"异常震动提醒",@"布防启动提示",@"碰撞报警",@"侧翻报警",@"电子围栏",@"平安亲人",@"保养提示"];
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
    NSLog(@"self.table.contentInset.top===%f",self.table.contentInset.top);
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0 * [self.dataArray count] + 64.0) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.scrollEnabled = NO;
    self.table.separatorInset = UIEdgeInsetsZero;
}

#pragma mark - tableView代理


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"homeCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
    }
    
    UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60 , (cell.frame.size.height - 30)/2, 60, 30)];
    [switchView setOn:YES];
//    switchView.onImage = [UIImage imageNamed:@"open_btn"];
//    switchView.offImage = [UIImage imageNamed:@"close_btn"];
    switchView.onTintColor = RGB(28.0, 130.0, 202.0);
    switchView.tintColor = RGB(189.0, 189.0, 189.0);
    [cell.contentView addSubview:switchView];
    
//    CustomSwitch *switchView = [[CustomSwitch alloc]initWithOnImage:[UIImage imageNamed:@"open_btn.png"] offImage:[UIImage imageNamed:@"close_btn.png"] arrange:CustomSwitchArrangeONLeftOFFRight];
//    switchView.status = CustomSwitchStatusOff;
//    switchView.frame = CGRectMake(SCREEN_WIDTH - 60, 7, 60, 30);
//    [cell.contentView addSubview:switchView];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = FONT(16.0);
    cell.imageView.image = [UIImage imageNamed:[self.imageArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
