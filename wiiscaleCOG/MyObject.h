//
//  MyObject.h
//  WiiScale
//
//  Created by 安部謙太朗 on 2016/04/25.
//  Copyright © 2016年 Dmitri Amariei. All rights reserved.
//

#ifndef MyObject_h
#define MyObject_h

@interface MyObject : NSObject{
    float TR;
    float TL;
    float BR;
    float BL;
}

- (void)printLogString:(NSString *)str Value:(float)x;

- (void)observeValueForKeyPath:(NSString *)keyPath     //Class
                      ofObject:(id)object              //Object
                        change:(NSDictionary *)change  //the way of change
                       context:(void *)context ;

@end


#endif /* MyObject_h */
