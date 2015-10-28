//
//  CONSTS.h
//  WanWan
//
//  Copyright 2014 Riverrun. All rights reserved.
//

#define SCREEN_HEIGHT_OF_IPHONE5        568
#define SCREEN_HEIGHT_OF_IPHONE6        667
#define SCREEN_HEIGHT_OF_IPHONE6PLUS    736

#define SCREEN_BOUNDS               [UIScreen mainScreen].bounds
#define SCREEN_HEIGHT               [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH                [UIScreen mainScreen].bounds.size.width
#define IS4InchScreen               (SCREEN_HEIGHT == SCREEN_HEIGHT_OF_IPHONE5)
#define ISIPHONE6                   (SCREEN_HEIGHT == SCREEN_HEIGHT_OF_IPHONE6)
#define ISIPHONE6PLUS               (SCREEN_HEIGHT == SCREEN_HEIGHT_OF_IPHONE6PLUS)

#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]

typedef NS_ENUM(NSInteger, DownloadVideoState){
    DownloadVideoStateDownloading = 1,
    DownloadVideoStateWating = 2,
    DownloadVideoStatePausing = 3,
    DownloadVideoStateFail = 4,
    DownloadVideoStateFinish = 5,
};

typedef NS_ENUM(NSInteger, M3U8AnalyseFail){
    M3U8AnalyseFailNotM3U8Url = 1,
    M3U8AnalyseFailNetworkUnConnection = 2,
};

#define kPathDownload    @"DownloadVideos"
#define kTextDownloadingFileSuffix @"_etc"
#define kDownloadVideoId @"TTT"










