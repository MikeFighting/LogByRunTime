//
//  MFLogModel.h
//  LogByRunTime
//
//  Created by Mike on 2018/11/20.
//  Copyright © 2018 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MFLogParamPram;
@class MFLogPropertyParam;

@interface MFLogModel : NSObject

@property (nonatomic, copy, readonly) NSString *method;
@property (nonatomic, copy, readonly) NSString *className;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, strong, readonly) NSArray <MFLogParamPram *>*argumentParams;
@property (nonatomic, strong, readonly) NSArray <MFLogPropertyParam *>*propertyParams;

- (instancetype)initWithDic:(NSDictionary *)aDic;

@end

NS_ASSUME_NONNULL_END
