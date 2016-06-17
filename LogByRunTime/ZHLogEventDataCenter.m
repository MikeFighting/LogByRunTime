//
//  ZHLogEventDataCenter.m
//  LogByRunTime
//
//  Created by Mike on 6/17/16.
//  Copyright © 2016 Mike. All rights reserved.
//

#import "ZHLogEventDataCenter.h"

@implementation ZHLogEventDataCenter

// 这些数据可以用统一类或者宏来管理，从中获取；
- (NSString *)sa{
    
    return @"userID";
}

- (NSString *)cq{
    
    return  @"currentTime";
    
}
- (NSString *)userName{
    
    return @"userName";
    
}

@end
