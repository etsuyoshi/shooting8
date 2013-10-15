//
//  TestsShootingTests.m
//  TestsShootingTests
//
//  Created by 遠藤 豪 on 13/10/14.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import "TestsShootingTests.h"
#import "AttrClass.h"

@implementation TestsShootingTests

- (void)setUp
{
    //テスト対象オブジェクトを生成
    [super setUp];
    
    
    attrclass = [[AttrClass alloc]init];
    
    // Set-up code here.
}

- (void)tearDown
{
    //テスト対象オブジェクトを解放
    // Tear-down code here.
//    [attrclass release];
    [super tearDown];
}

- (void)testExample
{
//    STFail(@"Unit tests are not implemented yet in TestsShootingTests");
    
    
}

-(void)testInit{
    STAssertNotNil(attrclass, @"AttrClassが初期化できません");
    [attrclass removeAllData];
    attrclass = [[AttrClass alloc]init];
    STAssertEquals([[attrclass getValueFromDevice:@"exp"] intValue], 0, @"初期値がゼロではありません");
}
-(void)testAddExp{
    [attrclass removeAllData];
    attrclass = [[AttrClass alloc]init];
    STAssertEquals([[attrclass getValueFromDevice:@"exp"] intValue], 0, @"exp初期値がゼロではありません");
    STAssertEquals([[attrclass getValueFromDevice:@"level"] intValue], 1, @"level初期値がゼロではありません");
    [attrclass addExp:99];
    STAssertEquals([[attrclass getValueFromDevice:@"exp"] intValue], 99, @"exp値が設定できていません");
    
    
    
    
}
-(void)testAddExp2{
    
    [attrclass removeAllData];
    attrclass = [[AttrClass alloc]init];
    [attrclass addExp:500];
    STAssertEquals([[attrclass getValueFromDevice:@"exp"] intValue], 200, @"exp値が設定できていません");
    STAssertEquals([[attrclass getValueFromDevice:@"level"] intValue], 3, @"level値が設定できていません");

    
    
}

@end
