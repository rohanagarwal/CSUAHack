//
//  EventObj.m
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import "EventObj.h"

@implementation EventObj
@synthesize organizationName = _organizationName, eventName = _eventName, location = _location, startDate = _startDate, endDate = _endDate;

-(NSString*) StringStartDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    return [dateFormatter stringFromDate:self.startDate];
}

-(NSString*) StringEndDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    return [dateFormatter stringFromDate:self.endDate];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.organizationName];
    [aCoder encodeObject: self.eventName];
    [aCoder encodeObject: self.location];
    [aCoder encodeObject:self.startDate];
    [aCoder encodeObject:self.endDate];    
}
-(id) initWithCoder: (NSCoder *) aDecoder
{
    self.organizationName = [aDecoder decodeObject];
    self.eventName = [aDecoder decodeObject];
    self.location = [aDecoder decodeObject];
    self.startDate = [aDecoder decodeObject];
    self.endDate = [aDecoder decodeObject];
    return self;
}


@end
