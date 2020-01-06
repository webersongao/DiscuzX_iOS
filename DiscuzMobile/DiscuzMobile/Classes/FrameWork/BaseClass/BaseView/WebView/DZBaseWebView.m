//
//  DZBaseWebView.m
//  DiscuzMobile
//
//  Created by WebersonGao on 2020/1/3.
//  Copyright © 2020 comsenz-service.com. All rights reserved.
//

#import "DZBaseWebView.h"

@implementation DZBaseWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    WKWebViewConfiguration * wkWebConfig = [self baseWebViewConfig];
    self = [super initWithFrame:frame configuration:wkWebConfig];
    if (self) {
        
    }
    return self;
}

-(WKWebViewConfiguration *)baseWebViewConfig{
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;
    return wkWebConfig;
}


@end






