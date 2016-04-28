//
//  MyObject.m
//  WiiScale
//
//  Created by 安部謙太朗 on 2016/04/25.
//  Copyright © 2016年 Dmitri Amariei. All rights reserved.
//

#import "MyObject.h"
#import <Foundation/Foundation.h>

@implementation MyObject

- (void)printLogString:(NSString *)str Value:(float)x{
    NSLog(@"\n%@: %f", str, x);
}

- (void)observeValueForKeyPath:(NSString *)keyPath     //Class
                      ofObject:(id)object              //Object
                        change:(NSDictionary *)change  //the way of change
                       context:(void *)context {
    if ([keyPath isEqual:@"weightBL"] || [keyPath isEqual:@"weightTL"] || [keyPath isEqual:@"weightBR"] || [keyPath isEqual:@"weightTR"]){
        NSLog(@"%@: %@", keyPath, change[NSKeyValueChangeNewKey]);
    }
}


@end
