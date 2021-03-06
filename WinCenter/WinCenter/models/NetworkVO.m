//
//  NetworkVO.m
//  wincenterDemo01
//
//  Created by 黄茂坚 on 14-8-28.
//  Copyright (c) 2014年 黄茂坚. All rights reserved.
//

#import "NetworkVO.h"

@implementation NetworkVO

-(NSString*) state_text{
    if([self.state isEqualToString:@"CONNECTED"]){
        return @"已连接";
    }else if([self.state isEqualToString:@"FREE"]){
        return @"可用";
    }else if([self.state isEqualToString:@"IN_USED"]){
        return @"在用";
    }else{
        return @"其他";
    }
}

-(UIColor*) state_color{
    if([self.state isEqualToString:@"CONNECTED"]){
        return PNGreen;
    }else if([self.state isEqualToString:@"FREE"]){
        return PNBlue;
    }else if([self.state isEqualToString:@"IN_USED"]){
        return PNYellow;
    }else{
        return PNBlue;
    }
}

-(NSString*) vlanId_text{
    if([self.vlanId rangeOfString:@"-" options:NSCaseInsensitiveSearch].length>0){
        return @"无";
    }else{
        return self.vlanId;
    }
}

-(NSString*) linkState_image{
    if([self.linkState isEqualToString:@"CONNECTED"]){
        return @"链接";
    }else if([self.linkState isEqualToString:@"DISCONNECTED"]){
        return @"断开链接";
    }else{
        return @"部分链接";
    }
}

- (void) getVmsByNetworkIdAsync:(FetchObjectCompletionBlock)completionBlock{
    if([[[NSUserDefaults standardUserDefaults] stringForKey:@"isDemo"] isEqualToString:@"true"]){
        completionBlock([NSArray arrayOfType:VmVO.class FromJSONData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NetworkVO.getVmsByNetworkIdAsync" ofType:@"json"]]], nil);
        return;
    }
    
    [[UNIRest get:^(UNISimpleRequest *simpleRequest) {
        [simpleRequest setUrl:[NSString stringWithFormat:@"/restServlet?connectorId=%d&apiKey=pc.winserver.vm.vmsByNetworkId&apiType=GET&placeholder=%d",[RemoteObject getCurrentDatacenterVO].id, self.networkId]];
    }] asJsonAsync:^(UNIHTTPJsonResponse *jsonResponse, NSError *error) {
        completionBlock([NSArray arrayOfType:VmVO.class FromJSONData:jsonResponse.rawBody], error);
    }];
}

@end
