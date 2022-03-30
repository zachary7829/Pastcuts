#import <Foundation/Foundation.h>
#import "ZLTCRootListController.h"

@implementation ZLTCRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)openGitHub {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://github.com/zachary7829"]
	options:@{}
	completionHandler:nil];
}

- (void)openTwitter {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://twitter.com/QuickUpdate5"]
	options:@{}
	completionHandler:nil];
}

-(void)openReddit {
	[[UIApplication sharedApplication]
	openURL:[NSURL URLWithString:@"https://reddit.com/u/zachary7829"]
	options:@{}
	completionHandler:nil];
}
@end
