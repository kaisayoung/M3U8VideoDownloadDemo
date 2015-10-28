//
//  SCM3U8VideoDownload.h
//  VideoDownloadDemo
//
//  Created by 王琦 on 15/10/19.
//  Copyright (c) 2015年 Riverrun. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 M3U8格式视频下载类：下载单个视频时直接使用，下载多个视频时需要写个管理单例类
 状态改变：等待->(开始)下载，下载->暂停，暂停->(继续)下载，失败->(重新)下载；
 总之：未完成状态下，未下载->下载，下载->暂停
 实际去下载的时候需要考虑网络情况变化，磁盘剩余空间，甚至手机当前电量等
 */

@protocol SCM3U8VideoDownloadDelegate <NSObject>

- (void)M3U8VideoDownloadParseFail;
- (void)M3U8VideoDownloadFinish;
- (void)M3U8VideoDownloadFail;
- (void)M3U8VideoDownloadProgress:(CGFloat)progress;

@end

@interface SCM3U8VideoDownload : NSObject

@property (assign, nonatomic) id<SCM3U8VideoDownloadDelegate>delegate;
@property (assign, nonatomic) DownloadVideoState downloadState;
@property (copy, nonatomic) NSString *vid;

- (id)initWithVideoId:(NSString *)vid VideoUrl:(NSString *)videoUrl;

- (void)changeDownloadVideoState;

- (void)deleteDownloadVideo;

@end
