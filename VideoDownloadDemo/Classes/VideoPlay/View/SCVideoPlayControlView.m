//
//  SCVideoPlayControlView.m
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "SCVideoPlayControlView.h"

@interface SCVideoPlayControlView ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSString *videoPlayUrl;
@property (assign, nonatomic) CGFloat videoTotalSeconds;
@property (assign, nonatomic) CGFloat videoPlayedSeconds;
@property (assign, nonatomic) CGFloat videoPlayableSeconds;

@end

@implementation SCVideoPlayControlView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setVideoTotalSeconds:(CGFloat)videoTotalSeconds
{
    if(_videoTotalSeconds!=videoTotalSeconds && videoTotalSeconds!=0.0){
        _videoTotalSeconds = videoTotalSeconds;
    }
}

- (void)setVideoPlayedSeconds:(CGFloat)videoPlayedSeconds
{
    if(_videoPlayedSeconds!=videoPlayedSeconds && videoPlayedSeconds!=0.0){
        if(((videoPlayedSeconds>_videoPlayedSeconds) && (videoPlayedSeconds-_videoPlayedSeconds<=5.0)) || ((videoPlayedSeconds<_videoPlayedSeconds) && (_videoPlayedSeconds-videoPlayedSeconds<=5.0))){
            _videoPlayedSeconds = videoPlayedSeconds;
        }
    }
}

- (void)setVideoPlayableSeconds:(CGFloat)videoPlayableSeconds
{
    if(_videoPlayableSeconds!=videoPlayableSeconds && videoPlayableSeconds!=0.0){
        _videoPlayableSeconds = videoPlayableSeconds;
    }
}

-(void)setControllerButtonHidden
{
    for (id object in self.moviePlayerController.view.subviews) {
        if ([object isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)object;
            button.hidden = YES;
        }
    }
}

- (void)initMoviePlayerController
{
    NSLog(@"get the real play url is %@",self.videoPlayUrl);
    NSURL *URL = [NSURL URLWithString:self.videoPlayUrl];
    self.moviePlayerController = [[MPMoviePlayerController alloc] initWithContentURL:URL];
    self.moviePlayerController.allowsAirPlay = NO;
    self.moviePlayerController.view.frame = self.bounds;
    self.moviePlayerController.scalingMode = MPMovieScalingModeNone;
    self.moviePlayerController.controlStyle = MPMovieControlStyleNone;
    [self.moviePlayerController prepareToPlay];
    [self setControllerButtonHidden];
    [self addSubview:self.moviePlayerController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerIsPreparedToPlay:) name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.moviePlayerController];
}

- (void)setUpMoviePlayerControllerWithPlayUrl:(NSString *)videoPlayUrl
{
    self.videoPlayUrl = videoPlayUrl;
    [self initMoviePlayerController];
}

- (void)resetDataContainLastPlayedTime:(BOOL)containLastPlayedTime
{
    [self destorySelf];
    _videoTotalSeconds = 0;
    _videoPlayableSeconds = 0;
    if(containLastPlayedTime){
        _videoPlayedSeconds = 0;
    }
}

- (void)destorySelf
{
    [self stopTimer];
    [self removeAllObserver];
    [self removeOldMoviePlayerController];
}

- (void)removeAllObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayerController];
}

- (void)removeOldMoviePlayerController
{
    if(!_moviePlayerController){
        return;
    }
    if (_moviePlayerController.loadState == MPMovieLoadStateUnknown) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self.moviePlayerController selector:@selector(prepareToPlay) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self.moviePlayerController selector:@selector(play) object:nil];
        [_moviePlayerController.view removeFromSuperview];
        _moviePlayerController = nil;
    }
    else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self.moviePlayerController selector:@selector(prepareToPlay) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self.moviePlayerController selector:@selector(play) object:nil];
        [self.moviePlayerController stop];
        [_moviePlayerController.view removeFromSuperview];
        _moviePlayerController = nil;
    }
}

- (void)adjustMoviePlayerControllerSize
{
    _moviePlayerController.view.frame = self.bounds;
}

- (void)changeMoviePlayerPlayState
{
    if(_moviePlayerController && _moviePlayerController.playbackState == MPMoviePlaybackStatePlaying){
        [self controlMoviePlayerStateIsPlay:NO];
    }
    else{
        [self controlMoviePlayerStateIsPlay:YES];
    }
}

- (void)controlMoviePlayerStateIsPlay:(BOOL)isPlay
{
    if(isPlay){
        if(_moviePlayerController.playbackState != MPMoviePlaybackStatePlaying){
            if(_videoPlayableSeconds>_videoPlayedSeconds){
                [self.moviePlayerController play];
            }
        }
    }
    else{
        if(_moviePlayerController.playbackState == MPMoviePlaybackStatePlaying){
            [_moviePlayerController pause];
        }
    }
}

- (void)setMoviePlayerPlayAtTime:(CGFloat)choosePlayTime
{
    if(choosePlayTime>=0 && choosePlayTime<_moviePlayerController.duration){
        _videoPlayedSeconds = choosePlayTime;
        [_moviePlayerController setCurrentPlaybackTime:choosePlayTime];
        [self.moviePlayerController play];
    }
}

- (void)addSomeNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoviePlayerPlayStateDidChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoviePlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MoviePlayerPlayFinished:) name: MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayerController];
}

- (void)removeSomeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:_moviePlayerController];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_moviePlayerController];
}

- (void)timerMethod
{
    if(!_moviePlayerController){
        return;
    }
    CGFloat duration = _moviePlayerController.duration;
    CGFloat playedTime = _moviePlayerController.currentPlaybackTime;
    CGFloat playableDuration = _moviePlayerController.playableDuration;
    if(isnan(duration)){
        duration = 0.0f;
    }
    if(isnan(playedTime)){
        playedTime = 0.0f;
    }
    if(isnan(playableDuration)){
        playableDuration = 0.0f;
    }
    self.videoTotalSeconds = duration;
    self.videoPlayedSeconds = playedTime;
    self.videoPlayableSeconds = playableDuration;
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayControlViewCurrentPlayState:)]){
        [_delegate videoPlayControlViewCurrentPlayState:_moviePlayerController.playbackState];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayControlViewCurrentLoadState:)]){
        [_delegate videoPlayControlViewCurrentLoadState:_moviePlayerController.loadState];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayControlViewCurrentPlayedTime:PlayableTime:TotalTime:)]){
        [_delegate videoPlayControlViewCurrentPlayedTime:self.videoPlayedSeconds PlayableTime:self.videoPlayableSeconds TotalTime:self.videoTotalSeconds];
    }
}

- (void)startTimer
{
    if(!_timer){
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerMethod) userInfo:nil repeats:YES];
        [self addSomeNotifications];
    }
}

- (void)stopTimer
{
    if(_timer){
        [_timer invalidate];
        _timer = nil;
        [self removeSomeNotifications];
    }
}

- (void)videoPlayBegin
{
    [self startTimer];
}

- (void)videoPlayFinish
{
    [self stopTimer];
}

#pragma mark --notification method--

- (void)moviePlayerIsPreparedToPlay:(NSNotification *)notification
{
    [self videoPlayBegin];
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayControlViewIsPrepareToPlay)]){
        [_delegate videoPlayControlViewIsPrepareToPlay];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.moviePlayerController];
    
}

- (void)MoviePlayerPlayFinished:(NSNotification *)notification
{
    [self videoPlayFinish];
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayControlViewIsFinishPlay)]){
        [_delegate videoPlayControlViewIsFinishPlay];
    }
}

- (void)MoviePlayerPlayStateDidChange:(NSNotification *)notification
{
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayControlViewCurrentPlayState:)]){
        [_delegate videoPlayControlViewCurrentPlayState:_moviePlayerController.playbackState];
    }
}

- (void)MoviePlayerLoadStateDidChange:(NSNotification *)notification
{
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayControlViewCurrentLoadState:)]){
        [_delegate videoPlayControlViewCurrentLoadState:_moviePlayerController.loadState];
    }
}

@end




































