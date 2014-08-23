//  KeyRing.h

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

//  Simple wrapper to store key and string pairs in the keyChain.
//  NOT to be used for https traffic etc, there are better ways to do that in iOS.

//  There are no instance methods because there's no reason to create instances.
//  Really the only reason to make it a class at all was because I prefer to use
//  named parameters, it could have just as well been a few C functions.

#import <Foundation/Foundation.h>

@interface KeyRing : NSObject

// Retrieve a value from the keychain
+(NSString*) valueForKey:(NSString *)key;

// Store value in the keychain using key
+(bool) storeValue:(NSString *)value forKey:(NSString *)key;

// Completely remove entry from keychain
+(bool) removeAllForKey:(NSString *)key;

@end
