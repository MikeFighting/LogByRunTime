//
//  ViewControllerTests.m
//  LogByRunTime
//
//  Created by Mike on 3/3/17.
//  Copyright © 2017 Mike. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
@interface ViewControllerTests : XCTestCase
{
    
    ViewController *viewController;
}

@end

@implementation ViewControllerTests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    viewController = [[ViewController alloc]init];
    
}

- (void)testLogForTapAction {

    [viewController performSelector:@selector(tapAction:) withObject:nil];
    
#warning The information should be gotten from data cache center, where data need to be uploaded.
    
    XCTAssertEqualObjects(viewController.tapTag, @"tapTagString",@"I should have this data if I did stored teh information about");

}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
