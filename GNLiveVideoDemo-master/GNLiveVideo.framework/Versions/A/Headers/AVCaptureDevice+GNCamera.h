//
//  UIImage+GNPadding.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

//
//  AVCaptureDevice+FastttCamera.h
//  FastttCamera
//
//  Created by Laura Skelton on 3/2/15.
//
//

#import <AVFoundation/AVFoundation.h>

/**
 *  管理摄像头输入设备 AVCaptureDevice 的私有 category
 */
@interface AVCaptureDevice (GNCamera)

/**
 *  检测设备是否具备对焦和变焦能力
 *
 *  @param cameraDevice 输入设备
 *
 *  @return 如果设备具备则返回 YES，否则返回 NO
 */
+ (BOOL)isPointFocusAvailableForCameraDevice:(AVCaptureDevice *)cameraDevice;

/**
 *  设备的最大变焦倍数
 *
 *  @return 最大变焦倍数
 */
- (CGFloat)videoMaxZoomFactor;

/**
 *  将摄像头变焦到指定的倍数
 *
 *  @param zoomScale 指定的变焦倍数
 *
 *  @return 如果变焦成功则返回 YES，否则返回 NO
 */
- (BOOL)zoomToScale:(CGFloat)zoomScale;

/**
 *  获取当前摄像头是前摄像头还是后摄像头
 *
 *  @param cameraDevice 摄像头设备
 *
 *  @return AVCaptureDevicePosition
 */
+ (AVCaptureDevicePosition)positionForCameraDevice:(AVCaptureDevice *)cameraDevice;

/**
 *  通知摄像头对焦到指定的区域
 *
 *  @param pointOfInterest 指定区域
 *
 *  @return 如果设备可以对焦则返回 YES，否则返回 NO
 */
- (BOOL)focusAtPointOfInterest:(CGPoint)pointOfInterest;

@end
