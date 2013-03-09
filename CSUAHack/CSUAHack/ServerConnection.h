//
//  ServerConnection.h
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import <Foundation/Foundation.h>
#import "CSUAType.h"

@interface ServerConnection : NSObject

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSURLResponse *response;
@property (strong, nonatomic) NSMutableData *responseData;
@property ServerConnectionType type;
@property (weak, nonatomic) id delegate;

@end
