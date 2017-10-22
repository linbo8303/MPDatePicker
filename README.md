# MPDatePicker
UIWindow level DatePicker

1. Provides two modes: 
  1) Regular UIDatePicker
  2) Post-Check UIDatePicker
  
2. Two blocks
  1) completionHandler: ((Date)->Void)?
  2) dismissHandler: (()->Void)?

**Usage:**
1. Regular UIDatePicker
```
let picker = MPDatePicker.show(selected: recommendedDate, minimumDate: minimumDate, maximumDate: maximumDate, validatdRealTime: true)
            picker.completionHandler = { [weak self] date in
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .medium
                self?.title = formatter.string(from: date)
            }
```

2. Post-Check UIDatePicker
```
      let picker = MPDatePicker.show(selected: recommendedDate, minimumDate: minimumDate, maximumDate: maximumDate, validatdRealTime: false)
            picker.recommendedDate = recommendedDate
            picker.completionHandler = { [weak self] date in
                let formatter = DateFormatter()
                formatter.timeStyle = .medium
                formatter.dateStyle = .medium
                self?.title = formatter.string(from: date)
            }
```

![Regular UIDatePicker](https://github.com/linbo8303/MPDatePicker/blob/master/Screenshot%201.png "Regular UIDatePicker")
![Post-Check UIDatePicker](https://github.com/linbo8303/MPDatePicker/blob/master/Screenshot%201.png "Post-Check UIDatePicker")
