//
//  SCVideoPlayTimeChooseHintView.m
//  StormChannel
//
//  Created by 王琦 on 15/7/23.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "SCVideoPlayTimeChooseHintView.h"

#define SEEKING_FORWARD_IMAGE_NAME   @"sc_video_play_seeking_forward_hint_image.png"
#define SEEKING_BACKWARD_IMAGE_NAME  @"sc_video_play_seeking_backward_hint_image.png"

@interface SCVideoPlayTimeChooseHintView ()

@property (weak, nonatomic) IBOutlet UIImageView *seekingImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *choosingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *separateLineLabel;

@end

@implementation SCVideoPlayTimeChooseHintView

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

- (void)setTotalTimeValue:(CGFloat)totalTimeValue
{
    if(_totalTimeValue!=totalTimeValue){
        _totalTimeValue = totalTimeValue;
        _totalTimeLabel.text = [UIUtil getTimeStringWithTotalSeconds:totalTimeValue];
    }
}

- (void)setPlayedTimeValue:(CGFloat)playedTimeValue
{
    if(_playedTimeValue!=playedTimeValue){
        _playedTimeValue = playedTimeValue;
        _choosingTimeLabel.text = [UIUtil getTimeStringWithPlayedSeconds:playedTimeValue];
    }
}

- (void)setIsSeekingBackward:(BOOL)isSeekingBackward
{
    if(_isSeekingBackward!=isSeekingBackward){
        _isSeekingBackward = isSeekingBackward;
        if(_isSeekingBackward){
            _seekingImageView.image = ImageNamed(SEEKING_BACKWARD_IMAGE_NAME);
        }
        else{
            _seekingImageView.image = ImageNamed(SEEKING_FORWARD_IMAGE_NAME);
        }
    }
}

@end







