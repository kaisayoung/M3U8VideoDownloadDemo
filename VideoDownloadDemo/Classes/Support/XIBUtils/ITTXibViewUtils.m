//
//  ITTXibViewUtils.m
//  iTotemFrame
//
//  Created by jack on 3/9/12.
//  Copyright 2011 iTotem. All rights reserved.
//

#import "ITTXibViewUtils.h"

@implementation ITTXibViewUtils

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:xibName owner:fileOwner options:nil];
    if (array && [array count]) {
        return array[0];
    }else {
        return nil;
    }
}

+ (id)loadViewFromXibNamed:(NSString*)xibName
{
    return [ITTXibViewUtils loadViewFromXibNamed:xibName withFileOwner:self];
}

@end
