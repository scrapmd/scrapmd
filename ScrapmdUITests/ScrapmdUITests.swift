//
//  ScrapmdUITests.swift
//  ScrapmdUITests
//
//  Created by Atsushi Nagase on 2020/06/04.
//  Copyright © 2020 LittleApps Inc. All rights reserved.
//

import XCTest

class ScrapmdUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func test01Launch() throws {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        if !app.otherElements["DirectoryBrowser"].exists {
            XCUIDevice.shared.orientation = .landscapeLeft
        }
        app.terminate()
    }

    func test02ActionExtension() throws {
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
//        setupSnapshot(safari)
        safari.launch()
        goToURL(safari, url: "https://yourbasic.org/golang/format-parse-string-time-date-example/")

        safari.buttons["ShareButton"].tap()
        safari.buttons["Edit Actions…"].tap()
        if safari.buttons["Delete Copy"].exists {
            safari.buttons["Delete Copy"].tap()
            safari.buttons["Remove"].tap()
        }
        if safari.buttons["Insert Activity"].exists {
            safari.buttons["Insert Activity"].tap()
        }
        safari.buttons["Done"].tap()
        if safari.buttons["Close"].exists {
            safari.buttons["Close"].tap()
        } else if safari.otherElements["PopoverDismissRegion"].exists {
            safari.otherElements["PopoverDismissRegion"].tap()
        }

        doScrap(safari)

        // swiftlint:disable:next line_length
        goToURL(safari, url: "https://www.sfgate.com/realestate/article/Will-Working-From-Home-Spell-Doom-for-the-Open-15329361.php")
        sleep(10)
        doScrap(safari)

        goToURL(safari, url: "https://hackaday.io/project/171790-armawatch-armachat-long-range-radio-messengers")
        sleep(5)
        doScrap(safari)

        goToURL(safari, url: "https://www.flyfishfood.com/2019/08/project-hopper-version-20.html")
        sleep(5)
        doScrap(safari)

        goToURL(safari, url: "https://en.wikipedia.org/wiki/Fly_fishing")
        sleep(5)
        doScrap(safari, takeSnapshot: true)

        safari.terminate()
    }

    func test03App() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        snapshot("0-home")
        app.cells.firstMatch.tap()
        snapshot("1-read")
        app.terminate()
    }

    func test04DarkApp() {
        let app = XCUIApplication()
        app.launchArguments = ["UITestingDarkModeEnabled"]
        setupSnapshot(app)
        app.launch()
        snapshot("4-home-dark")
        app.cells.firstMatch.tap()
        snapshot("5-read-dark")
        app.terminate()
    }

    func goToURL(_ safari: XCUIApplication, url: String) {
        let addressBar = safari.otherElements["TopBrowserBar"]
        addressBar.tap()
        if safari.buttons["Continue"].exists && safari.buttons["Continue"].isHittable {
            safari.buttons["Continue"].tap()
        }
        addressBar.tap()
        addressBar.typeText(url)
        safari.keyboards.buttons["Go"].tap()
    }

    func doScrap(_ safari: XCUIApplication, takeSnapshot: Bool = false) {
        safari.buttons["ShareButton"].tap()
        if takeSnapshot {
            snapshot("2-share", waitForLoadingIndicator: false)
        }
        safari.cells.firstMatch.tap()
        if !safari.buttons["Save"].waitForExistence(timeout: 5000) {
            fatalError()
        }
        if takeSnapshot {
            snapshot("3-save", waitForLoadingIndicator: false)
        }
        safari.buttons["Save"].tap()
        _ = safari.buttons["View Scrap"].waitForExistence(timeout: 5000)
        safari.buttons["Done"].tap()
    }
}
