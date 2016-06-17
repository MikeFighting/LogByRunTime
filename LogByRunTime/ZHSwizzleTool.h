//
//  ZHSwizzleTool.h
//  BornToTry
//
//  Created by Mike on 5/23/16.
//  Copyright © 2016 itemei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHSwizzleTool : NSObject

// 互换实现的工具类
+ (void)zhSwizzleWithClass:(Class)processedClass originalSelector:(SEL)originSelector swizzleSelector:(SEL)swizzlSelector;

@end
