//
//  ViewController.m
//  KWAIAudioVideoDemo
//
//  Created by Ranger Wu on 2018/10/11.
//  Copyright © 2018年 Ranger Wu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"音视频 Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.datas = @[
                   @{
                       @"title": @"音频 Demo",
                       @"class": @"KWAIAudioDemoViewController",
                       },
                   @{
                       @"title": @"视频 Demo",
                       @"class": @"KWAIVideoDemoViewController",
                       },
                   @{
                       @"title": @"音视频结合 Demo",
                       @"class": @"KWAIAudioVideoDemoViewController",
                       },
                   ];
    
    self.tableView.frame = self.view.bounds;
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = (id)self;
        tableView.dataSource = (id)self;
        _tableView = tableView;
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdetifier = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdetifier];
    }
    
    cell.textLabel.text = [self.datas[indexPath.row] valueForKey:@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *className = [self.datas[indexPath.row] valueForKey:@"class"];
    Class cls = NSClassFromString(className);
    if (cls) {
        [self.navigationController pushViewController:[cls new] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
