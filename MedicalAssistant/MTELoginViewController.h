//
//  MTELoginViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 8/1/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTELoginViewController : UIViewController <UITextFieldDelegate,NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end
