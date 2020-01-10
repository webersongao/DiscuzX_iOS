//
//  DZWebView.h
//  ebook
//
//  Created by zy.
//  Copyright (c) 2015年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewApi.h"

@protocol CommenWebViewDelegate <NSObject>

@optional
- (void)dz_CommonWebViewDidStartLoad;
- (void)dz_CommonWebViewDidFinishLoad:(id)active;
- (void)dz_CommonWebViewDidFailLoad;
- (void)dz_CommonWebViewShouldStartLoadWithData:(id)data;
- (void)updateWebViewTitle:(id)data;
- (void)dz_CommonWebViewDidDeceleratingEndWithScrollView:(UIScrollView *)scrollView;
- (void)dz_CommonWebViewBeginDragWithScrollView:(UIScrollView *)scrollView;

@end

//统一的webview封装
//内部含有诸多的webview的使用限定，比如说不能上下滑动等
//内部含有和webview的交互（和js交互）
@interface DZWebView : WKWebView <WKNavigationDelegate>
{
    WebViewBridge* bridge;//库里用来和webview进行交互的核心类，不处理具体事务
    WebViewApi* pWebapi; //自己写的，处理webview交互的具体事务的类
}

@property(nonatomic,copy) NSString *urlLoad;
@property(nonatomic,readonly)  WebViewApi* pWebapi;
@property(nonatomic,weak) id <CommenWebViewDelegate> IydDelegate;

@property (nonatomic, assign) BOOL isAjax;  //!< 是否执行Js,默认为YES

- (NSString*)addPublicParamToWebUrl:(NSString*)webUrl encode:(BOOL)needEncode;
/*如果没有下拉刷新，是否控制web滚动到边界的时候就停止
 *
 */
- (void)setScroller:(BOOL)canScro;
/*根据页面添加是否需要下拉刷新
 *
 */
- (void)refrshViewInitWithInsertFlag:(BOOL)insertFlag;
/*
 *检测是否动画需要执行
 */
- (void)checkRestartLoadingAnimation;
- (void)removeRefreshHeaderView;

-(void)startLoadRequest:(NSString *)urlStr;
-(void)startLoadRequestWithLocalPath:(NSString *)localPath;

- (void)completeProgress;

@end

