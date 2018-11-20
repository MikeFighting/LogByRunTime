//
// MFLogParamPram.h
// Pods-58tongcheng 
//
// Created by Mike on 2018/11/13 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFLogParamPram: NSObject

@property (nonatomic, assign, readonly) NSInteger position;
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, copy, readonly) NSString *path;

- (instancetype)initWithDic:(NSDictionary *)rawDic;

@end

NS_ASSUME_NONNULL_END
