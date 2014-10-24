//
//  RealtimeCurveVC.m
//  WinCenter
//
//  Created by apple on 14-7-6.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "RealtimeCurveVC.h"
#import <MZDayPicker/MZDayPicker.h>
#import <SMVerticalSegmentedControl/SMVerticalSegmentedControl.h>
#import "WebViewJavascriptBridge.h"

#define UI_COLOR_FROM_RGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface RealtimeCurveVC ()
@property (weak, nonatomic) IBOutlet MZDayPicker *dayPicker;
@property (weak, nonatomic) IBOutlet UIView *segmentControlContainer;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property(retain,nonatomic)NSTimer* timer;
@property NSObject *performanceData;
@property WebViewJavascriptBridge* bridge;
@end

@implementation RealtimeCurveVC
- (IBAction)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [WebViewJavascriptBridge enableLogging];
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webview webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"ObjC received message from JS: %@", data);
        responseCallback(@"Response for message from ObjC");
    }];

    //所有的资源都在source.bundle这个文件夹里
    NSString* htmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"RealtimeCurve.bundle/index.html"];
    
    NSURL* url = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    
       
       // Do any additional setup after loading the view from its nib.
    
    self.dayPicker.month = 9;
    self.dayPicker.year = 2013;
    self.dayPicker.delegate = self;
    self.dayPicker.dayNameLabelFontSize = 14.0f;
    self.dayPicker.dayLabelFontSize = 17.0f;
    [self.dayPicker setActiveDaysFrom:1 toDay:30];
    [self.dayPicker setCurrentDay:15 animated:NO];
    //[self.dayPicker setStartDate:[NSDate dateFromDay:28 month:9 year:2013] endDate:[NSDate dateFromDay:5 month:10 year:2013]];
    [self.dayPicker setCurrentDate:[NSDate dateFromDay:21 month:10 year:2014] animated:NO];
    
    //
    NSArray *titles = @[@"CPU使用率", @"内存使用率", @"存储使用率", @"网络使用率"];
    SMVerticalSegmentedControl *segmentedControl = [[SMVerticalSegmentedControl alloc] initWithSectionTitles:titles];
    [segmentedControl setFrame:self.segmentControlContainer.bounds];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.textColor = [UIColor grayColor];
    segmentedControl.selectedTextColor = [UIColor blackColor];
    segmentedControl.backgroundColor = UI_COLOR_FROM_RGB(0xecf0f1);
    segmentedControl.textAlignment = SMVerticalSegmentedControlTextAlignmentCenter;
    segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
    segmentedControl.selectionIndicatorThickness = 4;
    segmentedControl.selectionBoxBorderWidth = 1;
    segmentedControl.selectionBoxBackgroundColorAlpha = 0.5;
    segmentedControl.selectionBoxBorderColorAlpha = 0.7;
    segmentedControl.indexChangeBlock = ^(NSInteger index) {
        //TODO: add handler
    };
    [self.segmentControlContainer addSubview:segmentedControl];
    
}

- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
{
    NSLog(@"Will select day %@",day.day);
}

- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
{
    NSLog(@"Did select day %@",day.day);
}

-(void)updateData
{
    //取得当前时间，x轴
    NSDate* nowDate = [[NSDate alloc]init];
    NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970] * 1000;
    
    //随机温度，y轴
    int temperature = [self getRandomNumber:20 to:50];
    
    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
    //[jsStr appendFormat:@"updateData(%f,%d,%@)",nowTimeInterval,temperature, self.performanceData];
    //if (self.performanceData) {
        [jsStr appendFormat:@"updateData('%@')", self.performanceData];
        [self.webview stringByEvaluatingJavaScriptFromString:jsStr];
    //}
    
    
}
//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from  + (arc4random() % (to - from + 1)));
}
#pragma mark - delegate of webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    HostVO *host = [HostVO new];
    host.hostId = 1;
    [host getPerformanceAsync:^(id object, NSError *error) {
        self.performanceData = object;
        //[self.bridge send:self.performanceData];
        [_bridge callHandler:@"testJavascriptHandler" data:self.performanceData];
    }];
    

   


    //等webview加载完毕再更新数据
//    self.timer = [NSTimer scheduledTimerWithTimeInterval: 1
//                                             target: self
//                                           selector: @selector(updateData)
//                                           userInfo: nil
//                                            repeats: YES];
}

@end
