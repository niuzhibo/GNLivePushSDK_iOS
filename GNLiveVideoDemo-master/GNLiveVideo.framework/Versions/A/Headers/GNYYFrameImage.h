//
//  YYFrameImage.h
//  GNYYImage <https://github.com/ibireme/GNYYImage>
//
//  Created by ibireme on 14/12/9.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<GNYYImage/GNYYImage.h>)
#import <GNYYImage/GNYYAnimatedImageView.h>
#elif __has_include(<YYWebImage/GNYYImage.h>)
#import <YYWebImage/GNYYAnimatedImageView.h>
#else
#import "GNYYAnimatedImageView.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 An image to display frame-based animation.
 
 @discussion It is a fully compatible `UIImage` subclass.
 It only support system image format such as png and jpeg.
 The animation can be played by GNYYAnimatedImageView.
 
 Sample Code:
     
     NSArray *paths = @[@"/ani/frame1.png", @"/ani/frame2.png", @"/ani/frame3.png"];
     NSArray *times = @[@0.1, @0.2, @0.1];
     GNYYFrameImage *image = [GNYYFrameImage alloc] initWithImagePaths:paths frameDurations:times repeats:YES];
     GNYYAnimatedImageView *imageView = [GNYYAnimatedImageView alloc] initWithImage:image];
     [view addSubView:imageView];
 */
@interface GNYYFrameImage : UIImage <GNYYAnimatedImage>

/**
 Create a frame animated image from files.
 
 @param paths            An array of NSString objects, contains the full or 
                         partial path to each image file.
                         e.g. @[@"/ani/1.png",@"/ani/2.png",@"/ani/3.png"]
 
 @param oneFrameDuration The duration (in seconds) per frame.
 
 @param loopCount        The animation loop count, 0 means infinite.
 
 @return An initialized GNYYFrameImage object, or nil when an error occurs.
 */
- (nullable instancetype)initWithImagePaths:(NSArray<NSString *> *)paths
                           oneFrameDuration:(NSTimeInterval)oneFrameDuration
                                  loopCount:(NSUInteger)loopCount;

/**
 Create a frame animated image from files.
 
 @param paths          An array of NSString objects, contains the full or
                       partial path to each image file.
                       e.g. @[@"/ani/frame1.png",@"/ani/frame2.png",@"/ani/frame3.png"]
 
 @param frameDurations An array of NSNumber objects, contains the duration (in seconds) per frame.
                       e.g. @[@0.1, @0.2, @0.3];
 
 @param loopCount      The animation loop count, 0 means infinite.
 
 @return An initialized GNYYFrameImage object, or nil when an error occurs.
 */
- (nullable instancetype)initWithImagePaths:(NSArray<NSString *> *)paths
                             frameDurations:(NSArray<NSNumber *> *)frameDurations
                                  loopCount:(NSUInteger)loopCount;

/**
 Create a frame animated image from an array of data.
 
 @param dataArray        An array of NSData objects.
 
 @param oneFrameDuration The duration (in seconds) per frame.
 
 @param loopCount        The animation loop count, 0 means infinite.
 
 @return An initialized GNYYFrameImage object, or nil when an error occurs.
 */
- (nullable instancetype)initWithImageDataArray:(NSArray<NSData *> *)dataArray
                               oneFrameDuration:(NSTimeInterval)oneFrameDuration
                                      loopCount:(NSUInteger)loopCount;

/**
 Create a frame animated image from an array of data.
 
 @param dataArray      An array of NSData objects.
 
 @param frameDurations An array of NSNumber objects, contains the duration (in seconds) per frame.
                       e.g. @[@0.1, @0.2, @0.3];
 
 @param loopCount      The animation loop count, 0 means infinite.
 
 @return An initialized GNYYFrameImage object, or nil when an error occurs.
 */
- (nullable instancetype)initWithImageDataArray:(NSArray<NSData *> *)dataArray
                                 frameDurations:(NSArray *)frameDurations
                                      loopCount:(NSUInteger)loopCount;

@end

NS_ASSUME_NONNULL_END
