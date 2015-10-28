//
//  UIUtil.m
//
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIUtil.h"
#import "CONSTS.h"

@implementation UIUtil

+ (NSString*)imageName:(NSString*) name
{
    return name;
}

+ (NSString *)getBaseTimeString:(NSTimeInterval)time
{
    NSString *string = @"";
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    return string;
}

+ (NSString *)getTimeStringInMessageChatWithTime:(NSTimeInterval)time
{
    NSString *string = @"";
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    string = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(time)]];
    return string;
}

+ (NSString *)getTimeStringInMessageChatWithDate:(NSDate *)date
{
    NSString *string = @"";
    static NSDateFormatter *dateFormater = nil;
    if (dateFormater == nil) {
        dateFormater = [[NSDateFormatter alloc] init];
        [dateFormater setDateFormat:@"HH:mm"];
    }
    string = [dateFormater stringFromDate:date];
    return string;
}

+ (NSString *)getTimeStringWithPlayedSeconds:(CGFloat)seconds
{
    if(isnan(seconds)){
        return @"";
    }
    int playedSeconds = (int)seconds;
    int hour = playedSeconds/3600;
    int min = (playedSeconds-(3600*hour))/60;
    int second = playedSeconds-(3600*hour)-(60*min);
    NSString *timeString;
    if(hour!=0){
        timeString = [NSString stringWithFormat:@"%d:%02d:%02d",hour,min,second];
    }
    else{
        timeString = [NSString stringWithFormat:@"%02d:%02d",min,second];
    }
    return timeString;
}

+ (NSString *)getTimeStringWithTotalSeconds:(CGFloat)seconds
{
    if(isnan(seconds)){
        return @"";
    }
    int totalSeconds = (int)seconds;
    int hour = totalSeconds/3600;
    int min = (totalSeconds-(3600*hour))/60;
    int second = totalSeconds-(3600*hour)-(60*min);
    NSString *timeString;
    if(hour!=0){
        timeString = [NSString stringWithFormat:@"%d:%02d:%02d",hour,min,second];
    }
    else{
        timeString = [NSString stringWithFormat:@"%02d:%02d",min,second];
    }
    return timeString;
}

+ (void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake((SCREEN_WIDTH - LabelSize.width - 20)/2, SCREEN_HEIGHT - 100, LabelSize.width+20, LabelSize.height+10);
    [UIView animateWithDuration:2 animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

@end







