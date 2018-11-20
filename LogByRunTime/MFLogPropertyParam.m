//
// MFLogPropertyParam.m
// Pods-58tongcheng 
//
// Created by Mike on 2018/11/13 
//


#import "MFLogPropertyParam.h"
@interface MFLogPropertyParam()

@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, copy, readwrite) NSString *path;

@end

@implementation MFLogPropertyParam

- (instancetype)initWithDic:(NSDictionary *)rawDic {

    self = [super init];
    if (self) {
        self.key = rawDic[@"key"] ?: @"";
        self.path = rawDic[@"path"] ?: @"";
     }
    return self;
}

@end
