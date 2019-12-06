//
//  DZUserNetTool.m
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/12/2.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//

#import "DZUserNetTool.h"
#import "DZApiRequest.h"
#import "UIImage+Limit.h"

@interface DZUserNetTool ()


@end

@implementation DZUserNetTool

+ (instancetype)sharedTool {
    static DZUserNetTool *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[DZUserNetTool alloc] init];
    });
    return helper;
}

- (void)DZ_CheckRegisterAPIRequest {
    [self DZ_CheckRequestSuccess:nil failure:nil];
}

- (void)DZ_CheckRegisterRequestSuccess:(void(^)(void))success failure:(void(^)(void))failure {
    [self DZ_CheckRequestSuccess:^{
        [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
            request.urlString = self.regUrl;
        } success:^(id responseObject, JTLoadType type) {
            NSDictionary *reginput = [[responseObject objectForKey:@"Variables"] objectForKey:@"reginput"];
            if ([DataCheck isValidDictionary:[responseObject objectForKey:@"Variables"]] &&  [DataCheck isValidDictionary:reginput]) {
                self.regKeyDic = [NSDictionary dictionaryWithDictionary:reginput];
            }
            success?success():nil;
        } failed:^(NSError *error) {
            failure?failure():nil;
        }];
    } failure:failure];
}

- (void)DZ_CheckRequestSuccess:(void(^)(void))success failure:(void(^)(void))failure {
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = DZ_Url_BaseCheck;
    } success:^(id responseObject, JTLoadType type) {
        NSString *regname = [responseObject objectForKey:@"regname"];
        if ([DataCheck isValidString:regname]) {
            NSString *regUrl = [NSString stringWithFormat:@"%@&mod=%@",DZ_Url_Register,regname];
            if ([DataCheck isValidString:[responseObject objectForKey:@"formhash"]]) {
                [Environment sharedEnvironment].formhash = [responseObject objectForKey:@"formhash"];
            }
            self.regUrl = regUrl;
        }
        success?success():nil;
    } failed:^(NSError *error) {
        failure?failure():nil;
    }];
}

+ (void)DZ_UserUpdateAvatarToServer:(UIImage *)avatarImg  progress:(ProgressBlock)backProgress completion:(backBoolBlock)completion{
    
    if (!completion) {
        return;
    }
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        NSData *data = [avatarImg limitImageSize];
        NSString *nowTime = [[NSDate date] stringFromDateFormat:@"yyyyMMddHHmmss"];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", nowTime];
        [request addFormDataWithName:@"Filedata" fileName:fileName mimeType:@"image/png" fileData:data];
        request.urlString = DZ_Url_UploadHead;
        request.methodType = JTMethodTypeUpload;
    } progress:^(NSProgress *progress) {
        if (backProgress) {
            backProgress((1.f * progress.completedUnitCount/progress.totalUnitCount),nil);
        }
    } success:^(id responseObject, JTLoadType type) {
        id resDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if ([DataCheck isValidDictionary:resDict] && [[[resDict dictionaryForKey:@"Variables"] stringForKey:@"uploadavatar"] containsString:@"success"] ) {
            completion(YES);
        }
    } failed:^(NSError *error) {
        completion(NO);
    }];
    
}




+ (void)DZ_UserProfileFromServer:(BOOL)isMe Uid:(NSString *)uid userBlock:(void(^)(DZUserVarModel *UserVarModel, NSString *errorStr))userBlock{
    
    if (!userBlock) {
        return;
    }
    [DZApiRequest requestWithConfig:^(JTURLRequest *request) {
        request.urlString = DZ_Url_UserInfo;
        if (isMe) {
            request.methodType = JTMethodTypePOST;
        }else{
            request.methodType = JTMethodTypeGET;
        }
        request.parameters = @{@"uid":checkNull(uid)};
    } success:^(id responseObject, JTLoadType type) {
        NSString *errorStr = nil;
        DZUserResModel *varModel = [DZUserResModel modelWithJSON:responseObject];
        if ([DataCheck isValidString:[responseObject objectForKey:@"error"]]){
            if ([[responseObject stringForKey:@"error"] isEqualToString:@"user_banned"]) {
                varModel = nil;
                errorStr = @"用户被禁止";
            }
        }else if ([varModel.Message.messagestr hasPrefix:@"请先登录后才能继续浏览"]){
            varModel = nil;
            errorStr = @"请先登录后才能继续浏览";
        }
        userBlock(varModel.Variables,errorStr);
    } failed:^(NSError *error) {
        userBlock(nil,error.localizedDescription);
    }];
    
}




@end
