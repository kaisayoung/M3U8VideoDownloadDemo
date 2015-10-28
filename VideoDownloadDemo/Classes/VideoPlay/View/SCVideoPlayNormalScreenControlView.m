//
//  SCVideoPlayNormalScreenControlView.m
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "SCVideoPlayNormalScreenControlView.h"
#import "SCVideoPlayProgressControlView.h"
#import "SCVideoPlayTransparentControlView.h"

#define NORMAL_SCREEN_PLAY_BTN_NORMAL_STATE_NAME      @"sc_video_play_ns_play_btn.png"
#define NORMAL_SCREEN_PLAY_BTN_TAPPED_STATE_NAME      @"sc_video_play_ns_play_btn_hl.png"
#define NORMAL_SCREEN_PAUSE_BTN_NORMAL_STATE_NAME     @"sc_video_play_ns_pause_btn.png"
#define NORMAL_SCREEN_PAUSE_BTN_TAPPED_STATE_NAME     @"sc_video_play_ns_pause_btn_hl.png"

@interface SCVideoPlayNormalScreenControlView ()<SCVideoPlayProgressControlViewDelegate,SCVideoPlayTransparentControlViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *maskImageView;
@property (weak, nonatomic) IBOutlet UIImageView *loadingBgImageView;
@property (weak, nonatomic) IBOutlet UIView *progressHintView;
@property (weak, nonatomic) IBOutlet UIView *currentPlayedProgressView;
@property (weak, nonatomic) IBOutlet UIView *bottomControlView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *playedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *progressControlBgView;
@property (weak, nonatomic) IBOutlet UIView *transparentView;
@property (weak, nonatomic) IBOutlet UIView *topControlView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *hintView;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;
@property (strong, nonatomic) SCVideoPlayProgressControlView *progressControlView;
@property (strong, nonatomic) SCVideoPlayTransparentControlView *transparentControlView;
@property (assign, nonatomic) BOOL isHidingControlView;
@property (assign, nonatomic) CGFloat fadeDelay;
@property (assign, nonatomic) CGFloat totalTimeValue;

@property (assign, nonatomic) BOOL isFinish;

- (IBAction)onOneFuctionButtonClicked:(id)sender;


@end

@implementation SCVideoPlayNormalScreenControlView

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
    _fadeDelay = 5.0;
}

- (void)adjustSubviewsPosition
{
    _replayButton.centerX = self.width/2;
    _replayButton.centerY = self.height/2;
}

- (void)initSubviews
{
    [self adjustSubviewsPosition];
    if(!_progressControlView){
        _progressControlView = [SCVideoPlayProgressControlView loadFromXib];
        _progressControlView.delegate = self;
        _progressControlView.frame = _progressControlBgView.bounds;
        [_progressControlBgView addSubview:_progressControlView];
    }
    if(!_transparentControlView){
        _transparentControlView = [SCVideoPlayTransparentControlView loadFromXib];
        _transparentControlView.delegate = self;
        _transparentControlView.frame = _transparentView.bounds;
        [_transparentView addSubview:_transparentControlView];
        [_transparentControlView adjustSeekingHintViewPosition];
    }
}

- (void)setIsPlaying:(BOOL)isPlaying
{
    if(_isPlaying!=isPlaying){
        _isPlaying=isPlaying;
        if(_isPlaying){
            [_playButton setImage:ImageNamed(NORMAL_SCREEN_PAUSE_BTN_NORMAL_STATE_NAME) forState:UIControlStateNormal];
            [_playButton setImage:ImageNamed(NORMAL_SCREEN_PAUSE_BTN_TAPPED_STATE_NAME) forState:UIControlStateHighlighted];
        }
        else{
            [_playButton setImage:ImageNamed(NORMAL_SCREEN_PLAY_BTN_NORMAL_STATE_NAME) forState:UIControlStateNormal];
            [_playButton setImage:ImageNamed(NORMAL_SCREEN_PLAY_BTN_TAPPED_STATE_NAME) forState:UIControlStateHighlighted];
        }
    }
}

- (void)setIsListPlay:(BOOL)isListPlay
{
    if(_isListPlay!=isListPlay){
        _isListPlay=isListPlay;
        _topControlView.hidden=_isListPlay;
    }
}

- (void)setVideoTitle:(NSString *)videoTitle
{
    if(![_videoTitle isEqualToString:videoTitle]){
        _videoTitle = videoTitle;
        _videoTitleLabel.text = videoTitle;
    }
}

- (void)videoPlayBegin
{
    _loadingBgImageView.hidden = YES;
    _progressControlView.ifCanMove = YES;
    _transparentControlView.ifCanMove = YES;
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:2.0];
}

- (void)videoPlayFinish
{
    _isFinish = YES;
    _hintView.hidden = NO;
    [self showControls:nil];
}

- (void)resetDataAnyway
{
    _isFinish = NO;
    _hintView.hidden = YES;
    _loadingBgImageView.hidden = NO;
    _progressControlView.ifCanMove = NO;
    _transparentControlView.ifCanMove = NO;
    self.isPlaying = NO;
}

- (void)resetDataContainLastPlayedTime:(BOOL)containLastPlayedTime
{
    [self resetDataAnyway];
    if(containLastPlayedTime){
        _totalTimeLabel.text = @"00:00";
        _playedTimeLabel.text = @"00:00";
        _currentPlayedProgressView.width = 0.1;
        [_progressControlView resetData];
    }
}

- (void)setVideoPlayedTimeValue:(CGFloat)playedValue BufferedTimeValue:(CGFloat)bufferedValue TotalTimeValue:(CGFloat)totalValue
{
    _progressControlView.totalTimeValue = totalValue;
    _progressControlView.playableTimeValue = bufferedValue;
    _transparentControlView.totalTimeValue = totalValue;
    _totalTimeLabel.text = [UIUtil getTimeStringWithTotalSeconds:totalValue];
    if(_isPlaying){
        _progressControlView.playedTimeValue = playedValue;
        _transparentControlView.playedTimeValue = playedValue;
        _playedTimeLabel.text = [UIUtil getTimeStringWithPlayedSeconds:playedValue];
        if(totalValue!=0){
            _currentPlayedProgressView.width = _progressHintView.width*(playedValue/totalValue);
        }
    }
    if(totalValue!=0){
        _totalTimeValue = totalValue;
    }
}

- (void)setChoosePlayedTimeValue:(CGFloat)choosedTimeValue
{
    _progressControlView.playedTimeValue = choosedTimeValue;
    _transparentControlView.playedTimeValue = choosedTimeValue;
    _playedTimeLabel.text = [UIUtil getTimeStringWithPlayedSeconds:choosedTimeValue];
    _currentPlayedProgressView.width = _progressHintView.width*(choosedTimeValue/_totalTimeValue);
}

- (void)showControls:(void(^)(void))completion
{
    if(_isHidingControlView){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        [UIView animateWithDuration:0.3 animations:^{
            _isHidingControlView = NO;
            _topControlView.alpha = 1;
            _bottomControlView.alpha = 1;
            _maskImageView.alpha = 0.8;
            _progressHintView.alpha = 0;
        } completion:^(BOOL finished) {
            if(completion){
                completion();
            }
            if(!_isFinish){
                [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
            }
        }];
    }
    else{
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        if(completion){
            completion();
        }
        if(!_isFinish){
            [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
        }
    }
}

- (void)hideControls:(void(^)(void))completion
{
    if(!_isHidingControlView){
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
        [UIView animateWithDuration:0.3 animations:^{
            _isHidingControlView = YES;
            _topControlView.alpha = 0;
            _bottomControlView.alpha = 0;
            _maskImageView.alpha = 0;
            _progressHintView.alpha = 1;
        } completion:^(BOOL finished) {
            if(completion){
                completion();
            }
        }];
    }
    else{
        if(completion){
            completion();
        }
    }
}

- (IBAction)onOneFuctionButtonClicked:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 0:
        {
            if(_delegate && [_delegate respondsToSelector:@selector(videoPlayNormalScreenControlViewExitButtonTapped)]){
                [_delegate videoPlayNormalScreenControlViewExitButtonTapped];
            }
        }
            break;
        case 1:
        {
            if(_delegate && [_delegate respondsToSelector:@selector(videoPlayNormalScreenControlViewPlayButtonTapped)]){
                [_delegate videoPlayNormalScreenControlViewPlayButtonTapped];
            }
        }
            break;
        case 2:
        {
            if(_delegate && [_delegate respondsToSelector:@selector(videoPlayNormalScreenControlViewEnterFullScreenButtonTapped)]){
                [_delegate videoPlayNormalScreenControlViewEnterFullScreenButtonTapped];
            }
        }
            break;
        case 3:
        {
            if(_delegate && [_delegate respondsToSelector:@selector(videoPlayNormalScreenControlViewReplayButtonTapped)]){
                [_delegate videoPlayNormalScreenControlViewReplayButtonTapped];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark --- SCVideoPlayProgressControlViewDelegate ---

- (void)videoPlayProgressControlViewChoosingTimeValue:(CGFloat)timeValue
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControls:) object:nil];
    _playedTimeLabel.text = [UIUtil getTimeStringWithPlayedSeconds:timeValue];
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayNormalScreenControlViewChoosingTimeValue:)]){
        [_delegate videoPlayNormalScreenControlViewChoosingTimeValue:timeValue];
    }
}

- (void)videoPlayProgressControlViewChoosePlayTimeValue:(CGFloat)timeValue
{
    [self performSelector:@selector(hideControls:) withObject:nil afterDelay:self.fadeDelay];
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayNormalScreenControlViewChoosePlayTimeValue:)]){
        [_delegate videoPlayNormalScreenControlViewChoosePlayTimeValue:timeValue];
    }
}

#pragma mark --- SCVideoPlayTransparentControlViewDelegate ---

- (void)videoPlayTransparentControlViewTouchEnded
{
    self.isHidingControlView?[self showControls:nil]:[self hideControls:nil];
}

- (void)videoPlayTransparentControlViewChoosingTimeValue:(CGFloat)timeValue
{
    _progressControlView.playedTimeValue = timeValue;
    _playedTimeLabel.text = [UIUtil getTimeStringWithPlayedSeconds:timeValue];
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayNormalScreenControlViewChoosingTimeValue:)]){
        [_delegate videoPlayNormalScreenControlViewChoosingTimeValue:timeValue];
    }
}

- (void)videoPlayTransparentControlViewChoosePlayTimeValue:(CGFloat)timeValue
{
    _progressControlView.playedTimeValue = timeValue;
    _playedTimeLabel.text = [UIUtil getTimeStringWithPlayedSeconds:timeValue];
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayNormalScreenControlViewChoosePlayTimeValue:)]){
        [_delegate videoPlayNormalScreenControlViewChoosePlayTimeValue:timeValue];
    }
}

@end




















