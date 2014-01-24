//
//  TopPlacesListTVC.m
//  Top Places
//
//  Created by James Kizer on 1/22/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "TopPlacesListTVC.h"
#import "FlickrFetcher.h"
#import "Place.h"
#import "PhotoListForPlaceTVC.h"

@interface TopPlacesListTVC ()

//countries array has an entry for each country (unique), sorted alphabetically
//this is used to populate the section headers
@property (nonatomic, strong) NSArray *countries; //of NSStrings
//each entry is a sorted array of place entries
@property (nonatomic, strong) NSMutableDictionary *placeDictionary; //of NSArray

@end

@implementation TopPlacesListTVC

- (NSArray *)countries
{
    if (!_countries) _countries = [[NSArray alloc] init];
    return _countries;
    
}

- (NSMutableDictionary *)placeDictionary
{
    if (!_placeDictionary) _placeDictionary = [[NSMutableDictionary alloc]init];
    return _placeDictionary;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self fetchPlaces];
}

// this method is called in viewDidLoad,
//   but also when the user "pulls down" on the table view
//   (because this is the action of self.tableView.refreshControl)

- (IBAction)fetchPlaces
{
    [self.refreshControl beginRefreshing]; // start the spinner
    NSURL *url = [FlickrFetcher URLforTopPlaces];
    // create a (non-main) queue to do fetch on
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    // put a block to do the fetch onto that queue
    dispatch_async(fetchQ, ^{
        // fetch the JSON data from Flickr
        NSData *jsonResults = [NSData dataWithContentsOfURL:url];
        // convert it to a Property List (NSArray and NSDictionary)
        NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                            options:0
                                                                              error:NULL];
        
        //NSLog(@"%@",propertyListResults);
        // get the NSArray of photo NSDictionarys out of the results
        NSArray *places = [propertyListResults valueForKeyPath:FLICKR_RESULTS_PLACES];
        // update the Model (and thus our UI), but do so back on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing]; // stop the spinner
            [self processPlaceData:places];
            [self.tableView reloadData];
        });
    });
}

-(void)processPlaceData:(NSArray *)places
{
    NSMutableArray *placeObjects = [[NSMutableArray alloc]init]; //of Place objects
    NSMutableSet *countrySet = [[NSMutableSet alloc]init]; //of NSStrings
    //each key is a country name, each value is an array of Place objects
    //NSMutableDictionary *placesDict = [[NSMutableDictionary alloc]init];
    //first, for each dictionary in the array, generate a place object, add to place array
    //also, for each placeObject, add to countries set
    for (id place in places)
    {
        
        if ([place isKindOfClass:[NSDictionary class]])
        {
            //NSLog(@"In processPlaceData, processing the following NSDictionary:\n%@", place);
            Place *newPlace = [[Place alloc]initWithPlaceData:(NSDictionary *)place];
            //NSLog(@"Adding the following newPlace to the placeObjects array:\n%@", newPlace);
            [placeObjects addObject:newPlace];
            //NSLog(@"Adding the following country to the countrySet:\n%@", newPlace.country);
            [countrySet addObject:newPlace.country];
            
            NSMutableArray *newPlaceArray = [self.placeDictionary objectForKey:newPlace.country];
            if (!newPlaceArray)
            {
                newPlaceArray = [[NSMutableArray alloc]init];
                [self.placeDictionary setObject:newPlaceArray forKey:newPlace.country];
            }
            //determine the correct index to add the place to
            NSUInteger newIndex = [newPlaceArray indexOfObject:newPlace inSortedRange:NSMakeRange(0, [newPlaceArray count]) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id obj1, id obj2) {
                if ([obj1 isKindOfClass:[Place class]] && [obj1 isKindOfClass:[Place class]])
                    return [(Place *)obj1 compareCity: (Place *)obj2];
                else
                    return NSOrderedSame;
            }];
            
            [newPlaceArray insertObject:newPlace atIndex:newIndex];
        }
        else
            NSLog(@"In processPlaceData, the following object is not an NSDictionary:\n%@", place);
             
    }
    
    //NSLog(@"In processPlaceData, the following is the unique set of countries:\n%@", countrySet);
    //countrySet now contains a unique set of the countries
    //create sorted array from this set
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:Nil ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }]];
    self.countries = [countrySet sortedArrayUsingDescriptors:(NSArray *)sortDescriptors];
    //NSLog(@"In processPlaceData, the following is the sorted array of countries:\n%@", self.countries);
    
//    for (id country in self.placeDictionary)
//        NSLog(@"%@",self.placeDictionary[country]);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.countries count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    assert([self.countries count] > section);
    NSString *country = self.countries[section];
    NSArray *placeArray = [self.placeDictionary objectForKey:country];
    return [placeArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we must be sure to use the same identifier here as in the storyboard!
    static NSString *CellIdentifier = @"Place Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    // update UILabels in the UITableViewCell
    // valueForKeyPath: supports "dot notation" to look inside dictionaries at other dictionaries
    cell.textLabel.text = [self getTitleForRow:indexPath.row inSection:indexPath.section];
    cell.detailTextLabel.text = [self getDetailForRow:indexPath.row inSection:indexPath.section];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    assert([self.countries count] > section);
    return self.countries[section];
}

//the titles of the cells are the cities
- (NSString *)getTitleForRow:(NSUInteger)row inSection:(NSUInteger)section
{
    Place *place = [self placeForRow:row inSection:section];
    return place.city;
}

//the detail of the cells are the states
- (NSString *)getDetailForRow:(NSUInteger)row inSection:(NSUInteger)section
{
    Place *place = [self placeForRow:row inSection:section];
    if (!place.state)
        NSLog(@"State is nil for %@", place);
    return place.state;
}

- (Place *)placeForRow:(NSUInteger)row inSection:(NSUInteger)section
{
    Place *place = nil;
    assert([self.countries count] > section);
    NSString *country = self.countries[section];
    id obj = [self.placeDictionary objectForKey:country];
    if ([obj isKindOfClass:[NSArray class]])
    {
        NSArray *placeArray = (NSArray *)obj;
        assert([placeArray count] > row);
        id placeObj = placeArray[row];
        if ([placeObj isKindOfClass:[Place class]])
        {
            place = (Place *)placeObj;
        }
    }
    return place;
}

#pragma mark - Navigation

- (void)preparePhotoListForPlaceTVC:(PhotoListForPlaceTVC *)plTVC forPlace:(Place *)place
{
    plTVC.place = place;
    plTVC.title = place.city;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        // find out which row in which section we're seguing from
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            // found it ... are we doing the Photos For Place segue?
            if ([segue.identifier isEqualToString:@"Photos For Place"]) {
                // yes ... is the destination an ImageViewController?
                if ([segue.destinationViewController isKindOfClass:[PhotoListForPlaceTVC class]]) {
                    // yes ... then we know how to prepare for that segue!
                    [self preparePhotoListForPlaceTVC:segue.destinationViewController forPlace:[self placeForRow:indexPath.row inSection:indexPath.section]];
                }
            }
        }
    }
}

@end
