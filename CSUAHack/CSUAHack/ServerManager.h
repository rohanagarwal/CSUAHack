//
//  ServerManager.h
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

//
//  MIServerManager.h
//  LocalApps
//
//  Created by Rohan Agarwal on 1/1/13.
//  Copyright (c) 2013 Micello. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerRequestDelegate
@optional
-(void) gotOrganizations:(NSArray*)screenshotUrl;
-(void) gotEventsForOrganization:(NSArray*)events;

@end

@interface ServerManager : NSObject <NSURLConnectionDelegate>

+ (ServerManager *)sharedManager;

-(void) getOrganizations:(id<ServerRequestDelegate>) delegate;
-(void) getEventsForOrganization:(NSNumber*) orgID delegate:(id<ServerRequestDelegate>) delegate;
-(void) postAnalytic:(NSMutableArray*)allEvents;
// -(void) postEventAnalytic:(NSString*) organizationName...


@end
