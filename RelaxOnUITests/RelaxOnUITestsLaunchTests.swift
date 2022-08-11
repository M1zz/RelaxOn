//
//  RelaxOnUITestsLaunchTests.swift
//  RelaxOnUITests
//
//  Created by Moon Jongseek on 2022/07/31.
//

import XCTest

class RelaxOnUITestsLaunchTests: XCTestCase {

    // Device Orientation, Appearence Mode에 따라 Launch Test 진행
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        false
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

//        let attachment = XCTAttachment(screenshot: app.screenshot())
//        attachment.name = "Launch Screen"
//        attachment.lifetime = .keepAlways
//        add(attachment)
    }
}
