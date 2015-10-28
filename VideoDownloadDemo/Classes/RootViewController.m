//
//  RootViewController.m
//  VideoPlayDemo
//
//  Created by 王琦 on 15/7/23.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "RootViewController.h"
#import "SCVideoPlayDemo2ViewController.h"
#import "SCM3U8VideoDownload.h"

@interface RootViewController ()<SCM3U8VideoDownloadDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *playLocalButton;
@property (weak, nonatomic) IBOutlet UILabel *downloadStateLabel;
@property (weak, nonatomic) IBOutlet UILabel *downloadProgressLabel;
@property (strong, nonatomic) SCM3U8VideoDownload *videoDownload;

- (IBAction)onPlayUrlButtonClicked:(id)sender;
- (IBAction)onPlayLocalVideoButtonClicked:(id)sender;
- (IBAction)onChangeDownloadStateButtonClicked:(id)sender;
- (IBAction)onDeleteDownloadVideoButtonClicked:(id)sender;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setStateLabelContent
{
    switch (self.videoDownload.downloadState) {
        case DownloadVideoStateWating:
        {
            _downloadStateLabel.text = @"等待中";
        }
            break;
        case DownloadVideoStateDownloading:
        {
            _downloadStateLabel.text = @"下载中";
        }
            break;
        case DownloadVideoStatePausing:
        {
            _downloadStateLabel.text = @"暂停中";
        }
            break;
        case DownloadVideoStateFail:
        {
            _downloadStateLabel.text = @"下载失败";
        }
            break;
        case DownloadVideoStateFinish:
        {
            _downloadStateLabel.text = @"下载完成";
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textField resignFirstResponder];
}

- (IBAction)onPlayUrlButtonClicked:(id)sender
{
    SCVideoPlayDemo2ViewController *demo2ViewController = [[SCVideoPlayDemo2ViewController alloc] initWithNibName:@"SCVideoPlayDemo2ViewController" bundle:nil];
    demo2ViewController.videoUrl = _textField.text;
    [self.navigationController pushViewController:demo2ViewController animated:YES];
}

- (IBAction)onPlayLocalVideoButtonClicked:(id)sender
{
    //判断下是否已经下载完
    NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *saveTo = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:kDownloadVideoId];
    NSString *videoPath = [saveTo stringByAppendingPathComponent:@"movie.m3u8"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:videoPath isDirectory:&isDir])
    {
        [UIUtil showMessage:@"视频还没有下载呢"];
        return;
    }
    SCVideoPlayDemo2ViewController *demo2ViewController = [[SCVideoPlayDemo2ViewController alloc] initWithNibName:@"SCVideoPlayDemo2ViewController" bundle:nil];
    demo2ViewController.videoUrl = [NSString stringWithFormat:@"http://127.0.0.1:54321/%@/movie.m3u8",kDownloadVideoId];
    [self.navigationController pushViewController:demo2ViewController animated:YES];
}

- (IBAction)onChangeDownloadStateButtonClicked:(id)sender
{
    //下载->暂停；未下载->下载
    if(!_videoDownload){
        _videoDownload = [[SCM3U8VideoDownload alloc] initWithVideoId:kDownloadVideoId VideoUrl:_textField.text];
        _videoDownload.delegate = self;
    }
    if(_videoDownload.downloadState!=DownloadVideoStateFinish){
        [_videoDownload changeDownloadVideoState];
        [self setStateLabelContent];
    }
}

- (IBAction)onDeleteDownloadVideoButtonClicked:(id)sender
{
    if(!_videoDownload){
        _videoDownload = [[SCM3U8VideoDownload alloc] initWithVideoId:kDownloadVideoId VideoUrl:_textField.text];
        _videoDownload.delegate = self;
    }
    [_videoDownload deleteDownloadVideo];
    [self setStateLabelContent];
    _downloadProgressLabel.text = @"0%";
}

#pragma mark --- SCM3U8VideoDownloadDelegate ---

- (void)M3U8VideoDownloadFail
{
    [UIUtil showMessage:@"下载失败啦"];
    [self setStateLabelContent];
}

- (void)M3U8VideoDownloadFinish
{
    [UIUtil showMessage:@"下载完成可以播放啦"];
    [self setStateLabelContent];
}

- (void)M3U8VideoDownloadParseFail
{
    //回传到主线程显示
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIUtil showMessage:@"解析失败啦！换个视频地址试试"];
        [self setStateLabelContent];
    });
}

- (void)M3U8VideoDownloadProgress:(CGFloat)progress
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.downloadProgressLabel.text = [NSString stringWithFormat:@"%.1f%%",progress];
    });
}

@end














