//
//  MTEiPadCrearProcedimientoViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/7/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEprocedimiento.h"
#import "MTEiPadProcedimientosTableViewController.h"

@interface MTEiPadCrearProcedimientoViewController : UIViewController
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEiPadProcedimientosTableViewController *ptvc;
@property (nonatomic, strong) MTEprocedimiento *proc;
@property (nonatomic, strong) NSIndexPath *index;
@property int crear;

@end
