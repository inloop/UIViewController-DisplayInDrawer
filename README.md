# UIViewController-DisplayInDrawer
Present any view controller easily in a drawer (iOS Maps style).

[![CI Status](https://img.shields.io/travis/inloop/UIViewController-DisplayInDrawer.svg?style=flat)](https://travis-ci.org/inloop/UIViewController-DisplayInDrawer)
[![Version](https://img.shields.io/cocoapods/v/UIViewController-DisplayInDrawer.svg?style=flat)](https://cocoapods.org/pods/UIViewController-DisplayInDrawer)
[![License](https://img.shields.io/cocoapods/l/UIViewController-DisplayInDrawer.svg?style=flat)](https://cocoapods.org/pods/UIViewController-DisplayInDrawer)
[![Platform](https://img.shields.io/cocoapods/p/UIViewController-DisplayInDrawer.svg?style=flat)](https://cocoapods.org/pods/UIViewController-DisplayInDrawer)

It is implemented as a UIViewController extension, which means **no subclassing** and **no invasive view hierarchy setup**.
It is designed to be as easy to use as possible:
1. You can present any controller. Make it conform to the `DrawerConfiguration` protocol
1. Optionally setup a `DrawerPositionDelegate` which is notified about drawer's position
1. Call `displayInDrawer(controller, drawerPositionDelegate: delegate)` on your presenting controller.

![Demo](http://www.cocoaminers.com/files/DisplayInDrawer.gif)

Amongst other things we add blur behind your controller. If you want blur effect to be visible you need give transparent background to your viewController's view.
What does the lib add to visually decorate your content controller:
  * pull handle image
  * rounded edges
  * top border and top shadow
  * blur behind your controller's content
  * dim view, which is continually dimmmed when you drag above middle
  * bottom padding area so that you can bounce (overdrag) your controller at the top and the bottom area still looks nice
  

## Example

To see it in action run `pod try UIViewController-DisplayInDrawer` or clone the lib manually

## Requirements

iOS 10+

## Installation

UIViewController-DisplayInDrawer is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UIViewController-DisplayInDrawer'
```

## Author

vilemkurz, vilem.kurz@inloopx.com

## License

UIViewController-DisplayInDrawer is available under the MIT license. See the LICENSE file for more info.
