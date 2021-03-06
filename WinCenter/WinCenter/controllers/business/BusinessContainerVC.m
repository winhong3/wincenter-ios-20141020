//
//  BusinessContainerVC.m
//  WinCenter-iPad
//
//  Created by apple on 14-10-5.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "BusinessContainerVC.h"
#import "BusinessVmCollectionVC.h"
#import "BusinessDetailInfoVC.h"

@implementation BusinessContainerVC

-(void) reloadData{
    [self.businessVO getBusinessVOAsync:^(id object, NSError *error) {
        self.businessVO = object;
        [self refreshMainInfo];
    }];
}

-(void)refreshMainInfo{
    self.pathLabel.text = [RemoteObject getCurrentDatacenterVO].name;
    self.titleLabel.text = self.businessVO.name;
    self.name.text = self.businessVO.name;
    if (self.name.text.length > 26) {
        self.name.font = [UIFont systemFontOfSize:24.0f];
    }
    self.title = self.businessVO.name;
}

-(void)refresh{
    [self refreshMainInfo];
    
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:1];
    
    BusinessDetailInfoVC *vc = [self.storyboard instantiateViewController:@"BusinessDetailInfoVC"];
    vc.businessVO = self.businessVO;
    [pages addObject:vc];

    BusinessVmCollectionVC *vmCollectionVC = [self.storyboard instantiateViewController:@"BusinessVmCollectionVC"];
    vmCollectionVC.businessVO = self.businessVO;
    [pages addObject:vmCollectionVC];
    
    self.pages = pages;
    
    [super refresh];
}

@end
