//
//  ViewController.m
//  CurrencyTable
//
//  Created by Admin on 07.09.14.
//  Copyright (c) 2014 LembergSun. All rights reserved.
//

#import "SelectionListViewController.h"

@interface SelectionListViewController () {
  DataBaseManager *dataBaseManager;
  UsedData *data;
}

@property(weak, nonatomic) IBOutlet UITableView *selectionTableView;

@end

@implementation SelectionListViewController
- (void)viewDidLoad {
  [super viewDidLoad];
  dataBaseManager = [DataBaseManager sharedManager];
  self.navigationController.navigationBar.titleTextAttributes =
      @{NSForegroundColorAttributeName : [UIColor whiteColor]};
  _selectionTableView.backgroundColor = [UIColor
      colorWithPatternImage:[UIImage imageNamed:@"wood-wallpaper.png"]];
  data = [[UsedData alloc] initData];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource:

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {

  return [data.shortNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *SimpleIdentifier = @"SimpleIdentifier";
  TableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];

  CurrencyInfo *exemplair =
      [dataBaseManager.fetchedArrayOfCurrencyInfo objectAtIndex:indexPath.row];
  cell.nameLabel.text = exemplair.abbrev;
  cell.fullNameLabel.text = exemplair.fullName;
  cell.flagImageView.image = [UIImage imageNamed:exemplair.icon];
  cell.sumLabel.text = nil;

  if (!self.selectedMainSegue) { // if the new currency is to be added to the
                                 // target list

    if (exemplair.checked) { // if he element has been already selected -
                             // display its checkmark and increase amount

      cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
  }
  return cell;
}

#pragma mark - UITableViewDelegate:

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
  [shake setDuration:0.1];
  [shake setRepeatCount:3];
  [shake setAutoreverses:YES];

  [shake setFromValue:[NSValue valueWithCGPoint:CGPointMake(cell.center.x - 5,
                                                            cell.center.y)]];
  [shake setToValue:[NSValue valueWithCGPoint:CGPointMake(cell.center.x + 5,
                                                          cell.center.y)]];
  [cell.layer addAnimation:shake forKey:@"position"];
  if (self.selectedMainSegue) { // if the main currency is to be changed - invoke SETMainCurrency method
    [[self delegate] setMainCurrency:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
  } else { // on contrary, if any new currency is to be added - accept new selections and put or put away checkmarks
    CurrencyInfo *exemplair = [dataBaseManager.fetchedArrayOfCurrencyInfo
        objectAtIndex:indexPath.row];

    if (cell.accessoryType == UITableViewCellAccessoryNone) {
      if (![self.selectedCurrency isEqualToString:exemplair.abbrev]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        exemplair.checked = @1;
      }
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {

      cell.accessoryType = UITableViewCellAccessoryNone;
      self.amount -= 1;
      exemplair.checked = nil;
    }
  }
}

- (IBAction)done:(UIBarButtonItem *)sender // pass the amount of selected items
                                           // towards the first view and dismiss
                                           // this controller
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
