//
//  MTEresultadoCitaViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 12/1/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEresultadoCitaViewController.h"
#import "MTEdiagnosticoTableViewController.h"
#import "MTEmedicamentosTableViewController.h"

@interface MTEresultadoCitaViewController ()
@property (weak, nonatomic) IBOutlet UIButton *diagButton;
@property (weak, nonatomic) IBOutlet UIButton *mediButton;

@end

@implementation MTEresultadoCitaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.diag)
    {
        [self.diagButton setTitle:self.diag.desc
                               forState:UIControlStateNormal];
    }
    if (self.medicamento)
    {
        [self.mediButton setTitle:self.medicamento.nombre
                         forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)diagnosticoClick:(id)sender
{

}

- (IBAction)medicamentosClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEmedicamentosTableViewController *mtvc = [storyboard instantiateViewControllerWithIdentifier:@"mediTable"];
    [self.navigationController pushViewController:mtvc
                                         animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
