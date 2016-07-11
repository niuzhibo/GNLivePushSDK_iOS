//
//  GPUImageInteractiveMotionFilter.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

#import <GPUImage/GPUImage.h>

/*!
 *  基于 GPUImage 的水印滤镜。
 *
 *  @since v1.0.0
 */

@interface GPUImageInteractiveMotionFilter : GPUImageFilterGroup

@property (nonatomic, strong)NSArray *motionImages;     // 动效的图像
@property (nonatomic, assign)CGFloat alpha;             // 动效的透明度，取值范围在 0.0~1.0 之间。默认是 1.0

- (instancetype)initWithMotionImages:(NSArray *)motionImages dockImageSize:(CGSize)dockImageSize;

@end
