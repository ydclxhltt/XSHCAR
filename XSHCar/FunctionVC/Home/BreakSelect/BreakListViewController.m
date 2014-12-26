//
//  BreakListViewController.m
//  XSHCar
//
//  Created by clei on 14/11/19.
//  Copyright (c) 2014年 john. All rights reserved.
//

#import "BreakListViewController.h"
#import "BreakCell.h"

@interface BreakListViewController ()
@end

@implementation BreakListViewController

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
    //设置title
    self.title = [NSString stringWithFormat:@"违章记录%d条",(int)[self.dataArray count]];
    //添加返回item
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
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStyleGrouped tableDelegate:self];
}


#pragma mark 获取高度
- (float)getHeightWithString:(NSString *)text
{
    CGSize size = [text sizeWithFont:FONT(16.0) constrainedToSize:CGSizeMake(230, 20000)];
    NSLog(@"size.height===%.0f",size.height);
     if (size.height + 10 > 40.0)
    return  size.height + 10;
    else
    return 40.0;
}

#pragma mark tableDelegate
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    if (indexPath.row == 1)
    {
        return [self getHeightWithString:[dic objectForKey:@"occur_area"]];
    }
    else if (indexPath.row == 5)
    {
        return [self getHeightWithString:[dic objectForKey:@"info"]];
    }
    else if (indexPath.row == 6)
    {
        return [self getHeightWithString:[dic objectForKey:@"officer"]];
    }
    return 40.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"违章%d:",(int)section + 1];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    BreakCell *cell = (BreakCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[BreakCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    [cell setDescLabelFrame];
    NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.section];
    switch (indexPath.row)
    {
        case 0:
            cell.titleLabel.text = @"违规时间:";
            cell.descLabel.text = [dic objectForKey:@"occur_date"];
            break;
        case 1:
            cell.titleLabel.text = @"违规地点:";
            cell.descLabel.text = [dic objectForKey:@"occur_area"];
            break;
        case 2:
            cell.titleLabel.text = @"违规扣分:";
            cell.descLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fen"]];
            break;
        case 3:
            cell.titleLabel.text = @"违规罚款:";
            cell.descLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"money"]];
            break;
        case 4:
            cell.titleLabel.text = @"是否处理:";
            cell.descLabel.textColor = [UIColor redColor];
            cell.descLabel.text = [[dic objectForKey:@"status"] isEqualToString:@"Y"] ? @"已处理":@"未处理";
            break;
        case 5:
            cell.titleLabel.text = @"违规原因:";
            cell.descLabel.text = [dic objectForKey:@"info"];
            break;
        case 6:
            cell.titleLabel.text = @"处理机关:";
            cell.descLabel.text = [dic objectForKey:@"officer"];
            break;
        default:
            break;
    }
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
