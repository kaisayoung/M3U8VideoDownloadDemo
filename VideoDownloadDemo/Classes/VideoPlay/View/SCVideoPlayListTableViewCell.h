//
//  SCVideoPlayListTableViewCell.h
//  StormChannel
//
//  Created by 王琦 on 15/7/23.
//  Copyright (c) 2015年 王琦. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 15.7.23  新建列表播放的cell
 */

@class SCVideoPlayListTableViewCell;

@protocol SCVideoPlayListTableViewCellDelegate <NSObject>

- (void)videoPlayListTableViewCellExitFullScreenButtonTapped;
- (void)videoPlayListTableViewCellEnterFullScreenButtonTapped;
- (void)videoPlayListTableViewCellRemoveReusePlayManageView;
- (void)videoPlayListTableViewCellPlayButtonTappedWithIndex:(NSInteger)index AndCell:(SCVideoPlayListTableViewCell *)cell;

@end

@interface SCVideoPlayListTableViewCell : UITableViewCell

@property (assign, nonatomic) NSInteger index;
/*
 判断是否播放的唯一字符，若有网络判断之类的放到上层
 */
@property (assign, nonatomic) BOOL isCurrentCellPlaying;
@property (strong, nonatomic) IBOutlet UIView *videoPlayView;
@property (assign, nonatomic) id<SCVideoPlayListTableViewCellDelegate>delegate;

+ (SCVideoPlayListTableViewCell *)cellFromNib;

- (void)getDataSourceFromVideoTitle:(NSString *)title VideoUrl:(NSString *)url;

- (void)enterInFullScreen;
- (void)exitFromFullScreen;

- (void)backToInitState;

@end
