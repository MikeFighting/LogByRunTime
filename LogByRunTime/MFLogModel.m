//
//  MFLogModel.m
//  LogByRunTime
//
//  Created by Mike on 2018/11/20.
//  Copyright © 2018 Mike. All rights reserved.
//

#import "MFLogModel.h"
#import "MFLogPropertyParam.h"
#import "MFLogParamPram.h"
@interface MFLogModel()

@property (nonatomic, copy, readwrite) NSString *method;
@property (nonatomic, copy, readwrite) NSString *className;
@property (nonatomic, strong, readwrite) NSDictionary *params;
@property (nonatomic, strong, readwrite) NSArray<MFLogParamPram *> *argumentParams;
@property (nonatomic, strong, readwrite) NSArray<MFLogPropertyParam *> *propertyParams;

@end

@implementation MFLogModel

- (instancetype)initWithDic:(NSDictionary *)aDic {

    self = [super init];
    if (nil == self) {
        return nil;
    }
    NSString *method = aDic[@"method"];
    NSArray *classAndMethod = [method componentsSeparatedByString:@"#"];
    if (2 != classAndMethod.count) {
        return nil;
    }
    self.className = [classAndMethod firstObject];
    self.method = [classAndMethod lastObject];
    self.params = aDic[@"params"];
    NSMutableArray <MFLogParamPram *> *parameterParams = [NSMutableArray array];
    NSArray *parameterDatas = aDic[@"parameterParams"];
    for (NSDictionary *dic in parameterDatas) {
        MFLogParamPram *paramModel = [[MFLogParamPram alloc]initWithDic:dic];
        [parameterParams addObject:paramModel];
    }
    self.argumentParams = parameterParams;
    NSMutableArray <MFLogPropertyParam *> *propertyModels = [NSMutableArray array];
    NSArray *propertyDatas = aDic[@"attributeParams"];
    for (NSDictionary *attributeDic in propertyDatas) {
        MFLogPropertyParam *propertyModel = [[MFLogPropertyParam alloc]initWithDic:attributeDic];
        [propertyModels addObject:propertyModel];
    }
    self.propertyParams = propertyModels;
    
    return self;
}

@end
