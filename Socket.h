//
//  Socket.h
//  WiiScale
//
//  Created by 安部謙太朗 on 2016/04/29.
//  Copyright © 2016年 Dmitri Amariei. All rights reserved.
//
//  Reference: http://egg-is-world.com/2014/12/10/swift-generated-header/

#ifndef Socket_h
#define Socket_h

#import "WiiScale-Swift.h"


@interface WiiScaleSocket : NSObject{
    SocketIOClient* socket;
}

-(id)init;

@end

#endif /* Socket_h */
