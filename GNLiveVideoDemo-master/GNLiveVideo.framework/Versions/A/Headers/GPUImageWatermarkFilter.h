//
//  GPUImageWatermarkFilter.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

#import <GPUImage/GPUImage.h>

// SDK 内置的水印位置类型

typedef NS_ENUM(NSInteger, GPUImageWatermarkLocation) {
    GPUImageWatermarkLocationTopLeft,
    GPUImageWatermarkLocationBottomLeft,
    GPUImageWatermarkLocationTopRight,
    GPUImageWatermarkLocationBottomRight
};

/*!
 *  基于 GPUImage 的水印滤镜。
 *
 *  @since v1.0.0
 */

@interface GPUImageWatermarkFilter : GPUImageFilterGroup

@property (nonatomic, strong)NSArray *watermarkImages;               // 水印的图像
@property (nonatomic, assign)GPUImageWatermarkLocation location;     // 水印的位置。SDK 内置的几个标准位置
@property (nonatomic, assign)CGRect customLocation; // 水印的位置和大小。用户自定义具体的位置和大小
@property (nonatomic, assign)CGFloat alpha;         // 水印的透明度，取值范围在 0.0~1.0 之间。默认是 1.0

- (instancetype)initWithWatermarkImages:(NSArray *)watermarkImages dockImageSize:(CGSize)dockImageSize location:(GPUImageWatermarkLocation)location;

@end
