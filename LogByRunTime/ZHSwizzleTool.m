//
//  ZHSwizzleTool.m
//  BornToTry
//
//  Created by Mike on 5/23/16.
//  Copyright © 2016 itemei. All rights reserved.
//

#import "ZHSwizzleTool.h"
#import <objc/runtime.h>

@implementation ZHSwizzleTool

+(void)zhSwizzleWithClass:(Class)processedClass originalSelector:(SEL)originSelector swizzleSelector:(SEL)swizzlSelector{

    
    Method originMethod = class_getInstanceMethod(processedClass, originSelector);
    Method swizzleMethod = class_getInstanceMethod(processedClass, swizzlSelector);
    
    BOOL didAddMethod = class_addMethod(processedClass, originSelector, method_getImplementation(swizzleMethod), method_getTypeEncoding(swizzleMethod));
    
    if (didAddMethod) {
        
        class_replaceMethod(processedClass, swizzlSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        
    }else{
    
        method_exchangeImplementations(originMethod, swizzleMethod);
    
    }
    
    
}
@end
