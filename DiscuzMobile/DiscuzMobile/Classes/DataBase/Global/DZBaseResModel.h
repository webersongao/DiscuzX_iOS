//
//  DZBaseResModel.h
//  DiscuzMobile
//
//  Created by WebersonGao on 2019/11/27.
//  Copyright © 2019 comsenz-service.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DZBaseVarModel.h"

@interface DZBaseResModel : NSObject

@property (nonatomic, copy) NSString *Version;  //!< API版本
@property (nonatomic, copy) NSString *Charset;  //!< 字符编码
@property (nonatomic, strong) DZBaseVarModel *Variables;  //!< 属性注释
@property (nonatomic, strong) DZBackMsgModel *Message;  //!< 属性注释

-(BOOL)isAuthorized;



@end

