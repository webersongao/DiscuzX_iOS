//
//  DZApiRequest.m
//  DiscuzMobile
//
//  Created by ZhangJitao on 2018/3/23.
//  Copyright © 2018年 comsenz-service.com.  All rights reserved.
//

#import "DZApiRequest.h"
#import "MessageNoticeCenter.h"

@implementation DZApiRequest

+ (void)requestWithConfig:(JTRequestConfig)config success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    
    [self requestWithConfig:config progress:nil success:^(id responseObject, JTLoadType type) {
        [self publicDo:responseObject];
        
        NSArray *cookieArr = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies;
        DLog(@"-开始----⚠️----");
//        for (NSHTTPCookie *cookie in cookieArr) {
            DLog(@"WBS Cookies is %@ \n",cookieArr);
//        }
        DLog(@"-结束-⚠️---❤️---⚠️");
        success(responseObject,type);
    } failed:^(NSError *error) {
        if (failed) {
            failed(error);
        }
    }];
}

+ (void)requestWithConfig:(JTRequestConfig)config progress:(JTProgressBlock)progress success:(JTRequestSuccess)success failed:(JTRequestFailed)failed{
    
    [JTRequestManager requestWithConfig:^(JTURLRequest *request) {
        config ? config(request) : nil;
        request.urlString = [self checkUrl:request.urlString];
#ifndef MACRO_PRODUCT
        [self rebuiltUrlParams:request.parameters url:request.urlString];
#endif
    } progress:progress success:^(id responseObject, JTLoadType type) {
        success(responseObject,type);
    } failed:^(NSError *error) {
        failed(error);
    }];
}

+(void)rebuiltUrlParams:(NSDictionary *)rootDictionary url:(NSString *)requestUrl{
    
    DLog(@"请求链接：requestURL is \n\n %@ \n\n",[DataCheck rebuiltParams:rootDictionary url:requestUrl]);
}

/**
 是否缓存过了
 
 @param urlString 地址
 @param parameters 传递的参数
 @return 是否
 */
+ (BOOL)isCache:(NSString *)urlString andParameters:(id)parameters {
    JTURLRequest *request = [[JTURLRequest alloc] init];
    request.urlString = [self checkUrl:urlString];
    if (parameters != nil) {
        request.parameters = parameters;
    }
    return [[JTRequestOperation shareInstance] isCache:request];
}

+ (void)cancelRequest:(NSString *)urlString getParameter:(NSDictionary *)getParam completion:(JTCancelCompletedBlock)completion {
    if([urlString isEqualToString:@""]||urlString==nil)return;
    NSString *urlStr = [self checkUrl:urlString];
    [JTRequestManager cancelRequest:urlStr getParameter:getParam completion:completion];
}

+ (NSString *)checkUrl:(NSString *)urlStr {
    
    urlStr = [NSString stringWithFormat:@"api/mobile/%@",urlStr];
    NSString *domain = [[NSUserDefaults standardUserDefaults] stringForKey:KRoot_Domainkey];
    if ([DataCheck isValidString:domain]) {
        urlStr = [NSString stringWithFormat:@"%@%@",domain,urlStr];
    } else {
        urlStr = [NSString stringWithFormat:@"%@%@",DZ_BASEURL,urlStr];
    }
    urlStr = [urlStr stringByAppendingString:@"&mobiletype=IOS"];
    return urlStr;
}

// 掌上论坛公共处理
+ (void)publicDo:(id)responseObject {
    if ([DataCheck isValidDict:[responseObject objectForKey:@"Variables"]]) { // 公共提醒
        [[DZMobileCtrl sharedCtrl] updateGlobalFormHash:[[responseObject dictionaryForKey:@"Variables"] stringForKey:@"formhash"]];
        if ([DZLoginModule isLogged]) {
            if ([DataCheck isValidDict:[[responseObject dictionaryForKey:@"Variables"] dictionaryForKey:@"notice"]]) { //公共提醒
                [MessageNoticeCenter shared].noticeDic = [NSMutableDictionary dictionaryWithDictionary:[[responseObject dictionaryForKey:@"Variables"] objectForKey:@"notice"]];
            }
        }
        return;
    }
    NSString *error = [responseObject objectForKey:@"error"];
    if ([DataCheck isValidString:error] && [error hasSuffix:@"module_not_exists"]) {
        [MBProgressHUD showInfo:@"该模块暂未开放"];
    }
}

@end
