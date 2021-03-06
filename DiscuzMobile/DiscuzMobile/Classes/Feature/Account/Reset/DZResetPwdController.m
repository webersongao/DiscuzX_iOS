//
//  DZResetPwdController.m
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/11/17.
//  Copyright © 2019年 comsenz-service.com.  All rights reserved.
//

#import "DZResetPwdController.h"
#import "DZResetPwdView.h"
#import "DZAuthCodeView.h"
#import "DZLoginNetTool.h"
#import "DZLoginTextField.h"

@interface DZResetPwdController ()
@property (nonatomic,strong) DZResetPwdView *resetView;
@end

@implementation DZResetPwdController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.resetView];
    self.dz_NavigationItem.title = @"修改密码";
    
    [_resetView.submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    KWEAKSELF;
    self.resetView.authCodeView.refreshAuthCodeBlock = ^{
        [weakSelf downlodyan];
    };
    
    [self downlodyan];
}

#pragma mark - 验证码
- (void)downlodyan {
    
    [self.verifyView downSeccode:@"password" success:^{
        if (self.verifyView.isyanzhengma) {
            [self.resetView.authCodeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(50);
            }];
            self.resetView.authCodeView.hidden = NO;
        }
        
        [self loadSeccodeImage];
    } failure:^(NSError *error) {
        [self showServerError:error];
    }];
    
}


- (void)loadSeccodeImage {
    
    [self.resetView.authCodeView loadRequestWithCodeUrl:self.verifyView.secureData.seccode];
    
}

- (void)submitButtonClick {
    
    [self.view endEditing:YES];
    NSString *oldpassword = self.resetView.passwordView.userNameTextField.text;
    NSString *newpassword1 = self.resetView.newpasswordView.userNameTextField.text;
    NSString *newpassword2 = self.resetView.repassView.userNameTextField.text;
    
    if ([DataCheck isValidString:oldpassword] && [DataCheck isValidString:newpassword1] && [DataCheck isValidString:newpassword2]) { // 全部按要求填了
        if (![newpassword1 isEqualToString:newpassword2]) {
            [MBProgressHUD showInfo:@"请确定两次输入的密码相同"];
        } else { // 所有都输入了，去注册
            [self postResetData];
        }
    } else { // 未按要求填或者有空
        if (![DataCheck isValidString:oldpassword]) {
            [MBProgressHUD showInfo:@"请输入旧密码" ];
        } else if (![DataCheck isValidString:newpassword1]) {
            [MBProgressHUD showInfo:@"请输入新密码"];
        } else if (![DataCheck isValidString:newpassword2]) {
            [MBProgressHUD showInfo:@"请重复新密码"];
        }
    }
    
}

- (void)postResetData {
    NSString *oldpassword = self.resetView.passwordView.userNameTextField.text;
    NSString *newpassword1 = self.resetView.newpasswordView.userNameTextField.text;
    NSString *newpassword2 = self.resetView.repassView.userNameTextField.text;
    //    NSString *email = [DZMobileCtrl sharedCtrl].Global.email;
    
    NSMutableDictionary *postDic = @{@"oldpassword":oldpassword,
                                     @"newpassword":newpassword1,
                                     @"newpassword2":newpassword2,
                                     //          @"emailnew":email?email:@"",
                                     @"passwordsubmit":@"true",
                                     @"formhash":[DZMobileCtrl sharedCtrl].Global.formhash}.mutableCopy;
    if (self.verifyView.isyanzhengma) {
        [postDic setValue:self.resetView.authCodeView.textField.text forKey:@"seccodeverify"];
        [postDic setValue:self.verifyView.secureData.sechash forKey:@"sechash"];
    }
    [self.HUD showLoadingMessag:@"正在提交" toView:self.view];
    [DZLoginNetTool DZ_UserResetPasswordWithPostDic:postDic completion:^(DZBaseResModel *resModel) {
        [self.HUD hide];
        if (resModel) {
            if ([resModel.Message isSuccessed]) {
                [MBProgressHUD showInfo:@"修改密码成功，请重新登录"];
                [DZLoginModule signout];
                [self.navigationController popViewControllerAnimated:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:DZ_UserSigOut_Notify object:nil];
            } else {
                [MBProgressHUD showInfo:resModel.Message.messagestr];
            }
        }else{
            [MBProgressHUD showInfo:@"修改密码失败~~"];
        }
    }];
    
}


-(DZResetPwdView *)resetView{
    if (!_resetView) {
        _resetView = [[DZResetPwdView alloc] initWithFrame:KView_OutNavi_Bounds];
        _resetView.delegate = self;
    }
    return _resetView;
}

@end
