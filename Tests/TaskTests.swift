//
//  Tests.swift
//  Tests
//
//  Created by Danila Belyi on 15.06.2023.
//

@testable import To_Do_List
import XCTest

final class TaskTests: XCTestCase {
  func testJsonParsing() {
    let id = "123"
    let text = "Buy groceries"
    let createdAt = Date()
    let deadline = Date().addingTimeInterval(3600)
    let changedAt = Date().addingTimeInterval(7200)
    let importance = Importance.important
    let isDone = false

    let item = Task(
      id: id,
      text: text,
      createdAt: createdAt,
      deadline: deadline,
      changedAt: changedAt,
      importance: importance,
      isDone: isDone
    )

    let parsedItem = Task.parse(json: item.json)

    XCTAssertEqual(parsedItem!.id, id)
    XCTAssertEqual(parsedItem!.text, text)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), Int(createdAt.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.deadline!.timeIntervalSince1970), Int(deadline.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.changedAt!.timeIntervalSince1970), Int(changedAt.timeIntervalSince1970))
    XCTAssertEqual(parsedItem!.importance, importance)
    XCTAssertEqual(parsedItem!.isDone, isDone)
  }

  func testJsonParsingFromDictionary() {
    let json: [String: Any] = [
      "id": "123",
      "text": "Buy groceries",
      "createdAt": Int(Date().timeIntervalSince1970),
      "deadline": Int(Date().addingTimeInterval(3600).timeIntervalSince1970),
      "changedAt": Int(Date().addingTimeInterval(7200).timeIntervalSince1970),
      "importance": "low",
      "isDone": false
    ]

    let parsedItem = Task.parse(json: json)

    XCTAssertEqual(parsedItem!.id, json["id"] as String)
    XCTAssertEqual(parsedItem!.text, json["text"] as String)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), json["createdAt"] as Int)
    XCTAssertEqual(Int(parsedItem!.deadline!.timeIntervalSince1970), json["deadline"] as Int)
    XCTAssertEqual(Int(parsedItem!.changedAt!.timeIntervalSince1970), json["changedAt"] as Int)
    XCTAssertEqual(parsedItem!.importance, Importance(rawValue: json["importance"] as String))
    XCTAssertEqual(parsedItem!.isDone, json["isDone"] as Bool)
  }

  func testJsonParsingWithoutID() {
    let text = "Buy groceries"
    let createdAt = Date()
    let deadline = Date().addingTimeInterval(3600)
    let changedAt = Date().addingTimeInterval(7200)
    let importance = Importance.important
    let isDone = false

    let item = Task(
      text: text,
      createdAt: createdAt,
      deadline: deadline,
      changedAt: changedAt,
      importance: importance,
      isDone: isDone
    )

    let parsedItem = Task.parse(json: item.json)

    XCTAssertEqual(parsedItem!.text, text)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), Int(createdAt.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.deadline!.timeIntervalSince1970), Int(deadline.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.changedAt!.timeIntervalSince1970), Int(changedAt.timeIntervalSince1970))
    XCTAssertEqual(parsedItem!.importance, importance)
    XCTAssertEqual(parsedItem!.isDone, isDone)
  }

  func testJsonParsingWithNormalImportance() {
    let id = "456"
    let text = "Buy groceries"
    let createdAt = Date()
    let deadline = Date().addingTimeInterval(3600)
    let changedAt = Date().addingTimeInterval(7200)
    let importance = Importance.normal
    let isDone = false

    let item = Task(
      id: id,
      text: text,
      createdAt: createdAt,
      deadline: deadline,
      changedAt: changedAt,
      importance: importance,
      isDone: isDone
    )

    let parsedItem = Task.parse(json: item.json)

    XCTAssertEqual(parsedItem!.id, id)
    XCTAssertEqual(parsedItem!.text, text)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), Int(createdAt.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.deadline!.timeIntervalSince1970), Int(deadline.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.changedAt!.timeIntervalSince1970), Int(changedAt.timeIntervalSince1970))
    XCTAssertEqual(parsedItem!.importance, importance)
    XCTAssertEqual(parsedItem!.isDone, isDone)
  }

  func testJsonParsingWithoutDeadline() {
    let id = "456"
    let text = "Buy groceries"
    let createdAt = Date()
    let changedAt = Date().addingTimeInterval(7200)
    let importance = Importance.normal
    let isDone = false

    let item = Task(
      id: id,
      text: text,
      createdAt: createdAt,
      changedAt: changedAt,
      importance: importance,
      isDone: isDone
    )

    let parsedItem = Task.parse(json: item.json)

    XCTAssertEqual(parsedItem!.id, id)
    XCTAssertEqual(parsedItem!.text, text)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), Int(createdAt.timeIntervalSince1970))
    XCTAssertNil(parsedItem!.deadline)
    XCTAssertEqual(Int(parsedItem!.changedAt!.timeIntervalSince1970), Int(changedAt.timeIntervalSince1970))
    XCTAssertEqual(parsedItem!.importance, importance)
    XCTAssertEqual(parsedItem!.isDone, isDone)
  }

  func testJsonParsingWithMissingValues() {
    let json: [String: Any] = [
      "id": "123",
      "text": "Buy groceries",
      "createdAt": Int(Date().timeIntervalSince1970)
    ]

    let parsedItem = Task.parse(json: json)

    XCTAssertNil(parsedItem)
  }

  func testJsonParsingWithMissingNonImportantValues() {
    let text = "Buy groceries"
    let createdAt = Date()
    let importance = Importance.normal
    let isDone = false

    let item = Task(text: text, createdAt: createdAt, importance: importance, isDone: isDone)

    let parsedItem = Task.parse(json: item.json)

    XCTAssertNotNil(parsedItem!.id)
    XCTAssertEqual(parsedItem!.text, text)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), Int(createdAt.timeIntervalSince1970))
    XCTAssertNil(parsedItem!.deadline)
    XCTAssertNil(parsedItem!.changedAt)
    XCTAssertEqual(parsedItem!.importance, importance)
    XCTAssertEqual(parsedItem!.isDone, isDone)
  }

  func testJsonParsingWithInvalidValues() {
    let json: [String: Any] = [
      "id": 123,
      "text": 456,
      "createdAt": "not a timestamp",
      "importance": "invalid importance",
      "isDone": "not a boolean"
    ]

    let parsedItem = Task.parse(json: json)

    XCTAssertNil(parsedItem)
  }

  func testJsonParsingWithInvalidImportance() {
    let json: [String: Any] = [
      "id": "4316785",
      "text": "Buy groceries",
      "createdAt": Int(Date().timeIntervalSince1970),
      "importance": "what??",
      "isDone": false
    ]

    let parsedItem = Task.parse(json: json)

    XCTAssertNil(parsedItem)
  }

  func testCSVParsing() {
    let id = "123"
    let text = "Buy groceries"
    let createdAt = Date()
    let deadline = Date().addingTimeInterval(3600)
    let changedAt = Date().addingTimeInterval(7200)
    let importance = Importance.important
    let isDone = false

    let item = Task(
      id: id,
      text: text,
      createdAt: createdAt,
      deadline: deadline,
      changedAt: changedAt,
      importance: importance,
      isDone: isDone
    )

    let parsedItem = Task.parse(csv: item.csv)

    XCTAssertEqual(parsedItem!.id, id)
    XCTAssertEqual(parsedItem!.text, text)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), Int(createdAt.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.deadline!.timeIntervalSince1970), Int(deadline.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.changedAt!.timeIntervalSince1970), Int(changedAt.timeIntervalSince1970))
    XCTAssertEqual(parsedItem!.importance, importance)
    XCTAssertEqual(parsedItem!.isDone, isDone)
  }

  func testCSVParsingFromString() {
    let csv = "123;Buy groceries;1686837637;1686841237;1686844837;important;false"

    let parsedItem = Task.parse(csv: csv)

    XCTAssertEqual(parsedItem!.id, "123")
    XCTAssertEqual(parsedItem!.text, "Buy groceries")
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), 1_686_837_637)
    XCTAssertEqual(Int(parsedItem!.deadline!.timeIntervalSince1970), 1_686_841_237)
    XCTAssertEqual(Int(parsedItem!.changedAt!.timeIntervalSince1970), 1_686_844_837)
    XCTAssertEqual(parsedItem!.importance, Importance.important)
    XCTAssertEqual(parsedItem!.isDone, false)
  }

  func testCSVParsingWithoutID() {
    let text = "Buy groceries"
    let createdAt = Date()
    let deadline = Date().addingTimeInterval(3600)
    let changedAt = Date().addingTimeInterval(7200)
    let importance = Importance.important
    let isDone = false

    let item = Task(
      text: text,
      createdAt: createdAt,
      deadline: deadline,
      changedAt: changedAt,
      importance: importance,
      isDone: isDone
    )

    let parsedItem = Task.parse(csv: item.csv)

    XCTAssertEqual(parsedItem!.text, text)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), Int(createdAt.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.deadline!.timeIntervalSince1970), Int(deadline.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.changedAt!.timeIntervalSince1970), Int(changedAt.timeIntervalSince1970))
    XCTAssertEqual(parsedItem!.importance, importance)
    XCTAssertEqual(parsedItem!.isDone, isDone)
  }

  func testCSVParsingWithNormalImportance() {
    let id = "456"
    let text = "Buy groceries"
    let createdAt = Date()
    let deadline = Date().addingTimeInterval(3600)
    let changedAt = Date().addingTimeInterval(7200)
    let importance = Importance.normal
    let isDone = false

    let item = Task(
      id: id,
      text: text,
      createdAt: createdAt,
      deadline: deadline,
      changedAt: changedAt,
      importance: importance,
      isDone: isDone
    )

    let parsedItem = Task.parse(csv: item.csv)

    XCTAssertEqual(parsedItem!.id, id)
    XCTAssertEqual(parsedItem!.text, text)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), Int(createdAt.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.deadline!.timeIntervalSince1970), Int(deadline.timeIntervalSince1970))
    XCTAssertEqual(Int(parsedItem!.changedAt!.timeIntervalSince1970), Int(changedAt.timeIntervalSince1970))
    XCTAssertEqual(parsedItem!.importance, importance)
    XCTAssertEqual(parsedItem!.isDone, isDone)
  }

  func testCSVParsingWithoutDeadline() {
    let id = "456"
    let text = "Buy groceries"
    let createdAt = Date()
    let changedAt = Date().addingTimeInterval(7200)
    let importance = Importance.normal
    let isDone = false

    let item = Task(
      id: id,
      text: text,
      createdAt: createdAt,
      changedAt: changedAt,
      importance: importance,
      isDone: isDone
    )

    let parsedItem = Task.parse(csv: item.csv)

    XCTAssertEqual(parsedItem!.id, id)
    XCTAssertEqual(parsedItem!.text, text)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), Int(createdAt.timeIntervalSince1970))
    XCTAssertNil(parsedItem!.deadline)
    XCTAssertEqual(Int(parsedItem!.changedAt!.timeIntervalSince1970), Int(changedAt.timeIntervalSince1970))
    XCTAssertEqual(parsedItem!.importance, importance)
    XCTAssertEqual(parsedItem!.isDone, isDone)
  }

  func testCSVParsingWithMissingValues() {
    let csv = "123;Buy groceries;\(Int(Date().timeIntervalSince1970));;;;"

    let parsedItem = Task.parse(csv: csv)

    XCTAssertNil(parsedItem)
  }

  func testCSVParsingWithMissingNonImportantValues() {
    let text = "Buy groceries"
    let createdAt = Date()
    let importance = Importance.normal
    let isDone = false

    let item = Task(text: text, createdAt: createdAt, importance: importance, isDone: isDone)

    let parsedItem = Task.parse(csv: item.csv)

    XCTAssertNotNil(parsedItem!.id)
    XCTAssertEqual(parsedItem!.text, text)
    XCTAssertEqual(Int(parsedItem!.createdAt.timeIntervalSince1970), Int(createdAt.timeIntervalSince1970))
    XCTAssertNil(parsedItem!.deadline)
    XCTAssertNil(parsedItem!.changedAt)
    XCTAssertEqual(parsedItem!.importance, importance)
    XCTAssertEqual(parsedItem!.isDone, isDone)
  }

  func testCSVParsingWithInvalidValues() {
    let csv = "true;123;what???;hehehe;lol;!;?"

    let parsedItem = Task.parse(csv: csv)

    XCTAssertNil(parsedItem)
  }

  func testCSVParsingWithInvalidImportance() {
    let csv = "123;Buy groceries;\(Int(Date().timeIntervalSince1970));;;what??;false"

    let parsedItem = Task.parse(csv: csv)

    XCTAssertNil(parsedItem)
  }
}
