//
//  MTEiPadMainMenuViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 8/29/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEipadLoginViewController.h"

@interface MTEiPadMainMenuViewController : UIViewController
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) MTEipadLoginViewController *lvc;
@property (nonatomic, strong) NSString *memberID;

@end
