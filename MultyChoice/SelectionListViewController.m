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
    
    
    CGFloat rotationAngleDegrees = -15;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTransformation = transform;
     _shownIndexes = [NSMutableSet set];

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
    
    if (![self.shownIndexes containsObject:indexPath]) {
        [self.shownIndexes addObject:indexPath];
        
        //UIView *card = [(CTCardCell* )cell mainView];
        cell.layer.transform = self.initialTransformation;
        cell.layer.opacity = 1.8;
        [UIView animateWithDuration:0.7 animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.layer.opacity = 1;
        }];
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
  if (self.selectedMainSegue) {
    [[self delegate] setMainCurrency:(unsigned int)indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
  } else {
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.shownIndexes containsObject:indexPath]) {
        [self.shownIndexes addObject:indexPath];
        cell.layer.transform = self.initialTransformation;
        cell.layer.opacity = 1.8;
        [UIView animateWithDuration:0.7 animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.layer.opacity = 1;
        }];
    }
}




- (IBAction)done:(UIBarButtonItem *)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
