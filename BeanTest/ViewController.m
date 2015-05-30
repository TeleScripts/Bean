//
//  ViewController.m
//  BeanTest
//
//  Created by Mark Spano on 5/28/15.
//  Copyright (c) 2015 Mark Spano. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    self.beanManager = [[PTDBeanManager alloc] initWithDelegate:self];
    self.bean = nil;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


// handle my methods

- (IBAction)connectionButtonAction:(UIButton *)sender
{
    if (self.bean.state == BeanState_ConnectedAndValidated)
    {
        NSError *err;
        [self.beanManager disconnectBean:self.bean error:&err];
        if (err)
        {
            _statusLabel.text = [err localizedDescription];
        }
        [_connectionButton setTitle:@"Start Scanning" forState:UIControlStateNormal];
        
    }
    else
    {
        if(self.beanManager.state == BeanManagerState_PoweredOn)
        {
            NSError *err;
            [self.beanManager startScanningForBeans_error:&err];
            _statusLabel.text = @"Scanning";
            if (err)
            {
                _statusLabel.text = [err localizedDescription];
            }
        }
        else
        {
            _statusLabel.text = @"Bean Manager not powered on";
        }
    }
}

//- (IBAction)intensitySliderAction:(UISlider *)sender
//{
//    unsigned int sendData = sender.value;   // warning - truncates a float into an integer!!!
//    
//    if (self.bean)
//    {
//        NSMutableData *data = [NSMutableData dataWithBytes:&sendData length:sizeof(sendData)];
//        
//        // Cancel any pending data sends
//        
//        [NSObject cancelPreviousPerformRequestsWithTarget:self];
//        
//        // We send the data after 0.3 seconds to avoid the quick movement of the slider backing up send commands
//        
//        [self performSelector:@selector(sendDataToBean:) withObject:data afterDelay:0.3];
//    }
//}


// send data

- (void)receiveData:(unsigned char *)data length:(int)length
{
    for (int i = 0; i<length; i+=3)
    {
        
        if (data[i] == 0x0B)
        {
            UInt16 Value;
            Value = data[i+2] | data[i+1] << 8;
            NSLog(@"%d",Value);
            [_pulseLabel setText:[NSString stringWithFormat:@"%i",Value]];
        }
    }
}

//    [self.bean setScratchNumber:1 withValue:sendData];
//    
//    // Uncomment this line to get feedback from the bean, to make sure scratch data is OK
//    NSLog([self.bean readScratchBank:1]);


// check the delegate value

-(void)bean:(PTDBean *)bean didUpdateScratchNumber:(NSNumber *)number withValue:(NSData *)data
{
    unsigned int oneInt = ((unsigned int*)[data bytes])[0];
    NSLog(@"%d",oneInt);
    [_pulseLabel setText:[NSString stringWithFormat:@"%i",oneInt]];

}

- (void)readScratchBank:(NSInteger)bank data:(NSData *)data
{
    unsigned int oneInt = ((unsigned int*)[data bytes])[0];
    NSLog(@"%d",oneInt);
    [_pulseLabel setText:[NSString stringWithFormat:@"%i",oneInt]];
}

// bean discovered

- (void)BeanManager:(PTDBeanManager *)beanManager didDiscoverBean:(PTDBean *)aBean error:(NSError *)error
{
    if (error)
    {
        _statusLabel.text = [error localizedDescription];
        return;
    }
    _statusLabel.text = [NSString stringWithFormat:@"Bean found: %@",[aBean name]];
    [self.beanManager connectToBean:aBean error:nil];
}


// bean connected

- (void)BeanManager:(PTDBeanManager*)beanManager didConnectToBean:(PTDBean*)bean error:(NSError*)error
{
    if (error)
    {
        _statusLabel.text = [error localizedDescription];
        return;
    }
    
    // do stuff with your bean
    
    _statusLabel.text = @"Bean connected!";
    self.bean = bean;
    self.bean.delegate = self;
    
    [_connectionButton setTitle:@"Disconnect" forState:UIControlStateNormal];
}


// bean disconnected

- (void)BeanManager:(PTDBeanManager*)beanManager didDisconnectBean:(PTDBean*)bean error:(NSError*)error
{
    _statusLabel.text = @"Bean disconnected.";
}

- (void)beanManagerDidUpdateState:(PTDBeanManager *)beanManager;
{
    // We don't use this in this program but it may be useful at some point
    
     /*
     
     The state representing the BeanManager
     
     Example:
     
     - (void)beanManagerDidUpdateState:(PTDBeanManager *)manager
     {
        // if manager is powered on, start scanning
     
        if(self.beanManager.state == BeanManagerState_PoweredOn)
        {
            [self.beanManager startScanningForBeans_error:nil];
        }
        else if (self.beanManager.state == BeanManagerState_PoweredOff)
        {
            // do something else
        }
     }
     
     */

}

@end
