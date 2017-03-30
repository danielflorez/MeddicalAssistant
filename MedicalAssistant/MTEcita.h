//
//  MTEcita.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/14/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTEpaciente.h"
#import "MTEprocedimiento.h"
#import "MTEconsultorio.h"
#import "MTEEntidad.h"

@interface MTEcita : NSObject
@property (nonatomic, strong) NSString *idCita;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *fechaInicio;
@property (nonatomic, strong) NSString *fechaFin;
@property (nonatomic, strong) MTEpaciente *paci;
@property (nonatomic, strong) MTEprocedimiento *proc;
@property (nonatomic, strong) MTEconsultorio *consul;
@property (nonatomic, strong) MTEEntidad *enti;

@end
