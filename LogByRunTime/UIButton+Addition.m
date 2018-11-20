//
//  UIButton+Addition.m
//  LogByRunTime
//
//  Created by Mike on 6/17/16.
//  Copyright © 2016 Mike. All rights reserved.
//

#import "UIButton+Addition.h"
#import <objc/runtime.h>
@implementation UIButton (Addition)

static NSInteger buttonKey;

- (void)setZhLogTitle:(NSString *)zhLogTitle{

    objc_setAssociatedObject(self, &buttonKey, zhLogTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}
- (NSString *)zhLogTitle{

  return  objc_getAssociatedObject(self, &buttonKey);
    
}
@end
