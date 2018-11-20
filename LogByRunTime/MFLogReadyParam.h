//
// MFLogReadyParam.h
// Pods-58tongcheng 
//
// Created by Mike on 2018/11/13 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFLogReadyParam: NSObject
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) NSString *abtest;

- (instancetype)initWithDic:(NSDictionary *)rawDic;

@end

NS_ASSUME_NONNULL_END