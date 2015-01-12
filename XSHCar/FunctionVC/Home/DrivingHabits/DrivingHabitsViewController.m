//
//  DrivingHabitsViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "DrivingHabitsViewController.h"

@interface DrivingHabitsViewController ()
{
    UILabel *scoreLabel,*safeLabel,*enLable;
}
@property(nonatomic, strong) NSArray *titleArray;
@end

@implementation DrivingHabitsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加返回item
    [self addBackItem];
    //初始化数据
    _titleArray = @[@"经济车速得分",@"平均热车时长",@"停驶空转",@"急加油",@"急刹车",@"急拐弯",@"弯道踩油门",@"快速变道"];
    //初始化UI
    [self createUI];
    //获取数据
    [self getDrivingHabitsData];
    // Do any additional setup after loading the view.
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addTableView];
    [self setTableHeaderView];
}

- (void)addTableView
{
    [self addTableViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) tableType:UITableViewStylePlain tableDelegate:self];
    //self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setTableHeaderView
{
    float add_y = 15.0;
    //获取放大比例,手动适配
    float scale = SCREEN_WIDTH/320.0;
    UIImage *image = [UIImage imageNamed:@"numberBg"];
    UIImageView *headerView = [CreateViewTool createImageViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, add_y + image.size.height/2 + add_y) placeholderImage:nil];
    UIImageView *imageView = [CreateViewTool createImageViewWithFrame:CGRectMake((SCREEN_WIDTH - image.size.width/2 * scale)/2, add_y, image.size.width/2 * scale, image.size.height/2 * scale) placeholderImage:nil];
    imageView.image = image;
    imageView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:imageView];
    
    float left_x = 20.0 * scale;
    float left_y = 20.0 * scale;
    float lbl_width = 65.0 * scale;
    
    scoreLabel = [CreateViewTool createLabelWithFrame:CGRectMake(left_x, left_y, lbl_width, 35.0) textString:@"" textColor:APP_MAIN_COLOR textFont:BOLD_FONT(25.0)];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [imageView  addSubview:scoreLabel];
    
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(left_x, left_y + scoreLabel.frame.size.height, lbl_width, 20.0) textString:@"总得分" textColor:[UIColor blackColor] textFont:FONT(16.0)];
    label.textAlignment = NSTextAlignmentCenter;
    [imageView  addSubview:label];
    
    float add_x = 15.0 * scale;
    float add_y1 = 10.0 * scale;
    float lbl_width1 = 120.0 * scale;
    float lbl_height = 25.0 * scale;
    left_x = left_x + add_x + scoreLabel.frame.size.width;
    
    enLable = [CreateViewTool createLabelWithFrame:CGRectMake(left_x, left_y, lbl_width1, lbl_height) textString:@"环保指数: " textColor:[UIColor blackColor] textFont:BOLD_FONT(16.0)];
    //enLable.backgroundColor = [UIColor redColor];
    [imageView  addSubview:enLable];
    
    safeLabel = [CreateViewTool createLabelWithFrame:CGRectMake(left_x, left_y + lbl_height + add_y1, lbl_width1, lbl_height) textString:@"安全指数: " textColor:[UIColor blackColor] textFont:BOLD_FONT(16.0)];
     //safeLabel.backgroundColor = [UIColor redColor];
    [imageView  addSubview:safeLabel];
    
    
    //attributedText
    
    self.table.tableHeaderView = headerView;
}

#pragma mark 获取驾驶习惯数据
- (void)getDrivingHabitsData
{
    __weak __typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    RequestTool *request = [[RequestTool alloc] init];
    [request requestWithUrl:DRIVING_HABITS_URL requestParamas:@{@"car_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] carID]]} requestType:RequestTypeAsynchronous
     requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
     {
         NSLog(@"drivingHabitsResponseDic===%@",operation.responseString);
         if (responseDic && [responseDic isKindOfClass:[NSDictionary class]] && [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
             [weakSelf reloadData:responseDic];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:LOADING_WEBERROR_TIP];
         }
         
     }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
         NSLog(@"error===%@",error);
         [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
    }];
}

#pragma mark 刷新数据
- (void)reloadData:(NSDictionary *)responseDic
{
    scoreLabel.text = [responseDic objectForKey:@"countScore"];
    enLable.attributedText = [self makeStringWithTitle:@"环境指数: " scoreText:[responseDic objectForKey:@"envimentzhishu"]];
    safeLabel.attributedText = [self makeStringWithTitle:@"安全指数: " scoreText:[responseDic objectForKey:@"safezhishu"]];
    self.dataArray = [NSMutableArray arrayWithObjects:@"", @"", @"", @"", @"", @"", @"", @"", nil];
    NSString *jinjiString = [responseDic objectForKey:@"jinjidefen"];
    NSString *perString = [responseDic objectForKey:@"pingjunhotcar"];
    [self.dataArray replaceObjectAtIndex:0 withObject:(jinjiString) ? [NSString stringWithFormat:@"%d分",[jinjiString intValue]] : @"0分"];
    [self.dataArray replaceObjectAtIndex:1 withObject:(perString) ? [NSString stringWithFormat:@"%f秒",[perString floatValue]] : @"0秒"];
    NSArray *array = [responseDic objectForKey:@"allHabit"];
    if (array)
    {
        for (int j = 2 ; j < [self.titleArray count]; j++)
        {
            NSString *string = self.titleArray[j];
            for (int i = 0 ; i < [array count]; i++)
            {
                NSDictionary *dic = array[i];
                if ([string isEqualToString:[dic objectForKey:@"da_name"]])
                {
                    NSString *textString = [dic objectForKey:@"DHR_Value"];
                    [self.dataArray replaceObjectAtIndex:j withObject:(textString) ? [NSString stringWithFormat:@"%d次",[textString intValue]] : @"0次"];
                }
             }
        }
    }
    [self.table reloadData];
}

#pragma mark 设置多属性字符串
- (NSMutableAttributedString *)makeStringWithTitle:(NSString *)title scoreText:(NSString *)score
{
    NSString *textString = [NSString stringWithFormat:@"%@%@",title,score];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:textString];
    [attributedString addAttribute:NSFontAttributeName
                             value:FONT(15.0)
                             range:[textString rangeOfString:title]];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor blackColor]
                             range:[textString rangeOfString:title]];
    [attributedString addAttribute:NSFontAttributeName
                             value:BOLD_FONT(19.0)
                             range:[textString rangeOfString:score]];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:APP_MAIN_COLOR
                             range:[textString rangeOfString:score]];
    return attributedString;

}


#pragma mark - tableView代理


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray  count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"drivingHabitsCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:100];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.transform = CGAffineTransformScale(cell.imageView.transform, 0.5, 0.5);
        
        label = [CreateViewTool createLabelWithFrame:CGRectMake(SCREEN_WIDTH - 120.0 - 10.0, 0, 120.0, cell.frame.size.height) textString:@"" textColor:[UIColor grayColor] textFont:FONT(15.0)];
        label.textAlignment = NSTextAlignmentRight;
        label.tag = 100;
        [cell.contentView addSubview:label];
    }
    
    label.text = self.dataArray[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"drivingHabit_%d",(int)indexPath.row + 1]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.font = FONT(16.0);
    
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
