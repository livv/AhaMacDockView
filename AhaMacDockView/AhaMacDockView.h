//
//  FishEyeView.h
//  FishEyeDemo
//
//  Created by haiwei li on 11-11-22.
//  Copyright (c) 2011年 13awan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AhaMacDockDelegate <NSObject>

- (void)fishEyeIndex:(NSUInteger)index;

@end



@interface AhaMacDockView : UIView

@property (nonatomic, weak) id <AhaMacDockDelegate> delegate;

- (void) configWithViews:(NSArray *)views
             withMinSize:(CGSize)_minSize
             withMaxRate:(float)_maxRate;

@end


