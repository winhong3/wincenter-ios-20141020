//
//  NetworkTotalTabelVC.m
//  WinCenter
//
//  Created by 黄茂坚 on 14/10/29.
//  Copyright (c) 2014年 huadi. All rights reserved.
//

#import "NetworkTotalTabelVC.h"
#import "NetworkTotalTableCell.h"
#import "NetworkCollectionVC.h"

@interface NetworkTotalTabelVC ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property NSArray *networkList;
@property NSMutableDictionary *ipPoolsDict;
@end

@implementation NetworkTotalTabelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //    加ip池信息
    [[RemoteObject getCurrentDatacenterVO] getIpPoolsAsync:^(NSArray *allRemote, NSError *error) {
        
        self.ipPoolsDict = [NSMutableDictionary new];
        for(IpPoolsVO *poolVO in allRemote){
            NSString *vlanList = poolVO.vlanIdList;
            if(vlanList){
                NSArray *vlans = [vlanList componentsSeparatedByString:@","];
                for(NSString *vlan in vlans){
                    [self.ipPoolsDict setObject:poolVO forKey:vlan];
                }
            }
        }
        
        [[RemoteObject getCurrentDatacenterVO] getNetworkOutsideAsync:^(NSArray *allRemote, NSError *error) {
            self.networkList = allRemote;
            [self.tableView reloadData];
        }];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.networkList.count;
}

- (IBAction)segmentChange:(id)sender {
    if(self.segment.selectedSegmentIndex==0){
        [[RemoteObject getCurrentDatacenterVO] getNetworkOutsideAsync:^(NSArray *allRemote, NSError *error) {
            self.networkList = allRemote;
            [self.tableView reloadData];
            
        }];
        
    }else{
        [[RemoteObject getCurrentDatacenterVO] getNetworkInsideAsync:^(NSArray *allRemote, NSError *error) {
            self.networkList = allRemote;
            [self.tableView reloadData];
            
        }];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.segment.selectedSegmentIndex==0) {
        NetworkTotalTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NetworkTotalTableCell_Outside" forIndexPath:indexPath];
        
        NetworkVO *network = self.networkList[indexPath.row];
        IpPoolsVO *ipPoolVO = [self.ipPoolsDict objectForKey:network.vlanId];
        cell.name.text = network.name;
        cell.vlan.text = network.vlanId;
        cell.linkState.image = [UIImage imageNamed:[network linkState_image]];
        cell.state.text = [network state_text];
        cell.state.textColor = [network state_color];
        cell.state_image.layer.cornerRadius = 6;
        cell.state_image.backgroundColor = [network state_color];
        cell.ipSegment.text = ipPoolVO.segment;
        cell.ipTotal.text = [NSString stringWithFormat:@"%d",ipPoolVO.total];
        cell.ipUsable.text = [NSString stringWithFormat:@"%d",ipPoolVO.usable];
        cell.ipUsed.text = [NSString stringWithFormat:@"%d",ipPoolVO.used];
        
        return cell;
    }else
    {
        NetworkTotalTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NetworkTotalTableCell_Inside" forIndexPath:indexPath];
        
        NetworkVO *network = self.networkList[indexPath.row];
        cell.name.text = network.name;
        cell.linkState.image = [UIImage imageNamed:[network linkState_image]];
        cell.state.text = [network state_text];
        cell.state.textColor = [network state_color];
        cell.state_image.layer.cornerRadius = 6;
        cell.state_image.backgroundColor = [network state_color];
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.segment.selectedSegmentIndex==0) {
        return 170;
    }else{
        return 100;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NetworkVO *network = self.networkList[indexPath.row];
    IpPoolsVO *ipPoolVO = [self.ipPoolsDict objectForKey:network.vlanId];
    
    UISplitViewController *splitVC = (UISplitViewController*) self.parentViewController.parentViewController;
    UINavigationController *nav = [[splitVC childViewControllers] lastObject];
    NetworkCollectionVC *detailVC = [[nav childViewControllers] firstObject];
    detailVC.ipPoolVO = ipPoolVO;
    [detailVC reloadData];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
