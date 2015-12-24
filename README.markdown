Page Curl Sample for iPad
=========================

This application makes use of (clever?) manipulation of multiple CALayers attached to a single UIView to "fake" a page curl/page flip effect for the iPad. ~~It's the next best thing to iBooks until Apple releases a public API for the CIPageCurl ImageUnit on the iPad.~~ You should really be using [UIPageViewController](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIPageViewControllerClassReferenceClassRef/index.html) for this sort of thing now.

Clicking in right/left margins will flip pages forward/backwards. Dragging from said margins towards the center of the screen will slowly animate the flipping of the page so as to track your finger. Rotating does the Right Thing showing pages "two up" in landscape mode. 

This code is distributed under a BSD license (see LICENSE) and was originally written to support VERVM, an iPad version of the [VERVM CORPVS][2] comic book.


My thanks,   
-Joshua Emmons   
@jemmons   
May 2010


[2]: http://city.ofsand.com
