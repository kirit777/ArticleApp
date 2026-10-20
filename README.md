# ArticleApp

# Articles App

A native iOS article browsing app built with Swift, UIKit, and SwiftUI.
It fetches article data from a JSON endpoint, shows articles in grid or
list layouts, and opens a detail screen with the selected article's
title, publication date, image, and text.

## Features

-   Fetch article data from a Mocki JSON endpoint.
-   Parse JSON using SwiftyJSON and model types.
-   Make HTTP requests with Alamofire.
-   Display articles in grid and list collection-view layouts.
-   Load remote images and cache them with Kingfisher.
-   Show a placeholder when an image URL is missing or image loading
    fails.
-   Format ISO 8601 publication timestamps into readable dates such as
    `07 Mar, 2025`.
-   Embed a SwiftUI detail view inside a UIKit view controller with
    `UIHostingController`.
-   Keep the detail header (title, date, and image) visible while the
    article text scrolls.
-   Monitor network-path changes with Apple's `NWPathMonitor` and
    show/hide an offline view.
-   Use custom Roboto and Montserrat fonts, plus custom color
    extensions.
-   Use XIB-based UIKit screens and collection-view cells.

## Tech Stack

  Technology                    Purpose
  ----------------------------- -----------------------------------------------
  Swift                         Main language
  UIKit                         View controllers, navigation, collection view
  SwiftUI                       Article detail content
  `UIHostingController`         Hosts SwiftUI content in UIKit
  Alamofire                     HTTP networking
  SwiftyJSON                    JSON parsing
  Kingfisher                    Remote image loading and caching
  `Network` / `NWPathMonitor`   Network-path monitoring
  XIB / Auto Layout             UIKit layouts

## Project Structure

The structure below reflects the project organization shown during
development. Keep it updated if file names or groups change.

``` text
Articles App/
├── Model/
│   └── ArticlesModel.swift
├── Custom/
│   ├── UIColor+Custom.swift
│   └── CustomFont.swift
├── Font/
│   ├── Roboto-Bold.ttf
│   ├── Roboto-Light.ttf
│   ├── Roboto-Regular.ttf
│   ├── Roboto-Medium.ttf
│   ├── Roboto-SemiBold.ttf
│   ├── Roboto_Condensed-Black.ttf
│   ├── Montserrat-Regular.ttf
│   └── Montserrat-SemiBold.ttf
├── HomeFlow/
│   └── Home/
│       ├── HomeScreenVC.swift / .xib
│       ├── GridCVC.swift / .xib
│       ├── ListCVC.swift / .xib
│       └── DetailScreen/
│           ├── DetailScreenVC.swift
│           └── ArticleDetailView.swift
├── SplashScreen/
│   └── SplashScreenVC.swift / .xib
├── Assets.xcassets/
├── AppDelegate.swift
└── SceneDelegate.swift
```

## API

The current development endpoint is:

``` text
https://mocki.io/v1/9f09ed09-d8ca-48c7-9957-dec39e745321
```

The response has a NewsAPI-like structure with `status`, `totalResults`,
and `articles`. Each article can include `source`, `author`, `title`,
`description`, `url`, `urlToImage`, `publishedAt`, and `content`. Some
fields may be `null` or missing, so optional values should be handled
safely.

### Data flow

1.  `HomeScreenVC` calls `getArticles()`.
2.  Alamofire requests the endpoint.
3.  SwiftyJSON parses the returned JSON.
4.  `ArticlesResponse`, `Article`, and `ArticleSource` represent the
    parsed data.
5.  The article array is assigned to `HomeScreenVC.articles`.
6.  The collection view reloads and configures either `GridCVC` or
    `ListCVC`.
7.  Selecting an item passes its `Article` model to `DetailScreenVC`.
8.  `DetailScreenVC` embeds `ArticleDetailView` using
    `UIHostingController`.

## Grid and List Layouts

The home screen uses a single collection view (`cvList`) and an `isGrid`
state to choose the layout:

-   Grid mode uses `GridCVC`.
-   List mode uses `ListCVC`.
-   `imgListType` shows the layout-toggle icon.
-   Both cell XIBs should be registered with their matching reuse
    identifiers.
-   Change the layout and reload the collection view when switching
    modes. Register the XIBs during setup, not on every toggle.

The same article model powers both layouts; switching layout should not
require another API request.

## Article Detail Screen

The detail experience combines UIKit navigation with SwiftUI:

-   `DetailScreenVC` receives the selected `Article`.
-   `UIHostingController` embeds `ArticleDetailView` inside the
    controller's container view.
-   The SwiftUI view shows the article title, date/time, remote image,
    and article content (falling back to the description when content is
    absent).
-   The title/date/image header sits outside the `ScrollView`, so it
    remains visible while the article text scrolls.
-   Set the hosting controller's view and SwiftUI outer backgrounds to
    clear when the UIKit background must remain visible behind SwiftUI.

## Images

Kingfisher loads images from `urlToImage` and caches them. A local asset
named `placeholder` is expected when the URL is missing or loading
fails.

To configure the placeholder:

1.  Open `Assets.xcassets`.
2.  Add an Image Set named `placeholder`.
3.  Add the desired fallback image and ensure the asset name matches
    exactly.

## Date Formatting

The API returns ISO 8601 timestamps, for example:

``` text
2025-03-07T10:00:01Z
```

For article cards, the target display format is:

``` text
07 Mar, 2025
```

Parse with `ISO8601DateFormatter` and format with `DateFormatter` using
`dd MMM, yyyy`. For relative text such as `10h ago`, use
`RelativeDateTimeFormatter` rather than displaying a fixed string.

## Network Availability

`HomeScreenVC` can use `NWPathMonitor` from Apple's `Network` framework:

-   Show `viewOffline` when the network path is unavailable.
-   Hide `viewOffline` when the path becomes available.
-   Optionally retry `getArticles()` when connectivity returns.

`NWPathMonitor` reports network-path status, not guaranteed access to
the API server. Keep handling request failures in `getArticles()`
because Wi-Fi may be connected while the server or internet route is
unavailable.

## Navigation

The app uses a `UINavigationController` to push from the home screen to
the detail screen. The splash screen can be the initial root and then be
replaced by the home screen in the navigation stack.

When opening a detail screen:

-   Instantiate it using the mechanism appropriate to its actual source
    (XIB or storyboard).
-   Pass the selected `Article` model before pushing.
-   Confirm `HomeScreenVC` is embedded in a navigation controller;
    otherwise `navigationController` is `nil` and optional-chained
    pushes do nothing.

The navigation bar can be hidden on the home screen and configured
separately for the detail screen.

## Custom Fonts and Colors

The project includes Roboto and Montserrat font files. Make sure every
font file belongs to the app target and is registered in `UIAppFonts`.
The names used in `UIFont` and SwiftUI `Font` extensions must match the
fonts' PostScript names.

Color extensions provide reusable UIKit `UIColor` and SwiftUI `Color`
values, including named colors such as `Color.Color969696` and hex
colors such as `Color.hex("2F515B")`.

## Setup

1.  Open the project in Xcode.
2.  Resolve the Swift Package Manager dependencies:
    -   Alamofire
    -   SwiftyJSON
    -   Kingfisher
3.  Verify the Mocki endpoint returns the expected JSON.
4.  Confirm the `placeholder` image exists in `Assets.xcassets`.
5.  Check XIB target membership, custom classes, outlets, and reuse
    identifiers.
6.  Confirm fonts are registered and included in the app target.
7.  Build and run on an iOS simulator or device.

## Troubleshooting

### Articles are not loading

-   Check the Alamofire error in the Xcode console.
-   Verify the endpoint and JSON keys.
-   Ensure UI updates and collection-view reloads happen on the main
    thread.

### Images are missing

-   Check that `urlToImage` is a valid URL.
-   Confirm Kingfisher is linked to the app target.
-   Verify the `placeholder` asset name.

### Detail screen does not open

-   Check `navigationController` is not `nil`.
-   Verify the detail controller is instantiated using the correct
    XIB/storyboard setup.
-   Confirm the selected `Article` is assigned before pushing.

### Offline view does not update

-   Ensure `NWPathMonitor` is started and its callback updates UIKit on
    the main queue.
-   Do not repeatedly call `setupCollectionView()` to refresh data; call
    `getArticles()` and reload the collection view instead.
-   Remember that network-path availability does not guarantee API
    availability.

### Custom fonts are not applied

-   Verify font target membership and `UIAppFonts`.
-   Print registered font names at runtime and compare them with the
    names used by the extensions.

## Scope Notes

This project currently focuses on fetching and browsing article data and
showing a detail view. Opening the original article URL in a browser,
bookmarks, and search should be documented as features only if they are
implemented in the project.

The Mocki endpoint is a development/mock data source and may change or
become unavailable.

## License

Add a license section if you plan to distribute this project publicly.
