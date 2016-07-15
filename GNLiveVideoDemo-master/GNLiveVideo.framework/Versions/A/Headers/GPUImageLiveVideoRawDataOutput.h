//
//  GPUImageLiveVideoRawDataOutput.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GPUImage/GPUImageRawDataOutput.h>
#import <GPUImage/GPUImageVideoCamera.h>

#import "GNLiveVideoDefines.h"

typedef void (^GPUImageLiveVideoRawDataOutputSampleSessionBlock)(NSInteger videoRate);
typedef void (^GPUImageLiveVideoRawDataOutputSessionStateBlock)(GNLiveVideoSessionState state);

@class GPUImageVideoCamera;

/*!
 *  视频直播推流入口类。派生自 GPUImage 的视频数据输出类，以 GPUImageViewCamera 作为视频采集设备，并提供推流相关的接口。
 *
 *  @since v1.0.0
 */

@interface GPUImageLiveVideoRawDataOutput : GPUImageRawDataOutput

@property (nonatomic, copy) GPUImageLiveVideoRawDataOutputSampleSessionBlock sampleSessionHandler; // 返回推流会话中的吞吐量
@property (nonatomic, copy) GPUImageLiveVideoRawDataOutputSessionStateBlock sessionStateHandler; // 返回推流回话的状态流转

/*!
 *  @brief  初始化方法。接受一个 GPUImageViewCamera 作为视频采集摄入设备资源，以及期望的视频帧尺寸，
 *          和一个 block 来返回推流的吞吐量预测
 *
 *  @param videoCamera          GPUImageViewCamera 实例
 *  @param videoSize            视频帧尺寸
 *  @param sampleSessionHandler 返回推流的预测吞吐量
 *  @param sessionStateHandler  返回推流会话状态变更
 *
 *  @return GPUImageLiveVideoRawDataOutput 实例
 *
 *  @since v1.0.0
 */
- (instancetype)initWithVideoCamera:(GPUImageVideoCamera *)videoCamera withVideoSize:(CGSize)videoSize sampleSessionHandler:(GPUImageLiveVideoRawDataOutputSampleSessionBlock)sampleSessionHandler sessionStateHandler:(GPUImageLiveVideoRawDataOutputSessionStateBlock)sessionStateHandler;

/*!
 *  @brief  初始化方法。接受一个 GPUImageViewCamera 作为视频采集摄入设备资源，以及期望的视频帧尺寸，
 *          和一个 block 来返回推流的吞吐量预测
 *
 *  @param videoCamera          GPUImageViewCamera 实例
 *  @param videoSize            视频帧尺寸
 *  @param bitrate              推流的速度。单位是 kbps。如果没有指定，默认是 500kbps。具体的对照表，请参见 GDLiveVideoDefines.h
 *  @param sampleSessionHandler 返回推流的预测吞吐量
 *  @param sessionStateHandler  返回推流会话状态变更
 *
 *  @return GPUImageLiveVideoRawDataOutput 实例
 *
 *  @since v1.0.0
 */
- (instancetype) initWithVideoCamera:(GPUImageVideoCamera *)videoCamera withVideoSize:(CGSize)videoSize bitrate:(NSInteger)bitrate sampleSessionHandler:(GPUImageLiveVideoRawDataOutputSampleSessionBlock)sampleSessionHandler sessionStateHandler:(GPUImageLiveVideoRawDataOutputSessionStateBlock)sessionStateHandler;

/*!
 *  @brief  启动推流会话
 *
 *  @param  roomId              房间号
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)startUploadStreamWithRoomId:(NSString *)roomId;

- (void)startUploadStreamWithURL:(NSString *)rtmpUrl andStreamKey:(NSString *)streamKey;


/*!
 *  @brief  停止推流会话
 *
 *  @param  无
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)stopUploadStream;

/*!
 *  @brief  处理音频缓冲区(暂未用)
 *
 *  @param audioBuffer          来自摄像头的音频缓冲
 *
 *  @return 无
 *
 *  @since v1.0.0
 */
- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer;

@end
