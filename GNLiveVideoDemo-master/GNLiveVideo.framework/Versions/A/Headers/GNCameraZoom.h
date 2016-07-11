//
//  UIImage+GNPadding.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

//
//  FastttZoom.h
//  FastttCamera
//
//  Created by Laura Skelton on 3/5/15.
//
//

@import UIKit;

@protocol GNCameraZoomDelegate;

/**
 *  处理变焦的私有类
 */
@interface GNCameraZoom : NSObject

/**
 *  GNCameraZoom 实例的代理
 */
@property (nonatomic, weak) id <GNCameraZoomDelegate> delegate;

/**
 *  如果希望检测捏合手势，设为 YES，否则，如果希望手动变焦，则设为 NO
 *
 *  默认是 YES
 */
@property (nonatomic, assign) BOOL detectsPinch;

/**
 *  设置摄像头的最大变焦值
 */
@property (nonatomic, assign) CGFloat maxScale;

/**
 *  默认为 nil。如果需要自定义 UIGestureRecognizerDelegate 的一些设置，可以通过接口来设置此 gestureDelegate
 */
@property (nonatomic, weak) id <UIGestureRecognizerDelegate> gestureDelegate;

/**
 *  初始化函数
 *
 *  @param view 接收触摸事件的窗体
 *  @param gestureDelegate 处理手势的 delegate
 *
 *  @return GNCameraZoom 实例
 */
+ (instancetype)cameraZoomWithView:(UIView *)view gestureDelegate:(id <UIGestureRecognizerDelegate>)gestureDelegate;

/**
 *  手动处理变焦
 *
 *  @param zoomScale 变焦值。最低 1.0；默认也是 1.0，随着调节增大
 */
- (void)showZoomViewWithScale:(CGFloat)zoomScale;

/**
 *  切换摄像头的时候调用。变焦值切回默认的 1.0
 */
- (void)resetZoom;

@end

#pragma mark - GNCameraZoomDelegate

@protocol GNCameraZoomDelegate <NSObject>

/**
 *  探测到手势操作的时候调用此回调函数。并向 delegate 传递手势操作的缩放值
 *
 *  @param zoomScale 变焦值。最低 1.0；默认也是 1.0，随着调节增大
 *
 *  @return 如果摄像头允许变焦，则返回 YES，否则返回 NO
 */
- (BOOL)handlePinchZoomWithScale:(CGFloat)zoomScale;

@end
