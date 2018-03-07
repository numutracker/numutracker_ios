# Numu Tracker for iOS

This is the iOS app for accessing Numu Tracker.

As this was my first iOS app ever, please be gentle when viewing code repetition or strange architecture choices (like how there's SearchClient and JSONClient when really there should just be one client handling the duties split between them).

App is on the App Store: https://itunes.apple.com/us/app/numu-new-music-tracker/id1158641228

Built fairly slowly between October 2016 and September 2017.

# To Install

1. `git clone https://github.com/amiantos/numutracker_ios.git`
2. `pod install` (requires [CocoaPods](https://cocoapods.org))
3. Open `Numu Tracker.xcworkspace` in Xcode 8.0 or higher.
4. AppDelegate.swift has some Pusher API keys you should implement.
5. You'll need to modify the Info.plist to include a Crashlytics API key if you want it.