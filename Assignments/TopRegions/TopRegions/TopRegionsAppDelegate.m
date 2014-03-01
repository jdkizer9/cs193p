//
//  TopRegionsAppDelegate.m
//  TopRegions
//
//  Created by James Kizer on 2/27/14.
//  Copyright (c) 2014 JimmyTime Software. All rights reserved.
//

#import "TopRegionsAppDelegate.h"
#import "FlickrFetcher.h"
#import "Photo.h"
#import "Photo+Flickr.h"
#import "RegionsDatabaseAvailabilityNotification.h"


@interface TopRegionsAppDelegate() <NSURLSessionDownloadDelegate>

@property (strong, nonatomic) UIManagedDocument *topRegionsDBDocument;
@property (strong, nonatomic) NSManagedObjectContext *topRegionsDBContext;


@property (copy, nonatomic) void (^flickrDownloadBackgroundURLSessionCompletionHandler)();
@property (strong, nonatomic) NSURLSession *flickrDownloadSession;
@property (strong, nonatomic) NSTimer *flickrForegroundFetchTimer;

@end

#define FLICKR_FETCH @"Flickr Top Regions Fetch"

#define FOREGROUND_FLICKR_FETCH_INTERVAL (20*60)

@implementation TopRegionsAppDelegate

typedef void (^completion_handler_t)(BOOL);

- (UIManagedDocument *)topRegionsDBDocument
{
    if (!_topRegionsDBDocument) _topRegionsDBDocument = [[UIManagedDocument alloc] init];
    return _topRegionsDBDocument;
}

- (void)setTopRegionsDBContext:(NSManagedObjectContext *)topRegionsDBContext
{
    _topRegionsDBContext = topRegionsDBContext;
    NSDictionary *userInfo = self.topRegionsDBContext ? @{ RegionsDatabaseAvailabilityContext : self.topRegionsDBContext } : nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:RegionsDatabaseAvailabilityNotification
                                                        object:self
                                                      userInfo:userInfo];
}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    
    NSString *documentName = @"FirstDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.topRegionsDBDocument = [[UIManagedDocument alloc]initWithFileURL:url];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    self.topRegionsDBDocument.persistentStoreOptions = options;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]])
        [self.topRegionsDBDocument openWithCompletionHandler:^(BOOL success){
            if (success)
                [self documentIsReady];
            else
                NSLog(@"Couldn't open document at %@", url);
        }];
    else
        [self.topRegionsDBDocument saveToURL:url
           forSaveOperation:UIDocumentSaveForCreating
                           completionHandler:^(BOOL success){
                               if (success)
                                   [self documentIsReady];
                               else
                                   NSLog(@"Couldn't create document at %@", url);
                           }];
    
    
    // Override point for customization after application launch.
    return YES;
}
- (void)documentIsReady
{
    if (self.topRegionsDBDocument.documentState == UIDocumentStateNormal)
    {
        //start using document
        self.topRegionsDBContext = self.topRegionsDBDocument.managedObjectContext;
        [self startFlickrFetch];
        
    }
    else
        NSLog(@"Document in bad state");
}

- (void)startFlickrFetch
{
    [self.flickrDownloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if (![downloadTasks count]) {
            NSURLSessionDownloadTask *task = [self.flickrDownloadSession downloadTaskWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]];
            task.taskDescription = FLICKR_FETCH;
            [task resume];
        } else {
            for (NSURLSessionDownloadTask *task in downloadTasks) [task resume];
        }
    }];
}


//UIRefreshControl action
- (void)loadMoreFlickrData:(UIRefreshControl *)sender
{
    [self startFlickrFetch];
    [sender endRefreshing];
}

- (NSURLSession *)flickrDownloadSession
{
    if (!_flickrDownloadSession) {
        static dispatch_once_t oneToken;
        dispatch_once(&oneToken, ^{
            
            NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:FLICKR_FETCH];
            urlSessionConfig.allowsCellularAccess = NO;
            _flickrDownloadSession = [NSURLSession sessionWithConfiguration:urlSessionConfig
                                                                   delegate:self
                                                              delegateQueue:nil];
        });
    }
    return _flickrDownloadSession;
}

- (NSArray *)flickrPhotosAtURL:(NSURL *)url
{
    // fetch the JSON data from Flickr
    NSData *jsonResults = [NSData dataWithContentsOfURL:url];
    // convert it to a Property List (NSArray and NSDictionary)
    NSDictionary *propertyListResults = [NSJSONSerialization JSONObjectWithData:jsonResults
                                                                        options:0
                                                                          error:NULL];
    NSLog(@"%@", propertyListResults);
    return [propertyListResults valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    
    
}

#pragma mark - NSURLSessionDownloadDelegate

//required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)localFile
{
    if ([downloadTask.taskDescription isEqualToString:FLICKR_FETCH]) {
        NSManagedObjectContext *context = self.topRegionsDBContext;
        if (context)
        {
            NSArray *photos = [self flickrPhotosAtURL:localFile];
            [context performBlock:^{
                [Photo loadPhotosFromFlickrArray:photos intoManagedObjectContext:context];
                [context save:NULL];
            }];
        }
    }
}

//required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

//required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}





@end
