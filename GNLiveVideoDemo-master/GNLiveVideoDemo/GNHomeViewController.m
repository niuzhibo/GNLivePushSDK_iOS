//
//  GNHomeViewController.m
//  LiveVideoSDKDemo
//
//  Created by GeekNiu on 2016/6/6.
//  Copyright © 2016年 Geek Niu. All rights reserved.
//

#import <GNLiveVideo/GNRoomInfo.h>
#import <GNLiveVideo/GNLiveRoomManager.h>

#import "GNLiveRoomViewController.h"
#import "GNHomeViewController.h"

@interface GNHomeViewController ()<UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
}

@property (nonatomic, strong)UIButton *createRoomButton;
@property (nonatomic, strong)UILabel *roomNameLabel;
@property (nonatomic, strong)UITextField *roomNameField;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray *rooms;

@end

@implementation GNHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    CGFloat margin =  CGRectGetHeight(self.navigationController.navigationBar.frame) + CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    
    self.roomNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [self.roomNameLabel setText:@"房间名称："];
    [self.roomNameLabel setTextColor:[UIColor blackColor]];
    [self.roomNameLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.roomNameLabel];
    
    self.roomNameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100*2, 50)];
    [self.roomNameField setBackgroundColor:[UIColor clearColor]];
    [self.roomNameField setTextColor:[UIColor blackColor]];
    [self.roomNameField setPlaceholder:@"请输入要创建的房间名称"];
    [self.view addSubview:self.roomNameField];
    
    self.createRoomButton = [[UIButton alloc] init];
    [self.createRoomButton setBackgroundColor:[UIColor redColor]];
    [self.createRoomButton setTitle:@"创建房间" forState:UIControlStateNormal];
    [self.createRoomButton setFrame:CGRectMake(0, 0, 100*2, 50)];
    [self.createRoomButton addTarget:self action:@selector(handleCreateRoomButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createRoomButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];

    [self.createRoomButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.roomNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.roomNameField setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.roomNameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:margin+15],
                                [NSLayoutConstraint constraintWithItem:self.roomNameLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10],
                                [NSLayoutConstraint constraintWithItem:self.roomNameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.roomNameField attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.roomNameLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetWidth(self.roomNameLabel.frame)],
                                [NSLayoutConstraint constraintWithItem:self.createRoomButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetHeight(self.roomNameLabel.frame)]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.roomNameField attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.roomNameLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.roomNameField attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.roomNameLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:10],
                                [NSLayoutConstraint constraintWithItem:self.roomNameField attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10],
                                [NSLayoutConstraint constraintWithItem:self.roomNameField attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]
                                ]];

    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.createRoomButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.roomNameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:50],
                                [NSLayoutConstraint constraintWithItem:self.createRoomButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.createRoomButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200],
                                [NSLayoutConstraint constraintWithItem:self.createRoomButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50]
                                ]];
    
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.createRoomButton attribute:NSLayoutAttributeBottom multiplier:1 constant:50],
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
//                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:CGRectGetWidth(self.view.frame)]
                                ]];

    __weak typeof(self) weakSelf = self;
    
    [[GNLiveRoomManager sharedInstance] getLiveRoomList:^(NSArray *roomList) {
        [weakSelf setRooms:roomList];
        
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
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

- (void)handleCreateRoomButtonTapped:(id)sender
{
    NSString *roomName = @"未命名直播间";
    
    if (self.roomNameField.text.length > 0) {
        roomName = self.roomNameField.text;
    }
    
    __weak typeof(self) weakSelf = self;
    
    UIImage *logo = [UIImage imageNamed:@"gn_live_geek_niu_text_logo"];
    
    [[GNLiveRoomManager sharedInstance] uploadImage:logo imageUploadingHandler:^(NSString *imageUrl) {
        
        [[GNLiveRoomManager sharedInstance] createLiveRoom:roomName roomDescription:@"Anonymous" roomCoverUrl:imageUrl roomCreationHandler:^(GNRoomInfo *room) {
            NSLog(@"Room: %@ created.", room.roomId);
            
            [[GNLiveRoomManager sharedInstance] getLiveRoomList:^(NSArray *roomList) {
                [weakSelf setRooms:roomList];
    
                [weakSelf.tableView reloadData];
            } failure:^(NSError *error) {
    
            }];
        } failure:^(NSError *error) {
            
        }];
        
    } failure:^(NSError *error) {
        
    }];
    
    // 收起软键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark -
#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = 0;

    count = 1;
    
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = [self.rooms count];
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"LiveRoomIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    GNRoomInfo *room = [self.rooms objectAtIndex:indexPath.row];
    [cell.textLabel setText:room.roomId];
    [cell.detailTextLabel setText:room.name];
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    return cell;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GNRoomInfo *room = [self.rooms objectAtIndex:indexPath.row];
    
    GNLiveRoomViewController *roomViewController = [[GNLiveRoomViewController alloc] init];
    [roomViewController setRoom:room];
    [self.navigationController pushViewController:roomViewController animated:YES];
}

@end
