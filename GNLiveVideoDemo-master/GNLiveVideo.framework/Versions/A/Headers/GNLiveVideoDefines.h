//
//  GNLiveVideoDefines.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

/*!
 *  @brief  推流会话的状态定义
 *
 *  @since v1.0.0
 */

typedef NS_ENUM(NSInteger, GNLiveVideoSessionState)
{
    GNLiveVideoSessionStateNone,            // 默认的未启动状态
    GNLiveVideoSessionStateStarting,        // 推流启动中
    GNLiveVideoSessionStateStarted,         // 推流已启动
    GNLiveVideoSessionStateEnded,           // 推流已结束
    GNLiveVideoSessionStateError            // 推流有错误
};

