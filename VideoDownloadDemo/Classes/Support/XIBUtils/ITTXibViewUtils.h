//
//  ITTXibViewUtils.h
//  iTotemFrame
//  utils for all UIViews using xib to layout  
//
//  Created by jack on 3/9/12.
//  Copyright 2011 iTotem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ITTXibViewUtils : NSObject

+ (id)loadViewFromXibNamed:(NSString*)xibName withFileOwner:(id)fileOwner;

//  the view must not have any connecting to the file owner
+ (id)loadViewFromXibNamed:(NSString*)xibName;
@end
