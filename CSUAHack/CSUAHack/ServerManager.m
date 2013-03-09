//
//  ServerManager.m
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//

#import "ServerManager.h"
#import "ServerConnection.h"
#import <EventKit/EventKit.h>
#import "OrganizationObj.h"
#import "EventObj.h"

@interface ServerManager()

@property (strong, nonatomic) ServerConnection* getOrganizations;
@property (strong, nonatomic) ServerConnection* getEvents;

@end

@implementation ServerManager
@synthesize getOrganizations = _getOrganizations, getEvents = _getEvents;


#pragma mark - Singleton Enforcement
static ServerManager *sharedManager = nil;

- (id) init {
	if ( sharedManager != nil ) {
        [NSException raise:NSInternalInconsistencyException
					format:@"Cannot initialize an ServerManager directly. Use [ServerManager sharedManager]"];
	}
    else if ( self = [super init] ) {
	}
	return self;
}

+ (ServerManager *)sharedManager {
	@synchronized(self) {
		if(sharedManager == nil) {
			sharedManager = [[self alloc] init]; //sets the sharedManager automatically
		}
	}
	return sharedManager;
}

-(void) getOrganizations:(id<ServerRequestDelegate>) delegate {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.getOrganizations = [[ServerConnection alloc] init];
    self.getOrganizations.type = ServerConnectionTypeGetOrganizations;
    self.getOrganizations.responseData = [[NSMutableData alloc] init];
    self.getOrganizations.delegate = delegate;
    NSString *requestString = kGetOrganizations;
    NSLog(@"requestString: %@", requestString);
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [urlRequest setHTTPMethod:@"GET"];
	self.getOrganizations.request = urlRequest;
	self.getOrganizations.connection = [NSURLConnection connectionWithRequest:self.getOrganizations.request delegate:self];
	if(self.getOrganizations.connection == nil)
		NSLog(@"Connection error. Couldn't initialize connection with url: %@", requestString);
}
-(void) getEventsForOrganization:(NSNumber*) orgID delegate:(id<ServerRequestDelegate>) delegate {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.getEvents = [[ServerConnection alloc] init];
    self.getEvents.type = ServerConnectionTypeGetEvents;
    self.getEvents.responseData = [[NSMutableData alloc] init];
    self.getEvents.delegate = delegate;
    NSString *requestString = [kGetEvents stringByAppendingString:[orgID stringValue]];
    NSLog(@"requestString: %@", requestString);
    NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [urlRequest setHTTPMethod:@"GET"];
	self.getEvents.request = urlRequest;
	self.getEvents.connection = [NSURLConnection connectionWithRequest:self.getEvents.request delegate:self];
	if(self.getEvents.connection == nil)
		NSLog(@"Connection error. Couldn't initialize connection with url: %@", requestString);
}

#pragma mark - NSURLConnection methods

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == self.getOrganizations.connection) {
        [self.getOrganizations.responseData appendData:data];
    }
    else if (connection == self.getEvents.connection) {
        [self.getEvents.responseData appendData:data];
    }
    else {
        NSLog(@"invalid connection type in didRecieveData, programmer error");
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    if(connection == self.getOrganizations.connection) {
		self.getOrganizations.response = response;
	}
    else if (connection == self.getEvents.connection) {
        self.getEvents.response = response;
    }
    else {
        NSLog(@"invalid connection type in didReceiveResponse, programmer error");
    }
}

- (void)connection:(NSURLConnection *)urlConnection didFailWithError:(NSError *)error {
    ServerConnection* connection;
    if (urlConnection == self.getOrganizations.connection) {
        connection = self.getOrganizations;
    }
    else if (urlConnection == self.getEvents.connection) {
        connection = self.getEvents;
    }
    else {
        NSLog(@"invalid connection type in didFailWithError, programmer error");
    }
    connection.response = nil;
	connection.responseData = nil;
	[self connectionDidFinishLoading:connection.connection];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)urlConnection {
    ServerConnection* connection;
    if (urlConnection == self.getOrganizations.connection) {
        connection = self.getOrganizations;
    }
    else if (urlConnection == self.getEvents.connection) {
        connection = self.getEvents;
    }
    else {
        NSLog(@"invalid connection type in didFinishLoading, programmer error");
    }
    
    if (connection.type == ServerConnectionTypeGetOrganizations) {
        NSDictionary *responseInfo = nil;
        NSError *jsonError = nil;
        BOOL failed = NO;
        if (connection.response) {
            responseInfo = [NSJSONSerialization JSONObjectWithData:connection.responseData options:NSJSONReadingMutableContainers error:&jsonError];
        }
        else {
            NSLog(@"connection.response is nil");
            failed = YES;
        }
        if (!failed && jsonError) {
            NSLog(@"get apps json conversion failed, error: %@", jsonError);
        }
        if (!failed && responseInfo == nil) {
            NSLog(@"Error: Response didn't contain a result object");
            NSLog(@"Response info was: %@", responseInfo);
            failed = YES;
        }
        else {
            NSMutableArray* allOrganizations = [[NSMutableArray alloc] init];
            NSArray* allOrgs = [responseInfo valueForKey:@"objects"];
            for (NSDictionary* org in allOrgs) {
                NSString* orgName = [org valueForKey:@"org_name"];
                int orgID = [[org valueForKey:@"id"] intValue];
                OrganizationObj* obj = [[OrganizationObj alloc] init];
                obj.orgName = orgName;
                obj.orgID = [NSNumber numberWithInt:orgID];
                [allOrganizations addObject:obj];
            }
            [connection.delegate gotOrganizations:allOrganizations];
        }
    }
    else if (connection.type == ServerConnectionTypeGetEvents) {
        NSDictionary *responseInfo = nil;
        NSError *jsonError = nil;
        BOOL failed = NO;
        if (connection.response) {
            responseInfo = [NSJSONSerialization JSONObjectWithData:connection.responseData options:NSJSONReadingMutableContainers error:&jsonError];
        }
        else {
            NSLog(@"connection.response is nil");
            failed = YES;
        }
        if (!failed && jsonError) {
            NSLog(@"get apps json conversion failed, error: %@", jsonError);
        }
        if (!failed && responseInfo == nil) {
            NSLog(@"Error: Response didn't contain a result object");
            NSLog(@"Response info was: %@", responseInfo);
            failed = YES;
        }
        else {
            NSLog(@"responseInfo: %@", responseInfo);
            NSMutableArray* allEvents = [[NSMutableArray alloc] init];
            NSString* orgName = [responseInfo valueForKey:@"org_name"];
            NSArray* allEventsinJSON = [responseInfo valueForKey:@"events"];
            for (NSDictionary* event in allEventsinJSON) {
                EventObj* obj = [[EventObj alloc] init];
                obj.organizationName = orgName;
                obj.eventName = [event valueForKey:@"event_name"];
                obj.location = [event valueForKey:@"location"];
                NSDate* startDate = [[NSDate alloc] initWithTimeIntervalSince1970:[[event valueForKey:@"start"] intValue]];
                NSDate* endDate = [[NSDate alloc] initWithTimeIntervalSince1970:[[event valueForKey:@"end"] intValue]];
                obj.startDate = startDate;
                obj.endDate = endDate;
                [allEvents addObject:obj];
            }
            [connection.delegate gotEventsForOrganization:allEvents];
        }
    }
    
    // nil the connection
    if(urlConnection == self.getOrganizations.connection) {
        self.getOrganizations = nil;
    }
    else if(urlConnection == self.getEvents.connection) {
        self.getEvents = nil;
    }
    else {
        NSLog(@"invalid connection type in releasing connections, programmer error");
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger) hour minute:(NSInteger) minute second:(NSInteger) second {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    return [calendar dateFromComponents:components];
}

@end
