//  KeyRing.m

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
#import <Security/Security.h>

// Probably won't ever need any instance methods for this class.
@implementation KeyRing

/** Assemble a dictionary for the "query" parameter of SecItem calls
 This is used by the keychain as a record selector for searches, updates, 
 and deletes, and as the record dictionary when creating new entries.
 */
+(NSMutableDictionary*) newQueryDictionaryforKey:(NSString *)key {
    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)kSecClassGenericPassword,       kSecClass, // object is a string
                           key,                                   kSecAttrAccount, // identified by key
                           kCFBooleanTrue,                   kSecReturnAttributes, // decrypt to dictionary
                           nil];
    return query;
}

// Retrieve a value from the keychain
+(NSString*) valueForKey:(NSString *)key {
    CFDictionaryRef result = nil;
    CFDictionaryRef query =  (__bridge CFDictionaryRef) [self newQueryDictionaryforKey:key];

    OSStatus status = SecItemCopyMatching( query, (CFTypeRef*) &result);

    if (status == noErr) {      // good query?
        if(result) {            // and value found?
            // I'd rather not make a second copy of value, but I can't seem to retain the string
            // while releasing the dictionary, so grab the one string we care about
            NSString* value = [NSString stringWithString: CFDictionaryGetValue(result, kSecAttrGeneric)];
            CFRelease(result);  // toss the dictionary, we don't need it.

            return value;   // good exit
        }
    }
    NSLog(@"%s No value found for key:%@, error is %i",__func__, key, (int)status);
    return nil;  // Not found
}

// Store value in the keychain using key
// This manages both "add" and "update" actions in a single method.
// If the calling app wants to treate add and update differently, perhaps
// warning before overwrite, it should test first using valueForKey,
// then continue or cancel as desired.
+(bool) storeValue:(NSString *)value forKey:(NSString *)key {

    OSStatus status = 0;
    CFMutableDictionaryRef cfQuery = (__bridge CFMutableDictionaryRef)[self newQueryDictionaryforKey:key];

    NSString *existingValue = [self valueForKey:key];   // Does the value exist already?
    if (existingValue) {                                // Yes, so we'll be doing an update
        NSDictionary *valueDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   value, kSecAttrGeneric, nil]; // the value we're replacing or adding.

        // Keychain complains if this attribute appears in an update
        CFDictionaryRemoveValue(cfQuery, kSecReturnAttributes);

        status = SecItemUpdate(cfQuery, (__bridge CFDictionaryRef)(valueDict) );
    } else {
        // existing value not found, we'll need it in the dictionary we're passing to SecItemAdd()
        CFDictionarySetValue(cfQuery,kSecAttrGeneric,(__bridge const void *)(value));

        status = SecItemAdd(cfQuery, NULL); // 2nd param can return a reference to added item.
    }

    if (status == noErr) {  // was the value stored?
        return true;        // yes, good exit
    }
    NSLog(@"%s failed, error is %i",__func__, (int)status);
    return false;   // something failed.
}

// Completely remove entry from keychain
+(bool) removeAllForKey:(NSString *)key {

    NSDictionary *query =  [self newQueryDictionaryforKey:key];

    OSStatus status = SecItemDelete( (__bridge CFDictionaryRef) query);
    if (status == noErr) {    // Value found?
        return true;   // found it, good exit
    }
    NSLog(@"%s No value found for key:%@, error is %i",__func__, key, (int)status);

    return false;
}

@end
