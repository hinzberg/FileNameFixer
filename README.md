#  FileNameFixer

Getting consistent file names for your own file can be a time-consuming task. 
Especially if the files are downloaded from the Internet and contain unnecessary filler words. 
Often dots are used instead of spaces or the upper and lower case are ignored. 
This program will take care of this problem and renaming files will become a breeze. 

## Features
- Remove filler words
- Replace dots with spaces
- Capitalize words
- Rearrange date to begining of filename

![Screenshot 1](https://github.com/hinzberg/FileNameFixer/blob/main/FileNameFixer/Screenshots/Screenshot%201.png)
![Screenshot 2](https://github.com/hinzberg/FileNameFixer/blob/main/FileNameFixer/Screenshots/Screenshot%202.png)

## History

### 2026-01-10
- Added option to show only files that need to be renamed

### 2025-08-18
- New cleanup option: Replace Underscores with Spaces

### 2025-06-19
- Changed custom view for to SwiftUI table

### 2025-05-04
- Introduced CalVer Versionnumber
- Fixed a bug where differences in upper and lower case were not recognised as a difference.

### 2024-12-21
- Added Contextmenu with DynamicContextMenu

### 2024-12-15
- Added Inspector with file size and quicklook

### 2024-11-15
- In the Statusbar also the number of files to be renamed will be shown

### 2024-09-16
- Changed ObservableObject to @Observable

### 2024-04-27
- Text adapted for dark mode

### 2023-11-09
- Add Prefixes and Suffixes to Filename

### 2023-11-08
- Created PrefixPanelView for Settings
- Created Suffix PanelView for Settings
- Created CleanupPanelView for Settings

### 2023-11-06
- Added translucent Sidebar

### 2023-10-21
- Added ContentUnavailableView

### 2023-10-18 
- New Settings View
- Settings Migration to SwiftData

### 2023-09-05
- Added Versionnumber to Title
- List now total width of window

### 2022-10-03
- SelectedItem Background Color

### 2022-10-02
- Destination filename red color if different from source File name, else green color
- Delete / Clear icons swaped 
- Statusbar added

### 2022-09-11
- Added Swift Package: Hinzberg-Foundation
- Added Swift Package: Hinzberg-SwiftUI

### 2022-08-30
- Repository Protocol
- FileInfoRepository as base class for ContentViewController

### 2022-08-28
- Generic TextInputView

### 2022-08-22
- Codecleanup FileInfo class

### 2022-08-20
- Remove item from list via a button in the row
- Manual edit filename via sheet view

## ToDo
- Refresh list after rename
- Manual Rename TextField not big enough for long text, no text scroll
- Add default unwanted words
