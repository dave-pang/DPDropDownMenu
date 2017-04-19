# DPDropDownMenu

[![CI Status](http://img.shields.io/travis/yainoma00@gmail.com/DPDropDownMenu.svg?style=flat)](https://travis-ci.org/yainoma00@gmail.com/DPDropDownMenu)
[![Version](https://img.shields.io/cocoapods/v/DPDropDownMenu.svg?style=flat)](http://cocoapods.org/pods/DPDropDownMenu)
[![License](https://img.shields.io/cocoapods/l/DPDropDownMenu.svg?style=flat)](http://cocoapods.org/pods/DPDropDownMenu)
[![Platform](https://img.shields.io/cocoapods/p/DPDropDownMenu.svg?style=flat)](http://cocoapods.org/pods/DPDropDownMenu)

![](https://github.com/dave-ios/DPDropDownMenu/blob/master/demo.gif)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

DPDropDownMenu is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DPDropDownMenu"
```

## Usage
```swift
import DPDropDownMenu
```

Declare an array of texts that are served as the item in the menu.
```swift
let items = [DPItem(title: "item0"),
             DPItem(title: "item1"),
             DPItem(title: "item2")]

let menu = DPDropDownMenu(items: items)
menu.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
view.addSubview(menu)
```
The handler `public var didSelectedItemIndex: ((Int) -> (Void))?` would be called when menu item is tapped. So place code in here to do whatever you want. For example
```swift
menu1.didSelectedItemIndex = { index in
    print("did selected index: \(index)")
}
```
### Customize property
```swift
@IBInspectable public var visibleItemCount: Int = 3
    
@IBInspectable public var headerTitle: String = "Header"

@IBInspectable public var headerTextColor: UIColor = .white 

@IBInspectable public var headerBackgroundColor: UIColor = .orange 

@IBInspectable public var menuTextColor: UIColor = .black 

@IBInspectable public var menuBackgroundColor: UIColor = .white 

@IBInspectable public var selectedMenuTextColor: UIColor = .orange

@IBInspectable public var selectedMenuBackgroundColor: UIColor = .white 

@IBInspectable public var headerTextFont: UIFont = UIFont.systemFont(ofSize: 14) 

@IBInspectable public var menuTextFont: UIFont = UIFont.systemFont(ofSize: 14) 
```
## Author

yainoma00@gmail.com, dave.pang@kakaocorp.com

## License

DPDropDownMenu is available under the MIT license. See the LICENSE file for more info.
