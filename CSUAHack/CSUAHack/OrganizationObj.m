//
//  OrganizationObj.m
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/9/13.
//
//

#import "OrganizationObj.h"

@implementation OrganizationObj
@synthesize orgName = _orgName, orgID = _orgID;

-(NSString*) description {
    return [self.orgName stringByAppendingString:[NSString stringWithFormat:@"%d", [self.orgID intValue]]];
}


@end
