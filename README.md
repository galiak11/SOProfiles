# SOProfiles
StackOverflow Profiles demo app

## Description

An iOS app that fetches profiles from the [Stack Overflow Users API](https://api.stackexchange.com/2.2/users?site=stackoverflow), downloads their profile images, and uses on-device face detection to determine if those images contain a face.

<img src="Resources/SOProfilesScreenshot.png" alt="SOProfiles App Screenshot" width="200">

## Build tools

XCode Version 16.1 (16B40)

## Steps to run the app

To run the app, open the project in XCode, select a target device, and hit "Run".

## Third-party libraries

KingFisher (https://github.com/onevcat/Kingfisher) is a pure-Swift library for downloading and caching images.
Reason for using: Easy to use and saves time implementing image-downloading and caching logic. Caching images improves scrolling performance.

## Potential improvements

Given more time, the following potential improvements would be implemented:
- In-memory caching of face observations to improve face-detection performance and to reduce CPU/GPU resources.
- Prefetching users and images to improve scrolling performance.
- Additional unit & functional tests.
- Search/filter options to make the UI more usable.
- Etc.
