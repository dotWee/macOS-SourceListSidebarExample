# macOS-SourceListSidebarExample

Example Swift 4.2 implementation of the [Sidebar Use Case](https://developer.apple.com/design/human-interface-guidelines/macos/windows-and-views/sidebars/) using [NSOutlineView](https://developer.apple.com/documentation/appkit/nsoutlineview) with CoreData, RxSwift and the whole layout aligned at Apple's Human Interface Guidelines.

## Used Technologies / References

- Written on the Swift 4.2 language level platform
- [CoreData](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/index.html) to preserve data between application sessions
- [RxSwift](https://github.com/ReactiveX/RxSwift) (*5.1.1*) with [RxCocoa](https://github.com/ReactiveX/RxSwift/tree/master/RxCocoa) (*5.1.1*) to handle interactions
- [Swift Package Manager](https://swift.org/package-manager/) as dependency manager
- Apple's [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos/overview/visual-index/) for the macOS platform

## Screenshots

<table>
<tr>
<th>Main Window</th>
<th>With Add Account Sheet</th>
</tr>

<tr>
<td><img src="Art/ScreenshotMain.png"/></td>
<td><img src="Art/ScreenshotAdd.png"/></td>
</tr>
</table>

<table>
<tr>
<th>Screencapture</th>
</tr>
<tr>
<td><img src="Art/Screencapture.gif"/></td>
</tr>
</table>

## Execution

Clone repository:

```bash
$ git clone https://github.com/dotWee/macOS-SourceListSidebarExample.git
$ cd macOS-SourceListSidebarExample
```

Open the Xcode project:

```bash
$ open SourceListSidebarExample.xcodeproj
```

## License

    MIT License

    Copyright (c) 2019 Lukas (dotWee) Wolfsteiner

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.