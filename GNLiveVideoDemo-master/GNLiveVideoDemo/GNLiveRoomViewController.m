//
//  GNLiveRoomViewController.m
//  LiveVideoSDKDemo
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GNLiveVideo/GNRoomInfo.h>

#import "GNPlaybackViewController.h"
#import "GNLiveVideoViewController.h"
#import "GNLiveRoomViewController.h"

@interface GNLiveRoomViewController ()<UIAlertViewDelegate> {
}

@property (nonatomic, strong)UIButton *liveVideoButton;
@property (nonatomic, strong)UIButton *watchLiveButton;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)GNLiveVideoViewController *liveViewController;
@property (nonatomic, strong)GNPlaybackViewController *playbackViewController;

@end

@implementation GNLiveRoomViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.liveVideoButton = [[UIButton alloc] init];
        [self.liveVideoButton setBackgroundColor:[UIColor redColor]];
    [self.liveVideoButton setTitle:@"直播" forState:UIControlStateNormal];
    [self.liveVideoButton setFrame:CGRectMake(0, 0, 100*2, 50)];
    [self.liveVideoButton addTarget:self action:@selector(handleLiveVideoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.liveVideoButton];
    
    self.watchLiveButton = [[UIButton alloc] init];
    [self.watchLiveButton setBackgroundColor:[UIColor redColor]];
    [self.watchLiveButton setTitle:@"观看直播" forState:UIControlStateNormal];
    [self.watchLiveButton setFrame:CGRectMake(0, 0, 100*2, 50)];
    [self.watchLiveButton addTarget:self action:@selector(handleWatchLiveButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.watchLiveButton];
    
    [self.liveVideoButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.watchLiveButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.liveVideoButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:150],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200],
                                [NSLayoutConstraint constraintWithItem:self.liveVideoButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.watchLiveButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.liveVideoButton attribute:NSLayoutAttributeBottom multiplier:1 constant:150],
                                [NSLayoutConstraint constraintWithItem:self.watchLiveButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.watchLiveButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200],
                                [NSLayoutConstraint constraintWithItem:self.watchLiveButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]
                                ]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
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
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        // Code here will execute after the rotation has finished.
        // Equivalent to placing it in the deprecated method -[didRotateFromInterfaceOrientation:]
        
    }];
}

- (void)handleLiveVideoButtonTapped:(id)sender
{
    self.liveViewController = [[GNLiveVideoViewController alloc] init];
    [self.liveViewController setRoom:self.room];
    [self.navigationController pushViewController:self.liveViewController animated:YES];
}

- (void)handleWatchLiveButtonTapped:(id)sender
{
    self.playbackViewController = [[GNPlaybackViewController alloc] init];
    [self.playbackViewController setRoom:self.room];
    [self.navigationController pushViewController:self.playbackViewController animated:YES];
}

@end
