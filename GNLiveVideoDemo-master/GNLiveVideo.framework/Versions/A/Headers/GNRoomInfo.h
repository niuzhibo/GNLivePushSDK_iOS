//
//  GNRoomInfo.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

/*!
 *  视频直播间数据模型。
 *
 *  @since v1.0.0
 */

#import <Foundation/Foundation.h>

@interface GNRoomInfo : NSObject

@property (nonatomic, strong) NSString *roomId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *roomDescription;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *rtmpPlayUrl;
@property (nonatomic, strong) NSString *h5PlayUrl;
@property (nonatomic, strong) NSString *hlsPlayUrl;
@property (nonatomic, strong) NSString *hlsReplayUrl;
@property (nonatomic, strong) NSString *chatId;
@property (nonatomic, assign) NSInteger createdAt;

@end
