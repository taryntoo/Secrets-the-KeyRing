Secrets-the-KeyRing
===================

Slides, lecture notes, and source for a presentation on security theory, with an implementation wrapping Apple keychain APIs. 
This was presented to South Florida Cocoa developers in August, 2014. 
https://www.meetup.com/Cocoa-Developers/events/197557682/

Easiest entry is through Secrets.pdf for an overview of theory, and discussion of design.

Secrets.pdf is copyrighted and may not be redistributed.
Secrets.xcodeproj and its source files are released under the Apache license.

My keyring wrapper API was created out of disgust with Apple's keychain APIs. See 
"The Worst API Ever Made" https://caseymuratori.com/blog_0025 for an API similar, but even worse. 
Apparently the keychain API sucks because it came out of CDSA/CSSM.

The Secrets App was created simply to wrap the API for the presentation.
