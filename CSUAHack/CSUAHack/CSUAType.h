// bump api key
#define BumpAPI @"4c68f91e73e042188a8621c65de2c742"

#define kGetOrganizations @"http://ec2-50-18-129-223.us-west-1.compute.amazonaws.com/api/org/?format=json"

#define kGetEvents @"http://ec2-50-18-129-223.us-west-1.compute.amazonaws.com/api/org_events/"

#define kPostAnalytic @"http://ec2-50-18-129-223.us-west-1.compute.amazonaws.com/api/analytics/"

typedef enum {
	ServerConnectionTypeGetOrganizations,
	ServerConnectionTypeGetEvents,
    ServerConnectionTypePostAnalytic
} ServerConnectionType;