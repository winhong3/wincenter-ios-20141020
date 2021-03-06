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
@property (weak, nonatomic) IBOutlet UIDatePicker *datepicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *timepicker;
@property (weak, nonatomic) IBOutlet UIView *datepickerView;
@property float startTime;
@property NSString *startTimeStr;
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
        if ([data isEqualToString:@"选择开始时间"]) {
            [self showDatepickerView];
        }
        if ([data isEqualToString:@"开始查询"]) {
            [self queryData];
        }
        
        if ([data isEqualToString:@"取消选择"]) {
            [self hideDatepickerView];
        }
        
        //取消选择
        
    }];

    //所有的资源都在source.bundle这个文件夹里
    NSString *pagePath;
    if ([self.chartType isEqualToString:@"host"]) {
        pagePath = @"RealtimeCurve.bundle/index4host.html";
    }else if([self.chartType isEqualToString:@"vm"])
        pagePath = @"RealtimeCurve.bundle/index4vm.html";
    NSString* htmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pagePath];
    NSURL* url = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    
       
       // Do any additional setup after loading the view from its nib.
    
//    self.dayPicker.month = 9;
//    self.dayPicker.year = 2013;
//    self.dayPicker.delegate = self;
//    self.dayPicker.dayNameLabelFontSize = 14.0f;
//    self.dayPicker.dayLabelFontSize = 17.0f;
//    [self.dayPicker setActiveDaysFrom:1 toDay:30];
//    [self.dayPicker setCurrentDay:15 animated:NO];
//    //[self.dayPicker setStartDate:[NSDate dateFromDay:28 month:9 year:2013] endDate:[NSDate dateFromDay:5 month:10 year:2013]];
//    [self.dayPicker setCurrentDate:[NSDate dateFromDay:21 month:10 year:2014] animated:NO];
    
    //
//    NSArray *titles = @[@"CPU使用率", @"内存使用率", @"存储使用率", @"网络使用率"];
//    SMVerticalSegmentedControl *segmentedControl = [[SMVerticalSegmentedControl alloc] initWithSectionTitles:titles];
//    [segmentedControl setFrame:self.segmentControlContainer.bounds];
//    segmentedControl.selectedSegmentIndex = 0;
//    segmentedControl.textColor = [UIColor grayColor];
//    segmentedControl.selectedTextColor = [UIColor blackColor];
//    segmentedControl.backgroundColor = UI_COLOR_FROM_RGB(0xecf0f1);
//    segmentedControl.textAlignment = SMVerticalSegmentedControlTextAlignmentCenter;
//    segmentedControl.selectionStyle = SMVerticalSegmentedControlSelectionStyleBox;
//    segmentedControl.selectionIndicatorThickness = 4;
//    segmentedControl.selectionBoxBorderWidth = 1;
//    segmentedControl.selectionBoxBackgroundColorAlpha = 0.5;
//    segmentedControl.selectionBoxBorderColorAlpha = 0.7;
//    segmentedControl.indexChangeBlock = ^(NSInteger index) {
//        //TODO: add handler
//    };
//    [self.segmentControlContainer addSubview:segmentedControl];
    NSDate *now = [NSDate new];
    self.datepicker.maximumDate = now;
    [self.datepicker setDate:now animated:YES];
    
}

//- (void)dayPicker:(MZDayPicker *)dayPicker willSelectDay:(MZDay *)day
//{
//    NSLog(@"Will select day %@",day.day);
//}
//
//- (void)dayPicker:(MZDayPicker *)dayPicker didSelectDay:(MZDay *)day
//{
//    NSLog(@"Did select day %@",day.day);
//}
//
//-(void)updateData
//{
//    //取得当前时间，x轴
//    NSDate* nowDate = [[NSDate alloc]init];
//    NSTimeInterval nowTimeInterval = [nowDate timeIntervalSince1970] * 1000;
//    
//    //随机温度，y轴
//    int temperature = [self getRandomNumber:20 to:50];
//    
//    NSMutableString* jsStr = [[NSMutableString alloc] initWithCapacity:0];
//    //[jsStr appendFormat:@"updateData(%f,%d,%@)",nowTimeInterval,temperature, self.performanceData];
//    //if (self.performanceData) {
//        [jsStr appendFormat:@"updateData('%@')", self.performanceData];
//        [self.webview stringByEvaluatingJavaScriptFromString:jsStr];
//    //}
//    
//    
//}
////获取一个随机整数，范围在[from,to），包括from，不包括to
//-(int)getRandomNumber:(int)from to:(int)to
//{
//    return (int)(from  + (arc4random() % (to - from + 1)));
//}
#pragma mark - delegate of webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
- (IBAction)refreshAction:(id)sender {
    [self reloadData];
}
-(void)reloadData{
    if (!self.startTime) {
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        self.startTime = (long long int)time*1000 - 10*60*1000;
        //self.startTime = (long long int)[NSDate new];
        
    }
    
    [UserVO getUserVOAsync:^(id object, NSError *error) {
        UserVO *userVO = object;
        //非业务系统管理员
        if(userVO.role!=3){
            
            if ([self.chartType isEqualToString:@"host"]) {
                [self.hostVO getHostVOAsync:^(id object, NSError *error) {
                    self.hostVO = object;
                    
                    if ([self.hostVO.state isEqualToString:@"OK"]) {
                        [self.hostVO getPerformanceAsync:^(id object, NSError *error) {
                            self.performanceData = object;
                            [_bridge callHandler:@"testJavascriptHandler" data:self.performanceData];
                             self.parentViewController.parentViewController.navigationItem.rightBarButtonItem.enabled = true;
                        } withStartTime:self.startTime];
                    }else{
                        [_bridge callHandler:@"testJavascriptHandler" data:@"无法获取性能数据！"];
                         self.parentViewController.parentViewController.navigationItem.rightBarButtonItem.enabled = true;
                    }
                }];
                
             }else if([self.chartType isEqualToString:@"vm"]){
                 [self.vmVO getVmVOAsync:^(id object, NSError *error) {
                     self.vmVO = object;
                
                     if ([self.vmVO.state isEqualToString:@"OK"] && (!self.vmVO.operationState || [self.vmVO.operationState isEqualToString:@""]) ) {
                         [self.vmVO getPerformanceAsync:^(id object, NSError *error) {
                             self.performanceData = object;
                             [_bridge callHandler:@"sendVcpuCount" data:[NSString stringWithFormat:@"%d",self.vmVO.vcpu ]];
                             [_bridge callHandler:@"testJavascriptHandler" data:self.performanceData];
                             self.parentViewController.parentViewController.navigationItem.rightBarButtonItem.enabled = true;
                         } withStartTime:self.startTime];
                     }else{
                         [_bridge callHandler:@"testJavascriptHandler" data:@"无法获取性能数据！"];
                         self.parentViewController.parentViewController.navigationItem.rightBarButtonItem.enabled = true;
                     }
                 }];
                
             }
        }else{
            //[_bridge callHandler:@"testJavascriptHandler" data:@"无法获取性能数据！"];
            //self.parentViewController.parentViewController.navigationItem.rightBarButtonItem.enabled = true;
            [_bridge callHandler:@"businessUser" data:@"业务管理员不能查看性能数据！"];
        }
        
    }];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [self reloadData];

}

-(void)queryData{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:self.startTimeStr];
    NSTimeInterval time=[date timeIntervalSince1970]*1000;
    self.startTime = (float)time;
    [self reloadData];
}
- (IBAction)selectDate:(id)sender {
    
    
    NSDate *selectDate = [self.datepicker date];
    NSDate *selectTime = [self.timepicker date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"];
    
    NSString *date =  [dateFormatter1 stringFromDate:selectDate];
    NSString *time =  [dateFormatter2 stringFromDate:selectTime];
    
    NSString *dateAndTime = [NSString stringWithFormat:@"%@ %@",date,time ];
    
    NSDateFormatter *dateFormatter3=[[NSDateFormatter alloc]init];
    [dateFormatter3 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateSelect=[dateFormatter3 dateFromString:dateAndTime];
    
    NSDate *Now = [NSDate new];
    NSTimeInterval result=[Now timeIntervalSinceDate:dateSelect];
    if (result<=0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"选择的日期不能大于或者等于当前日期！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        [self hideDatepickerView];
        self.startTimeStr = dateAndTime;
        [_bridge callHandler:@"setStartTime" data:[NSString stringWithFormat:@"%@",dateAndTime ]];
    }
    
}

- (void) showDatepickerView
{
    [_bridge callHandler:@"webviewShowLayer" data:@"遮罩"];
    [UIView animateWithDuration:0.3 animations:^{
        self.datepickerView.frame = CGRectMake(-20, 311, 1019, 202);
    }];
}
- (void) hideDatepickerView
{
    [_bridge callHandler:@"webviewHideLayer" data:@"遮罩"];
    [UIView animateWithDuration:0.3 animations:^{
        self.datepickerView.frame = CGRectMake(-20, 524, 1019, 202);
    }];
}

@end
