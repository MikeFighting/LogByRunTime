 //
//  UIViewController+HYSwizzle.m
//  Bidding
//
//  Created by Mike on 5/30/16.
//  Copyright © 2016 bj.58.com. All rights reserved.
//

#import "UIViewController+HYSwizzle.h"
#import "ZHSwizzleTool.h"
#import "ZHLogEventDataCenter.h"
#import "MFLogParamPram.h"
#import "MFLogPropertyParam.h"
#import "MFLogModel.h"
#import <objc/runtime.h>
#import "Aspects.h"

NSString * const kMFUploadLogNotificationKey = @"MFUploadLogNotificationKey";

@implementation UIViewController (HYSwizzle)

+ (void)load{
    
    static dispatch_once_t dispatch_once_token;
    dispatch_once(&dispatch_once_token, ^{
        
        SEL originlSelector = @selector(viewWillAppear:);
        SEL newSelector = @selector(swizzledViewWillAppear:);
        [ZHSwizzleTool zhSwizzleWithClass:[self class ] originalSelector:originlSelector swizzleSelector:newSelector];
    });
}

- (void)swizzledViewWillAppear:(BOOL)animated{
    
    NSArray<MFLogModel *> *logModels = [self p_fetchMetaModels];
    for (MFLogModel *logModel in logModels) {
        NSString *logClassName = logModel.className;
        NSString *selfClassName = NSStringFromClass([self class]);
        if (NO == [selfClassName isEqualToString:logClassName]) {
            continue;
        }
        [self p_aopForLogModel:logModel];
    }
    [self swizzledViewWillAppear:animated];
}

- (void)p_aopForLogModel:(MFLogModel *)logModel {
    
    SEL originSEL = NSSelectorFromString(logModel.method);
    NSString *className = logModel.className;
    Class HookClass = NSClassFromString(className);
    if (HookClass == nil || originSEL == nil) {
        return;
    }

    [HookClass aspect_hookSelector:originSEL withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> info, ...){
                               
       NSMutableDictionary *resultDic = [[NSMutableDictionary alloc]initWithDictionary:logModel.params];
       NSArray *arguments = [info arguments];
       NSDictionary *paramDic = [self p_getParamInfoWithMetaDatas:logModel.argumentParams
                                                      paramInfos:arguments];
       [resultDic addEntriesFromDictionary:paramDic];
       id methodOwner = [info instance];
       NSDictionary *propertyDic = [self p_getPropertyInfoWithMetaDatas:logModel.propertyParams instance:methodOwner];
       [resultDic addEntriesFromDictionary:propertyDic];
       NSLog(@"LogInfo == %@",resultDic);
                               
     }
                                error:nil];
    
}

- (NSDictionary *)p_getPropertyInfoWithMetaDatas:(NSArray <MFLogPropertyParam *>*)mateDatas
                                        instance:(id)instance {
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    for (MFLogPropertyParam *model in mateDatas) {
        NSString *path = model.path;
        NSString *key = model.key;
        if (path.length == 0 || key.length == 0) {
            // TODO: 这里需要给服务端发送异常报警
            continue;
        }
        NSString *value = [instance valueForKeyPath:path] ?: @"";
        [resultDic setValue:value forKey:key];
    }
    return resultDic;
}

- (NSDictionary *)p_getParamInfoWithMetaDatas:(NSArray <MFLogParamPram *>*)mateDatas
                                   paramInfos:(NSArray *)params {
    
    if (mateDatas.count == 0 || params.count == 0) {
        return nil;
    }
    NSMutableDictionary *resultParams = [NSMutableDictionary dictionary];
    for (MFLogParamPram *logParam in mateDatas) {
        if (logParam.position >= params.count) {
            // TODO: 这里需要给服务端发送异常报警
            continue;
        }
        if (logParam.key.length == 0) {
            // TODO: 这里需要给服务端发送异常报警
            continue;
        }
        NSString *keyPath = logParam.path;
        id param = params[logParam.position];
        id paramValue = [param valueForKeyPath:keyPath];
        [resultParams setValue:paramValue forKey:logParam.key];
    }
    
    return resultParams;
    
}

- (ZHLogEventDataCenter *)p_getLogCenter {
 
    return [[ZHLogEventDataCenter alloc]init];
}

- (NSArray *)p_fetchMetaModels {
    
    NSString *pathString = [[NSBundle mainBundle]pathForResource:@"Loginfo" ofType:@"json"];
    NSData *jsonData = [[NSData alloc]initWithContentsOfFile:pathString];
    NSDictionary *plistDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingAllowFragments
                                                               error:nil];
    NSArray *logs = plistDic[@"logs"];
    NSMutableArray *logModels = [NSMutableArray array];
    for (NSDictionary *dic in logs) {
        MFLogModel *logModel = [[MFLogModel alloc]initWithDic:dic];
        [logModels addObject:logModel];
    }
    
    return logModels;
}

@end
