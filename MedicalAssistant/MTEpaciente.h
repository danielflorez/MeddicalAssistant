//
//  MTEpaciente.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/16/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTEpaciente : NSObject
@property (nonatomic, strong) NSString *nombre;
@property (nonatomic, strong) NSString *apellido;
@property (nonatomic, strong) NSString *cedula;
@property (nonatomic, strong) NSString *direccion;
@property (nonatomic, strong) NSString *telefono;
@property (nonatomic, strong) NSString *fechaNacimiento;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *idEntidad;

@end
