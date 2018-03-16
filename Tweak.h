#import "../CC.h"
#import "../PSPrefs.x"

NSString *tweakIdentifier = @"com.CC.SB3DTouchColor";

NSString *enabledKey = @"enabled";
NSString *HueKey = @"Hue";
NSString *SatKey = @"Sat";
NSString *BriKey = @"Bri";
NSString *AlphaKey = @"Alpha";
NSString *colorProfileKey = @"colorProfile";

#ifdef TWEAK

BOOL enabled;

CGFloat alpha;
CGFloat hue;
CGFloat sat;
CGFloat bri;

NSInteger colorProfile;

struct pixel {
    unsigned char r, g, b, a;
};

static UIColor *dominantColorFromImage(UIImage *image) {
    CGImageRef iconCGImage = image.CGImage;
    NSUInteger red = 0, green = 0, blue = 0;
    size_t width = CGImageGetWidth(iconCGImage);
    size_t height = CGImageGetHeight(iconCGImage);
    size_t bitmapBytesPerRow = width * 4;
    size_t bitmapByteCount = bitmapBytesPerRow * height;
    struct pixel *pixels = (struct pixel *)malloc(bitmapByteCount);
    if (pixels) {
        CGContextRef context = CGBitmapContextCreate((void *)pixels, width, height, 8, bitmapBytesPerRow, CGImageGetColorSpace(iconCGImage), kCGImageAlphaPremultipliedLast);
        if (context) {
            CGContextDrawImage(context, CGRectMake(0.0, 0.0, width, height), iconCGImage);
            NSUInteger numberOfPixels = width * height;
            for (size_t i = 0; i < numberOfPixels; i++) {
                red += pixels[i].r;
                green += pixels[i].g;
                blue += pixels[i].b;
            }
            red /= numberOfPixels;
            green /= numberOfPixels;
            blue /= numberOfPixels;
            CGContextRelease(context);
        }
        free(pixels);
    }
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}

UIColor *SB3DTouchColorColor(UIImage *image) {
    UIColor *color = dominantColorFromImage(image);
    switch (colorProfile) {
        case 2:
            color = [UIColor colorWithHue:hue saturation:sat brightness:bri alpha:alpha];
            break;
    }
    return color;
}

HaveCallback() {
    GetPrefs()
    GetBool2(enabled, YES)
    GetCGFloat(hue, HueKey, 1.0)
    GetCGFloat(sat, SatKey, 1.0)
    GetCGFloat(bri, BriKey, 1.0)
    GetCGFloat(alpha, AlphaKey, 1.0)
    GetInt2(colorProfile, 1)
}

#endif
