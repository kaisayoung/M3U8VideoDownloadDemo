//
//  SCVideoPlayListTableViewCell.m
//  StormChannel
//
//  Created by 王琦 on 15/7/23.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "SCVideoPlayListTableViewCell.h"
#import "SCVideoPlayManageView.h"
#import "ITTXibViewUtils.h"

//海报与上下边距总和86!
//plus    394   216    302
//6       355   194    280
//5       300   164    250

@interface SCVideoPlayListTableViewCell ()<SCVideoPlayManageViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UIView *subControlView;
@property (weak, nonatomic) IBOutlet UIImageView *playIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (strong, nonatomic) SCVideoPlayManageView *videoPlayManageView;
@property (strong, nonatomic) NSString *videoUrl;

- (IBAction)onTransparentButtonClicked:(id)sender;

@end

@implementation SCVideoPlayListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _videoPlayView.width = SCREEN_WIDTH-20;
    _videoPlayView.height = ceilf((SCREEN_WIDTH-20)*164/300);
    _playIconImageView.centerX = _videoPlayView.width/2;
    _playIconImageView.centerY = _videoPlayView.height/2;
}

+ (SCVideoPlayListTableViewCell *)cellFromNib
{
    return [ITTXibViewUtils loadViewFromXibNamed:@"SCVideoPlayListTableViewCell"];
}

- (void)initVideoPlayManageView
{
    if(!_videoPlayManageView){
        _videoPlayManageView = [SCVideoPlayManageView loadFromXib];
        _videoPlayManageView.delegate = self;
        _videoPlayManageView.isListPlay = YES;
        _videoPlayManageView.frame = _videoPlayView.bounds;
        [_videoPlayView addSubview:_videoPlayManageView];
        [_videoPlayManageView beginInitSubviews];
    }
    [self startPlay];
}

- (void)startPlay
{
    [_videoPlayManageView addTestDataWithVideoTitle:_videoTitleLabel.text Url:_videoUrl];
}

- (void)beginTryToPlayCurrentVideo
{
    _subControlView.hidden = YES;
    [self initVideoPlayManageView];
}

- (void)removeReusePlayManageView
{
    if(_videoPlayManageView){
        if(_delegate && [_delegate respondsToSelector:@selector(videoPlayListTableViewCellRemoveReusePlayManageView)]){
            [_delegate videoPlayListTableViewCellRemoveReusePlayManageView];
        }
        [_videoPlayManageView destorySelf];
        [_videoPlayManageView removeFromSuperview];
        _videoPlayManageView = nil;
    }
}

- (void)getDataSourceFromVideoTitle:(NSString *)title VideoUrl:(NSString *)url
{
    _titleLabel.text = [NSString stringWithFormat:@"视频名称：%ld",_index];
    _videoTitleLabel.text = title;
    _videoUrl = url;
    
    [self backToInitState];
    [_videoPlayView removeAllSubviews];
    [_videoPlayView addSubview:_subControlView];

    if(_isCurrentCellPlaying){
        [self onTransparentButtonClicked:nil];
    }
    
}

- (void)enterInFullScreen
{
    _videoPlayManageView.frame = self.videoPlayView.bounds;
    [_videoPlayManageView enterInFullScreen];
}

- (void)exitFromFullScreen
{
    _videoPlayManageView.frame = self.videoPlayView.bounds;
    [_videoPlayManageView exitFromFullScreen];
}

- (void)backToInitState
{
    [self removeReusePlayManageView];
    self.subControlView.hidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)onTransparentButtonClicked:(id)sender
{
    _isCurrentCellPlaying = YES;
    [self beginTryToPlayCurrentVideo];
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayListTableViewCellPlayButtonTappedWithIndex:AndCell:)]){
        [_delegate videoPlayListTableViewCellPlayButtonTappedWithIndex:_index AndCell:self];
    }
}

#pragma mark --- SCVideoPlayManageViewDelegate ---

- (void)videoPlayManageViewVideoBeginPlay
{
    
}

- (void)videoPlayManageViewVideoFinishPlay
{
    
}

- (void)videoPlayManageViewReplayButtonTapped
{
    [_videoPlayManageView resetData];
    [self startPlay];
}

- (void)videoPlayManageViewExitFullScreenButtonTapped
{
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayListTableViewCellExitFullScreenButtonTapped)]){
        [_delegate videoPlayListTableViewCellExitFullScreenButtonTapped];
    }
}

- (void)videoPlayManageViewEnterFullScreenButtonTapped
{
    if(_delegate && [_delegate respondsToSelector:@selector(videoPlayListTableViewCellEnterFullScreenButtonTapped)]){
        [_delegate videoPlayListTableViewCellEnterFullScreenButtonTapped];
    }
}

@end























