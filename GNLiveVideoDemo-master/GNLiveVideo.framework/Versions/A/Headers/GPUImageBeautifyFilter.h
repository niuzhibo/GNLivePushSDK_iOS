//
//  GPUImageBeautifyFilter.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

#import <GPUImage/GPUImage.h>

/*!
 *  基于 GPUImage 的美颜滤镜。
 *
 *  @since v1.0.0
 */

@interface GPUImageBeautifyFilter : GPUImageFilterGroup

@property (nonatomic, strong)UIImage *watermarkImage;

@end
