//
//  SelectViewController.m
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import "SelectViewController.h"
#import "SelectOrgViewController.h"
#import "PersonViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SelectViewController ()

@end

@implementation SelectViewController
@synthesize organization = _organization, individual = _individual;
@synthesize organizationText = _organizationText, individualText = _individualText;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    
    [self.organizationText.layer setShadowOpacity:1.0];
    [self.organizationText.layer setShadowRadius:1.0];
    [self.organizationText.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.organizationText.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
    
    [self.individualText.layer setShadowOpacity:1.0];
    [self.individualText.layer setShadowRadius:1.0];
    [self.individualText.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.individualText.layer setShadowOffset:CGSizeMake(-0.5, 0.5)];
}
-(void) viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)selectedOrganization:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toSelectOrg" sender:self];
}

- (IBAction)selectedPerson:(UIButton *)sender {
    [self performSegueWithIdentifier:@"toPerson" sender:self];
}

#pragma mark - segue
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath*)sender {
    if ([segue.identifier isEqualToString:@"toSelectOrg"]) {
        [segue destinationViewController];
    }
    else if ([segue.identifier isEqualToString:@"toPerson"]) {
        [segue destinationViewController];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
