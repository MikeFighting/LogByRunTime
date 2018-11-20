//
//  MFLogModel.h
//  LogByRunTime
//
//  Created by Mike on 2018/11/20.
//  Copyright © 2018 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MFLogModel : NSObject

@property (nonatomic, copy, readonly) NSString *method;
@property (nonatomic, strong, readonly) NSArray *params;
@property (nonatomic, strong, readonly) NSArray *parameterParams;
@property (nonatomic, strong, readonly) NSArray *attributeParams;

- (instancetype)initWithDic:(NSDictionary *)aDic;

@end

NS_ASSUME_NONNULL_END
