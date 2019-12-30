//
//  webviewApi.h
//  ebook
//
//  Created by zy on 12-2-27.
//  Copyright (c) 2015年. All rights reserved.
//

#import "WebviewBridge.h"
#import "WebJsInteractionDelegate.h"

//webviewApi用来和webview进行交互的实体工作类
//内部处理了很多的apiName，通过delegate通知给具体的某个ui
@interface WebviewApi : NSObject<WebviewClientExecuteable>

@property(weak,nonatomic) id<WebJsInteractionDelegate> delegate;

+ (BOOL)handleRedirectUrl:(NSString *)url;
+ (BOOL)isAppOpenUrl:(NSString*)url;

@end
