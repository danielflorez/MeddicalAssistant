//
//  MTEresultadoCitaViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 12/1/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEdiagnostico.h"
#import "MTEmedicamento.h"

@interface MTEresultadoCitaViewController : UIViewController
@property (nonatomic, strong) MTEdiagnostico *diag;
@property (nonatomic, strong) MTEmedicamento *medicamento;

@end
