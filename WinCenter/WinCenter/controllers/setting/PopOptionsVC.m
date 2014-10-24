//
//  OptionsVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-25.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "PopOptionsVC.h"
#import <TOWebViewController/TOWebViewController.h>
#import <THPinViewController/THPinViewController.h>

@interface PopOptionsVC ()
@property int remainingPinEntries;
@property NSString *correctPin;
@end

@implementation PopOptionsVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.remainingPinEntries = 3;
    self.correctPin = @"1234";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSUInteger)pinLengthForPinViewController:(THPinViewController *)pinViewController
{
    return 4;
}

- (BOOL)pinViewController:(THPinViewController *)pinViewController isPinValid:(NSString *)pin
{
    if ([pin isEqualToString:self.correctPin]) {
        return YES;
    } else {
        self.remainingPinEntries--;
        return NO;
    }
}

- (BOOL)userCanRetryInPinViewController:(THPinViewController *)pinViewController
{
    return (self.remainingPinEntries > 0);
}

- (void)showPinView{
    THPinViewController *pinViewController = [[THPinViewController alloc] initWithDelegate:self];
    pinViewController.promptTitle = @"Enter PIN";
    pinViewController.promptColor = [UIColor darkTextColor];
    pinViewController.view.tintColor = [UIColor darkTextColor];
    pinViewController.hideLetters = YES;
    
    // for a solid color background, use this:
    pinViewController.backgroundColor = [UIColor whiteColor];
    
    // for a translucent background, use this:
    self.view.tag = THPinViewControllerContentViewTag;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    pinViewController.translucentBackground = YES;
    
    [self presentViewController:pinViewController animated:YES completion:nil];
    
    // mandatory delegate methods
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(indexPath.row == 3){
            [self showPinView];
        }
    }else if(indexPath.section==2){
        if(indexPath.row==1){
            TOWebViewController *webView = [[TOWebViewController alloc] initWithURLString:@"http://support.winhong.com"];
            [self.navigationController pushViewController:webView animated:YES];
        }else if(indexPath.row==2){
            TOWebViewController *webView = [[TOWebViewController alloc] initWithURLString:@"https://192.168.100.147:8090/pages/help/helpWord.htm"];
            [self.navigationController pushViewController:webView animated:YES];

        }
    }
}
@end
