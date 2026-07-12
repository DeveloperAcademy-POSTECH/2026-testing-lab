# [SWIFT-TESTING] Refactoring XCTest-Based Unit Tests to Swift Testing

# 1. Introduction

## 1.1 Big Idea

Improve the structure of existing XCTest-based unit tests by adopting Swift Testing, making the test code more readable and maintainable.

## 1.2 Essential Question

How can existing XCTest-based tests be migrated to Swift Testing to create cleaner and more maintainable test code?

## 1.3 Challenge

Analyze the calculator application's existing unit tests written with XCTest and refactor them using Swift Testing's `@Test`, `#expect`, and `@Suite` while preserving the original test behavior.

## 1.4 Challenge Statement

Refactor the existing XCTest-based unit tests using Swift Testing to make the test suite easier to read and maintain.

---

# 2. Project Overview

## 2.1 Project Introduction

In this project, I implemented a calculator application that supports basic arithmetic operations, percentage calculations, and sign changes.

## 2.2 Project Structure

To better understand the architecture of the calculator application and the flow of the tests, I created a class diagram and a sequence diagram.

### 2.2.1 Class Diagram

| <img src="https://github.com/user-attachments/assets/969efbf0-e8e1-4b15-964a-88b66a8b2621" width="300"> | Illustrates the relationships among **Calculator**, <br> **CalculatorOperation**, and **CalculatorTests**. |
| --- | --- |

### 2.2.2 Sequence Diagram

| <img src="https://github.com/user-attachments/assets/b2f4a129-07a0-44d5-befe-1a2218a50db0" width="500"> | Shows how the test calls `Calculator` <br> and verifies the result step by step. |
| --- | --- |

> The sequence diagram was created to illustrate the order in which methods are invoked and results are returned as the test code executes.
>
> In particular, it demonstrates the complete flow of an exceptional case such as `10 ÷ 0`: the test requests a calculation from `Calculator`, `Calculator` performs the division operation and returns `nil`, and finally the test verifies that the returned value is `nil`.

## 2.3 Calculator View

The following screenshot shows the actual UI of the calculator application used as the test target.

| <img width="250" alt="Simulator Screen Recording - iPhone 17 - 2026-07-10 at 19 30 17" src="https://github.com/user-attachments/assets/21c74498-0a4e-42db-96f7-c3b8b231761b" /> | When the user taps number and operator buttons,  <br> `CalculatorViewModel` processes the input,  <br> while the actual calculation is performed by `Calculator`. |
| --- | --- |

---

# 3. Testing Fundamentals

## 3.1 Test Code

Test code is used to automatically verify that implemented functionality behaves as expected.

For example, when testing the addition operation, the test verifies that the result of `10 + 5` is `15`.

```swift
@Test
func addition() {
    #expect(
        logic.calculate(
            lhs: 10,
            rhs: 5,
            operation: .add
        ) == 15
    )
}
```

If this test passes, it confirms that the current addition logic produces the expected result.

---

## 3.2 Why Write Test Code?

1. Verify that implemented features produce the expected results.
2. Quickly confirm that existing functionality has not been broken after code changes.
3. Make it easier to identify where problems occur when a bug is introduced.
4. Reduce the need to repeatedly launch the app and manually test features.
5. Ensure that functionality remains unchanged before and after refactoring.

In this refactoring project, I verified that all 22 existing tests still passed after migrating from `XCTest` to `Swift Testing`, confirming that the application's behavior remained unchanged.

---

## 3.3 Unit Tests and UI Tests

Application testing can generally be divided into Unit Tests and UI Tests.

| Category | What It Verifies | Calculator Example |
| --- | --- | --- |
| Unit Test | Individual logic, objects, and state changes | Calculation results, button input handling, changes to `displayText` |
| UI Test | Actual user interactions with the application | Tapping buttons on the screen and verifying that the correct result is displayed |

In this project, I focused on Unit Tests that verify the application's internal logic rather than UI Tests that interact with the actual interface.

---

## 3.4 Unit Test Structure

The unit tests are divided into two files based on the component being tested.

```text
Unit Tests
 ├─ CalculatorTests
 │   └─ Verifies calculation logic
 │
 └─ CalculatorViewModelTests
     └─ Verifies user input handling and UI state changes
```

### 3.4.1 CalculatorTests

`CalculatorTests` verifies the core calculation logic.

- Addition
- Subtraction
- Multiplication
- Division
- Division by zero
- Percentage calculation
- Sign toggle
- Converting a string to `Decimal`
- Converting `Decimal` to a string

### 3.4.2 CalculatorViewModelTests

`CalculatorViewModelTests` verifies that the UI state changes correctly after processing user input.

- Number input
- Decimal point input
- Arithmetic operation flow
- Clear
- Backspace
- Sign toggle
- Percentage
- Division-by-zero error handling
- Starting a new calculation after pressing `=`

## 3.5 Why Separate Calculator and ViewModel Tests?

`Calculator` and `CalculatorViewModel` have different responsibilities, so their tests are separated accordingly.

### 3.5.1 CalculatorTests

`Calculator` is responsible only for the calculation logic.

```swift
logic.calculate(
    lhs: 10,
    rhs: 5,
    operation: .add
)
```

`CalculatorTests` verifies that the correct calculation result is returned for a given input.

```swift
@Test
func addition() {
    #expect(
        logic.calculate(
            lhs: 10,
            rhs: 5,
            operation: .add
        ) == 15
    )
}
```

### 3.5.2 CalculatorViewModelTests

`CalculatorViewModel` manages user input, calculation state, and the text displayed on the screen.

```swift
viewModel.tap(.digit(7))
viewModel.tap(.add)
viewModel.tap(.digit(8))
viewModel.tap(.equals)
```

`CalculatorViewModelTests` verifies that `displayText` is updated correctly after user interactions.

```swift
@Test
func additionFlow() {
    viewModel.tap(.digit(7))
    viewModel.tap(.add)
    viewModel.tap(.digit(8))
    viewModel.tap(.equals)

    #expect(viewModel.displayText == "15")
}
```

Separating these tests makes it easier to identify the source of failures.

```text
If a calculation result is incorrect
→ Check Calculator or CalculatorTests

If button input or the displayed value is incorrect
→ Check CalculatorViewModel or CalculatorViewModelTests
```

By organizing the tests according to each component's responsibility, the purpose of each test becomes clearer and failures are easier to diagnose.

---

# 4. Analysis of XCTest-Based Unit Tests

## 4.1 Problem

The original unit tests were written using `XCTest`.

With XCTest, test classes inherit from `XCTestCase`, and test objects are created in `setUp()` and released in `tearDown()`.

| CalculatorTests | CalculatorViewModelTests |
| --- | --- |
| <img src="https://github.com/user-attachments/assets/b2fd0997-4b93-42cc-8ba5-b746803e8f40" width="400"> | <img src="https://github.com/user-attachments/assets/83fe65b9-c1aa-4f8e-bc7e-123036365574" width="400"> |

In addition, different assertion methods had to be used depending on the expected test result.

```swift
XCTAssertEqual(result, 15)
XCTAssertNil(result)
```

As a result, repetitive test setup code appeared before the actual test logic, making the code more focused on `XCTestCase`, `setUp()`, and `tearDown()` than on the behavior being tested.

> **Boilerplate Code:** Repetitive code that must be written regardless of the application's core functionality.
>
> In this case, inheriting from `XCTestCase` and implementing `setUp()` and `tearDown()` are examples of boilerplate code.

---

# 5. Refactoring with Swift Testing

## 5.1 Approach

The existing XCTest-based tests were refactored to use Swift Testing.

During the refactoring process, the test inputs and expected results remained unchanged. Only the way tests were declared and assertions were written was updated.

### 5.1.1 Removing `XCTestCase`

The original class-based tests that inherited from `XCTestCase` were converted to struct-based tests.

```swift
// Before
final class CalculatorTests: XCTestCase {
}

// After
struct CalculatorTests {
}
```

---

### 5.1.2 Removing `setUp()` and `tearDown()`

Previously, test objects were created in `setUp()` and released in `tearDown()`.

```swift
// Before
private var logic: Calculator!

override func setUp() {
    super.setUp()
    logic = Calculator()
}

override func tearDown() {
    logic = nil
    super.tearDown()
}
```

With Swift Testing, the test object can be initialized directly as a property.

```swift
// After
private let logic = Calculator()
```

The same approach was applied to the ViewModel.

```swift
private let viewModel = CalculatorViewModel(
    logic: Calculator()
)
```

---

### 5.1.3 Replacing `test` Methods with `@Test`

In XCTest, test function names must begin with the `test` prefix.

```swift
// Before
func testAddition() {
}
```

In Swift Testing, the `@Test` attribute identifies a function as a test.

```swift
// After
@Test
func addition() {
}
```

Since the `test` prefix is no longer required, test names can be written more naturally.

---

### 5.1.4 Replacing `XCTAssert` with `#expect`

XCTest uses different assertion methods depending on the type of verification, such as `XCTAssertEqual` and `XCTAssertNil`.

```swift
// Before
XCTAssertEqual(
    logic.calculate(
        lhs: 10,
        rhs: 5,
        operation: .add
    ),
    15
)

XCTAssertNil(
    logic.calculate(
        lhs: 10,
        rhs: 0,
        operation: .divide
    )
)
```

Swift Testing uses a single `#expect` macro with a Boolean expression.

```swift
// After
#expect(
    logic.calculate(
        lhs: 10,
        rhs: 5,
        operation: .add
    ) == 15
)

#expect(
    logic.calculate(
        lhs: 10,
        rhs: 0,
        operation: .divide
    ) == nil
)
```

The same change was applied to the ViewModel tests.

```swift
// Before
XCTAssertEqual(
    viewModel.displayText,
    "15"
)

// After
#expect(
    viewModel.displayText == "15"
)
```

---

## 5.2 Test Cases

XCTest and Swift Testing execute the same 22 test cases.

During the refactoring, only the test names and assertion syntax were changed, while the test inputs and expected results remained the same.

### 5.2.1 CalculatorTests

| XCTest | Swift Testing | Description |
| --- | --- | --- |
| `testAddition()` | `addition()` | Verifies that `10 + 5` returns `15`. |
| `testSubtraction()` | `subtraction()` | Verifies that `10 - 5` returns `5`. |
| `testMultiplication()` | `multiplication()` | Verifies that `10 × 5` returns `50`. |
| `testDivision()` | `division()` | Verifies that `10 ÷ 5` returns `2`. |
| `testDivisionByZeroReturnsNil()` | `divisionByZeroReturnsNil()` | Verifies that dividing `10 ÷ 0` returns `nil`. |
| `testPercent()` | `percent()` | Verifies that applying the percentage operation to `50` returns `0.5`. |
| `testToggleSign()` | `toggleSign()` | Verifies that `10` becomes `-10` and `-10` becomes `10`. |
| `testDecimalFromString()` | `decimalFromString()` | Verifies that the string `"1,234.5"` is converted to `Decimal(1234.5)`. |
| `testStringFromDecimal()` | `stringFromDecimal()` | Verifies that `Decimal(1234.5)` is converted to `"1,234.5"`. |

### 5.2.2 CalculatorViewModelTests

| XCTest | Swift Testing | Description |
| --- | --- | --- |
| `testNumberInput()` | `numberInput()` | Verifies that entering `1`, `2`, and `3` displays `"123"`. |
| `testDecimalInput()` | `decimalInput()` | Verifies that entering `1`, `.`, and `5` displays `"1.5"`. |
| `testAdditionFlow()` | `additionFlow()` | Verifies that entering `7 → + → 8 → =` displays `"15"`. |
| `testSubtractionFlow()` | `subtractionFlow()` | Verifies that entering `9 → − → 4 → =` displays `"5"`. |
| `testMultiplicationFlow()` | `multiplicationFlow()` | Verifies that entering `6 → × → 7 → =` displays `"42"`. |
| `testDivisionFlow()` | `divisionFlow()` | Verifies that entering `8 → ÷ → 2 → =` displays `"4"`. |
| `testClear()` | `clear()` | Verifies that pressing **Clear** resets the display to `"0"`. |
| `testBackspace()` | `backspace()` | Verifies that pressing **Backspace** on `"123"` changes the display to `"12"`. |
| `testBackspaceToZero()` | `backspaceToZero()` | Verifies that deleting the last digit displays `"0"` instead of an empty string. |
| `testPlusMinus()` | `plusMinus()` | Verifies that pressing the ± button after entering `5` displays `"-5"`. |
| `testPercent()` | `percent()` | Verifies that pressing the % button after entering `50` displays `"0.5"`. |
| `testDivisionByZeroShowsError()` | `divisionByZeroShowsError()` | Verifies that entering `8 → ÷ → 0 → =` displays `"Error"`. |
| `testDigitAfterEqualsStartsNewCalculation()` | `digitAfterEqualsStartsNewCalculation()` | Verifies that entering `7` after completing a calculation starts a new calculation instead of appending to the previous result. |

| XCTest | Swift Testing |
| --- | --- |
| <img src="https://github.com/user-attachments/assets/66586b11-6747-44a6-85fa-ea7aa5a41237" width="250"> | <img src="https://github.com/user-attachments/assets/6755982f-2f2f-466a-9108-2fd76cc381e9" width="250"> |

All 22 test cases passed successfully, confirming that both the calculator logic and the ViewModel's input flow remained unchanged after migrating to Swift Testing.

---

## 5.3 Comparison Between XCTest and Swift Testing

| Comparison | XCTest | Swift Testing |
| --- | --- | --- |
| Framework | `import XCTest` | `import Testing` |
| Test Type | `class` inheriting from `XCTestCase` | `struct` or `class` |
| Object Initialization | Created in `setUp()` | Can be initialized directly as a property |
| Object Cleanup | Released in `tearDown()` | No explicit cleanup required for simple tests |
| Test Declaration | Function name must start with `test` | Uses `@Test` |
| Function Name | `testAddition()` | `addition()` |
| Value Assertion | `XCTAssertEqual` | `#expect(result == value)` |
| Nil Assertion | `XCTAssertNil` | `#expect(result == nil)` |
| Code Structure | Repetitive setup code | Focuses directly on the test logic |
| Maintainability | Requires multiple assertion methods and lifecycle management | Uses a consistent `@Test` and `#expect` syntax |

---

## 5.4 Diagram

### 5.4.1 Before (XCTest)

```text
CalculatorTests
 ├─ Inherits from XCTestCase
 ├─ setUp() / tearDown()
 ├─ testXXX()
 └─ XCTAssertEqual / XCTAssertNil
```

### 5.4.2 After (Swift Testing)

```text
CalculatorTests
 ├─ struct
 ├─ @Test
 ├─ #expect
 └─ Initialize test object as a property
```

---

# 6. Results and Discussion

## 6.1 Findings

Through this refactoring, I found that although XCTest and Swift Testing verify the same functionality, they differ significantly in how tests are written.

With Swift Testing, repetitive setup code such as inheriting from `XCTestCase` and implementing `setUp()` and `tearDown()` could be eliminated. In addition, using `@Test` for test declarations and `#expect` for assertions made the overall test structure more consistent and easier to read.

Separating `CalculatorTests` and `CalculatorViewModelTests` also reinforced the idea that tests should be organized based on the responsibilities of each component rather than by class or file names.

- `CalculatorTests` verifies the calculation logic.
- `CalculatorViewModelTests` verifies user input handling and UI state changes.

Furthermore, comparing XCTest with Swift Testing while documenting the reasons for the refactoring helped me gain a deeper understanding of both testing frameworks, including their architecture and testing approaches.

---

## 6.2 Conclusion

The existing `CalculatorTests` and `CalculatorViewModelTests`, originally written with XCTest, were successfully refactored to use Swift Testing.

The original 22 test cases retained the same inputs and expected results, while only the testing syntax and structure were updated as follows:

```text
XCTestCase       → struct
setUp/tearDown   → Property initialization
testXXX()        → @Test
XCTAssertEqual   → #expect
XCTAssertNil     → #expect(... == nil)
```

After the refactoring, all 22 tests passed successfully, confirming that the application's existing behavior remained unchanged.

This project demonstrated that Swift Testing enables test code to be written in a more concise and consistent manner. It also showed that organizing tests according to each component's responsibility makes both the purpose of each test and the cause of test failures easier to understand.


<details>
<summary>한국어 번역</summary>

# [SWIFT-TESTING] XCTest 기반 Unit Test를 Swift Testing으로 리팩토링

# 1. 서론

## 1.1 Big Idea

Swift Testing을 활용하여 기존 XCTest 기반 Unit Test의 구조를 개선하고, 테스트 코드의 가독성과 유지보수성을 향상시킨다.

## 1.2 Essential Question

기존 XCTest 기반 테스트를 Swift Testing으로 전환하여 어떻게 더 간결하고 유지보수하기 쉬운 테스트 코드를 작성할 수 있을까?

## 1.3 Challenge

기존 XCTest로 작성된 계산기 앱의 Unit Test를 분석하고, 동일한 테스트 동작을 유지하면서 Swift Testing의 `@Test`, `#expect`, `@Suite`를 적용하여 리팩토링한다.

## 1.4 Challenge Statement

Swift Testing을 적용하여 기존 XCTest 기반 Unit Test를 더 읽기 쉽고 유지보수하기 좋은 구조로 개선한다.

---

# 2. 프로젝트 개요

## 2.1. 프로젝트 소개

이번 프로젝트에서는 사칙연산, 퍼센트, 부호 변경 등의 기능을 제공하는 계산기 앱을 구현했다.

## 2.2. 프로젝트 구조

계산기 앱의 구조와 테스트 흐름을 이해하기 위해 클래스 다이어그램과 시퀀스 다이어그램을 작성하였다.

### 2.2.1. 클래스 다이어 그램

| <img src="https://github.com/user-attachments/assets/969efbf0-e8e1-4b15-964a-88b66a8b2621" width="300">  | **Calculator**, **CalculatorOperation**, <br> **CalculatorTests** 간의 관계를 표현 |
| --- | --- |


### 2.2.2. 시퀀스 다이어그램

| <img src="https://github.com/user-attachments/assets/b2f4a129-07a0-44d5-befe-1a2218a50db0" width="500">  | 테스트가 `Calculator`를 호출하고 <br> 결과를 검증하는 과정을 순서대로 표현 |
| --- | --- |


> 시퀀스 다이어그램은 **테스트 코드가 실행될 때 객체 간에 어떤 순서로 메서드가 호출되고 결과가 반환되는지 이해하기 위해 작성하였다.**
> 
> 특히 `10 ÷ 0`과 같은 예외 상황에서 테스트 코드가 `Calculator`에 계산을 요청하고, `Calculator`가 나누기 연산을 수행한 뒤 `nil`을 반환하며, 마지막으로 테스트 코드가 `nil`이 반환되었는지를 검증하는 전체 흐름을 한눈에 확인할 수 있다.
> 

## 2.3. Calculator View

아래 화면은 테스트 대상이 되는 실제 계산기 앱의 UI이다.

| <img width="250" alt="Simulator Screen Recording - iPhone 17 - 2026-07-10 at 19 30 17" src="https://github.com/user-attachments/assets/21c74498-0a4e-42db-96f7-c3b8b231761b" />  |계산기 화면에서 숫자와 연산 버튼을 누르면<br>  `CalculatorViewModel`이 입력을 처리하고,<br> 실제 계산은 `Calculator`가 담당 |
| --- | --- |

---

# 3. 테스트 이론

## 3.1. 테스트 코드(Test Code)

테스트 코드는 작성한 기능이 예상한 대로 동작하는지 자동으로 검증하는 코드이다.

예를 들어 덧셈 기능을 테스트할 때는 `10 + 5`의 결과가 `15`인지 확인한다.

```swift
@Test
func addition() {
    #expect(
        logic.calculate(
            lhs: 10,
            rhs: 5,
            operation: .add
        ) == 15
    )
}
```

이 테스트가 통과하면 현재 덧셈 로직이 기대한 결과를 반환하고 있다는 것을 확인할 수 있다.

---

## 3.2. 테스트 코드를 작성하는 이유

1. 구현한 기능이 예상한 결과를 반환하는지 확인할 수 있다.
2. 코드 수정 이후 기존 기능이 깨지지 않았는지 빠르게 확인할 수 있다.
3. 오류가 발생했을 때 어느 부분에서 문제가 발생했는지 찾기 쉬워진다.
4. 수동으로 앱을 실행하고 버튼을 반복해서 누르는 작업을 줄일 수 있다.
5. 리팩토링 전후에 기능이 동일하게 유지되는지 검증할 수 있다.

이번 리팩토링에서도 `XCTest`를 `Swift Testing`으로 변경한 후 기존 22개의 테스트가 모두 통과하는지 확인하여 기능이 유지되고 있음을 검증했다.

---

## 3.3. Unit Test와 UI Test

앱 테스트는 크게 Unit Test와 UI Test로 구분할 수 있다.

| 구분 | 검증 대상 | 계산기 앱의 예시 |
| --- | --- | --- |
| Unit Test | 개별 로직, 객체, 상태 변화 | 계산 결과, 버튼 입력 처리, `displayText` 변경 |
| UI Test | 실제 앱 화면과 사용자 동작 | 화면의 버튼을 직접 누르고 결과가 표시되는지 확인 |

이번 프로젝트에서는 실제 화면을 직접 조작하는 UI Test가 아니라, 코드 내부의 기능을 검증하는 Unit Test를 작성했다.

---

## 3.4. Unit Test 구성

이번 Unit Test는 테스트 대상에 따라 두 파일로 나누었다.

```
Unit Tests
 ├─ CalculatorTests
 │   └─ 계산 로직 검증
 │
 └─ CalculatorViewModelTests
     └─ 사용자 입력과 화면 상태 변화 검증
```

### 3.4.1. CalculatorTests

`CalculatorTests`는 실제 계산 결과를 검증한다.

- 덧셈
- 뺄셈
- 곱셈
- 나눗셈
- 0으로 나누기
- 퍼센트 계산
- 부호 변경
- 문자열을 `Decimal`로 변환
- `Decimal`을 문자열로 변환

### 3.4.2. CalculatorViewModelTests

`CalculatorViewModelTests`는 사용자의 버튼 입력을 처리한 후 화면 상태가 올바르게 변경되는지 검증한다.

- 숫자 입력
- 소수점 입력
- 사칙연산 입력 흐름
- Clear
- Backspace
- 부호 변경
- 퍼센트
- 0으로 나누기 오류 표시
- `=` 입력 후 새로운 계산 시작

## 3.5. Calculator와 ViewModel 테스트를 분리한 이유

`Calculator`와 `CalculatorViewModel`은 담당하는 역할이 다르기 때문에 테스트도 분리했다.

### 3.5.1. CalculatorTest

`Calculator`는 실제 계산 로직만 담당한다.

```swift
logic.calculate(
    lhs: 10,
    rhs: 5,
    operation: .add
)
```

`CalculatorTests`에서는 입력값을 전달했을 때 올바른 계산 결과가 반환되는지를 검증한다.

```swift
@Test
func addition() {
    #expect(
        logic.calculate(
            lhs: 10,
            rhs: 5,
            operation: .add
        ) == 15
    )
}
```

### 3.5.2. CalculatorViewModelTest

`CalculatorViewModel`은 사용자의 버튼 입력, 계산 과정의 상태, 화면에 표시되는 문자열을 관리한다.

```swift
viewModel.tap(.digit(7))
viewModel.tap(.add)
viewModel.tap(.digit(8))
viewModel.tap(.equals)
```

`CalculatorViewModelTests`에서는 버튼 입력 이후 `displayText`가 올바르게 변경되는지를 검증한다.

```swift
@Test
func additionFlow() {
    viewModel.tap(.digit(7))
    viewModel.tap(.add)
    viewModel.tap(.digit(8))
    viewModel.tap(.equals)

    #expect(viewModel.displayText == "15")
}
```

두 테스트를 분리하면 테스트 실패 원인을 더 빠르게 찾을 수 있다.

```
계산 결과가 잘못된 경우
→ Calculator 또는 CalculatorTests 확인

버튼 입력이나 화면 표시가 잘못된 경우
→ CalculatorViewModel 또는 CalculatorViewModelTests 확인
```

테스트 대상의 책임을 기준으로 파일을 나누어 각 테스트의 목적을 명확하게 했다.

---

# 4. XCTest 기반 Unit Test 분석

## 4.1. Problem

기존 Unit Test는 `XCTest`를 기반으로 작성되어 있었다.

XCTest에서는 `XCTestCase`를 상속하고, `setUp()`과 `tearDown()`을 통해 테스트 객체를 생성하고 해제했다.

| CalculatorTests | CalculatorViewModelTests |
| --- | --- |
| <img src="https://github.com/user-attachments/assets/b2fd0997-4b93-42cc-8ba5-b746803e8f40" width="400"> | <img src="https://github.com/user-attachments/assets/83fe65b9-c1aa-4f8e-bc7e-123036365574" width="400"> |

또한 테스트 결과를 검증할 때 상황에 따라 서로 다른 Assertion을 사용해야 했다.

```swift
XCTAssertEqual(result, 15)
XCTAssertNil(result)
```

이처럼 테스트 준비 코드가 반복되어 실제로 검증하려는 테스트 로직보다 `XCTestCase`, `setUp()`, `tearDown()` 등의 코드가 먼저 보였다.

> **보일러플레이트 코드(Boilerplate Code) :** 실제 핵심 기능과 관계없이 비슷한 형태로 반복해서 작성해야 하는 코드
> 

---

# 5. Swift Testing을 활용한 리팩토링

## 5.1. Approach

기존 XCTest 기반 테스트를 Swift Testing으로 리팩토링했다.

리팩토링 과정에서 테스트의 입력값과 기대 결과는 변경하지 않고, 테스트를 선언하고 검증하는 방식만 변경했다.

### 5.1.1. `XCTestCase` 제거

`XCTestCase`를 상속하는 클래스 기반 테스트를 `struct` 기반 테스트로 변경했다.

```swift
// Before
final class CalculatorTests: XCTestCase {
}

// After
struct CalculatorTests {
}
```

---

### 5.1.2. `setUp()`과 `tearDown()` 제거

기존에는 `setUp()`에서 테스트 객체를 생성하고 `tearDown()`에서 해제했다.

```swift
// Before
private var logic: Calculator!

override func setUp() {
    super.setUp()
    logic = Calculator()
}

override func tearDown() {
    logic = nil
    super.tearDown()
}
```

Swift Testing에서는 테스트 객체를 프로퍼티에서 바로 생성하도록 변경했다.

```swift
// After
private let logic = Calculator()
```

ViewModel도 동일하게 변경했다.

```swift
private let viewModel = CalculatorViewModel(
    logic: Calculator()
)
```

---

### 5.1.3. `test` 메서드를 `@Test`로 변경

XCTest에서는 테스트 함수의 이름이 `test`로 시작해야 했다.

```swift
// Before
func testAddition() {
}
```

Swift Testing에서는 `@Test`를 사용해 해당 함수가 테스트임을 표시한다.

```swift
// After
@Test
func addition() {
}
```

함수 이름에 `test` 접두사를 붙이지 않아도 되므로 테스트 이름을 더 자연스럽게 작성할 수 있다.

---

### 5.1.4. `XCTAssert`를 `#expect`로 변경

XCTest에서는 검증 종류에 따라 `XCTAssertEqual`, `XCTAssertNil` 등을 사용했다.

```swift
// Before
XCTAssertEqual(
    logic.calculate(
        lhs: 10,
        rhs: 5,
        operation: .add
    ),
    15
)

XCTAssertNil(
    logic.calculate(
        lhs: 10,
        rhs: 0,
        operation: .divide
    )
)
```

Swift Testing에서는 조건식을 `#expect` 안에 작성했다.

```swift
// After
#expect(
    logic.calculate(
        lhs: 10,
        rhs: 5,
        operation: .add
    ) == 15
)

#expect(
    logic.calculate(
        lhs: 10,
        rhs: 0,
        operation: .divide
    ) == nil
)
```

ViewModel 테스트도 동일하게 변경했다.

```swift
// Before
XCTAssertEqual(
    viewModel.displayText,
    "15"
)

// After
#expect(
    viewModel.displayText == "15"
)
```

---

## 5.2. Test Cases

XCTest와 Swift Testing은 동일한 22개의 테스트 케이스를 수행한다.

리팩토링 과정에서는 테스트 이름과 검증 문법만 변경했으며, 입력값과 기대 결과는 유지했다.

### 5.2.1. CalculatorTests

| XCTest | Swift Testing | 검증 내용 |
| --- | --- | --- |
| `testAddition()` | `addition()` | `10 + 5`를 계산했을 때 결과가 `15`인지 검증한다. |
| `testSubtraction()` | `subtraction()` | `10 - 5`를 계산했을 때 결과가 `5`인지 검증한다. |
| `testMultiplication()` | `multiplication()` | `10 × 5`를 계산했을 때 결과가 `50`인지 검증한다. |
| `testDivision()` | `division()` | `10 ÷ 5`를 계산했을 때 결과가 `2`인지 검증한다. |
| `testDivisionByZeroReturnsNil()` | `divisionByZeroReturnsNil()` | `10 ÷ 0`을 수행했을 때 `nil`을 반환하는지 검증한다. |
| `testPercent()` | `percent()` | `50`에 퍼센트 연산을 적용했을 때 `0.5`가 반환되는지 검증한다. |
| `testToggleSign()` | `toggleSign()` | `10`은 `-10`으로, `-10`은 `10`으로 부호가 변경되는지 검증한다. |
| `testDecimalFromString()` | `decimalFromString()` | 문자열 `"1,234.5"`가 `Decimal(1234.5)`로 변환되는지 검증한다. |
| `testStringFromDecimal()` | `stringFromDecimal()` | `Decimal(1234.5)`가 `"1,234.5"`로 변환되는지 검증한다. |

### 5.2.2. CalculatorViewModelTests

| XCTest | Swift Testing | 검증 내용 |
| --- | --- | --- |
| `testNumberInput()` | `numberInput()` | `1`, `2`, `3`을 입력했을 때 `"123"`이 표시되는지 검증한다. |
| `testDecimalInput()` | `decimalInput()` | `1`, `.`, `5`를 입력했을 때 `"1.5"`가 표시되는지 검증한다. |
| `testAdditionFlow()` | `additionFlow()` | `7 → + → 8 → =` 입력 후 `"15"`가 표시되는지 검증한다. |
| `testSubtractionFlow()` | `subtractionFlow()` | `9 → - → 4 → =` 입력 후 `"5"`가 표시되는지 검증한다. |
| `testMultiplicationFlow()` | `multiplicationFlow()` | `6 → × → 7 → =` 입력 후 `"42"`가 표시되는지 검증한다. |
| `testDivisionFlow()` | `divisionFlow()` | `8 → ÷ → 2 → =` 입력 후 `"4"`가 표시되는지 검증한다. |
| `testClear()` | `clear()` | 숫자를 입력한 뒤 Clear를 누르면 `"0"`으로 초기화되는지 검증한다. |
| `testBackspace()` | `backspace()` | `"123"`에서 Backspace를 누르면 `"12"`가 표시되는지 검증한다. |
| `testBackspaceToZero()` | `backspaceToZero()` | 마지막 숫자를 삭제했을 때 빈 문자열이 아닌 `"0"`이 표시되는지 검증한다. |
| `testPlusMinus()` | `plusMinus()` | `5` 입력 후 ± 버튼을 누르면 `"-5"`가 표시되는지 검증한다. |
| `testPercent()` | `percent()` | `50` 입력 후 % 버튼을 누르면 `"0.5"`가 표시되는지 검증한다. |
| `testDivisionByZeroShowsError()` | `divisionByZeroShowsError()` | `8 → ÷ → 0 → =` 입력 후 `"Error"`가 표시되는지 검증한다. |
| `testDigitAfterEqualsStartsNewCalculation()` | `digitAfterEqualsStartsNewCalculation()` | 계산 완료 후 `7`을 입력하면 기존 결과에 이어지지 않고 `"7"`로 새로운 계산이 시작되는지 검증한다. |

| XCTest | Swift Testing |
| --- | --- |
| <img src="https://github.com/user-attachments/assets/66586b11-6747-44a6-85fa-ea7aa5a41237" width="250"> | <img src="https://github.com/user-attachments/assets/6755982f-2f2f-466a-9108-2fd76cc381e9" width="250"> |

총 22개의 테스트가 통과했으며, 이를 통해 테스트 프레임워크를 변경한 이후에도 기존 계산 기능과 ViewModel의 입력 흐름이 동일하게 유지되고 있음을 확인했다.

---

## 5.3. XCTest와 Swift Testing 비교

| 비교 기준 | XCTest | Swift Testing |
| --- | --- | --- |
| 프레임워크 | `import XCTest` | `import Testing` |
| 테스트 타입 | `XCTestCase`를 상속한 `class` | `struct` 또는 `class` |
| 객체 생성 | `setUp()`에서 생성 | 프로퍼티에서 바로 생성 가능 |
| 객체 정리 | `tearDown()`에서 해제 | 단순한 테스트에서는 별도 정리 불필요 |
| 테스트 선언 | 함수 이름에 `test` 접두사 사용 | `@Test` 사용 |
| 함수 이름 | `testAddition()` | `addition()` |
| 값 비교 | `XCTAssertEqual` | `#expect(result == value)` |
| nil 검증 | `XCTAssertNil` | `#expect(result == nil)` |
| 코드 구조 | 테스트 준비 코드가 반복됨 | 테스트 핵심 로직이 바로 드러남 |
| 유지보수 | 여러 Assertion과 생명주기 관리 필요 | `@Test`와 `#expect` 중심으로 작성 |

---

## 5.4. Diagram

### 5.4.1. Before (XCTest)

```
CalculatorTests
 ├─ Inherits from XCTestCase
 ├─ setUp() / tearDown()
 ├─ testXXX()
 └─ XCTAssertEqual / XCTAssertNil
```

### 5.4.2. After (Swift Testing)

```
CalculatorTests
 ├─ struct
 ├─ @Test
 ├─ #expect
 └─ Initialize test object as a property
```

---

# 6. 결과 및 고찰

## 6.1. Findings

이번 리팩토링을 통해 XCTest와 Swift Testing은 동일한 기능을 검증하지만 테스트를 작성하는 방식에는 차이가 있다는 점을 확인했다.

Swift Testing에서는 `XCTestCase` 상속, `setUp()`, `tearDown()`과 같은 반복적인 준비 코드를 줄일 수 있었다. 또한 테스트 선언은 `@Test`, 결과 검증은 `#expect`를 중심으로 작성하여 코드의 구조를 더 일관성 있게 만들 수 있었다.

`CalculatorTests`와 `CalculatorViewModelTests`를 분리하면서 테스트는 클래스나 파일의 이름을 기준으로 나누는 것이 아니라, 각 객체가 담당하는 책임을 기준으로 나누어야 한다는 점도 이해했다.

- `CalculatorTests`는 순수 계산 결과를 검증
- `CalculatorViewModelTests`는 사용자 입력 처리와 화면 상태 변화를 검증

또한 다른 사람에게 리팩토링 이유를 설명하기 위해 XCTest와 Swift Testing을 비교하고 정리하는 과정에서 두 테스트 프레임워크의 구조와 동작을 더 깊게 학습할 수 있었다.

---

## 6.2. Conclusion

기존 XCTest 기반의 `CalculatorTests`와 `CalculatorViewModelTests`를 Swift Testing으로 리팩토링했다.

기존 22개의 테스트에서 사용하던 입력값과 기대 결과는 그대로 유지하면서 다음과 같이 테스트 작성 방식만 변경했다.

```
XCTestCase       → struct
setUp/tearDown   → 프로퍼티 초기화
testXXX()        → @Test
XCTAssertEqual   → #expect
XCTAssertNil     → #expect(... == nil)
```

리팩토링 후 전체 테스트가 정상적으로 통과했으며, 이를 통해 기존 기능이 유지되는 것을 확인했다.

이번 작업을 통해 Swift Testing을 사용하면 테스트 코드를 더 간결하고 일관성 있게 작성할 수 있으며, 테스트 대상을 책임에 따라 분리하면 테스트의 목적과 실패 원인을 더 명확하게 파악할 수 있다는 점을 확인했다.


</details>
