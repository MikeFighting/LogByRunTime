 //
//  UIViewController+HYSwizzle.m
//  Bidding
//
//  Created by Mike on 5/30/16.
//  Copyright © 2016 bj.58.com. All rights reserved.
//

#import "UIViewController+HYSwizzle.h"
#import "ZHSwizzleTool.h"
#import "ZHLogEventDataCenter.h"
#import <objc/runtime.h>
#import "Aspects.h"

NSString * const kMFUploadLogNotificationKey = @"MFUploadLogNotificationKey";

@implementation UIViewController (HYSwizzle)

+ (void)load{
    
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        
        // swizzle the system
        SEL originlSelector = @selector(viewWillAppear::);
        SEL newSelector = @selector(swizzledViewWillAppear:);
        [ZHSwizzleTool zhSwizzleWithClass:[self class ] originalSelector:originlSelector swizzleSelector:newSelector];
    });
}

- (void)swizzledViewWillAppear:(BOOL)animated{
    
    NSDictionary *plistDic = [self p_fetchMetaDatas];
    NSDictionary *classMthodDic = plistDic[NSStringFromClass([self class])];
    if (classMthodDic == nil) {
        return;
    }
    NSArray *methodNameArray = [classMthodDic allKeys];
    for (NSString *methodString in methodNameArray) {
        
        __block SEL originalSEL = NSSelectorFromString(methodString);
        BOOL isResponseOriginSEL = [self respondsToSelector:originalSEL];
        NSRange controlActionRange = [methodString rangeOfString:@"ControlAction"];
        BOOL notControlAction = controlActionRange.length == 0 ? YES : NO;
        if (isResponseOriginSEL && notControlAction) {
            
            [[self class] aspect_hookSelector:originalSEL withOptions:AspectPositionAfter
                                   usingBlock:^(id<AspectInfo> info, ...){
                
                NSArray *arguments = [info arguments];
                id methodOwner = [info instance];
//                NSDictionary *fullValueDic =
                }
                                        error:nil];
        }
    }
    [self swizzledViewWillAppear:animated];
}

- (ZHLogEventDataCenter *)p_getLogCenter {
 
    return [[ZHLogEventDataCenter alloc]init];
}

- (NSDictionary *)p_fetchMetaDatas {
    
    NSString *pathString = [[NSBundle mainBundle]pathForResource:@"Loginfo" ofType:@"json"];
    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:pathString];
    return plistDic;
}

@end
