# Animated Notch Bottom Bar
<a href="https://pub.dev/packages/animated_notch_bottom_bar"><img src="https://img.shields.io/pub/v/animated_notch_bottom_bar.svg?label=animated_notch_bottom_bar" alt="animated_notch_bottom_bar version"></a>
<a href="https://flutter.dev/"><img src="https://img.shields.io/badge/flutter-website-deepskyblue.svg" alt="Flutter Website"></a>
<a href="https://dart.dev"><img src="https://img.shields.io/badge/dart-website-deepskyblue.svg" alt="Dart Website"></a>
<a href="https://developer.android.com" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-android-blue">
</a>
<a href="https://developer.apple.com/ios/" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-iOS-blue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Web-deepskyblue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Mac-deepskyblue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Linux-deepskyblue">
</a>
<a href="" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/badge/platform-Windows-deepskyblue">
</a>
<a href=""><img src="https://app.codacy.com/project/badge/Grade/dc683c9cc61b499fa7cdbf54e4d9ff35"/></a>
<a href="https://github.com/Mindinventory/animated_notch_bottom_bar/blob/main/LICENSE" style="pointer-events: stroke;" target="_blank">
<img src="https://img.shields.io/github/license/Mindinventory/animated_notch_bottom_bar"></a>
<a href="https://pub.dev/packages/animated_notch_bottom_bar"></a>
<a href="https://github.com/Mindinventory/animated_notch_bottom_bar"><img src="https://img.shields.io/github/stars/Mindinventory/animated_notch_bottom_bar?style=social" alt="MIT License"></a>

A Flutter package for animating the position of selected item in bottomNavigationBar with notch like design. Inspired by [react-native-tabbar-interaction](https://github.com/Mindinventory/react-native-tabbar-interaction) plugin.

## Features :
* Supports any widget as as a bottom bar children.
* Animates the notch toward selected item.
* Create an optimized bottom navigation bar with beautiful animation.
* Supports blur effect like iOS Tab View.

<img src="https://cdn.dribbble.com/users/1233499/screenshots/4844696/preview.gif" > 

## Getting Started

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  ...
  animated_notch_bottom_bar: ^1.0.0
```
## Basic Usage

Place `AnimatedNotchBottomBar` in the bottomNavigationBar parameter of a `Scaffold` widget and provide `NotchBottomBarController` to `AnimatedNotchBottomBar`.

```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
  notchBottomBarController: _controller,
  ...
)
```

##### Use any `Widget` as bottom bar item

You can also set any animated widget.
```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
  pageController: _pageController,
  bottomBarItems: [
    const BottomBarItem(
        inActiveItem: Icon(
           Icons.home_filled,
            color: Colors.blueGrey,
        ),
        activeItem: Icon(
          Icons.home_filled,
          color: Colors.blueAccent,
        ),
        itemLabel: 'Page 1',
  ),
    const BottomBarItem(
        inActiveItem: Icon(
            Icons.star,
            color: Colors.blueGrey,
          ),
        activeItem: Icon(
            Icons.star,
            color: Colors.blueAccent,
        ),
        itemLabel: 'Page 2',
  ),

     ///svg item
    BottomBarItem(
        inActiveItem: SvgPicture.asset(
          'assets/search_icon.svg',
           color: Colors.blueGrey,
       ),
       activeItem: SvgPicture.asset(
          'assets/search_icon.svg',
           color: Colors.black,
       ),
       itemLabel: 'Page 3',
    ),
     ...
)
```
##### Remove margins

```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
     ...
     removeMargins: true,     
     ...
)
```

##### Set bottom bar width and height

```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
     ...
     bottomBarWidth: 500.0,     
     bottomBarHeight: 62.0,     
     ...
)
```

##### Add animation duration

```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
     ...
     durationInMilliSeconds: 300,     
     ...
)
```

##### Show/hide item label and style

```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
     ...
     showLabel: true,
     itemLabelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0
                    ),
     ...
)
```

##### Set Notch's color

```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
     ...
      notchColor: Colors.black87,     
     ...
)
```

##### Set Notch's gradient

```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
     ...
     notchGradient: const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.red,
          Colors.green,
        ],
     ),     
     ...
)
```

##### Hide top and bottom corner radius

```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
     ...
     showBottomRadius = false,
     showTopRadius = false,
     ...
)
```

##### Customize elevation

```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
     ...
     elevation = 2.0,
     ...
)
```

##### Customized Blur Effect (iOS Tab View)

```dart
bottomNavigationBar:  AnimatedNotchBottomBar(
    ...
    showBlurBottomBar: true,
    blurOpacity: 0.2,
    blurFilterX: 5.0,
    blurFilterY: 10.0,
    ...
)
```

### Migrating to 1.0.0+

Starting with version `1.0.0` of the package, `NotchBottomBarController` have been added for control the animation instead of `PageController`. The `pageController` field has been removed and `notchBottomBarController` is required now.

### AnimatedNotchBottomBar
- `notchBottomBarController` - The controller which allows you to control the page.
- `bottomBarItems` - Navigation items, required more than one item and less than six.
- `onTap` - Required to listen when an item is tapped it provides the selected item's index.
- `color` - The bottom bar's background color.
- `removeMargins` - To remove side and bottom margins by default it's false.
- `bottomBarWidth` - To provide width for web and desktop app.
- `durationInMilliSeconds` - To set duration time in MilliSeconds.
- `showLabel`: To show or hide the label under bottom bar item.
- `itemLabelStyle` - The bottom bar's item text style.
- `showShadow` - If false the bottom bar's elevation will be removed.
- `showBlurBottomBar` - If true the bottom bar will look blur.
- `blurOpacity` - To set opacity of blur effect.
- `blurFilterX` - Creates an image filter that applies a Gaussian blur at x axis.
- `blurFilterY` - Creates an image filter that applies a Gaussian blur at y axis.
- `notchColor` - Customizable notch's color.
- `notchGradient` - Add Gradient to notch.
- `showTopRadius` - If set false the top corner radius will be removed.
- `showBottomRadius` - If set false the top corner radius will be removed.
- `elevation` - Set elevation of bottom bar.
- `bottomBarHeight` - To set height of bottom bar.

### BottomBarItems
- `title` - the bottom bar item label
- `activeItem` - the selected item.
- `inActiveItem` - the inactive item.

## Guideline for contributors
Contribution towards our repository is always welcome, we request contributors to create a pull request to the main branch only.

# LICENSE!
Animated Notch Bottom Bar is [MIT-licensed](https://github.com/Mindinventory/animated_notch_bottom_bar/blob/main/LICENSE "MIT-licensed").

# Let us know!
We’d be really happy if you send us links to your projects where you use our component. Just send an email to sales@mindinventory.com and do let us know if you have any questions or suggestion regarding our work.

