//
//  WQTempItem1.m
//  WQBaseFrameDemo
//
//  Created by 温强 on 2017/11/24.
//  Copyright © 2017年 温强. All rights reserved.
//

#import "WQTempItem1.h"
#import "RESideMenu.h"
#import "WQImagePickerManager.h"
#import "UTViewController.h"
#import "UPDateVC.h"
static NSString * const Camera = @"相机（真机）";
static NSString * const Album = @"相册";
static NSString * const littleVideo = @"小视频录制（真机）";
static NSString * const autoUpdate = @"自动更新";

static NSString * const item1CellID = @"item1Cell";
@interface WQTempItem1 ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataAry;
@end

@implementation WQTempItem1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavi];
    [self setUpdata];
    [self setUpTableView];
}
- (void)setUpdata {
    self.dataAry = @[littleVideo,
                     Camera,
                     Album,
                     autoUpdate];
}
- (void)setNavi {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clouddisk_search_up_n"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
}
- (void)setUpTableView{
    self.tableView = [UITableView tableWithFrame:self.view.bounds style:UITableViewStylePlain superView:self.view];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

}
#pragma mark - tableView delegate/datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item1CellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item1CellID];
    }
    cell.textLabel.text = self.dataAry[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataAry[indexPath.row] isEqualToString:Camera]) {
        // 相机
        [[WQImagePickerManager sharedImagePickerManager] openCamera:^(UIImage *image) {
            ;
        }];
    } else if ([self.dataAry[indexPath.row] isEqualToString:Album]) {
        // 相册
        [[WQImagePickerManager sharedImagePickerManager] openAlbumPhotos:^(NSArray<UIImage *> *photos) {
            ;
        }];
    } else if ([self.dataAry[indexPath.row] isEqualToString:littleVideo]) {
        // 小视频录制
        UTViewController *littleVideoVc = [[UTViewController alloc] init];
        [self.navigationController pushViewController:littleVideoVc animated:YES];
    } else if ([self.dataAry[indexPath.row] isEqualToString:autoUpdate]) {
        // 自动更新
        [self.navigationController pushViewController:[[UPDateVC alloc] init] animated:YES];
    }
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"addBadge" object:nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"cleanBadge" object:nil];
}



@end
