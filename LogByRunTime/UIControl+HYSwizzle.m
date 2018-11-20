//
//  UIControl+HYSwizzle.m
//  Bidding
//
//  Created by Mike on 5/30/16.
//  Copyright © 2016 bj.58.com. All rights reserved.
//

#import "UIControl+HYSwizzle.h"
#import "ZHSwizzleTool.h"
#import "ZHLogEventDataCenter.h"
#import <objc/runtime.h>
@implementation UIControl (HYSwizzle)

+(void)load{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originSEL = @selector(sendAction:to:forEvent:);
        SEL swizzleSEL = @selector(swizzleSendAction:to:forEvent:);
        Class processedClass = [self class];
        Method originMethod = class_getInstanceMethod(processedClass, originSEL);
        Method swizzleMethod = class_getInstanceMethod(processedClass, swizzleSEL);
        method_exchangeImplementations(originMethod, swizzleMethod);
    });
}

- (void)swizzleSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    
    // 1.先执行原来的方法，以防止有和类上下文有关的数值
    [self swizzleSendAction:action to:target forEvent:event];
    NSString *selectorName = NSStringFromSelector(action);
    NSString *pathString = [[NSBundle mainBundle]pathForResource:@"HYLogInfoDataCenter" ofType:@"plist"];
    NSDictionary *plistDic = [NSDictionary dictionaryWithContentsOfFile:pathString];
    
    // 2.获取某个类的方法列表
    NSDictionary *classMthodDic = plistDic[NSStringFromClass([target class])];
    
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
        
        // 满足条件
        if (conditionValues[1] == [target valueForKey:conditionValues[0]]) {
            
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
            NSString *valueString = @"";
            NSArray *paraArray = [paraString componentsSeparatedByString:@"&"];
            if ([paraArray[1] isEqualToString:@"zhLogTitle"]) {
            
            valueString = [self valueForKey:@"zhLogTitle"];
                
            }else{
                
            valueString = [target valueForKey:paraArray[1]];
           
            }
            
             [logInfoDic setObject:valueString forKey:paraArray[0]];
            
        }else{
        
            SEL paraSel = NSSelectorFromString(paraString);
            if ([logCenter respondsToSelector:paraSel]) {
                
                NSString *valueString = [logCenter performSelector:paraSel withObject:nil];
                [logInfoDic setObject:valueString forKey:paraString];
            }

        }
        
    }

    if ([logInfoDic allValues].count) {
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"showLogResult" object:logInfoDic];
        NSLog(@"需存到本地以备上传的数据:%@",logInfoDic);
        
    }
    
}


@end
