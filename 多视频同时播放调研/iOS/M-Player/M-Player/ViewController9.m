//
//  ViewController9.m
//  M-Player
//
//  Created by Brooks on 2019/6/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "ViewController9.h"
#import <LXMPlayer/LXMPlayer.h>

static NSArray * __DataSource(){
    NSArray *array = @[@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                       @"http://alcdn.hls.xiaoka.tv/2017427/14b/7b3/Jzq08Sl8BbyELNTo/index.m3u8",
                       @"https://media.w3.org/2010/05/sintel/trailer.mp4",
                       @"http://www.w3school.com.cn/example/html5/mov_bbb.mp4",
                       @"https://media.w3.org/2010/05/sintel/trailer.mp4",
                       @"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
                       @"http://vfx.mtime.cn/Video/2017/03/31/mp4/170331093811717750.mp4",
                       @"https://media.w3.org/2010/05/sintel/trailer.mp4",
                       @"http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4",
                       @"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8"];
    
    return array;
}

@interface ViewController9 ()

@end

@implementation ViewController9
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
