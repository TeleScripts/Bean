//
//  ViewController.h
//  BeanTest
//
//  Created by Mark Spano on 5/28/15.
//  Copyright (c) 2015 Mark Spano. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTDBean.h"
#import "PTDBeanManager.h"
#import "PTDBeanRadioConfig.h"

@interface ViewController : UIViewController <PTDBeanDelegate, PTDBeanManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *connectionButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISlider *intensitySlider;
@property (strong, nonatomic) IBOutlet UILabel *pulseLabel;

//- (IBAction)connectionButtonAction:(UIButton *)sender;
//- (IBAction)intensitySliderAction:(UISlider *)sender;

@property (nonatomic, retain) PTDBean *bean;
@property (nonatomic, retain) PTDBeanManager *beanManager;

@end

