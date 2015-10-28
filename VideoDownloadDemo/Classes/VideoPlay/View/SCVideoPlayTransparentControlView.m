//
//  SCVideoPlayTransparentControlView.m
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "SCVideoPlayTransparentControlView.h"
#import "SCVideoPlayTimeChooseHintView.h"

@interface SCVideoPlayTransparentControlView ()

@property (strong, nonatomic) SCVideoPlayTimeChooseHintView *timeChooseHintView;

@property (assign, nonatomic) BOOL isMoved;
@property (assign, nonatomic) CGPoint lastPoint;
@property (assign, nonatomic) CGPoint beginPoint;
@property (assign, nonatomic) CGPoint finishPoint;


@end

@implementation SCVideoPlayTransparentControlView

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
    _totalSeekingValue = 60;
    _timeChooseHintView = [SCVideoPlayTimeChooseHintView loadFromXib];
    _timeChooseHintView.hidden = YES;
    [self addSubview:_timeChooseHintView];
}

- (void)adjustSeekingHintViewPosition
{
    _timeChooseHintView.centerX = self.width/2;
    _timeChooseHintView.centerY = self.height/2;
}

- (void)setTotalTimeValue:(CGFloat)totalTimeValue
{
    if(!_totalTimeValue!=totalTimeValue){
        _totalTimeValue = totalTimeValue;
        _timeChooseHintView.totalTimeValue = totalTimeValue;
    }
}

- (BOOL)ifResponseToTouch
{
    if(!_ifCanMove){
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL responseToTouch = [self ifResponseToTouch];
    if(!responseToTouch){
        return;
    }
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _lastPoint = point;
    _beginPoint = point;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL responseToTouch = [self ifResponseToTouch];
    if(!responseToTouch){
        return;
    }
    _timeChooseHintView.hidden = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    if(point.x>_beginPoint.x){
        _timeChooseHintView.isSeekingBackward = NO;
    }
    else{
        _timeChooseHintView.isSeekingBackward = YES;
    }
    CGFloat value = (point.x-_beginPoint.x)*_totalSeekingValue/self.width;   //单位是s
    CGFloat choosingTime = value+_playedTimeValue;
    if(choosingTime>=0&&choosingTime<=_totalTimeValue){
        _timeChooseHintView.playedTimeValue = choosingTime;
        if(_delegate && [_delegate respondsToSelector:@selector(videoPlayTransparentControlViewChoosingTimeValue:)]){
            [_delegate videoPlayTransparentControlViewChoosingTimeValue:choosingTime];
        }
    }
    _lastPoint = point;
    _isMoved = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL responseToTouch = [self ifResponseToTouch];
    if(!responseToTouch || !_isMoved){
        if(_delegate && [_delegate respondsToSelector:@selector(videoPlayTransparentControlViewTouchEnded)]){
            [_delegate videoPlayTransparentControlViewTouchEnded];
        }
        return;
    }
    _isMoved = NO;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [UIView animateWithDuration:0.3 animations:^{
        _timeChooseHintView.alpha = 0;
    } completion:^(BOOL finished) {
        _timeChooseHintView.hidden = YES;
        _timeChooseHintView.alpha = 1;
    }];
    CGFloat value = (point.x-_beginPoint.x)*_totalSeekingValue/self.width;   //单位是s
    CGFloat chooseTime = value+_playedTimeValue;
    if(chooseTime<=0){
        chooseTime = 1;
    }
    else if(chooseTime>=_totalTimeValue){
        chooseTime = _totalTimeValue-2;
    }
    if(chooseTime>0&&chooseTime<_totalTimeValue){
        _timeChooseHintView.playedTimeValue = chooseTime;
        if(_delegate && [_delegate respondsToSelector:@selector(videoPlayTransparentControlViewChoosePlayTimeValue:)]){
            [_delegate videoPlayTransparentControlViewChoosePlayTimeValue:chooseTime];
        }
    }
}

@end















