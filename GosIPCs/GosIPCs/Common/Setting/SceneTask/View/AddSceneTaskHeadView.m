//  AddSceneTaskHeadView.m
//  Goscom
//
//  Create by 匡匡 on 2018/12/27.
//  Copyright © 2018 goscam. All rights reserved.

#import "AddSceneTaskHeadView.h"

@implementation AddSceneTaskHeadView



#pragma mark - lifeStyle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self = [[[NSBundle mainBundle] loadNibNamed:@"AddSceneTaskHeadView" owner:self options:nil] lastObject];
    if (self) {
        self.frame = frame;
    }
    return self;
}
@end