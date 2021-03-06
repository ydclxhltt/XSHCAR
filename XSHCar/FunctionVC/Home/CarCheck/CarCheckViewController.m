//
//  CarCheckViewController.m
//  XSHCar
//
//  Created by clei on 14/12/22.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "CarCheckViewController.h"
#import "ASProgressPopUpView.h"

@interface CarCheckViewController ()<ASProgressPopUpViewDataSource>
{
    NSTimer *processTimer;
    ASProgressPopUpView *processView;
    float height;
    UITextView *textView;
    RequestTool *request;
}
@property(nonatomic, strong) NSString *textString;
@end

@implementation CarCheckViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加backitem
    [self addBackItem];
    //获取体检数据
    [self getCarCheckData];
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
}


- (void)viewWillDisappear:(BOOL)animated
{
    [self stopTimer];
    [request cancelRequest];
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addCheckTipView];
    [self addCheckDetailView];
}

- (void)addCheckTipView
{
    float add_y = 5.0;
    height = 100.0;
    UIImageView *checkTipImageView = [CreateViewTool createImageViewWithFrame:CGRectMake(5, NAV_HEIGHT + add_y, SCREEN_WIDTH - 5 * 2, height) placeholderImage:nil];
    [CommonTool setViewLayer:checkTipImageView withLayerColor:[UIColor lightGrayColor] bordWidth:.5];
    [CommonTool clipView:checkTipImageView withCornerRadius:5.0];
    [self.view addSubview:checkTipImageView];
    
    
    UILabel *label = [CreateViewTool createLabelWithFrame:CGRectMake(5, 10, checkTipImageView.frame.size.width - 5*2, 20) textString:@"正在扫描:" textColor:[UIColor grayColor] textFont:FONT(16.0)];
    [checkTipImageView addSubview:label];
    
    processView = [[ASProgressPopUpView alloc]initWithFrame:CGRectMake(5, 80, checkTipImageView.frame.size.width - 5 * 2, 2)];
    processView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:14.0];
    processView.popUpViewAnimatedColors = @[[UIColor orangeColor], [UIColor orangeColor], APP_MAIN_COLOR];
    processView.dataSource = self;
    processView.userInteractionEnabled = NO;
    [processView showPopUpViewAnimated:YES];
    [checkTipImageView addSubview:processView];
    
    height += checkTipImageView.frame.origin.y + 10;
    
    [self startTimer];
}

- (void)addCheckDetailView
{
    float textHeight = [CommonTool labelHeightWithText:CAR_CHECK_TIP textFont:FONT(15.0) labelWidth:SCREEN_WIDTH - 10 * 2];
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, height, SCREEN_WIDTH - 10 * 2, textHeight)];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    [CommonTool setViewLayer:textView withLayerColor:[UIColor grayColor] bordWidth:.5];
    [CommonTool clipView:textView withCornerRadius:5.0];
    textView.textAlignment = NSTextAlignmentLeft;
    textView.text = CAR_CHECK_TIP;
    textView.font = FONT(15.0);
    [self.view addSubview:textView];
}


#pragma mark  获取体检数据
- (void)getCarCheckData
{
    //__weak __typeof(self) weakSelf = self;
    request = [[RequestTool alloc] init];
    [request requestWithUrl:CAR_CHECK_URL requestParamas:@{@"user_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] userID]],@"car_id":[NSNumber numberWithInt:[[XSH_Application shareXshApplication] carID]]} requestType:RequestTypeAsynchronous
    requestSucess:^(AFHTTPRequestOperation *operation,id responseDic)
    {
         NSLog(@"carCheckResponseDic===%@",responseDic);
         if ([responseDic isKindOfClass:[NSDictionary class]] || [responseDic isKindOfClass:[NSMutableDictionary class]])
         {
             self.textString = @"";
             int statues = [[responseDic objectForKey:@"status"] intValue];
             float mileage = [[responseDic objectForKey:@"maintenanceMileage"] floatValue];
             if (statues == 0)
             {
                 self.textString = @"保养状态:\n您还没有设置保养里程";
             }
             else if (statues == 1)
             {
                 self.textString = [NSString stringWithFormat:@"保养状态:\n距离您下次保养里程还有\n%.2f KM",mileage];
             }
             NSArray *array = [responseDic objectForKey:@"faultInfoList"];
             if (array || [array count] == 0)
             {
                 self.textString = [self.textString stringByAppendingString:@"\n\n故障诊断:\n车辆状况良好!\n没有任何故障,请继续保持..."];
             }
             else
             {
                 self.textString = [self.textString stringByAppendingString:@"\n\n故障诊断:\n"];
                 for (NSDictionary *dic in array)
                 {
                     if (dic)
                     {
                         NSString *codeString = [dic objectForKey:@"smsinforCode"];
                         NSString *contentString = [dic objectForKey:@"odbChdefinition"];
                         if (codeString && ![@"" isEqualToString:codeString])
                         {
                             self.textString = [self.textString stringByAppendingString:[NSString stringWithFormat:@"故障码:%@\n",codeString]];
                         }
                         if (contentString && ![@"" isEqualToString:contentString])
                         {
                              self.textString = [self.textString stringByAppendingString:[NSString stringWithFormat:@"%@\n\n",contentString]];
                         }
                         
                     }
                 }

             }
         }
         
    }
    requestFail:^(AFHTTPRequestOperation *operation,NSError *error)
    {
         NSLog(@"error===%@",error);
    }];

}



#pragma mark - Timer

- (void)startTimer
{
   [self stopTimer];
   processTimer = [NSTimer scheduledTimerWithTimeInterval: 0.05
                                     target:self
                                   selector:@selector(progress)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)stopTimer
{
    if (processTimer)
    {
        [processTimer invalidate];
        processTimer = nil;
    }
}


- (void)progress
{
    float progress = processView.progress;
    if (progress < 1.0)
    {
        progress += 0.005;
        [processView setProgress:progress animated:YES];
        textView.contentOffset = CGPointMake(0, textView.contentOffset.y + (0.005/1.0) * textView.contentSize.height);
    }
    else
    {
        if (progress == 1.0)
        {
            textView.contentOffset = CGPointMake(0, 0);
            textView.text = self.textString;
        }
        [self stopTimer];
    }
}


#pragma mark - ASProgressPopUpView dataSource

// <ASProgressPopUpViewDataSource> is entirely optional
// it allows you to supply custom NSStrings to ASProgressPopUpView
- (NSString *)progressView:(ASProgressPopUpView *)progressView stringForProgress:(float)progress
{
    NSString *textString;
    if (progress < 0.2) {
        textString = @"开始扫描";
    } else if (progress > 0.4 && progress < 0.6) {
        textString = @"ABS检查";
    } else if (progress > 0.75 && progress < 1.0) {
        textString = @"发动机检查";
    } else if (progress >= 1.0) {
        textString = @"检查完成";
    }
    return textString;
}

// by default ASProgressPopUpView precalculates the largest popUpView size needed
// it then uses this size for all values and maintains a consistent size
// if you want the popUpView size to adapt as values change then return 'NO'
- (BOOL)progressViewShouldPreCalculatePopUpViewSize:(ASProgressPopUpView *)progressView;
{
    return YES;
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
