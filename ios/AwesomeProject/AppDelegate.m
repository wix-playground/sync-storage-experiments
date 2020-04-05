/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>

#import <JavaScriptCore/JavaScriptCore.h>
#import "fishhook.h"

static JSGlobalContextRef (*__orig_JSGlobalContextCreateInGroup)(JSContextGroupRef group, JSClassRef globalObjectClass);
JSGlobalContextRef __elad_JSGlobalContextCreateInGroup(JSContextGroupRef group, JSClassRef globalObjectClass)
{
	JSGlobalContextRef rv = __orig_JSGlobalContextCreateInGroup(group, globalObjectClass);
	
	JSContext* objCContext = [JSContext contextWithJSGlobalContextRef:rv];
	
	objCContext[@"___elad_log"] = ^ NSString* (NSString* log) {
		NSLog(@"From js: %@", log);
		
		return @"From native";
	};
	
	return rv;
}

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	struct rebinding arr[] = (struct rebinding[]) {
		"JSGlobalContextCreateInGroup",
		__elad_JSGlobalContextCreateInGroup,
		(void**)&__orig_JSGlobalContextCreateInGroup
	};
	
	rebind_symbols(arr, 1);
	
	RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
	RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
													 moduleName:@"AwesomeProject"
											  initialProperties:nil];
	
	rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
	
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	UIViewController *rootViewController = [UIViewController new];
	rootViewController.view = rootView;
	self.window.rootViewController = rootViewController;
	[self.window makeKeyAndVisible];
	return YES;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
	return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
	return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
