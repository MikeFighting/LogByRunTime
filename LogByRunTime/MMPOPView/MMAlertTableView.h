//
//  MMAlertTableView.h
//  Bidding
//
//  Created by 58 on 2016/10/27.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "MMPopupView.h"
#import "MMPopupDefine.h"
@interface MMAlertTableView : MMPopupView
- (instancetype) initWithTableViewWithTitle:(NSString *)title DataSource:(NSArray<NSString *>*) dataSource;
@end
@interface MMAlertTableViewConfig : NSObject

+ (MMAlertTableViewConfig*) globalConfig;

@property (nonatomic,assign) CGFloat maxHeight;             //Default is 400
@property (nonatomic, assign) CGFloat width;                // Default is 275.
@property (nonatomic, assign) CGFloat buttonHeight;         // Default is 50.
@property (nonatomic, assign) CGFloat innerMargin;          // Default is 25.
@property (nonatomic, assign) CGFloat cornerRadius;         // Default is 5.

@property (nonatomic, assign) CGFloat titleFontSize;        // Default is 18.
@property (nonatomic, assign) CGFloat detailFontSize;       // Default is 14.
@property (nonatomic, assign) CGFloat buttonFontSize;       // Default is 17.

@property (nonatomic, strong) UIColor *backgroundColor;     // Default is #FFFFFF.
@property (nonatomic, strong) UIColor *titleColor;          // Default is #333333.
@property (nonatomic, strong) UIColor *detailColor;         // Default is #333333.
@property (nonatomic, strong) UIColor *splitColor;          // Default is #CCCCCC.

@property (nonatomic, strong) UIColor *itemNormalColor;     // Default is #333333. effect with MMItemTypeNormal
@property (nonatomic, strong) UIColor *itemHighlightColor;  // Default is #E76153. effect with MMItemTypeHighlight
@property (nonatomic, strong) UIColor *itemPressedColor;    // Default is #EFEDE7.


@property (nonatomic, strong) NSString *defaultTextOK;      // Default is "好".
@property (nonatomic, strong) NSString *defaultTextCancel;  // Default is "取消".
@property (nonatomic, strong) NSString *defaultTextConfirm; // Default is "确定".

@property (nonatomic, assign) NSTextAlignment detailTextAlignment; //Default is NSTextAlignmentCenter

@end
