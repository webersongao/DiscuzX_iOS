//
//  DZLoginModule.m
//  DiscuzMobile
//
//  Created by gensinimac1 on 15/5/7.
//  Copyright (c) 2015年 comsenz-service.com. All rights reserved.
//

#import "DZLoginModule.h"
#import "DZPushCenter.h"
#import "DZShareCenter.h"
#import "DZUserNetTool.h"

NSString * const CookieValue = @"COOKIEVALU";

@implementation DZLoginModule

+ (void)saveLoginData:(DZLoginResModel *)resModel andHandle:(void(^)(void))handle{
    
    // 普通登录或者登录成功
    [DZMobileCtrl sharedCtrl].Global = resModel.Variables;
    [DZLoginModule saveLocalGlobalInfo:resModel.Variables];
    NSString *cookirStr = [DZMobileCtrl sharedCtrl].Global.authKey;
    for (NSHTTPCookie * cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        if ([[cookie name] isEqualToString:checkNull(cookirStr)]) {
            [DZLoginModule saveCookie:cookie];
        }
    }
    handle?handle():nil;
}

+(BOOL)loginAnylyeData:(DZLoginResModel *)resModel{
    
    if (resModel.Message && !resModel.Message.isSuccessed) {
        [MBProgressHUD showInfo:resModel.Message.messagestr];
        return NO;
    }
    
    if(!resModel.Variables.auth.length) {
        [MBProgressHUD showInfo:resModel.Message.messagestr];
        return NO;
    }
    
    if (!resModel.Variables.member_uid.length) {
        [MBProgressHUD showInfo:@"未能获取到您的用户id"];
        return NO;
    }
    
    if (!resModel.Message.isBindThird) {
        // 去第三方绑定页面
        [[DZMobileCtrl sharedCtrl] PushToJudgeBindController];
        return NO;
    }
    
    return YES;
}

/*
 * 判断是否登录
 */
+ (BOOL)isLogged {
    NSString *auth = [DZMobileCtrl sharedCtrl].Global.auth;
    NSString *uid = [DZMobileCtrl sharedCtrl].Global.member_uid;
    if ([DataCheck isValidString:uid] && [DataCheck isValidString:auth]) {
        return YES;
    }
    return NO;
}

/*
 * 退出登录
 */
+ (void)signout {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:CookieValue];
    [[DZPushCenter shareInstance] configPush];
    for (NSHTTPCookie *cookie in [NSHTTPCookieStorage sharedHTTPCookieStorage].cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
    //  LoginFile
    [[DZLocalContext shared] removeLocalGloabalInfo];
    [DZShareCenter shareInstance].bloginModel = nil;
}

/*
 * 设置自动登录状态
 */

+ (void)setAutoLogin {
    DZGlobalModel *user = [[DZLocalContext shared] GetLocalGlobalInfo];
    if (user.member_uid.length) {
        [self setHttpCookie:[self getCookie]];
    }
}

/*
 * 保存登录信息到本地
 */
+ (void)saveLocalGlobalInfo:(DZGlobalModel *)varinfo {
    [[DZLocalContext shared] updateLocalGlobal:varinfo];
}

// 获取当前登录的uid
+ (NSString *)getLoggedUid {
    NSString *uid = [DZMobileCtrl sharedCtrl].Global.member_uid;
    if (![DataCheck isValidString:uid]) {
        uid = @"0";
    }
    return uid;
}

#pragma mark - cookie
// 检查cookie
+ (void)checkCookie {
    if ([self isLogged]) {
        [DZUserNetTool DZ_UserProfileFromServer:YES Uid:nil userBlock:^(DZUserVarModel *UserVarModel, NSString *errorStr) {
            if (errorStr.length) {
                [DZLoginModule signout];
                DLog(@"WBS Cookie 过期");
            }
        }];
    }
}

+ (void)setHttpCookie:(NSHTTPCookie *)cookie {
    if (cookie) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
}

// 保存cookie
+ (void)saveCookie:(NSHTTPCookie *)cookie {
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:cookie];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:CookieValue];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSHTTPCookie *)getCookie {
    NSData * data = [[NSUserDefaults standardUserDefaults] objectForKey:CookieValue];
    NSHTTPCookie * cookie_PD = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return cookie_PD;
}


@end

