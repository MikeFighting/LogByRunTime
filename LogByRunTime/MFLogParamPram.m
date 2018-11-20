//
// MFLogParamPram.m
// Pods-58tongcheng 
//
// Created by Mike on 2018/11/13 
//

#import "MFLogParamPram.h"
@interface MFLogParamPram()

@property (nonatomic, assign, readwrite) NSInteger position;
@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, copy, readwrite) NSString *path;

@end

@implementation MFLogParamPram

- (instancetype)initWithDic:(NSDictionary *)rawDic {
    self = [super init];
    if (self) {
        self.position = [rawDic[@"position"] integerValue];
        self.key = rawDic[@"key"] ?: @"";
        self.path = rawDic[@"path"] ?: @"";
    }
    return self;
}

@end
