//
//  DZDiscoverNetTool.h
//  PandaReader
//
//  Created by WebersonGao on 2018/10/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DZDiscoverNetTool : NSObject

+ (void)getForumCategoryInfo:(BOOL)isReload forum:(void(^)(NSArray *cateList,NSArray *forumList))forumBlock;







@end

NS_ASSUME_NONNULL_END