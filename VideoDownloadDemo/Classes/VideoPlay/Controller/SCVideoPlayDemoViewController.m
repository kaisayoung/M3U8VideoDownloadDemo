//
//  SCVideoPlayDemoViewController.m
//  StormChannel
//
//  Created by 王琦 on 15/7/21.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "SCVideoPlayDemoViewController.h"
#import "SCVideoPlayManageView.h"

@interface SCVideoPlayDemoViewController ()<SCVideoPlayManageViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *whiteView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (assign, nonatomic) BOOL ifCanNotRotate;
@property (assign, nonatomic) CGRect normalScreenFrame;
@property (assign, nonatomic) NSInteger lastOrientationValue;
@property (strong, nonatomic) SCVideoPlayManageView *videoPlayManageView;

@end

@implementation SCVideoPlayDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.lastOrientationValue = 1;
    }
    return self;
}

- (void)initVideoPlayManageView
{
    _normalScreenFrame = CGRectMake(0, 20, SCREEN_WIDTH, ceilf(SCREEN_WIDTH*180/320));
    if(!_videoPlayManageView){
        _videoPlayManageView = [SCVideoPlayManageView loadFromXib];
        _videoPlayManageView.delegate = self;
        _videoPlayManageView.frame = _normalScreenFrame;
        [self.view addSubview:_videoPlayManageView];
        [_videoPlayManageView beginInitSubviews];
    }
    //
    _whiteView.top = _videoPlayManageView.bottom;
    _whiteView.height = SCREEN_HEIGHT-_videoPlayManageView.bottom;
    [self startPlay];
}

- (void)startPlay
{
    NSString *url = @"http://pl.youku.com/playlist/m3u8?ts=1437702603&keyframe=1&vid=320191511&type=flv&sid=843770260302821d3f1ad&token=2798&oip=1008521670&ep=zd8V3J4AK7hblIeUIUrhPIDTQEBtjjyORcilounf625td0T%2Fl9HuL3fkWRw6MvQW&did=65c906c26a8703f45f2f64b92bff8203e8697e75&ctype=21&ev=1";
    [_videoPlayManageView addTestDataWithVideoTitle:@"三分钟看清蝙蝠侠发展史" Url:url];
    _stateLabel.text = @"begin loading";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initVideoPlayManageView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationHasChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)rotateToFullScreen
{
    if(SCREEN_WIDTH>SCREEN_HEIGHT){
        _videoPlayManageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    else{
        _videoPlayManageView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    }
    [_videoPlayManageView enterInFullScreen];
}

- (void)rotateToLandscapeLeft
{
    if(_lastOrientationValue==UIInterfaceOrientationLandscapeLeft){
        return;
    }
    [self rotateToFullScreen];
    _lastOrientationValue = UIInterfaceOrientationLandscapeLeft;
}

- (void)rotateToLandscapeRight
{
    if(_lastOrientationValue==UIInterfaceOrientationLandscapeRight){
        return;
    }
    [self rotateToFullScreen];
    _lastOrientationValue = UIInterfaceOrientationLandscapeRight;
}

- (void)rotateToPortrait
{
    if(_lastOrientationValue==UIInterfaceOrientationPortrait){
        return;
    }
    _videoPlayManageView.frame = _normalScreenFrame;
    [_videoPlayManageView exitFromFullScreen];
    _lastOrientationValue = UIInterfaceOrientationPortrait;
}

- (void)orientationHasChange:(NSNotification *)notification
{
    if(_ifCanNotRotate){
        return;
    }
    UIDevice *device = (UIDevice *)notification.object;
    if(device.orientation == UIInterfaceOrientationLandscapeLeft){
        [self rotateToLandscapeLeft];
    }
    else if(device.orientation == UIInterfaceOrientationLandscapeRight){
        [self rotateToLandscapeRight];
    }
    else if(device.orientation == UIInterfaceOrientationPortrait){
        [self rotateToPortrait];
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

#pragma mark --- SCVideoPlayManageViewDelegate ---

- (void)videoPlayManageViewVideoBeginPlay
{
    _stateLabel.text = @"stop loading & begin play";
}

- (void)videoPlayManageViewVideoFinishPlay
{
    _stateLabel.text = @"Play finish hahaha!!!";
}

- (void)videoPlayManageViewBackButtonTapped
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)videoPlayManageViewReplayButtonTapped
{
    [_videoPlayManageView resetData];
    [self startPlay];
}

- (void)videoPlayManageViewExitFullScreenButtonTapped
{
    if([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]){
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [UIViewController attemptRotationToDeviceOrientation];
}

- (void)videoPlayManageViewEnterFullScreenButtonTapped
{
    if([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]){
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [UIViewController attemptRotationToDeviceOrientation];
    [self rotateToLandscapeRight];
}

#pragma mark --- control orientation method ---

- (BOOL)shouldAutorotate
{
    if(_ifCanNotRotate){
        return NO;
    }
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if(_ifCanNotRotate){
        return self.interfaceOrientation;
    }
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end

















