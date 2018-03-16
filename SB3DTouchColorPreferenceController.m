#define UIFUNCTIONS_NOT_C
#import <UIKit/UIKit.h>
#import <UIKit/UIColor+Private.h>
#import <Preferences/PSTableCell.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSListController.h>
#import "NKOColorPickerView.h"
#import <Social/Social.h>
#import "Tweak.h"
#import "../PSPrefs.x"
#import "../CC.h"

DeclarePrefsTools()

@interface SB3DTouchColorPreferenceController : PSListController
@end

@interface ColorPickerViewController : UIViewController <NKOColorPickerViewDelegate>
@property (retain) UIColor *color;
+ (UIColor *)savedCustomColor;
@end

NSString *updateCellColorNotification = @"com.CC.SB3DTouchColor.prefs.colorUpdate";
NSString *IdentifierKey = @"ColorCellIdentifier";

@interface ColorCell : PSTableCell
@end

@implementation ColorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(id)identifier specifier:(PSSpecifier *)specifier {
    if (self == [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier specifier:specifier]) {
        [self updateColorCell];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateColorCell:) name:updateCellColorNotification object:nil];
    }
    return self;
}

- (UIColor *)savedCustomColor {
    return [ColorPickerViewController savedCustomColor];
}

- (UIView *)colorCell {
    UIView *circle = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 28.0, 28.0)];
    circle.layer.cornerRadius = 14.0;
    circle.backgroundColor = [self savedCustomColor];
    return [circle autorelease];
}

- (void)updateColorCell:(NSNotification *)notification {
    [self updateColorCell];
}

- (void)updateColorCell {
    self.accessoryView = [[self colorCell] retain];
    self.titleLabel.textColor = self.accessoryView.backgroundColor;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [super dealloc];
}

@end

@implementation ColorPickerViewController

- (void)colorDidChange:(UIColor *)color {
    self.color = color;
}

+ (UIColor *)savedCustomColor {
    return [UIColor colorWithHue:cgfloatForKey(HueKey, 1.0) saturation:cgfloatForKey(SatKey, 1.0) brightness:cgfloatForKey(BriKey, 1.0) alpha:1.0];
}

- (id)init {
    if (self == [super init]) {
        UIColor *color = [[[self class] savedCustomColor] retain];
        NKOColorPickerView *colorPickerView = [[[NKOColorPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 340.0) color:color delegate:self] autorelease];
        colorPickerView.backgroundColor = UIColor.blackColor;
        self.view = colorPickerView;
        self.navigationItem.title = @"Select Color";
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:0 target:self action:@selector(dismissPicker)] autorelease];
    }
    return self;
}

- (void)dismissPicker {
    CGFloat hue, sat, bri;
    if ([self.color getHue:&hue saturation:&sat brightness:&bri alpha:nil]) {
        setFloatForKey(hue, HueKey);
        setFloatForKey(sat, SatKey);
        setFloatForKey(bri, BriKey);
        DoPostNotification();
        [NSNotificationCenter.defaultCenter postNotificationName:updateCellColorNotification object:nil userInfo:nil];
    }
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation SB3DTouchColorPreferenceController

HavePrefs()

- (id)init {
    if (self == [super init]) {
      UIButton *heart = [[[UIButton alloc] initWithFrame:CGRectZero] autorelease];
      UIImage *image = [UIImage imageNamed:@"Heart" inBundle:[NSBundle bundleWithPath:@"/Library/PreferenceBundles/SB3DTouchColorSettings.bundle"]];
      [heart setImage:image forState:UIControlStateNormal];
      [heart sizeToFit];
      [heart addTarget:self action:@selector(loved) forControlEvents:UIControlEventTouchUpInside];
      self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:heart] autorelease];
    }
    return self;
}

- (void)showColorPicker:(id)param {
    ColorPickerViewController *picker = [[[ColorPickerViewController alloc] init] autorelease];
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:picker] autorelease];
    nav.modalPresentationStyle = 2;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)loved {
    SLComposeViewController *twitter = [[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter] retain];
    twitter.initialText = @"#SB3DTouchColor by @ca13ra1 is my favorite 3D touch tweak!";
    [self.navigationController presentViewController:twitter animated:YES completion:nil];
    [twitter release];
}

- (NSArray *)specifiers {
    if (_specifiers == nil) {
			NSMutableArray *specs = [NSMutableArray arrayWithArray:[self loadSpecifiersFromPlistName:@"SB3DTouchColor" target:self]];
			_specifiers = [specs copy];
    }
    return _specifiers;
}

@end
