//
//  DatacenterContainerTableVC.h
//  WinCenter-iPhone
//
//  Created by apple on 14-10-9.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatacenterTableVC.h"
#import "DatacenterDetailInfoVC.h"

@interface DashboardTableVC : UITableViewController<DatacenterTableVCDelegate>
@property DatacenterDetailInfoVC *infoVC;
@end
