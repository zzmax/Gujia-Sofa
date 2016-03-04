/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */
/**
 *  define color, button, screen width, etc something we use frequentely
 *
 */
#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define NAVIGATION_COLOR	[UIColor colorWithRed:0.07451f green:0.73333f blue:1.0f alpha:1.0f]
#define BACKGROUND_COLOR	[UIColor colorWithRed:0.88235f green:0.95294f blue:1.0f alpha:1.0f]
#define BOTTOM_RECT	CGRectMake(24, 450, 300, 50)
#define BARBUTTON(TITLE, SELECTOR) 	[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define IS_PORTRAIT UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation) || UIDeviceOrientationIsPortrait(self.interfaceOrientation)
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_PLUS (SCREEN_WIDTH >= 414)
#define IS_IPHONE_6 (SCREEN_WIDTH == 375)
// < 5; 4s, 4 or before 4
#define IS_IPHONE_SMALL (SCREEN_HEIGHT <= 480)

#define ESTABLISH_WEAK_SELF __weak typeof(self) weakSelf = self
#define ESTABLISH_STRONG_SELF __strong typeof(self) strongSelf = weakSelf;


#pragma mark - Constraints
#define PREPCONSTRAINTS(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]
#define CONSTRAIN(PARENT, VIEW, FORMAT) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:NSDictionaryOfVariableBindings(VIEW)]]
#define CONSTRAIN_VIEWS(PARENT, FORMAT, VIEWBINDINGS) [PARENT addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:VIEWBINDINGS]]
#define CONSTRAINTS(FORMAT, VIEWBINDINGS) [NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:VIEWBINDINGS]

// Stretch across axis
#define STRETCH_VIEW_H(PARENT, VIEW) CONSTRAIN(PARENT, VIEW, @"H:|["#VIEW"(>=0)]|")
#define STRETCH_VIEW_V(PARENT, VIEW) CONSTRAIN(PARENT, VIEW, @"V:|["#VIEW"(>=0)]|")
#define STRETCH_VIEW(PARENT, VIEW) {STRETCH_VIEW_H(PARENT, VIEW); STRETCH_VIEW_V(PARENT, VIEW);}

// Center along axis
#define CENTER_VIEW_H(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW_V(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]]
#define CENTER_VIEW(PARENT, VIEW) {CENTER_VIEW_H(PARENT, VIEW); CENTER_VIEW_V(PARENT, VIEW);}
#define CENTER_VIEW_H_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:CONSTANT]]
#define CENTER_VIEW_V_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:CONSTANT]]

// Align to parent
#define ALIGN_VIEW_LEFT(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_RIGHT(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_TOP(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_BOTTOM(PARENT, VIEW) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]]
#define ALIGN_VIEW_LEFT_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeLeft multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_RIGHT_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeRight multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_TOP_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeTop multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW1_TOP_TO_VIEW2_TOP_CONSTANT(PARENT, VIEW1, VIEW2, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW1 attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:VIEW2 attribute:NSLayoutAttributeTop multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW_BOTTOM_CONSTANT(PARENT, VIEW, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:PARENT attribute:NSLayoutAttributeBottom multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW1_TOP_TO_VIEW2_BOTTOM_CONSTANT(PARENT, VIEW1, VIEW2, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW1 attribute: NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:VIEW2 attribute:NSLayoutAttributeBottom multiplier:1.0f constant:CONSTANT]]
#define ALIGN_VIEW1_BOTTOM_TO_VIEW2_BOTTOM_CONSTANT(PARENT, VIEW1, VIEW2, CONSTANT) [PARENT addConstraint:[NSLayoutConstraint constraintWithItem:VIEW1 attribute: NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:VIEW2 attribute:NSLayoutAttributeBottom multiplier:1.0f constant:CONSTANT]]

// Set Size
#define CONSTRAIN_WIDTH(VIEW, WIDTH) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:WIDTH]];
#define CONSTRAIN_HEIGHT(VIEW, HEIGHT) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:HEIGHT]];
#define CONSTRAIN_SIZE(VIEW, HEIGHT, WIDTH) {CONSTRAIN_WIDTH(VIEW, WIDTH); CONSTRAIN_HEIGHT(VIEW, HEIGHT);}

// Set Aspect
#define CONSTRAIN_ASPECT(VIEW, ASPECT) [VIEW addConstraint:[NSLayoutConstraint constraintWithItem:VIEW attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:VIEW attribute:NSLayoutAttributeHeight multiplier:(ASPECT) constant:0.0f]]

