//
//  EventObj.h
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import <Foundation/Foundation.h>

@interface EventObj : NSObject <NSCoding>

@property (strong, nonatomic) NSString* organizationName;
@property (strong, nonatomic) NSString* eventName;
@property (strong, nonatomic) NSString* location;
@property (strong, nonatomic) NSDate* startDate;
@property (strong, nonatomic) NSDate* endDate;

-(NSString*) StringStartDate;
-(NSString*) StringEndDate;

@end
