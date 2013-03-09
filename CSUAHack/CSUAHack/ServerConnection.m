//
//  ServerConnection.m
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import "ServerConnection.h"

@implementation ServerConnection
@synthesize connection = _connection, request = _request, response = _response, responseData = _responseData, type = _type, delegate = _delegate;

- (id) init {
	if(self = [super init]) {
	}
	return self;
}

@end
