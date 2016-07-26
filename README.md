# DxMDTextField
Material Design EditText for IOS

useage:
```swift
     let textField = MDTextField.init(frame: CGRectMake(x, y, width, height))
```
show error：
```swift
     textField.setErrorMsg("error message")
```
hide error:
```swift
     textField.setErrorMsg(nil)
```
show character counter and limit:
```swift
     textField.showMaxInputLength(true)
     textField.maxInputLength = 20;
```
