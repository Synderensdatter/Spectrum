// SkittyColorCell.m

#import "SkittyColorCell.h"
#import "SkittyColorViewController.h"

@implementation SkittyColorCell

- (id)target {
	return self;
}

- (id)cellTarget {
	return self;
}

- (SEL)action {
	return @selector(openColorPicker);
}

- (SEL)cellAction {
	return @selector(openColorPicker);
}

- (void)openColorPicker {
	// do it
	UIViewController *viewController = [self _viewControllerForAncestor];
	SkittyColorViewController *colorController = [[SkittyColorViewController alloc] initWithProperties:self.specifier.properties];
	[viewController presentViewController:colorController animated:YES completion:nil];
}

- (void)updatePreview {
	UIView *colorPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
	colorPreview.layer.cornerRadius = colorPreview.frame.size.width / 2;
	colorPreview.layer.borderWidth = 1.5;
	colorPreview.layer.borderColor = [UIColor lightGrayColor].CGColor;

	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", self.specifier.properties[@"defaults"]]];
	
	NSString *fallback = self.specifier.properties[@"default"];
	
	unsigned rgbValue = 0;
	NSScanner *scanner = [NSScanner scannerWithString:[settings objectForKey:self.specifier.properties[@"key"]] ?: fallback];
	[scanner setScanLocation:0];
	[scanner scanHexInt:&rgbValue];

	UIColor *color = [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];

	colorPreview.backgroundColor = color;

	[self setAccessoryView:colorPreview];
}

- (void)didMoveToSuperview {
	[super didMoveToSuperview];

	[self updatePreview];

	[self.specifier setTarget:self];
	[self.specifier setButtonAction:@selector(openColorPicker)];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePreview) name:@"xyz.skitty.spectrum.colorupdate" object:nil];
}

@end
