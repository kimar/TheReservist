# TheReservist

![Icon-120](Assets/Icon-120.png)

This App let's you take a peek into the current Apple reservation states of your local Apple Store.

The Country / Locale determining your Stores is taken from your Device's current locale.

This App is written in `Swift` and uses `Alamofire` for Networking as well as `PKHUD` for loading indicators / activity views.

Those libraries are added via `git submodules` as of the time of writing this, there is no possibility to use `CocoaPods` using `Swift`.

Install using:
```
git submodule update --init --recursive
```

Then just open up `TheReservist.xcodeproj` and build it. 😉

Licenses goes here: [LICENSE.md](LICENSE.md)