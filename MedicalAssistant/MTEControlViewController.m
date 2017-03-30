//
//  MTEControlViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 12/16/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import "MTEControlViewController.h"
#import "MTEdiagnosticoTableViewController.h"
#import "MTEFormulacionTableViewController.h"

@interface MTEControlViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIButton *diagButton;
@property (weak, nonatomic) IBOutlet UIButton *formulacionButton;

@end

@implementation MTEControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320, 400)];
    UIImage *bg = [UIImage imageNamed:@"bcint.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.diag)
    {
        [self.diagButton setTitle:self.diag.desc
                         forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)diagClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEdiagnosticoTableViewController *dtvc = [storyboard instantiateViewControllerWithIdentifier:@"diagTable"];
    dtvc.cvc = self;
    [self.navigationController pushViewController:dtvc
                                         animated:YES];
}

- (IBAction)formulacionClick:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    MTEFormulacionTableViewController *dtvc = [storyboard instantiateViewControllerWithIdentifier:@"formulacionTVC"];
    //dtvc.cvc = self;
    [self.navigationController pushViewController:dtvc
                                         animated:YES];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer
{
    [[self view] endEditing:YES];
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
