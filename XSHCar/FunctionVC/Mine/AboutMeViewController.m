//
//  AboutMeViewController.m
//  XSHCar
//
//  Created by chenlei on 14/12/29.
//  Copyright (c) 2014年 chenlei. All rights reserved.
//

#import "AboutMeViewController.h"

@interface AboutMeViewController ()<UIWebViewDelegate>
{
    UIWebView *webwiew;
}
@end

@implementation AboutMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置title
    self.title = @"帮助";
    //添加返回item
    [self addBackItem];
    //初始化UI
    [self createUI];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self loadWebView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    webwiew.delegate = nil;
}

#pragma mark 初始化UI
- (void)createUI
{
    [self addWebView];
}

- (void)addWebView
{
    [SVProgressHUD showWithStatus:LOADING_DEFAULT_TIP];
    webwiew = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    webwiew.scrollView.bounces = NO;
    webwiew.scalesPageToFit = YES;
    webwiew.delegate = self;
    [self.view addSubview:webwiew];
}

#pragma mark 加载网页
- (void)loadWebView
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:HELP_URL]];
    [webwiew loadRequest:request];
}

#pragma mark webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD showSuccessWithStatus:LOADING_SUCESS_TIP];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:LOADING_FAIL_TIP];
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
