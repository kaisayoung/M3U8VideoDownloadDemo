//
//  SCVideoPlayProgressControlView.m
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "SCVideoPlayProgressControlView.h"

@interface SCVideoPlayProgressControlView ()

@property (weak, nonatomic) IBOutlet UIImageView *totalProgressImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bufferedProgressImageView;
@property (weak, nonatomic) IBOutlet UIImageView *playedProgressImageView;
@property (weak, nonatomic) IBOutlet UIImageView *currentProgressImageView;
@property (assign, nonatomic) BOOL isMoved;

@end

@implementation SCVideoPlayProgressControlView

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
    _totalProgressImageView.centerY = self.height/2;
    _playedProgressImageView.centerY = self.height/2;
    _bufferedProgressImageView.centerY = self.height/2;
}

- (void)resetData
{
    _playedProgressImageView.width=0.1;
    _bufferedProgressImageView.width=0.1;
    _currentProgressImageView.centerX=0.0;
}

- (void)setPlayedTimeValue:(CGFloat)playedTimeValue
{
    if(_totalTimeValue==0 || _playedTimeValue==playedTimeValue){
        return;
    }
    _playedTimeValue = playedTimeValue;
    CGFloat playedProportionValue = _playedTimeValue/_totalTimeValue;
    _playedProgressImageView.width = _totalProgressImageView.width*playedProportionValue;
    _currentProgressImageView.centerX = _playedProgressImageView.right;
}

- (void)setPlayableTimeValue:(CGFloat)playableTimeValue
{
    if(_totalTimeValue==0 || _playableTimeValue==playableTimeValue){
        return;
    }
    _playableTimeValue = playableTimeValue;
    CGFloat bufferedProportionValue = _playableTimeValue/_totalTimeValue;
    _bufferedProgressImageView.width = _totalProgressImageView.width*bufferedProportionValue;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!_ifCanMove){
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!_ifCanMove){
        return;
    }
    CGPoint pt = [[touches anyObject] locationInView:self];
    if(pt.x<=0){
        pt.x = 0;
    }
    else if(pt.x>=self.width){
        pt.x = self.width;
    }
    _currentProgressImageView.centerX = pt.x;
    CGFloat playedProportionValue = (pt.x)/self.width;
    _playedProgressImageView.width = _totalProgressImageView.width*playedProportionValue;
    _currentProgressImageView.centerX = _playedProgressImageView.right;
    CGFloat playedTimeValue = _totalTimeValue*playedProportionValue;
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayProgressControlViewChoosingTimeValue:)]){
        [_delegate videoPlayProgressControlViewChoosingTimeValue:playedTimeValue];
    }
    _isMoved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!_ifCanMove){
        return;
    }
    if(!_isMoved){
        return;
    }
    _isMoved = NO;
    CGPoint pt = [[touches anyObject] locationInView:self];
    if(pt.x<=0){
        pt.x = 0;
    }
    else if(pt.x>=self.width){
        pt.x = self.width;
    }
    _currentProgressImageView.centerX = pt.x;
    CGFloat playedProportionValue = (pt.x)/self.width;
    _playedProgressImageView.width = _totalProgressImageView.width*playedProportionValue;
    _currentProgressImageView.centerX = _playedProgressImageView.right;
    CGFloat playedTimeValue = _totalTimeValue*playedProportionValue;
    if(playedTimeValue>=_totalTimeValue){
        playedTimeValue = _totalTimeValue-5;
    }
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayProgressControlViewChoosePlayTimeValue:)]){
        [_delegate videoPlayProgressControlViewChoosePlayTimeValue:playedTimeValue];
    }
}

@end














