//
//  ViewController2.m
//  M-Player
//
//  Created by Brooks on 2019/6/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "ViewController2.h"

#import <LXMPlayer/LXMPlayer.h>

static NSArray * __DataSource(){
    NSArray *array = @[@"https://media.w3.org/2010/05/sintel/trailer.mp4",
                       @"https://media.w3.org/2010/05/sintel/trailer.mp4"];
    
    return array;
}

@interface ViewController2 ()

@end

@implementation ViewController2
{
    IBOutletCollection(LXMAVPlayerView) NSArray *pvs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [pvs enumerateObjectsUsingBlock:^(LXMAVPlayerView*  _Nonnull pv, NSUInteger idx, BOOL * _Nonnull stop) {
        pv.assetURL = [NSURL URLWithString:[__DataSource() objectAtIndex:idx]];
        [pv play];
    }];
}
- (IBAction)btnAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
