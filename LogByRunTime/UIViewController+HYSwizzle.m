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
@implementation UIViewController (HYSwizzle)


+ (void)load{
    
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        
        // swizzle the system
        SEL originlSelector = @selector(viewDidAppear:);
        SEL newSelector = @selector(swizzleviewWillAppear:);
        [ZHSwizzleTool zhSwizzleWithClass:[self class ] originalSelector:originlSelector swizzleSelector:newSelector];
        
    });
    
}

- (void)swizzleviewWillAppear:(BOOL)animated{
    
    NSString *pathString = [[NSBundle mainBundle]pathForResource:@"HYLogInfoDataCenter" ofType:@"plist"];
    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:pathString];
    // 1.获取某个类的方法列表
    NSDictionary *classMthodDic = plistDic[NSStringFromClass([self class])];
    if (classMthodDic == nil) return; // 该类的方法不需要hook

    NSArray *methodNameArray = [classMthodDic allKeys];
    
    for (NSString *methodString in methodNameArray) {
        
        __block SEL originalSEL = NSSelectorFromString(methodString);
        // 这里需要判断是否是UIControl的事件，以防止两个地方同时hook，造成重复上传
        BOOL isResponseOriginSEL = [self respondsToSelector:originalSEL];
        
        NSRange controlActionRange = [methodString rangeOfString:@"ControlAction"];
        BOOL notControlAction = controlActionRange.length == 0 ? YES : NO;
        
        if (isResponseOriginSEL && notControlAction) {

        [[self class] aspect_hookSelector:originalSEL withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info){
                
                
                NSString *selectorName = NSStringFromSelector(originalSEL);
                NSString *pathString = [[NSBundle mainBundle]pathForResource:@"HYLogInfoDataCenter" ofType:@"plist"];
                NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:pathString];
                // 2.获取某个类的方法列表
                NSDictionary *classMthodDic = plistDic[NSStringFromClass([self class])];
                // 3.获取其中某个方法的参数列表
                NSArray *parameterArray = classMthodDic[selectorName];
                
                
                ZHLogEventDataCenter *logCenter = [[ZHLogEventDataCenter alloc]init];
                NSMutableDictionary *logInfoDic = [NSMutableDictionary dictionary];
                
                // 4.对已经知道数值的数据进行埋点的处理
                NSMutableDictionary *konwnParaDic = [NSMutableDictionary dictionaryWithDictionary:parameterArray[0]];
                NSString *coValueString = [konwnParaDic objectForKey:@"co"];
                if ([coValueString containsString:@"&"]) {
                    
                    NSArray *conditionValuesArray = [coValueString componentsSeparatedByString:@"&"];
                    
                    NSString *conditionString = conditionValuesArray[1];
                    NSArray *conditionValues = [conditionString componentsSeparatedByString:@"="];
                    
                    NSInteger conditionValue = [conditionValues[1] integerValue];
                    NSInteger actualValue = [[self valueForKey:conditionValues[0]] integerValue];
                    
                    // 满足条件
                    if (conditionValue == actualValue ) {
                        
                        [konwnParaDic setObject:conditionValuesArray[0] forKey:@"co"];
                        
                        // 不满足条件直接返回
                    }else{
                        
                        return;
                    }
                    
                }
                
                // 5.没有条件则直接处理
                [logInfoDic addEntriesFromDictionary:konwnParaDic];
                
                // 6.对其余的字符串进行相应的处理
                for (int i = 1; i < parameterArray.count; i ++) {
                    
                    NSString * paraString =parameterArray[i];
                    
                    if ([paraString containsString:@"&"]) {
                        
                        // 这个数值是需要从所在的类获取的
                        NSArray *paraArray = [paraString componentsSeparatedByString:@"&"];
                        NSString *valueString = [self valueForKey:paraArray[1]];
                        if (valueString.length) [logInfoDic setObject:valueString forKey:paraArray[0]];
                        
                    }else{
                        
                        SEL paraSel = NSSelectorFromString(paraString);
                        if ([logCenter respondsToSelector:paraSel]) {
                            
                            NSString *valueString = [logCenter performSelector:paraSel withObject:nil];
                            [logInfoDic setObject:valueString forKey:paraString];
                        }
                        
                        
                        
                    }
                    
                }
                
                if ([logInfoDic allValues].count) {
                    
                    NSLog(@"需存到本地以备上传的数据:%@",logInfoDic);
                    
                }
            
            } error:nil];

        }
}
    [self swizzleviewWillAppear:animated];

}

@end
