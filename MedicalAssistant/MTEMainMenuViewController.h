//
//  MTEMainMenuViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 8/29/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTELoginViewController.h"

@interface MTEMainMenuViewController : UIViewController
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) MTELoginViewController *lvc;
@property (nonatomic, strong) NSString *memberID;

@end
