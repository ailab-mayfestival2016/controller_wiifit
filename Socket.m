//
//  Socket.m
//  WiiScale
//
//  Created by 安部謙太朗 on 2016/04/28.
//  Copyright © 2016年 Dmitri Amariei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Socket.h"

@implementation WiiScaleSocket
-(id)init{
    self = [super init];
    if (self){
        NSURL* url = [[NSURL alloc] initWithString:@"abe://localhost:8080"];
        
        socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"log": @YES, @"forcePolling": @YES}];
        
        [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
            NSLog(@"socket connected");
        }];
        
        [socket on:@"currentAmount" callback:^(NSArray* data, SocketAckEmitter* ack) {
            double cur = [[data objectAtIndex:0] floatValue];
            
            [socket emitWithAck:@"canUpdate" withItems:@[@(cur)]](0, ^(NSArray* data) {
                [socket emit:@"update" withItems:@[@{@"amount": @(cur + 2.50)}]];
            });
            
            [ack with:@[@"Got your currentAmount, ", @"dude"]];
        }];
        
        [socket connect];
    }
    
    return self;
}
/*
-(IBAction)send:(id)sender{
    NSLog(@"SENDING SOCKET");
    [socket emit:@"from_client" withItems:[NSArray arrayWithObjects:@"Socket from ABE", nil]];
    NSLog(@"SENDED SOCKET");
}*/

@end