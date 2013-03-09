//
//  SelectViewController.h
//  CSUAHack
//
//  Created by Rohan Agarwal on 3/8/13.
//
//

#import <UIKit/UIKit.h>

@interface SelectViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *organization;
@property (strong, nonatomic) IBOutlet UIButton *individual;
@property (strong, nonatomic) IBOutlet UILabel *organizationText;
@property (strong, nonatomic) IBOutlet UILabel *individualText;

@end
