//
//  MTECrearConsultorioViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/15/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEConsultoriosTableViewController.h"
#import "MTEconsultorio.h"

@interface MTECrearConsultorioViewController : UIViewController
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEConsultoriosTableViewController *ctvc;
@property (nonatomic, strong) MTEconsultorio *consultorio;
@property (nonatomic, strong) NSIndexPath *index;
@property int crear;

@end
