//
//  MineViewController.m
//  XSHCar
//
//  Created by clei on 14/12/18.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "MineViewController.h"
#import "AboutMeViewController.h"
#import "CheckUpdateTool.h"

@interface MineViewController ()
@property(nonatomic, retain) NSArray *imageArray;
@end

@implementation MineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我";
    //初始化UI
    [self createUI];
    //初始化数据
    self.dataArray = (NSMutableArray *)@[@[@"账户信息"],@[@"检查更新",@"帮助",@"退出"]];
    self.imageArray = @[@[@"account_information"],@[@"check_forupdates",@"help",@"exit"]];
    // Do any additional setup after loading the view.
}


#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0 *  4 + 15 * 2 + NAV_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    self.table.scrollEnabled = NO;
}


#pragma mark - tableView代理

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0;
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
    return [[self.dataArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *homeCellID = @"mineCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:homeCellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:homeCellID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
    }
    
    for (UIView *view in cell.contentView.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    
    NSArray *array = self.dataArray[indexPath.section];
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.font = FONT(16.0);
    cell.imageView.image = [UIImage imageNamed:[[self.imageArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    if (indexPath.row == 0 && indexPath.section == 1)
    {
        UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 20.0 - 100.0, 0, 100.0, cell.frame.size.height) textString:PRODUCT_VERSION textColor:[UIColor grayColor] textFont:FONT(15.0)];
        label.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:label];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        //账户信息
    }
    if (indexPath.section == 1)
    {
        CheckUpdateTool *tool = [[CheckUpdateTool alloc] init];
        switch (indexPath.row)
        {
            case 0:
               [tool checkUpdateWithTip:YES alertViewDelegate:self];
                break;
            case 1:
                [self gotoAboutMeView];
                break;
            case 2:
                [self exit];
                break;
                
            default:
                break;
        }
    }
}

#pragma mark 帮助页面
- (void) gotoAboutMeView
{
    AboutMeViewController *aboutMeViewController = [[AboutMeViewController alloc] init];
    aboutMeViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aboutMeViewController animated:YES];
}

#pragma mark 退出
- (void)exit
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Exit" object:nil];
    [[XSH_Application shareXshApplication] setIsExited:YES];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@"0" forKey:@"IsAutoLogin"];
    [userDefaults setValue:@"0" forKey:@"IsSavePwd"];
    [userDefaults setValue:@"" forKey:@"UserName"];
    [userDefaults setValue:@"" forKey:@"PassWord"];
}


#pragma mark alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([@"立即升级" isEqualToString:title])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/xi-sheng-heng-qi-che/id912066247?mt=8"]];
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
