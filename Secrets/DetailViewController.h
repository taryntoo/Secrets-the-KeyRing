//
//  DetailViewController.h
//  Secrets
//
//  Created by taryn on 8/17/14.
//  Copyright (c) 2014 taryn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
