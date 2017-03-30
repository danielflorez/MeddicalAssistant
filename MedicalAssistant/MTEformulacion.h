//
//  MTEformulacion.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 3/17/15.
//  Copyright (c) 2015 Mangosta Tecnologia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MTEmedicamento.h"

@interface MTEformulacion : NSObject
@property (nonatomic, strong) MTEmedicamento *medicamento;
@property (nonatomic, strong) NSString *dosis;
@end
