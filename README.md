# MPDatePicker
UIWindow level DatePicker which supports different UIDatePickerMode

1. Provides two modes: 
   1. Regular UIDatePicker
   2. Post-Check UIDatePicker
  
2. Two blocks
   1. completionHandler: ((Date)->Void)?
   2. dismissHandler: (()->Void)?

**Usage:**
1. Regular UIDatePicker
```swift
let picker = MPDatePicker.show(selected: selectedDate, minimumDate: minimumDate, maximumDate: maximumDate, validatdRealTime: true)
picker.completionHandler = { date in
    // do something after tapping done
}
pickerr.dismissHandler = { in
    // do something after dismiss the picker
}
```

![Regular UIDatePicker](https://github.com/linbo8303/MPDatePicker/blob/master/Screenshot1.png "Regular UIDatePicker") 

2. Post-Check UIDatePicker (validate the date by clicking "Done" button)
```swift
let picker = MPDatePicker.show(selected: recommendedDate, minimumDate: minimumDate, maximumDate: maximumDate, validatdRealTime: false)
picker.recommendedDate = recommendedDate     // "Recommended" button
picker.completionHandler = { date in
    // do something after tapping done
}
pickerr.dismissHandler = { in
    // do something after dismiss the picker
}
```

![Post-Check UIDatePicker](https://github.com/linbo8303/MPDatePicker/blob/master/Screenshot2.png "Post-Check UIDatePicker")
