import XCTest

class currenciesUITests: XCTestCase {
  static let webserviceTimeout: TimeInterval = 5.0
  static let serviceUpdateDelayWithDelta: TimeInterval = 1.1

  override func setUp() {
    continueAfterFailure = false
    XCUIApplication().launch()
  }

  func testEuroCell() {
    let app = XCUIApplication()
    let firstCell = app.tables.cells.firstMatch
    XCTAssert(firstCell.exists)
    let euroCellByCode = firstCell.staticTexts["EUR"]
    XCTAssert(euroCellByCode.exists)
    let euroCellByName = firstCell.staticTexts["Euro"]
    XCTAssert(euroCellByName.exists)
    let euroCellByFlag = firstCell.staticTexts["🇪🇺"]
    XCTAssert(euroCellByFlag.exists)
  }

  func testEuroCellWithBaseAmount() {
    let app = XCUIApplication()
    let firstCell = app.tables.cells.firstMatch
    XCTAssert(firstCell.exists)
    let textField = firstCell.textFields.firstMatch
    XCTAssert(textField.exists)
    XCTAssertEqual(textField.value as? String, "100.00")
  }

  func testUpdateRows() {
    let app = XCUIApplication()
    let secondCell = app.tables.cells.element(boundBy: 1)
    XCTAssert(secondCell.waitForExistence(timeout: currenciesUITests.webserviceTimeout))
    let textField = secondCell.textFields.firstMatch
    XCTAssert(textField.exists)
    XCTAssertNotNil(textField.value as? String)
    XCTAssertNotEqual(textField.value as? String, "0.00")
  }

  func testUpdateAutomaticallyRows() {
    let app = XCUIApplication()
    let secondCell = app.tables.cells.element(boundBy: 1)
    XCTAssert(secondCell.waitForExistence(timeout: currenciesUITests.webserviceTimeout))
    let textField = secondCell.textFields.firstMatch
    let firstValue = textField.value as? String
    XCTAssertNotNil(firstValue)
    let textFieldChangeExpectation = expectation(for: NSPredicate(format: "value != \(firstValue!)"), evaluatedWith: textField)
    wait(for: [textFieldChangeExpectation], timeout: currenciesUITests.serviceUpdateDelayWithDelta)
    XCTAssertNotEqual(firstValue, textField.value as? String)
  }
}
