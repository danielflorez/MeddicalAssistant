//
//  MTEiPadSelecEntidadTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/27/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEntidad.h"
#import "MTEiPadCrearClienteViewController.h"

@interface MTEiPadSelecEntidadTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *entidades;
@property (nonatomic, weak) MTEiPadCrearClienteViewController *ccvc;

@end
