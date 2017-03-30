//
//  MTEiPadCrearClienteViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/27/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEiPadClientesTableViewController.h"
#import "MTEpaciente.h"
#import "MTEEntidad.h"

@interface MTEiPadCrearClienteViewController : UIViewController
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEiPadClientesTableViewController *ctvc;
@property (nonatomic, strong) MTEEntidad *entSeleccionada;
@property (nonatomic, strong) MTEpaciente *paci;
@property (nonatomic, strong) NSIndexPath *index;
@property int crear;
@property int selec;

@end
