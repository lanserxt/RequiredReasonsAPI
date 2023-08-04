# RequiredReasonsAPI
RequiredReasonsAPI - macOS application to find required iOS API usage

## Problem

iOS 17 [introduces](https://developer.apple.com/documentation/bundleresources/privacy_manifest_files/describing_use_of_required_reason_api) a set of essential "required reason" APIs, which must be defined prior to an app receiving approval for distribution in the App Store. Apple states that these APIs have the potential to be exploited for device signal access in attempts to perform device or user identification, commonly referred to as fingerprinting. Developers who employ any of the five mandated reason APIs – active keyboard, disk space, file timestamp, system boot time, and user defaults – are obligated to declare one or more valid reasons for utilizing each API and the associated data collection.

To illustrate, consider an app utilizing the file timestamp API; it must clarify the necessity for revealing file timestamps to the user, accessing timestamps of files within the app's container, or reaching timestamps of files or directories explicitly authorized by the user. Failure to meet these criteria would preclude the developer from incorporating the API into their app.

For developers legitimately leveraging these APIs, the supplementary steps should be expeditious. Nonetheless, this rule modification could result in app submission denials for those who inappropriately utilize APIs to amass user data. Apple has announced that these updated guidelines will become effective during the autumn of 2023

## Solution Approach
Get folders to check the files from the user and search for function and key strings

## Features

## Limitations

## Specification

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



