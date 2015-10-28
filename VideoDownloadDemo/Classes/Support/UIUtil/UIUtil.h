//
//  UIUtil.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CONSTS.h"

@interface UIUtil : NSObject

+ (NSString *)imageName:(NSString *)name;

+ (NSString *)getBaseTimeString:(NSTimeInterval)time;
+ (NSString *)getTimeStringWithPlayedSeconds:(CGFloat)seconds;
+ (NSString *)getTimeStringWithTotalSeconds:(CGFloat)seconds;

+ (void)showMessage:(NSString *)message;

@end
