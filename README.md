# MesaNews

This is a sample project app using Clean + MVVM+C + RxSwift 

## Requirements

* Xcode 12 or later

* [xcodegen](https://github.com/yonaskolb/XcodeGen)
> Used to generate the `.xcodeproj` file based on a `.yml` config file and the file system

* [swiftgen](https://github.com/SwiftGen/SwiftGen)
> Used to generate strongly typed resources 

* [swiftlint](https://github.com/realm/SwiftLint) (Optional)
> Used to enforce a concise code style throughout the codebase

## Setup

In order to build and run this project you must first download and install XcodeGen and SwiftGen, you can find more information about the installation options in each Package's README.

We use XcodeGen to manage and generate the `.xcodeproj` config file using the data contained in `project.yml` and the file system.
We use SwiftGen to generate the project's resources allowing them to be used throughout the codebase in a type-safe way

1. run xcodegen in the project's root folder:
```$ xcodegen generate``` 

2. generate the static resources using:
```$ swiftgen```

3. Open the `MesaNews.xcworkspace` and wait for the dependencies download to finish. we are using the swift package manager to manage
libraries and dependencies, the setup and libraries definition is handled by the XcodeGen

4. Select the `MesaNews Dev` or `MesaNews` scheme and run-it, if you'll be testing this project on a real device you need to setup a valid 
provisioning profile
