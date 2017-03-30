//
//  MTECrearProcedimientoViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEProcedimientosTableViewController.h"
#import "MTEprocedimiento.h"

@interface MTECrearProcedimientoViewController : UIViewController
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEProcedimientosTableViewController *ptvc;
@property (nonatomic, strong) MTEprocedimiento *proc;
@property (nonatomic, strong) NSIndexPath *index;
@property int crear;

@end
