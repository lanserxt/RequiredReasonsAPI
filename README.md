# RequiredReasonsAPI
RequiredReasonsAPI - macOS application to find required iOS API usage

## Problem

iOS 17 [introduces](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api) a set of essential "required reason" APIs, which must be defined prior to an app receiving approval for distribution in the App Store. Apple states that these APIs have the potential to be exploited for device signal access in attempts to perform device or user identification, commonly referred to as fingerprinting. Developers who employ any of the five mandated reason APIs – active keyboard, disk space, file timestamp, system boot time, and user defaults – are obligated to declare one or more valid reasons for utilizing each API and the associated data collection.

To illustrate, consider an app utilizing the file timestamp API; it must clarify the necessity for revealing file timestamps to the user, accessing timestamps of files within the app's container, or reaching timestamps of files or directories explicitly authorized by the user. Failure to meet these criteria would preclude the developer from incorporating the API into their app.

For developers legitimately leveraging these APIs, the supplementary steps should be expeditious. Nonetheless, this rule modification could result in app submission denials for those who inappropriately utilize APIs to amass user data. Apple has announced that these updated guidelines will become effective during the autumn of 2023

## Solution Approach
Get folders to check the files from the user and search for function and key strings

## Features
* **Plain macOS App:** The iOS App API Reason Checker is designed as a straightforward macOS application, making it easy to clone and use without any complex setup.
* **Draggable Folders to Scan:** Users can simply drag and drop folders containing iOS applications onto the app interface, initiating a thorough analysis of the "required reason" APIs within the apps.
* **Easy List Management:** The tool provides a user-friendly list management interface, allowing users to track and organize the iOS applications that have been scanned or are scheduled for analysis.
* **API Info:** Gain insights into the specific "required reason" APIs being utilized by each app, helping you understand their intended usage and ensure compliance with Apple's regulations.
* **File Detection and Opening:** Detected files with API usage are conveniently marked within the app interface. Users can seamlessly open these files directly in Finder or Xcode for further examination and adjustments.
* **Sample manifest generation:** Detected APIs wrapped in dictionaries for privacy manifest file. Users can easily copy-past this code and adjust.
## Limitations
For not it's just a basic search of specific functions and keys by string compare. So if you would have realm file like this:

```
import RealmSwift

class MyRealmObject: Object {
     @Persisted var id = UUID().uuidString
     @Persisted var name = ""
     @Persisted var modificationDate = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
```

@Persisted var **modificationDate** = Date() will be marked as **File timestamp APIs**

## Specification
- Swift 5
- async/await
- Plain SwiftUI
- No dependencies
- \>=macOS 12

## How to Use
* **Installation:** Clone this repository and run the code in Xcode
* **Scanning Apps:** Drag and drop folders containing iOS applications onto the app window to initiate the scanning process. The tool will automatically analyze the "required reason" APIs within the apps.
* **List Management:** Use the built-in list management features to keep track of scanned apps, upcoming scans, and any necessary actions.
* **API Insights:** Review the API information provided for each app to ensure proper and transparent API usage.
* **Opening Files:** Easily access files detected with API usage by clicking on them. Open these files directly in Finder or Xcode to make necessary adjustments.



## Screenshot
![DemoScreen](DemoScreen.png?raw=true "Optional title")

## Credentials

<div id="badges">
  <a href="https://www.linkedin.com/in/antongubarenko">
    <img src="https://img.shields.io/badge/LinkedIn-blue?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn Badge"/>
  </a>
  <a href="https://twitter.com/AntonGubarenko">
    <img src="https://img.shields.io/badge/Twitter-blue?style=for-the-badge&logo=twitter&logoColor=white" alt="Twitter Badge"/>
  </a>
</div>

Note: The Required reason API Finder is not affiliated with or endorsed by Apple Inc. It is an independent project created by developers for developers.


