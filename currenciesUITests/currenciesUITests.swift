import XCTest

class currenciesUITests: XCTestCase {
  static let webserviceTimeout: TimeInterval = 5.0
  static let serviceUpdateDelayWithDelta: TimeInterval = 1.1
  static let codeTextPredicate = NSPredicate(format: "label MATCHES '[A-Z]{3}'")

  override func setUp() {
    continueAfterFailure = true
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

  func testTapOnARowAndItShouldBeOnTopOfTheList() {
    let app = XCUIApplication()
    let firstCell = app.tables.cells.firstMatch
    let firstCellCode = firstCell.staticTexts.element(matching: currenciesUITests.codeTextPredicate).label
    let secondCell = app.tables.cells.element(boundBy: 1)
    XCTAssert(secondCell.waitForExistence(timeout: currenciesUITests.webserviceTimeout))
    let secondCellCode = secondCell.staticTexts.element(matching: currenciesUITests.codeTextPredicate).label
    XCTAssertNotEqual(firstCellCode, secondCellCode)

    secondCell.tap()
    let tappedCellCode = secondCellCode
    let newFirstCell = app.tables.cells.firstMatch
    let newFirstCellCode = newFirstCell.staticTexts.element(matching: currenciesUITests.codeTextPredicate).label
    XCTAssertEqual(newFirstCellCode, tappedCellCode)
  }

  func testTapOnARowAndAmountShouldBeEditable() {
    let app = XCUIApplication()
    let secondCell = app.tables.cells.element(boundBy: 1)
    XCTAssert(secondCell.waitForExistence(timeout: currenciesUITests.webserviceTimeout))

    let keyboard = app.keyboards.firstMatch
    XCTAssertFalse(keyboard.exists)

    secondCell.tap()
    XCTAssert(keyboard.exists)
  }

  func testChangeAmountShouldChangeOtherCellsAmount() {
    let app = XCUIApplication()
    let firstCell = app.tables.cells.firstMatch
    let secondCell = app.tables.cells.element(boundBy: 1)
    let secondCellTextField = secondCell.textFields.firstMatch
    XCTAssert(secondCell.waitForExistence(timeout: currenciesUITests.webserviceTimeout))
    let secondCellTextFieldFirstValue = secondCellTextField.value as? String

    firstCell.tap()
    let textField = firstCell.textFields.firstMatch

    textField.typeText(XCUIKeyboardKey.delete.rawValue)
    textField.typeText(XCUIKeyboardKey.delete.rawValue)
    textField.typeText(XCUIKeyboardKey.delete.rawValue)
    textField.typeText(XCUIKeyboardKey.delete.rawValue)
    textField.typeText(XCUIKeyboardKey.delete.rawValue)

    XCTAssertNotEqual(secondCellTextField.value as? String, secondCellTextFieldFirstValue)

    let firstValue = Double(secondCellTextFieldFirstValue!)!
    let secondValue = Double(secondCellTextField.value as! String)!
    let delta = 10.0

    XCTAssertNotEqual(firstValue, secondValue, accuracy: delta)
  }
}
