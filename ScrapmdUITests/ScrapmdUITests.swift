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

    func testActionExtension() throws {
        let app = XCUIApplication()
        app.launch()

        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
        safari.launch()
        setupSnapshot(safari)
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
        safari.buttons["Close"].tap()

        doScrap(safari)

        // swiftlint:disable:next line_length
        goToURL(safari, url: "https://www.sfgate.com/realestate/article/Will-Working-From-Home-Spell-Doom-for-the-Open-15329361.php")
        sleep(5)
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
    }

    func testApp() {
        let app = XCUIApplication()
        app.launch()
        setupSnapshot(app)
        app.activate()
        snapshot("0-home")
        app.cells.firstMatch.tap()
        snapshot("1-read")
    }

    func testDarkApp() {
        let app = XCUIApplication()
        app.launchArguments = ["UITestingDarkModeEnabled"]
        app.launch()
        setupSnapshot(app)
        app.activate()
        snapshot("4-home-dark")
        app.cells.firstMatch.tap()
        snapshot("5-read-dark")
    }

    func goToURL(_ safari: XCUIApplication, url: String) {
        let addressBar = safari.otherElements["TopBrowserBar"]
        addressBar.tap()
        if safari.buttons["Continue"].exists {
            safari.buttons["Continue"].tap()
        }
        addressBar.tap()
        addressBar.typeText(url)
        safari.buttons["Go"].tap()
    }

    func doScrap(_ safari: XCUIApplication, takeSnapshot: Bool = false) {
        safari.buttons["ShareButton"].tap()
        if takeSnapshot {
            snapshot("2-share")
        }
        safari.cells.firstMatch.tap()
        if takeSnapshot {
            snapshot("3-save")
        }
        _ = safari.buttons["Save"].waitForExistence(timeout: 50000)
        safari.buttons["Save"].tap()
        _ = safari.buttons["View Scrap"].waitForExistence(timeout: 5000)
        safari.buttons["Done"].tap()
    }
}
