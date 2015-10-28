//
//  SCVideoPlayDemo3ViewController.m
//  StormChannel
//
//  Created by 王琦 on 15/7/24.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import "SCVideoPlayDemo3ViewController.h"
#import "SCVideoPlayListTableViewCell.h"

@interface SCVideoPlayDemo3ViewController ()<UITableViewDataSource,UITableViewDelegate,SCVideoPlayListTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SCVideoPlayListTableViewCell *currentPlayingCell;
@property (assign, nonatomic) NSInteger currentPlayingIndex;
@property (assign, nonatomic) NSInteger lastOrientationValue;
@property (assign, nonatomic) CGRect startFrame1;               //在cell上的frame
@property (assign, nonatomic) CGRect startFrame2;               //转到self.view上的frame
@property (assign, nonatomic) CGFloat cellHeight;
@property (strong, nonatomic) NSMutableArray *listArray;
@property (strong, nonatomic) NSMutableArray *visibleIndexArray;
@property (assign, nonatomic) BOOL ifAutoPlay;                  //是否自动播放
@property (assign, nonatomic) BOOL ifViewDisappear;             //是否离开此页面

- (IBAction)onBackButtonClicked:(id)sender;
- (IBAction)onSwitchButtonClicked:(id)sender;

@end

@implementation SCVideoPlayDemo3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.lastOrientationValue = 1;
    }
    return self;
}

- (void)addTestData
{
    if(ISIPHONE6){
        _cellHeight = 280;
    }
    else if(ISIPHONE6PLUS){
        _cellHeight = 302;
    }
    else{
        _cellHeight = 250;
    }
    _listArray = [NSMutableArray array];
    _visibleIndexArray = [NSMutableArray array];
    NSMutableDictionary *dic0 = [NSMutableDictionary dictionary];
    [dic0 setObject:@"黄老板Ed Sheeran单曲 Don't" forKey:@"title"];
    [dic0 setObject:@"http://s.dingboshi.cn:8080/school/file/201507/resource/79e01f8be9db444291257b067ccffbc7.mp4" forKey:@"url"];
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setObject:@"《我的世界★Minecraft - 红叔勇者的极限生存》" forKey:@"title"];
    [dic1 setObject:@"http://pl.youku.com/playlist/m3u8?ts=1437701404&keyframe=1&vid=156616791&type=mp4&sid=843770140406021a49c3e&token=9349&oip=1008521670&ep=3eqc%2BKmdOBcZzztXlpaFv%2B0bW8F91nOmnXjQqcDNdBwyHlizjMh5aZ9FoBopN9xy&did=65c906c26a8703f45f2f64b92bff8203e8697e75&ctype=21&ev=1" forKey:@"url"];
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setObject:@"17个超牛开瓶绝招" forKey:@"title"];
    [dic2 setObject:@"http://pl.youku.com/playlist/m3u8?ts=1437701345&keyframe=1&vid=321078601&type=mp4&sid=54377013456362135b1d0&token=8522&oip=1008521675&ep=OAf0nR%2F%2B9B%2BPguQmrDQP9FH850C4WPDKe06dAUr5qoyRP%2Bp04Re3GTLTY20BzRlZ&did=65c906c26a8703f45f2f64b92bff8203e8697e75&ctype=21&ev=1" forKey:@"url"];
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setObject:@"猫的集会" forKey:@"title"];
    [dic3 setObject:@"http://pl.youku.com/playlist/m3u8?did=838637d7afb0e0461f19a0dfaf3e00859b191c48&ts=1437703803&ctype=65&token=4797&keyframe=1&sid=3437703803075658fe5b3&ev=1&type=3gphd&oip=1008521675&vid=XNTQ5OTkwODMy&ep=S6LKs3w4lznSO9SWRuCzL9zx7VSqZJnboLctKOgFxXJkghlhAhq3MXZxRYQpwZ82" forKey:@"url"];
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setObject:@"【Dark5】5大二战中不可思议的巧合" forKey:@"title"];
    [dic4 setObject:@"http://pl.youku.com/playlist/m3u8?ts=1437703369&keyframe=1&vid=322585193&type=mp4&sid=0437703369022215df43b&token=9414&oip=1008521672&ep=aqX0IleqSBYH0vzmTXRsAFkH8pJmdKIjBVVP5xMOgQF1B8hzBNGMqAEE8pURFqUW&did=65c906c26a8703f45f2f64b92bff8203e8697e75&ctype=21&ev=1" forKey:@"url"];
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
    [dic5 setObject:@"雏蜂：01 序章 上 天使降临" forKey:@"title"];
    [dic5 setObject:@"http://s.dingboshi.cn:8080/school/file/201507/resource/79e01f8be9db444291257b067ccffbc7.mp4" forKey:@"url"];
    NSMutableDictionary *dic6 = [NSMutableDictionary dictionary];
    [dic6 setObject:@"那些年，我们追过的武侠剧" forKey:@"title"];
    [dic6 setObject:@"http://pl.youku.com/playlist/m3u8?ts=1437701818&keyframe=1&vid=XOTM3NjkwMDU2&type=mp4&sid=843770181829221b06a9e&token=4332&oip=1008521673&ep=oO2KuypCEu1LSkVIFO0w1aQYCQgBVeyzksn%2B0ev9okhV0A69Xy4NP%2FgRvpxYZJEI&did=65c906c26a8703f45f2f64b92bff8203e8697e75&ctype=21&ev=1" forKey:@"url"];
    NSMutableDictionary *dic7 = [NSMutableDictionary dictionary];
    [dic7 setObject:@"如果把“失眠”拟人化" forKey:@"title"];
    [dic7 setObject:@"http://pl.youku.com/playlist/m3u8?ts=1437702603&keyframe=1&vid=320191511&type=flv&sid=843770260302821d3f1ad&token=2798&oip=1008521670&ep=zd8V3J4AK7hblIeUIUrhPIDTQEBtjjyORcilounf625td0T%2Fl9HuL3fkWRw6MvQW&did=65c906c26a8703f45f2f64b92bff8203e8697e75&ctype=21&ev=1" forKey:@"url"];
    [_listArray addObject:dic0];
    [_listArray addObject:dic1];
    [_listArray addObject:dic2];
    [_listArray addObject:dic3];
    [_listArray addObject:dic4];
    [_listArray addObject:dic5];
    [_listArray addObject:dic6];
    [_listArray addObject:dic7];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addTestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationHasChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    //可以在此添加网络判断然后决定修改是否自动播放
    _ifAutoPlay = YES;
    _ifViewDisappear = NO;
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    _ifViewDisappear = YES;
    if(_currentPlayingCell){
        [_currentPlayingCell backToInitState];
        _currentPlayingCell = nil;
    }
}

- (void)changeFatherViewIfNecessary
{
    //如有必要，先将视图移到self.view上
    if(_lastOrientationValue==UIInterfaceOrientationPortrait){
        _startFrame1 = _currentPlayingCell.videoPlayView.frame;
        _startFrame2 = [_currentPlayingCell.videoPlayView convertRect:_currentPlayingCell.videoPlayView.bounds toView:self.view];
        [_currentPlayingCell.videoPlayView removeFromSuperview];
        _currentPlayingCell.videoPlayView.frame = _startFrame2;
        [self.view addSubview:_currentPlayingCell.videoPlayView];
    }
}

- (void)rotateToFullScreen
{
    if(SCREEN_WIDTH>SCREEN_HEIGHT){
        _currentPlayingCell.videoPlayView.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    }
    else{
        _currentPlayingCell.videoPlayView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    [_currentPlayingCell enterInFullScreen];
}

- (void)rotateToLandscapeLeft
{
    BOOL isOutOfScreen = [self judgeCurrentFullScreenPlayingCellIfOutOfScreen];
    if(isOutOfScreen){
        if(_currentPlayingCell){
            [_currentPlayingCell backToInitState];
            _currentPlayingCell = nil;
        }
        return;
    }
    if(_lastOrientationValue==UIInterfaceOrientationLandscapeLeft){
        return;
    }
    [self changeFatherViewIfNecessary];
    [UIView animateWithDuration:0.3 animations:^{
        _currentPlayingCell.videoPlayView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        [self rotateToFullScreen];
    } completion:^(BOOL finished) {
    }];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
    _lastOrientationValue = UIInterfaceOrientationLandscapeLeft;
}

- (void)rotateToLandscapeRight
{
    BOOL isOutOfScreen = [self judgeCurrentFullScreenPlayingCellIfOutOfScreen];
    if(isOutOfScreen){
        if(_currentPlayingCell){
            [_currentPlayingCell backToInitState];
            _currentPlayingCell = nil;
        }
        return;
    }
    if(_lastOrientationValue==UIInterfaceOrientationLandscapeRight){
        return;
    }
    [self changeFatherViewIfNecessary];
    [UIView animateWithDuration:0.3 animations:^{
        _currentPlayingCell.videoPlayView.transform = CGAffineTransformMakeRotation(M_PI/2);
        [self rotateToFullScreen];
    } completion:^(BOOL finished) {
    }];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    _lastOrientationValue = UIInterfaceOrientationLandscapeRight;
}

- (void)rotateToPortrait
{
    if(_lastOrientationValue==UIInterfaceOrientationPortrait){
        return;
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    if(_currentPlayingCell){
        [UIView animateWithDuration:0.3 animations:^{
            _currentPlayingCell.videoPlayView.transform = CGAffineTransformIdentity;
            _currentPlayingCell.videoPlayView.frame = _startFrame2;
            [_currentPlayingCell exitFromFullScreen];
        } completion:^(BOOL finished) {
        }];
        //再将视图移到cell上
        [_currentPlayingCell.videoPlayView removeFromSuperview];
        _currentPlayingCell.videoPlayView.frame = _startFrame1;
        [self.currentPlayingCell addSubview:_currentPlayingCell.videoPlayView];
        [self.currentPlayingCell bringSubviewToFront:_currentPlayingCell.videoPlayView];
    }
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    _lastOrientationValue = UIInterfaceOrientationPortrait;
}

- (void)orientationHasChange:(NSNotification *)notification
{
    if(!_currentPlayingCell){
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

- (IBAction)onBackButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSwitchButtonClicked:(id)sender
{
    //模拟切换是否自动播放和切换页面
    //    _ifAutoPlay = !_ifAutoPlay;
    if(!_ifViewDisappear){
        [self viewWillDisappear:YES];
    }
    else{
        [self viewWillAppear:YES];
    }
}

- (void)setCurrentPlayingIndex:(NSInteger)currentPlayingIndex
{
    if(_currentPlayingIndex!=currentPlayingIndex){
        _currentPlayingIndex=currentPlayingIndex;
        if(_currentPlayingCell){
            if(_lastOrientationValue!=UIInterfaceOrientationPortrait){
                NSLog(@"duang duang new index is %ld",currentPlayingIndex);
            }
        }
        [_tableView reloadData];
    }
}

- (BOOL)judgeOneIndexPathIsExistInVisibleIndexArrayWithValue:(NSIndexPath *)indexPath
{
    NSInteger visibleCount = [_visibleIndexArray count];
    for(int i=0;i<visibleCount;i++){
        NSIndexPath *oneIndexPath = [_visibleIndexArray objectAtIndex:i];
        if(oneIndexPath.row==indexPath.row){
            return YES;
        }
    }
    return NO;
}

- (void)addOneIndexPathToVisibleIndexArrayWithValue:(NSIndexPath *)indexPath
{
    BOOL isExist = [self judgeOneIndexPathIsExistInVisibleIndexArrayWithValue:indexPath];
    if(!isExist){
        [_visibleIndexArray addObject:indexPath];
    }
}

- (NSInteger)getCurrentCellIndexShouldBePlaying
{
    NSInteger visibleCount = [_visibleIndexArray count];
    if(visibleCount==2){
        CGFloat offsetY = _tableView.contentOffset.y;
        CGFloat totalCount = _tableView.height/_cellHeight;
        CGFloat offsetIndex = offsetY/_cellHeight;
        CGFloat firstShowValue = ceilf(offsetIndex)-offsetIndex;
        CGFloat secondShowValue = totalCount-firstShowValue;
        NSIndexPath *firstIndexPath = [_visibleIndexArray firstObject];
        NSIndexPath *lastIndexPath = [_visibleIndexArray lastObject];
        if(offsetY==0 || (secondShowValue<=firstShowValue)){
            return firstIndexPath.row;
        }
        else{
            return lastIndexPath.row;
        }
    }
    else if(visibleCount==3){
        NSIndexPath *firstIndexPath = [_visibleIndexArray firstObject];
        NSInteger smallIndex = firstIndexPath.row;
        for(int i=1;i<visibleCount;i++){
            NSIndexPath *oneIndexPath = [_visibleIndexArray objectAtIndex:i];
            if(oneIndexPath.row<=smallIndex){
                smallIndex=oneIndexPath.row;
            }
        }
        return smallIndex+1;
    }
    return 0;
}

- (BOOL)judgeCurrentFullScreenPlayingCellIfOutOfScreen
{
    NSInteger visibleCount = [_visibleIndexArray count];
    for(int i=0;i<visibleCount;i++){
        NSIndexPath *oneIndexPath = [_visibleIndexArray objectAtIndex:i];
        if(_currentPlayingIndex==oneIndexPath.row){
            return NO;
        }
    }
    return YES;
}

#pragma mark --- UIScrollViewDelegate ---

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.2];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    BOOL isOutOfScreen = [self judgeCurrentFullScreenPlayingCellIfOutOfScreen];
    if(isOutOfScreen){
        [self rotateToPortrait];
        if(_currentPlayingCell){
            [_currentPlayingCell removeFromSuperview];
            [_currentPlayingCell backToInitState];
            _currentPlayingCell = nil;
        }
    }
    if(_ifAutoPlay){
        self.currentPlayingIndex = [self getCurrentCellIndexShouldBePlaying];
    }
}

#pragma mark --- UITableViewDelegate ---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SCVideoPlayListTableViewCell";
    SCVideoPlayListTableViewCell *cell = (SCVideoPlayListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        cell = [SCVideoPlayListTableViewCell cellFromNib];
    }
    cell.delegate = self;
    cell.index = indexPath.row;
    if(!_ifAutoPlay){
        cell.isCurrentCellPlaying = NO;
    }
    else{
        cell.isCurrentCellPlaying = NO;
        if(_currentPlayingIndex==indexPath.row){
            cell.isCurrentCellPlaying = YES;
        }
    }
    NSMutableDictionary *dic = [_listArray objectAtIndex:indexPath.row];
    NSString *url = [dic objectForKey:@"url"];
    NSString *title = [dic objectForKey:@"title"];
    [cell getDataSourceFromVideoTitle:title VideoUrl:url];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self addOneIndexPathToVisibleIndexArrayWithValue:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_visibleIndexArray removeObject:indexPath];
    if(_currentPlayingIndex==indexPath.row){
        [self rotateToPortrait];
        if(_currentPlayingCell){
            [_currentPlayingCell removeFromSuperview];
            [_currentPlayingCell backToInitState];
            _currentPlayingCell = nil;
        }
    }
}

#pragma mark --- SCVideoPlayListTableViewCellDelegate ---

- (void)videoPlayListTableViewCellExitFullScreenButtonTapped
{
    [self rotateToPortrait];
}

- (void)videoPlayListTableViewCellEnterFullScreenButtonTapped
{
    [self rotateToLandscapeRight];
}

- (void)videoPlayListTableViewCellRemoveReusePlayManageView
{
    _currentPlayingCell = nil;
}

- (void)videoPlayListTableViewCellPlayButtonTappedWithIndex:(NSInteger)index AndCell:(SCVideoPlayListTableViewCell *)cell
{
    if(_currentPlayingCell){
        [_currentPlayingCell backToInitState];
        _currentPlayingCell = nil;
    }
    _currentPlayingIndex = index;
    _currentPlayingCell = cell;
}

#pragma mark --- control orientation method ---

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end


















