//
//  ViewController1.m
//  M-Player
//
//  Created by Brooks on 2019/6/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "ViewController1.h"
#import <LXMPlayer/LXMPlayer.h>


@interface ViewController1 ()


@end

@implementation ViewController1
{
    __weak IBOutlet LXMAVPlayerView *pv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSString *testUrl = @"https://media.w3.org/2010/05/sintel/trailer.mp4";
    NSURL *url = [NSURL URLWithString:testUrl];
    pv.assetURL = url;
    [pv play];
}
- (IBAction)btnAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


@end
