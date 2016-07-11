//
//  GNLiveRoomManager.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

/*!
 *  视频直播间管理。
 *
 *  @since v1.0.0
 */

#import <UIKit/UIKit.h>

@class GNRoomInfo;

typedef void(^GNLiveRoomManagerRoomCreationBlock)(GNRoomInfo *room);
typedef void(^GNLiveRoomManagerRoomListBlock)(NSArray *roomList);
typedef void(^GNLiveRoomManagerStreamStartedBlock)(NSString *streamUrl);
typedef void(^GNLiveRoomManagerImageUploadedBlock)(NSString *imageUrl);
typedef void(^GNLiveRoomManagerCaptchaBlock)(NSString *captcha);
typedef void(^GNLiveRoomManagerSuccessBlock)(void);
typedef void(^GNLiveRoomManagerFailureBlock)(NSError *error);

typedef void(^GNLiveRoomManagerUserRegistrationBlock)(NSString *appKey);

@interface GNLiveRoomManager : NSObject

+ (instancetype)sharedInstance;

/*!
 *  @brief  创建直播间
 *
 *  @param roomName             直播间名称
 *  @param roomDescription      直播间描述
 *  @param roomCover            直播间封面
 *  @param roomCreationHandler  返回直播间数据模型
 *  @param failure              如果请求出错，返回错误
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)createLiveRoom:(NSString *)roomName roomDescription:(NSString *)roomDescription roomCoverUrl:(NSString *)roomCoverUrl roomCreationHandler:(GNLiveRoomManagerRoomCreationBlock)roomCreationHandler failure:(GNLiveRoomManagerFailureBlock)failure;

/*!
 *  @brief  更新直播间
 *
 *  @param roomName             直播间名称
 *  @param roomDescription      直播间描述
 *  @param roomCover            直播间封面
 *  @param roomCreationHandler  返回直播间数据模型
 *  @param failure              如果请求出错，返回错误
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)updateLiveRoom:(NSString *)roomName roomDescription:(NSString *)roomDescription roomCoverUrl:(NSString *)roomCoverUrl roomCreationHandler:(GNLiveRoomManagerRoomCreationBlock)roomCreationHandler failure:(GNLiveRoomManagerFailureBlock)failure;

/*!
 *  @brief  删除直播间
 *
 *  @param roomId               直播间唯一 ID
 *  @param success              没有错误，停止推流通知成功
 *  @param failure              如果请求出错，返回错误
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)deleteLiveRoom:(NSString *)roomId success:(GNLiveRoomManagerSuccessBlock)success failure:(GNLiveRoomManagerFailureBlock)failure;

/*!
 *  @brief  获取直播间列表
 *
 *  @param roomCreationHandler  返回登录用户的所有直播间列表
 *  @param failure              如果请求出错，返回错误
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)getLiveRoomList:(GNLiveRoomManagerRoomListBlock)roomListHandler failure:(GNLiveRoomManagerFailureBlock)failure;

/*!
 *  @brief  上传图片到服务器
 *
 *  @param imageUploadingHandler  返回图片的 URL
 *  @param failure                如果请求出错，返回错误
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)uploadImage:(UIImage *)image imageUploadingHandler:(GNLiveRoomManagerImageUploadedBlock)imageUploadingHandler failure:(GNLiveRoomManagerFailureBlock)failure;

/*!
 *  @brief  获取手机验证码
 *
 *  @param phoneNumber          手机号码
 *  @param captchaHandler       返回直播间数据模型
 *  @param failure              如果请求出错，返回错误
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)getCaptcha:(NSString *)phoneNumber captchaHandler:(GNLiveRoomManagerCaptchaBlock)captchaHandler failure:(GNLiveRoomManagerFailureBlock)failure;

/*!
 *  @brief  用户注册
 *
 *  @param phoneNumber          用户手机
 *  @param password             用户密码
 *  @param inviteCode           邀请码
 *  @param captcha              验证码
 *  @param success              没有错误，用户注册成功
 *  @param failure              如果请求出错，返回错误
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)registerUser:(NSString *)phoneNumber password:(NSString *)password inviteCode:(NSString *)inviteCode captcha:(NSString *)captcha registrationHandler:(GNLiveRoomManagerUserRegistrationBlock)registrationHandler failure:(GNLiveRoomManagerFailureBlock)failure;

/*!
 *  @brief  用户登录
 *
 *  @param phoneNumber          用户手机
 *  @param password             用户密码
 *  @param success              没有错误，用户登录成功
 *  @param failure              如果请求出错，返回错误
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)loginUser:(NSString *)phoneNumber password:(NSString *)password registrationHandler:(GNLiveRoomManagerUserRegistrationBlock)registrationHandler failure:(GNLiveRoomManagerFailureBlock)failure;


/*!
 *  @brief  通知直播间直播开始
 *
 *  @param rooomId              直播间唯一 ID
 *  @param steamStartedHandler  返回此直播间的推流地址
 *  @param failure              如果请求出错，返回错误
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)startLiveStreaming:(NSString *)roomId steamStartedHandler:(GNLiveRoomManagerStreamStartedBlock)steamStartedHandler failure:(GNLiveRoomManagerFailureBlock)failure;


/*!
 *  @brief  通知直播间直播停止
 *
 *  @param rooomId              直播间唯一 ID
 *  @param success              没有错误，停止推流通知成功
 *  @param failure              如果请求出错，返回错误
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)stopLiveStreaming:(NSString *)roomId success:(GNLiveRoomManagerSuccessBlock)success failure:(GNLiveRoomManagerFailureBlock)failure;

@end
