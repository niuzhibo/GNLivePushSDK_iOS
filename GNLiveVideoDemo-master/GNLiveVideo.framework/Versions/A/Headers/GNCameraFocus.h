//
//  UIImage+GNPadding.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

//
//  FastttFocus.h
//  FastttCamera
//
//  Created by Laura Skelton on 3/2/15.
//
//

#import <UIKit/UIKit.h>

@protocol GNCameraFocusDelegate;

/**
 *  处理对焦的私有类
 */
@interface GNCameraFocus : NSObject

/**
 *  GNCameraFocus 实例的 delegate
 */
@property (nonatomic, weak) id <GNCameraFocusDelegate> delegate;

/**
 *  是否探测单击手势。如果不探测，则使用者自行处理对焦
 *
 *  默认是 YES
 */
@property (nonatomic, assign) BOOL detectsTaps;

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
 *  @return GNCameraFocus 实例
 */
+ (instancetype)cameraFocusWithView:(UIView *)view gestureDelegate:(id <UIGestureRecognizerDelegate>)gestureDelegate;

/**
 *  如果手动处理对焦，则调用此函数
 *
 *  @param location 在窗体上手势点击产生的位置值
 */
- (void)showFocusViewAtPoint:(CGPoint)location;

@end

#pragma mark - GNCameraFocusDelegate

@protocol GNCameraFocusDelegate <NSObject>

/**
 *  探测单击手势，并将单击位置传给 delegate
 *
 *  @param touchPoint 探测到单击手势在窗体上的位置
 *
 *  @return 摄像头支持单击动作，则为 YES。否则为 NO
 */
- (BOOL)handleTapFocusAtPoint:(CGPoint)touchPoint;

@end
