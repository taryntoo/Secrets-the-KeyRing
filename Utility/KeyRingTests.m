//  KeyRingTests.m
//

/**
 Created by taryn, Copyright 2014.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "KeyRing.h"
#import "KeyRingTests.h"

#define XCTFail NSLog

NSString* boguskey;
NSString* barleykey;
NSString* ccNumFirst;
NSString* ccNumSecond;

bool TestKeyRingForBogusKey(void)
{
    NSString* bogus = [KeyRing valueForKey:boguskey];
    if(bogus) {
        XCTFail(@"%s, should not have returned value:%@", __PRETTY_FUNCTION__, bogus);
    }
    return true;
}

bool TestKeyRingAdd(void)
{

    bool stored = [KeyRing storeValue:ccNumFirst forKey:barleykey];
    if(!stored) {
        XCTFail(@"%s, failed to store:%@", __PRETTY_FUNCTION__, barleykey);
    }
    return true;
}

bool TestKeyRingForGoodKey(void)
{

    NSString* returned = [KeyRing valueForKey:barleykey];
    if(returned) {
        if(![returned isEqualToString:ccNumFirst]) {
            XCTFail(@"%s, returned a mismatched value:%@, instead of the expected:%@", __PRETTY_FUNCTION__, returned, ccNumFirst);
        }
    } else {
        XCTFail(@"%s, should have returned a value for:%@", __PRETTY_FUNCTION__,barleykey);
    }
    return true;
}

bool TestKeyRingUpDate(void)
{

    bool stored = [KeyRing storeValue:ccNumSecond forKey:barleykey];
    if(!stored) {
        XCTFail(@"%s, failed to store:%@", __PRETTY_FUNCTION__, barleykey);
    }

    NSString* returned = [KeyRing valueForKey:barleykey];
    if(returned) {
        if(![returned isEqualToString:ccNumSecond]) {
            XCTFail(@"%s, returned a mismatched value:%@, instead of the expected:%@", __PRETTY_FUNCTION__, returned, ccNumSecond);
        }
    } else {
        XCTFail(@"%s, should have returned a value for:%@", __PRETTY_FUNCTION__,barleykey);
    }
    return true;
}

bool TestKeyRingRemove(void)
{
    bool shouldfail = [KeyRing removeAllForKey:boguskey];
    if(shouldfail) {
        XCTFail(@"%s, no failure trying to remove a non-existent key", __PRETTY_FUNCTION__ );
    }


    bool removed = [KeyRing removeAllForKey:barleykey];
    if(!removed) {
        XCTFail(@"%s, failed to remove:%@", __PRETTY_FUNCTION__, barleykey);
    }

    return removed;
}





// TODO: without a removeValueForKey method this test may behave differently on first run.

bool RunKeyRingTests(void)
{
    boguskey = @"boguskey";
    barleykey = @"barleycornKeyCardNum1";
    ccNumFirst = @"1234567812345678";
    ccNumSecond = @"5678123456781234";


    if( TestKeyRingForBogusKey()) {
        if( TestKeyRingAdd()) {
            if( TestKeyRingForGoodKey()) {
                if( TestKeyRingUpDate()) {
                    if( TestKeyRingRemove()) {
                        NSLog(@"%s,\n   All tests passed, 2 warnings for %@ and 1 for %@ are expected.\n", __PRETTY_FUNCTION__, boguskey, barleykey);

                        return true;
                    }
                }
            }
        }
    }
    return false;
}



@implementation KeyRingTests

@end
