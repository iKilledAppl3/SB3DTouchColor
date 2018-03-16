#define TWEAK
#import "../CC.h"
#import "Tweak.h"
#import <dlfcn.h>
#import <objc/runtime.h>
#import <substrate.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SBIcon : NSObject
-(UIImage *)getIconImage:(int)arg1;
@end

@interface SBIconView : UIView
@property (nonatomic,retain) SBIcon * icon;
- (id)icon;
@end

@interface SBUIIconForceTouchWrapperViewController : UIViewController
@end

@interface SBUIIconForceTouchControllerDataProvider : NSObject
@property (nonatomic,readonly) UIViewController * primaryViewController;
@property (nonatomic,readonly) UIViewController * secondaryViewController;
-(SBIconView *)newIconViewCopy;
@end

@interface SBUIIconForceTouchViewController : UIViewController {
  SBUIIconForceTouchWrapperViewController *_primaryViewController;
  SBUIIconForceTouchWrapperViewController *_secondaryViewController;
}
@property (nonatomic,readonly) SBUIIconForceTouchControllerDataProvider * dataProvider;
@end

%hook SBUIIconForceTouchViewController

- (void)viewWillLayoutSubviews {
	%orig;
  if (enabled) {
    SBUIIconForceTouchControllerDataProvider *dataProvider = MSHookIvar<SBUIIconForceTouchControllerDataProvider* >(self, "_dataProvider");
    SBUIIconForceTouchWrapperViewController *primaryViewController = MSHookIvar<SBUIIconForceTouchWrapperViewController *>(self, "_primaryViewController");
    SBUIIconForceTouchWrapperViewController *secondaryViewController = MSHookIvar<SBUIIconForceTouchWrapperViewController *>(self, "_secondaryViewController");
    SBIconView *iconView = [dataProvider newIconViewCopy];
    UIImage *iconImage = [iconView.icon getIconImage:2];
    UIColor *color = SB3DTouchColorColor(iconImage);
    if(dataProvider.primaryViewController) {
      [primaryViewController.view setBackgroundColor:color];
    }
    if(dataProvider.secondaryViewController) {
      [secondaryViewController.view setBackgroundColor:color];
    }
  }
}

%end

%ctor {
  callback();
	HaveObserver();
  %init;
}
