//
//  UIImage+GNPadding.h
//  LiveVideoSDK
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GNPadding)

+ (UIImage *)createPaddedInputImage:(UIImage *)inputImage inputSize:(CGSize)inputSize outputPosition:(CGPoint)outputPosition;

@end
