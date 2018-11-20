//
// MFLogReadyParam.m
// Pods-58tongcheng 
//
// Created by Mike on 2018/11/13 
//


#import "MFLogReadyParam.h"
@interface MFLogReadyParam()

@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, copy, readwrite) NSString *id;
@property (nonatomic, copy, readwrite) NSString *text;
@property (nonatomic, copy, readwrite) NSString *abtest;

@end

@implementation MFLogReadyParam

- (instancetype)initWithDic:(NSDictionary *)rawDic {
    return nil;
}

@end
