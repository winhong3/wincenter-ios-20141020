//
//  NetworkMainVC.m
//  wincenterDemo01
//
//  Created by huadi on 14-8-15.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "NetworkContainerVC.h"
#import <REFrostedViewController/REFrostedViewController.h>

@interface NetworkContainerVC ()
@property UIPopoverController *popover;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *name;

@end

@implementation NetworkContainerVC

- (IBAction)showMenu:(id)sender {
    [self.frostedViewController presentMenuViewController];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[RemoteObject getCurrentDatacenterVO] getDatacenterVOAsync:^(id object, NSError *error) {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if(!self.navigationItem.leftBarButtonItem){
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
        }
        self.navigationItem.leftBarButtonItem.title = ((DatacenterVO *)object).name;
        }
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if(!self.navigationItem.leftBarButtonItem){
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showMenu:)];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)showWarningInfoVC:(id)sender{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Warning" bundle:nil] instantiateInitialViewController];
        UIViewController *vc = [[nav childViewControllers] firstObject];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if(self.popover!=nil){
            [self.popover dismissPopoverAnimated:NO];
        }
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"Warning" bundle:nil] instantiateInitialViewController];
        self.popover = [[UIPopoverController alloc] initWithContentViewController:vc];
        UIBarButtonItem *button = (UIBarButtonItem*)sender;
        [self.popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

-(IBAction)showControlRecordVC:(id)sender{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Task" bundle:nil] instantiateInitialViewController];
        UIViewController *vc = [[nav childViewControllers] firstObject];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if(self.popover!=nil){
            [self.popover dismissPopoverAnimated:NO];
        }
        UINavigationController *nav = [[UIStoryboard storyboardWithName:@"Task" bundle:nil] instantiateInitialViewController];
        self.popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        UIBarButtonItem *button = (UIBarButtonItem*)sender;
        [self.popover presentPopoverFromBarButtonItem:button permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
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
