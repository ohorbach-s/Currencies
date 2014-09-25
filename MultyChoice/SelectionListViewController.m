//
//  ViewController.m
//  CurrencyTable
//
//  Created by Admin on 07.09.14.
//  Copyright (c) 2014 LembergSun. All rights reserved.
//

#import "SelectionListViewController.h"



@interface SelectionListViewController ()
{
    NSString *SimpleIdentifier;
}

@end

@implementation SelectionListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood-wallpaper.png"]];
    SimpleIdentifier = @"SimpleIdentifier";
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource:

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger) section{
    
    Starter *start = [[Starter alloc]initStarter];
    return [start.shortNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wood-wallpaper.png"]];
    RTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleIdentifier];
    RTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *req = [NSFetchRequest new];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"CurrencyInfo"
                inManagedObjectContext:context];
    
    [req setEntity:entityDesc];
    
    NSArray *fetched = [context executeFetchRequest:req error:&error];                                //loading the currencies data from DB
    
    unsigned index = indexPath.row;
    
    CurrencyInfo *exemplair = fetched[index];
    cell.nameLabel.text = exemplair.abbrev;
    cell.fullNameLabel.text = exemplair.fullName;
    cell.flagImageView.image = [UIImage imageNamed:exemplair.icon];
    cell.sumLabel.text = nil;
    
    [context save:&error];
    
    if(!self.selectedMainSegue){                                                                        //if the new currency is to be added to the target list
        
        if(exemplair.checked){                                                                       //if he element has been already selected - display its checkmark and increase amount
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.amount += 1;
        }
    }
    NSLog(@"table amount = %d", self.amount);
    
    return cell;
}


#pragma mark - UITableViewDelegate:

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.selectedMainSegue){                                                                          //if the main currency is to be changed - invoke SETMainCurrency method
        [[self delegate] setMainCurrency: indexPath.row];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {                                                                             //on contrary, if any new currency is to be added - accept new selections and put or put away checkmarks
        RTAppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        NSFetchRequest *req = [NSFetchRequest new];
        
        NSEntityDescription *entityDesc =
        [NSEntityDescription entityForName:@"CurrencyInfo"inManagedObjectContext:context];
        
        NSError *error;
        [req setEntity:entityDesc];
        
        NSArray *fetched = [context executeFetchRequest:req error:&error];
        CurrencyInfo *exemplair = fetched[indexPath.row];
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.amount += 1;
            exemplair.checked = @1;
            NSError *error;
            [context save: &error];
            
        } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.amount -= 1;
            exemplair.checked = nil;
            
            NSError *error;
            [context save: &error];
        }
    
   NSLog(@"amount = %d", self.amount);
        
    }
}


- (IBAction)done:(UIBarButtonItem *)sender                                             //pass the amount of selected items towards the first view and dismiss this controller
{
    if(!self.selectedMainSegue)[[self delegate] setSelectedCurrency: self.amount];    
    [self dismissViewControllerAnimated:YES completion:nil];

}


@end
