//
//  RelaxOnUITests.swift
//  RelaxOnUITests
//
//  Created by Moon Jongseek on 2022/08/11.
//

import XCTest

class RelaxOnUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMakeCDTest() throws {
        let app = XCUIApplication()
        app.launch()
        let nameTextField = app
            .children(matching: .window).element(boundBy: 0)
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .other).element
            .children(matching: .textField).element
        if nameTextField.exists {
            nameTextField.tap()
            nameTextField.typeText("NickName")
            app.buttons["Start"].tap()
        }
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.buttons["추가"].tap()
        elementsQuery.images["LongSun"].tap()
        app.staticTexts["MELODY"].tap()
        elementsQuery.images["Ambient"].swipeUp()
        elementsQuery.images["Relaxing"].tap()
        app.staticTexts["NATURAL"].tap()
        elementsQuery.images["DryGrass"].swipeUp()
        elementsQuery.images["Wave"].tap()
        
        let navigationBarsQuery = app.navigationBars
        navigationBarsQuery.buttons["Mix"].tap()
        let titleTextField = app.textFields["Enter title"]
        titleTextField.tap()
        titleTextField.typeText("Test CD")
        app.buttons["Save"].tap()
        navigationBarsQuery.buttons["뒤로"].tap()
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
