import XCTest

class currenciesUITests: XCTestCase {
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
}
