//
//  MMPopupView.h
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MMPopupType) {
    MMPopupTypeAlert,
    MMPopupTypeSheet,
    MMPopupTypeCustom,
};

@class MMPopupView;

typedef void(^MMPopupBlock)(MMPopupView *);

@interface MMPopupView : UIView

@property (nonatomic, assign, readonly) BOOL           visible;             // default is NO.

@property (nonatomic, strong          ) UIView         *attachedView;       // default is MMPopupWindow. You can attach MMPopupView to any UIView.

@property (nonatomic, assign          ) MMPopupType    type;                // default is MMPopupTypeAlert.
@property (nonatomic, assign          ) NSTimeInterval animationDuration;   // default is 0.3 sec.
@property (nonatomic, assign          ) BOOL           withKeyboard;        // default is NO. When YES, alert view with be shown with a center offset (only effect with MMPopupTypeAlert).

@property (nonatomic, copy            ) MMPopupBlock   showCompletionBlock; // show completion block.
@property (nonatomic, copy            ) MMPopupBlock   hideCompletionBlock; // hide completion block

@property (nonatomic, copy            ) MMPopupBlock   showAnimation;       // custom show animation block.
@property (nonatomic, copy            ) MMPopupBlock   hideAnimation;       // custom hide animation block.

/**
 *  override this method to show the keyboard if with a keyboard
 */
- (void) showKeyboard;

/**
 *  override this method to hide the keyboard if with a keyboard
 */
- (void) hideKeyboard;


/**
 *  show the popup view
 */
- (void) show;

/**
 *  show the popup view with completiom block
 *
 *  @param block show completion block
 */
- (void) showWithBlock:(MMPopupBlock)block;

/**
 *  hide the popup view
 */
- (void) hide;

/**
 *  hide the popup view with completiom block
 *
 *  @param block hide completion block
 */
- (void) hideWithBlock:(MMPopupBlock)block;

@end
