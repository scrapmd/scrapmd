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
        let domain = locale == "ja" ? "ja.ngs.io" : "ngs.io"
        let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
//        setupSnapshot(safari)
        safari.launch()
        goToURL(safari, url: "https://\(domain)/2019/02/08/go-release-action/")

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

        goToURL(safari, url: "https://\(domain)/2020/05/15/ci2go-maccatalyst/")
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
