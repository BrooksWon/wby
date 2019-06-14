//
//  ViewController.m
//  M-Player
//
//  Created by Brooks on 2019/6/14.
//  Copyright © 2019 Brooks. All rights reserved.
//

#import "ViewController.h"

static NSDictionary<NSString*,NSString*>* __DataSources(){
    NSDictionary *dic = @{@"1个视频播放":@"ViewController1",
                       @"2个视频同时播放":@"ViewController2",
                       @"4个视频同时播放":@"ViewController4",
                       @"9个视频同时播放":@"ViewController9"};
    
    return dic;
}

static NSString *cellId = @"cellId";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController
{
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count =  __DataSources().count;
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", [__DataSources().allKeys objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString([__DataSources().allValues objectAtIndex:indexPath.row]) alloc] init]];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
