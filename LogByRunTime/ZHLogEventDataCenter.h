//
//  ZHLogEventDataCenter.h
//  LogByRunTime
//
//  Created by Mike on 6/17/16.
//  Copyright © 2016 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHLogEventDataCenter : NSObject

/**用户id*/
@property (nonatomic,copy) NSString *sa;
/**操作时间*/
@property (nonatomic,copy) NSString *cq;
/**用户名*/
@property (nonatomic,copy) NSString *userName;

@end
