//
//  TestsShootingTests.h
//  TestsShootingTests
//
//  Created by 遠藤 豪 on 13/10/14.
//  Copyright (c) 2013年 endo.tuyo. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "AttrClass.h"


@interface TestsShootingTests : SenTestCase{
    
    @private AttrClass *attrclass;
    
}
-(void)testInit;
-(void)testAddExp;
-(void)testAddExp2;
@end
