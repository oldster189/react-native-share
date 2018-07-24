//
//  FacebookShare.m
//  RNShare
//
//  Created by Diseño Uno BBCL on 23-07-16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "LineShare.h"

@implementation LineShare
- (void)shareSingle:(NSDictionary *)options
    failureCallback:(RCTResponseErrorBlock)failureCallback
    successCallback:(RCTResponseSenderBlock)successCallback {

    NSLog(@"Try open view");

    if ([options objectForKey:@"message"] && [options objectForKey:@"message"] != [NSNull null]) {
        NSString *text = [RCTConvert NSString:options[@"message"]];
        text = [text stringByAppendingString: [@" " stringByAppendingString: options[@"url"]] ];
        text = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) text, NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
        
        NSString * urlWhats = [NSString stringWithFormat:@"line://msg/text/%@", text];
        NSURL * lineURL = [NSURL URLWithString:urlWhats];

        UIApplication *application = [UIApplication sharedApplication];
        NSURL *URL = [NSURL URLWithString:urlWhats];
        [application openURL:URL options:@{} completionHandler:^(BOOL success) {
            if (success) {
                [[UIApplication sharedApplication] openURL: lineURL];
                successCallback(@[]);
            }else{
                // Cannot open line
                NSString *stringURL = @"https://itunes.apple.com/jp/app/line/id443904275?ls=1&mt=8";
                NSURL *url = [NSURL URLWithString:stringURL];
                [[UIApplication sharedApplication] openURL:url];

                NSString *errorMessage = @"Not installed";
                NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedString(errorMessage, nil)};
                NSError *error = [NSError errorWithDomain:@"com.rnshare" code:1 userInfo:userInfo];

                NSLog(errorMessage);
                failureCallback(error);
            }
        }]; 
    }

}


@end
