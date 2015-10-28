//
//  SCM3U8VideoDownload.m
//  VideoDownloadDemo
//
//  Created by 王琦 on 15/10/19.
//  Copyright (c) 2015年 Riverrun. All rights reserved.
//

#import "SCM3U8VideoDownload.h"
#import "SCM3U8Analyse.h"
#import "SCM3U8SegmentListDownload.h"

@interface SCM3U8VideoDownload ()<SCM3U8AnalyseDelegate,SCM3U8SegmentListDownloadDelegate>

@property (copy, nonatomic) NSString *videoUrl;
@property (strong, nonatomic) SCM3U8Analyse *m3u8Analyse;
@property (strong, nonatomic) SCM3U8SegmentListDownload *listDownload;
@property (assign, nonatomic) BOOL analyseDataFinish;

@end

@implementation SCM3U8VideoDownload

- (id)initWithVideoId:(NSString *)vid VideoUrl:(NSString *)videoUrl
{
    if(self = [super init]){
        self.vid = vid;
        self.videoUrl = videoUrl;
        self.downloadState = DownloadVideoStateWating;
    }
    return self;
}

- (void)analyseM3U8VideoUrl
{
    //注意不论是解析字符串还是实际去下载都需要单开一个线程
    if(!_m3u8Analyse){
        _m3u8Analyse = [[SCM3U8Analyse alloc] init];
        _m3u8Analyse.delegate = self;
    }
    dispatch_queue_t myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(myQueue, ^{
        [_m3u8Analyse analyseVideoUrl:_videoUrl];
    });
}

- (void)changeDownloadVideoState
{
    switch (self.downloadState) {
        case DownloadVideoStateWating:
        {
            //去解析，解析成功去下载
            [self analyseM3U8VideoUrl];
            self.downloadState = DownloadVideoStateDownloading;
        }
            break;
        case DownloadVideoStateDownloading:
        {
            //暂停下载
            [self pauseDownloadVideo];
            self.downloadState = DownloadVideoStatePausing;
        }
            break;
        case DownloadVideoStatePausing:
        {
            //继续下载
            [self startDownloadVideo];
            self.downloadState = DownloadVideoStateDownloading;
        }
            break;
        case DownloadVideoStateFail:
        {
            //重新下载
            if(self.analyseDataFinish){
                [self startDownloadVideo];
            }
            else{
                [self analyseM3U8VideoUrl];
            }
            self.downloadState = DownloadVideoStateDownloading;
        }
            break;
        default:
            break;
    }
}

- (void)startDownloadVideo
{
    if(!_listDownload){
        _listDownload = [[SCM3U8SegmentListDownload alloc] initWithSegmentList:_m3u8Analyse.segmentList];
        _listDownload.vid = self.vid;
        _listDownload.delegate = self;
    }
    [_listDownload startDownloadVideo];
}

- (void)pauseDownloadVideo
{
    [_listDownload pauseDownloadVideo];
}

- (void)deleteDownloadVideo
{
    [_listDownload cancelDownloadVideo];
    NSString *pathPrefix = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
    NSString *savePath = [[pathPrefix stringByAppendingPathComponent:kPathDownload] stringByAppendingPathComponent:self.vid];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = YES;
    if([fileManager fileExistsAtPath:savePath isDirectory:&isDir]){
        [fileManager removeItemAtPath:savePath error:nil];
    }
    self.downloadState = DownloadVideoStateWating;
    self.analyseDataFinish = NO;
    self.listDownload.delegate = nil;
    self.listDownload = nil;
}

#pragma mark --- SCM3U8AnalyseDelegate ---

- (void)M3U8AnalyseFinish
{
    self.analyseDataFinish = YES;
    if(self.downloadState==DownloadVideoStateDownloading){
        [self startDownloadVideo];
    }
}

- (void)M3U8AnalyseFail:(NSError *)error
{
    NSLog(@"error.code is %ld",error.code);
    self.downloadState = DownloadVideoStateFail;
    if(self.delegate && [self.delegate respondsToSelector:@selector(M3U8VideoDownloadParseFail)]){
        [self.delegate M3U8VideoDownloadParseFail];
    }
}

#pragma mark --- SCM3U8SegmentListDownloadDelegate ---

- (void)M3U8SegmentListDownloadFinished
{
    self.downloadState = DownloadVideoStateFinish;
    if(self.delegate && [self.delegate respondsToSelector:@selector(M3U8VideoDownloadFinish)]){
        [self.delegate M3U8VideoDownloadFinish];
    }
}

- (void)M3U8SegmentListDownloadFailed
{
    self.downloadState = DownloadVideoStateFail;
    if(self.delegate && [self.delegate respondsToSelector:@selector(M3U8VideoDownloadFail)]){
        [self.delegate M3U8VideoDownloadFail];
    }
}

- (void)M3U8SegmentListDownloadProgress:(CGFloat)progress
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(M3U8VideoDownloadProgress:)]){
        [self.delegate M3U8VideoDownloadProgress:progress];
    }
}

@end











