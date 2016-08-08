//
//  GNLiveVideoViewController.m
//  LiveVideoSDKDemo
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <GPUImage/GPUImageView.h>
#import <GPUImage/GPUImageFilter.h>
#import <AVFoundation/AVFoundation.h>
#import <GPUImage/GPUImageVideoCamera.h>
#import <GPUImage/GPUImageRawDataOutput.h>
#import <GPUImage/GPUImageMovieWriter.h>

#import <GNLiveVideo/UIImage+GNPadding.h>
#import <GNLiveVideo/GNRoomInfo.h>
#import <GNLiveVideo/GNLiveRoomManager.h>

#import <GNLiveVideo/AVCaptureDevice+GNCamera.h>

#import <GNLiveVideo/GNCameraFocus.h>
#import <GNLiveVideo/GNCameraZoom.h>
#import <GNLiveVideo/GNCameraUtils.h>
#import <GNLiveVideo/GNYYImage.h>

#import <GNLiveVideo/GNLiveVideoDefines.h>
#import <GNLiveVideo/GPUImageLiveVideoRawDataOutput.h>
#import <GNLiveVideo/GPUImageBeautifyFilter.h>
#import <GNLiveVideo/GPUImageWatermarkFilter.h>
#import <GNLiveVideo/GPUImageInteractiveMotionFilter.h>

#import "GNLiveVideoViewController.h"

typedef NS_ENUM(NSInteger, GDLiveVideoCameraFlashStatus) {
    GDLiveVideoCameraFlashStatusOn,
    GDLiveVideoCameraFlashStatusOff
};

@interface GNLiveVideoViewController ()<UIAlertViewDelegate> {
    NSMutableArray *watermarkFrames;
    NSMutableArray *motionFrames;
}

@property (nonatomic, strong) UIImageView *liveVideoPushImageView;
@property (nonatomic, strong) UIImageView *closeImageView;
@property (nonatomic, strong) UIButton *previewButton;
@property (nonatomic, strong) UIButton *liveVideoPushButton;
@property (nonatomic, strong) UIButton *rotateCameraButton;
@property (nonatomic, strong) UIButton *switchFlashButton;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UISwitch *autoBlackWhiteSwitch;
@property (nonatomic, strong) UILabel *autoBlackWhiteLabel;
@property (nonatomic, strong) UISwitch *autoReconnectSwitch;
@property (nonatomic, strong) UILabel *autoReconnectLabel;
@property (nonatomic, strong) UILabel *liveVideoPushLabel;
@property (nonatomic, strong) UILabel *liveStatisticsLabel;
@property (nonatomic, strong) UIButton *switchBeautifyButton;
@property (nonatomic, strong) NSTimer *periodic;
@property (nonatomic, assign) double startTimestamp;
@property (nonatomic, assign) BOOL isLiveInterrupted;

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) GPUImageBeautifyFilter *beautifyFilter;
@property (nonatomic, strong) GPUImageLiveVideoRawDataOutput *rawDataOutput;
@property (nonatomic, strong) GPUImageWatermarkFilter *watermarkFilter;
@property (nonatomic, strong) GPUImageInteractiveMotionFilter *motionFilter;
@property (nonatomic, assign) CGSize videoSize;

@property (nonatomic, assign) GNLiveVideoSessionState sessionState;
@property (nonatomic, assign) GDLiveVideoCameraFlashStatus cameraFlashStatus;

@property (nonatomic, strong) GNCameraFocus *cameraFocus;
@property (nonatomic, strong) GNCameraZoom *cameraZoom;
@property (nonatomic, strong) UIView *gestureView;
@property (nonatomic, weak) id <UIGestureRecognizerDelegate> gestureDelegate;
@property (nonatomic, assign) BOOL enableFocus;
@property (nonatomic, assign) BOOL enableZoom;
@property (nonatomic, assign) BOOL showsFocusView;
@property (nonatomic, assign) BOOL showsZoomView;
@property (nonatomic, assign) CGFloat maxZoomFactor;

@end

@implementation GNLiveVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    [self.videoCamera setHorizontallyMirrorFrontFacingCamera:YES];
    [self.videoCamera setOutputImageOrientation:UIInterfaceOrientationLandscapeRight];
    [self.videoCamera setFrameRate:20];
    
    [self.videoCamera removeAllTargets];
    
    self.beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    //    [self.videoCamera addTarget:self.beautifyFilter];
    
    self.videoSize = CGSizeMake(1280, 720);
    
//    UIImage *logo = [UIImage imageNamed:@"gn_live_geek_niu_text_logo"];
//    
//    watermarkFrames = [[NSMutableArray alloc] initWithCapacity:1];
//    GNYYImage *gif = [GNYYImage imageNamed:@"niconiconi"];
//    
//    for (int i = 0; i < gif.animatedImageFrameCount; i++) {
//        [watermarkFrames addObject:[gif animatedImageFrameAtIndex:i]];
//    }
//    
//    self.watermarkFilter = [[GPUImageWatermarkFilter alloc] initWithWatermarkImages:watermarkFrames dockImageSize:self.videoSize location:GPUImageWatermarkLocationBottomLeft];
//    [self.videoCamera addTarget:self.watermarkFilter];
    
    
    motionFrames = [[NSMutableArray alloc] initWithCapacity:1];
    GNYYImage *gif = [GNYYImage imageNamed:@"kiss"];
    
    for (int i = 0; i < gif.animatedImageFrameCount; i++) {
        [motionFrames addObject:[gif animatedImageFrameAtIndex:i]];
    }
    
    self.motionFilter = [[GPUImageInteractiveMotionFilter alloc] initWithMotionImages:motionFrames dockImageSize:self.videoSize];
    [self.videoCamera addTarget:self.motionFilter];
    
    __weak typeof(self) weakSelf = self;
    
    self.rawDataOutput = [[GPUImageLiveVideoRawDataOutput alloc] initWithVideoCamera:self.videoCamera withVideoSize:self.videoSize sampleSessionHandler:^(NSInteger videoRate) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateStatistics:videoRate/1000];
        });
    } sessionStateHandler:^(GNLiveVideoSessionState state) {
        [weakSelf setSessionState:state];
        
        NSLog(@"Live video session state changed: %ld", state);
    }];
    
//    [self.watermarkFilter addTarget:self.beautifyFilter];
//    [self.watermarkFilter addTarget:self.rawDataOutput];
    
    [self.motionFilter addTarget:self.beautifyFilter];
    [self.motionFilter addTarget:self.rawDataOutput];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive:) name:@"GNLiveVideoResumed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground:) name:@"GNLiveVideoInterrupted" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"lll");
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // Code here will execute before the rotation begins.
    // Equivalent to placing it in the deprecated method -[willRotateToInterfaceOrientation:duration:]
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Place code here to perform animations during the rotation.
        // You can pass nil or leave this block empty if not necessary.
        
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        [self initFiltersWithViewFrame:CGRectMake(0.0f, 0.0f, bounds.size.width, bounds.size.height)];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        
    }];
}

- (void)appBecomeActive:(id)notification
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

    if (self.isLiveInterrupted) {
        [self startPushLiveVideo];
    }
}

- (void)appEnterBackground:(id)notification
{
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];

    if (self.sessionState == GNLiveVideoSessionStateStarted) {
        [self stopPushLiveVideo];
        [self setIsLiveInterrupted:YES];
    }
}

- (void)initFiltersWithViewFrame:(CGRect)frame
{
    [self.filterView removeFromSuperview];
    
    self.filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
    //    [self.filterView setCenter:self.view.center];
    [self.view addSubview:self.filterView];
    
    //    [self.beautifyFilter addTarget:self.filterView];
    
    //    [self.beautifyFilter addTarget:self.blendFilter];
    [self.beautifyFilter addTarget:self.filterView];
    //    [self.beautifyFilter addTarget:self.alphaBlendFilter atTextureLocation:0];
    
    [self.videoCamera startCameraCapture];
    
    CGFloat buttonHeight = (CGRectGetHeight(frame)-30)/6;
    
    UIImage *image = [UIImage imageNamed:@"gn_live_close"];
    self.closeImageView = [[UIImageView alloc] initWithImage:image];
    [self.closeImageView setFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.closeImageView.frame)*2/3, CGRectGetHeight(self.closeImageView.frame)*2/3)];
    
    self.closeButton = [[UIButton alloc] init];
    //        [self.closeButton setBackgroundColor:[UIColor redColor]];
    [self.closeButton setFrame:CGRectMake(0, 0, buttonHeight*2, buttonHeight)];
    [self.closeButton addTarget:self action:@selector(handleCloseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addSubview:self.closeImageView];
    [self.view addSubview:self.closeButton];
    
    self.liveStatisticsLabel = [[UILabel alloc] init];
    [self.liveStatisticsLabel setBackgroundColor:[UIColor clearColor]];
    [self.liveStatisticsLabel setText:[NSString stringWithFormat:@"%00fkb/s | %02f:%02f:%02f", 0000.0, 0.0, 0.0, 0.0]];
    [self.liveStatisticsLabel setTextColor:[UIColor whiteColor]];
    [self.liveStatisticsLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Small" size:16.0f]];
    [self.liveStatisticsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.liveStatisticsLabel];
    
    image = [UIImage imageNamed:@"gn_live_rotate_camera"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake((buttonHeight*2-CGRectGetWidth(imageView.frame))/2, (buttonHeight-CGRectGetHeight(imageView.frame))/2, CGRectGetWidth(imageView.frame), CGRectGetHeight(imageView.frame))];
    
    self.rotateCameraButton = [[UIButton alloc] init];
    //    [self.rotateCameraButton setBackgroundColor:[UIColor redColor]];
    [self.rotateCameraButton setFrame:CGRectMake(0, 0, buttonHeight*2, buttonHeight)];
    [self.rotateCameraButton addTarget:self action:@selector(handleRotateCameraButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.rotateCameraButton addSubview:imageView];
    [self.view addSubview:self.rotateCameraButton];
    
    self.switchFlashButton = [[UIButton alloc] init];
    //    [self.switchFlashButton setBackgroundColor:[UIColor redColor]];
    [self.switchFlashButton setFrame:CGRectMake(0, 0, buttonHeight*2, buttonHeight)];
    [self.switchFlashButton addTarget:self action:@selector(handleSwitchFlashButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.switchFlashButton addSubview:imageView];
    [self.switchFlashButton setImage:[UIImage imageNamed:@"gn_live_switch_flash_on"] forState:UIControlStateNormal];
    [self.switchFlashButton setImage:[UIImage imageNamed:@"gn_live_switch_flash_off"] forState:UIControlStateDisabled];
    [self.switchFlashButton setImage:[UIImage imageNamed:@"gn_live_switch_flash_off"] forState:UIControlStateSelected];
    [self.view addSubview:self.switchFlashButton];
    
    self.switchBeautifyButton = [[UIButton alloc] init];
    //    [self.switchBeautifyButton setBackgroundColor:[UIColor redColor]];
    [self.switchBeautifyButton setImage:[UIImage imageNamed:@"gn_live_switch_beautify"] forState:UIControlStateNormal];
    [self.switchBeautifyButton setImage:[UIImage imageNamed:@"gn_live_switch_beautify_selected"] forState:UIControlStateSelected];
    [self.switchBeautifyButton setFrame:CGRectMake(0, 0, buttonHeight*2, buttonHeight)];
    [self.switchBeautifyButton addTarget:self action:@selector(handleSwitchBeautifyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.switchBeautifyButton addSubview:imageView];
    [self.switchBeautifyButton setSelected:YES];
    [self.view addSubview:self.switchBeautifyButton];
    
    image = [UIImage imageNamed:@"gn_live_start_push"];
    self.liveVideoPushImageView = [[UIImageView alloc] initWithImage:image];
    [self.liveVideoPushImageView setFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.liveVideoPushImageView.frame)*2, CGRectGetHeight(self.liveVideoPushImageView.frame)*2)];
    
    self.liveVideoPushButton = [[UIButton alloc] init];
    //    [self.liveVideoPushButton setBackgroundColor:[UIColor redColor]];
    [self.liveVideoPushButton setFrame:CGRectMake(0, 0, buttonHeight*2, buttonHeight)];
    [self.liveVideoPushButton addTarget:self action:@selector(handleLiveVideoPushButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.liveVideoPushButton setImage:[UIImage imageNamed:@"gn_live_start_push"] forState:UIControlStateNormal];
    //    [self.liveVideoPushButton setImage:[UIImage imageNamed:@"gn_live_stop_push"] forState:UIControlStateSelected];
    [self.liveVideoPushButton addSubview:self.liveVideoPushImageView];
    [self.view addSubview:self.liveVideoPushButton];
    
    self.liveVideoPushLabel = [[UILabel alloc] init];
    //    [self.liveVideoPushLabel setBackgroundColor:[UIColor clearColor]];
    [self.liveVideoPushLabel setText:@"开始"];
    [self.liveVideoPushLabel setTextColor:[UIColor whiteColor]];
    [self.liveVideoPushLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Small" size:16.0f]];
    [self.liveVideoPushLabel setTextAlignment:NSTextAlignmentCenter];
    [self.liveVideoPushButton addSubview:self.liveVideoPushLabel];
    
    [self.closeImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.closeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.liveStatisticsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.rotateCameraButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.switchFlashButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.switchBeautifyButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.liveVideoPushLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.liveVideoPushImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.liveVideoPushButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.closeImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.closeButton attribute:NSLayoutAttributeLeading multiplier:1 constant:20],
                                [NSLayoutConstraint constraintWithItem:self.closeImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.closeButton attribute:NSLayoutAttributeTop multiplier:1 constant:10]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:-5],
                                [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight*2],
                                [NSLayoutConstraint constraintWithItem:self.closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.liveStatisticsLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.liveStatisticsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:10],
                                [NSLayoutConstraint constraintWithItem:self.liveStatisticsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight*4],
                                [NSLayoutConstraint constraintWithItem:self.liveStatisticsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.rotateCameraButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.rotateCameraButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.liveStatisticsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.rotateCameraButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight*2],
                                [NSLayoutConstraint constraintWithItem:self.rotateCameraButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.switchFlashButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.switchFlashButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.rotateCameraButton attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.switchFlashButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight*2],
                                [NSLayoutConstraint constraintWithItem:self.switchFlashButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.switchBeautifyButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.switchBeautifyButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.switchFlashButton attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.switchBeautifyButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight*2],
                                [NSLayoutConstraint constraintWithItem:self.switchBeautifyButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.liveVideoPushButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.liveVideoPushButton attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight*2]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.liveVideoPushButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.liveVideoPushLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:10],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.switchBeautifyButton attribute:NSLayoutAttributeBottom multiplier:1 constant:15],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight*2],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoPushButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:buttonHeight*2]
                                ]];
    
    [self setSessionState:GNLiveVideoSessionStateNone];
    [self setCameraFlashStatus:GDLiveVideoCameraFlashStatusOff];
    [self.switchFlashButton setSelected:YES];
    [self setIsLiveInterrupted:NO];
}

- (void)startPushLiveVideo
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [self.liveVideoPushButton setSelected:YES];
    [self.liveVideoPushLabel setText:@"停止"];
    [self.liveVideoPushImageView setImage:[UIImage imageNamed:@"gn_live_stop_push"]];
    [self.liveVideoPushButton setEnabled:NO];
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
        
        [self.rawDataOutput startUploadStreamWithRoomId:self.room.roomId];
        
        [self startStatistics];
        [self setSessionState:GNLiveVideoSessionStateStarted];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void) {
            [weakSelf.liveVideoPushButton setEnabled:YES];
        });
    });

 }

- (void)stopPushLiveVideo
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    
    [self.liveVideoPushButton setSelected:NO];
    [self.liveVideoPushLabel setText:@"开始"];
    [self.liveVideoPushImageView setImage:[UIImage imageNamed:@"gn_live_start_push"]];

    __weak typeof(self) weakSelf = self;
    
    [[GNLiveRoomManager sharedInstance] stopLiveStreaming:self.room.roomId success:^{
        [weakSelf.rawDataOutput stopUploadStream];
        [weakSelf setSessionState:GNLiveVideoSessionStateEnded];
    } failure:^(NSError *error) {
        
    }];
}

- (void)startPeriodicStatistics
{
    self.periodic = [NSTimer scheduledTimerWithTimeInterval:0.4f
                                                     target:self
                                                   selector:@selector(updateStatistics:)
                                                   userInfo:nil
                                                    repeats:YES];
}

- (void)updateStatistics:(double)videoRate
{
    double curentTimeStamp = [[NSDate date] timeIntervalSince1970];
    [self.liveStatisticsLabel setText:[NSString stringWithFormat:@"%4.0fkb/s | %@", videoRate, [self timeFormatted: (curentTimeStamp - self.startTimestamp)]]];
}

- (void)startStatistics
{
    self.startTimestamp = [[NSDate date] timeIntervalSince1970];
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

- (void)handleCloseButtonTapped:(id)sender
{
    if (self.sessionState == GNLiveVideoSessionStateStarted) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您确定停止直播吗？"
                                                       delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else {
        [self.videoCamera stopCameraCapture];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)handleRotateCameraButtonTapped:(id)sender
{
    if ([self.videoCamera isFrontFacingCameraPresent]) {
        [self.switchFlashButton setEnabled:YES];
    }
    else {
        [self.switchFlashButton setEnabled:NO];
    }
    
    [self.videoCamera rotateCamera];
    
    if ([self.videoCamera isFrontFacingCameraPresent]) {
        [self.videoCamera setHorizontallyMirrorFrontFacingCamera:YES];
    }
}

- (void)handleSwitchFlashButtonTapped:(id)sender
{
    NSError *error = nil;
    
    if ([self.videoCamera.inputCamera lockForConfiguration:&error]) {
        if (self.videoCamera.inputCamera.torchMode == AVCaptureTorchModeOff) {
            if ([self.videoCamera.inputCamera isTorchModeSupported:AVCaptureTorchModeOn]) {
                [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
            }
            
            [self setCameraFlashStatus:GDLiveVideoCameraFlashStatusOn];
            [self.switchFlashButton setSelected:NO];
        }
        else {
            if ([self.videoCamera.inputCamera isTorchModeSupported:AVCaptureTorchModeOff]) {
                [self.videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
            }
            
            [self setCameraFlashStatus:GDLiveVideoCameraFlashStatusOff];
            [self.switchFlashButton setSelected:YES];
        }
        
        [self.videoCamera.inputCamera unlockForConfiguration];
    }
}

- (void)handleLiveVideoPushButtonTapped:(id)sender
{
    if (self.sessionState != GNLiveVideoSessionStateStarted) {
        [self startPushLiveVideo];
    }
    else {
        [self stopPushLiveVideo];
    }
}

- (void)handleSwitchBeautifyButtonTapped:(id)sender
{
    if (self.switchBeautifyButton.selected) {
        [self.switchBeautifyButton setSelected:NO];
        [self.videoCamera removeAllTargets];
        [self.beautifyFilter removeAllTargets];
        [self.watermarkFilter removeAllTargets];
        
        //        [self.videoCamera addTarget:self.filterView];
        //        [self.videoCamera addTarget:self.rawDataOutput];
        [self.videoCamera addTarget:self.watermarkFilter];
        [self.watermarkFilter addTarget:self.filterView];
        [self.watermarkFilter addTarget:self.rawDataOutput atTextureLocation:0];
    }
    else {
        [self.switchBeautifyButton setSelected:YES];
        [self.videoCamera removeAllTargets];
        [self.beautifyFilter removeAllTargets];
        [self.watermarkFilter removeAllTargets];
        
        [self.beautifyFilter addTarget:self.filterView];
        [self.videoCamera addTarget:self.watermarkFilter];
        [self.watermarkFilter addTarget:self.beautifyFilter];
        [self.watermarkFilter addTarget:self.rawDataOutput];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0) {
        if (self.sessionState == GNLiveVideoSessionStateStarted) {
            [self stopPushLiveVideo];
        }
        
        [self.videoCamera stopCameraCapture];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGPoint)_focusPointOfInterestForTouchPoint:(CGPoint)touchPoint
{
    return [GNCameraUtils captureDevicePointOfInterestForPoint:touchPoint inPreview:self.filterView withVideoCamera:self.videoCamera];
}

- (BOOL)_focusAtPointOfInterest:(CGPoint)pointOfInterest
{
    return [self.videoCamera.inputCamera focusAtPointOfInterest:pointOfInterest];
}

- (BOOL)zoomToScale:(CGFloat)scale
{
    return [self.videoCamera.inputCamera zoomToScale:scale];
}

- (void)_resetZoom
{
    [self.cameraZoom resetZoom];
    
    self.cameraZoom.maxScale = [self.videoCamera.inputCamera videoMaxZoomFactor];
    
    self.maxZoomFactor = self.cameraZoom.maxScale;
}


#pragma mark - CameraFocusDelegate

- (BOOL)handleTapFocusAtPoint:(CGPoint)touchPoint
{
    if ([AVCaptureDevice isPointFocusAvailableForCameraDevice:self.videoCamera.inputCamera]) {
        
        CGPoint pointOfInterest = [self _focusPointOfInterestForTouchPoint:touchPoint];
        
        return ([self _focusAtPointOfInterest:pointOfInterest] && self.showsFocusView);
    }
    
    return NO;
}

#pragma mark - CameraZoomDelegate

- (BOOL)handlePinchZoomWithScale:(CGFloat)zoomScale
{
    return ([self zoomToScale:zoomScale] && self.showsZoomView);
}

@end
