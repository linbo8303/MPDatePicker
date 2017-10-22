//
//  MPDatePicker.swift
//  Posmeal
//
//  Created by Bo Lin on 20/10/17.
//  Copyright © 2017 Posmill. All rights reserved.
//

import UIKit

class MPDatePicker: UIView {
    
    var contentHeight: CGFloat = 310
    
    // public vars
    public var backgroundViewColor: UIColor? = .clear {
        didSet {
            shadowView.backgroundColor = backgroundViewColor
        }
    }
    
    public var highlightColor = #colorLiteral(red: 0.2, green: 0.4784313725, blue: 0.7176470588, alpha: 1) {
        didSet {
            todayButton.setTitleColor(highlightColor, for: .normal)
        }
    }
    
    public var datePickerMode: UIDatePickerMode = .dateAndTime {
        didSet {
            datePicker.datePickerMode = datePickerMode
        }
    }
    
    public var darkColor = UIColor(red: 0, green: 22.0/255.0, blue: 39.0/255.0, alpha: 1) {
        didSet {
            viewTitleLabel.textColor = darkColor
            cancelButton.setTitleColor(darkColor.withAlphaComponent(0.5), for: .normal)
            doneButton.backgroundColor = darkColor.withAlphaComponent(0.5)
            borderTopView.backgroundColor = darkColor.withAlphaComponent(0.2)
        }
    }
    
    var didLayoutAtOnce = false
    public override func layoutSubviews() {
        // For the first time view will be layouted manually before show
        // For next times we need relayout it because of screen rotation etc.
        if !didLayoutAtOnce {
            didLayoutAtOnce = true
        } else {
            self.configureView()
        }
    }
    
    public var selectedDate = Date() {
        didSet {
            resetViewTitle()
        }
    }
    
    @objc public var recommendedDate: Date? {
        didSet {
            todayButtonTitle = "Recommend"
        }
    }
    
    public var dateFormat = "HH:mm dd/MM/YYYY" {
        didSet {
            resetViewTitle()
        }
    }
    
    public var cancelButtonTitle = "Cancel" {
        didSet {
            cancelButton.setTitle(cancelButtonTitle, for: .normal)
            let size = cancelButton.sizeThatFits(CGSize(width: 0, height: 44.0)).width + 20.0
            cancelButton.frame = CGRect(x: 0, y: 0, width: size, height: 44)
        }
    }
    
    public var todayButtonTitle = "Today" {
        didSet {
            todayButton.setTitle(todayButtonTitle, for: .normal)
            let size = todayButton.sizeThatFits(CGSize(width: 0, height: 44.0)).width + 20.0
            todayButton.frame = CGRect(x: contentView.frame.width - size, y: 0, width: size, height: 44)
        }
    }
    
    public var doneButtonTitle = "DONE" {
        didSet {
            doneButton.setTitle(doneButtonTitle, for: .normal)
        }
    }
    
    public var invalidTitle = "INVALID DATE"
    
    public var validatdRealTime: Bool = true
    
    public var timeZone = TimeZone.current
    @objc public var completionHandler: ((Date)->Void)?
    @objc public var dismissHandler: (()->Void)?
    
    // private vars
    internal var datePicker: UIDatePicker!
    
    private var shadowView: UIView!
    private var contentView: UIView!
    private var viewTitleLabel: UILabel!
    private var cancelButton: UIButton!
    private var doneButton: UIButton!
    private var todayButton: UIButton!
    
    private var borderTopView: UIView!
    private var borderBottomView: UIView!
    
    internal var minimumDate: Date!
    internal var maximumDate: Date!
    
    internal var calendar: Calendar = .current
    internal var dates: [Date]! = []
    internal var components: DateComponents! {
        didSet {
            components.timeZone = timeZone
        }
    }
    
    @objc open class func show(selected: Date? = nil, minimumDate: Date? = nil, maximumDate: Date? = nil, validatdRealTime: Bool = true) -> MPDatePicker {
        
        let mpDatePicker = MPDatePicker()
        mpDatePicker.minimumDate = minimumDate?.dateTrimSeconds ?? Date(timeIntervalSinceNow: -3600 * 24 * 365 * 20)
        mpDatePicker.maximumDate = maximumDate?.dateTrimSeconds ?? Date(timeIntervalSinceNow: 3600 * 24 * 365 * 20)
        mpDatePicker.selectedDate = selected ?? mpDatePicker.minimumDate
        mpDatePicker.validatdRealTime = validatdRealTime
        assert(mpDatePicker.minimumDate.compare(mpDatePicker.maximumDate) == .orderedAscending, "Minimum date should be earlier than maximum date")
        assert(mpDatePicker.minimumDate.compare(mpDatePicker.selectedDate) != .orderedDescending, "Selected date should be later or equal to minimum date")
        assert(mpDatePicker.selectedDate.compare(mpDatePicker.maximumDate) != .orderedDescending, "Selected date should be earlier or equal to maximum date")
        
        mpDatePicker.configureView()
        UIApplication.shared.keyWindow?.addSubview(mpDatePicker)
        
        return mpDatePicker
    }
    
    
    private func configureView() {
        if self.contentView != nil {
            self.contentView.removeFromSuperview()
        }
        let screenSize = UIScreen.main.bounds.size
        self.frame = CGRect(x: 0,
                            y: 0,
                            width: screenSize.width,
                            height: screenSize.height)
        // shadow view
        shadowView = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: frame.width,
                                          height: frame.height))
        shadowView.backgroundColor = backgroundViewColor ?? UIColor.black.withAlphaComponent(0.3)
        shadowView.alpha = 1
        let shadowViewTap = UITapGestureRecognizer(target: self, action: #selector(MPDatePicker.dismissView(sender:)))
        shadowView.addGestureRecognizer(shadowViewTap)
        addSubview(shadowView)
        
        // content view
        contentView = UIView(frame: CGRect(x: 0,
                                           y: frame.height,
                                           width: frame.width,
                                           height: contentHeight))
        contentView.layer.shadowColor = UIColor(white: 0, alpha: 0.3).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: -2.0)
        contentView.layer.shadowRadius = 1.5
        contentView.layer.shadowOpacity = 0.5
        contentView.backgroundColor = .clear
        contentView.isHidden = true
        addSubview(contentView)
        
        // blur view
        let blur = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blur)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: contentView.frame.height)
        contentView.addSubview(blurEffectView)
        
        // title view
        let titleView = UIView(frame: CGRect(origin: CGPoint.zero,
                                             size: CGSize(width: contentView.frame.width, height: 44)))
        titleView.backgroundColor = .clear
        contentView.addSubview(titleView)
        
        viewTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        viewTitleLabel.font = UIFont.systemFont(ofSize: 15)
        viewTitleLabel.numberOfLines = 0
        viewTitleLabel.textColor = darkColor
        viewTitleLabel.textAlignment = .center
        resetViewTitle()
        titleView.addSubview(viewTitleLabel)
        
        cancelButton = UIButton(type: .system)
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(darkColor.withAlphaComponent(0.5), for: .normal)
        cancelButton.addTarget(self, action: #selector(MPDatePicker.dismissView(sender:)), for: .touchUpInside)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        let cancelSize = cancelButton.sizeThatFits(CGSize(width: 0, height: 44.0)).width + 20.0
        cancelButton.frame = CGRect(x: 0, y: 0, width: cancelSize, height: 44)
        titleView.addSubview(cancelButton)
        
        todayButton = UIButton(type: .system)
        todayButton.setTitle(todayButtonTitle, for: .normal)
        todayButton.setTitleColor(highlightColor, for: .normal)
        todayButton.addTarget(self, action: #selector(MPDatePicker.setToday), for: .touchUpInside)
        todayButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        todayButton.isHidden = validatdRealTime && (self.minimumDate.compare(Date()) == .orderedDescending || self.maximumDate.compare(Date()) == .orderedAscending)
        let todaySize = todayButton.sizeThatFits(CGSize(width: 0, height: 44.0)).width + 20.0
        todayButton.frame = CGRect(x: contentView.frame.width - todaySize, y: 0, width: todaySize, height: 44)
        titleView.addSubview(todayButton)
        
        // top borders
        borderTopView = UIView(frame: CGRect(x: 0, y: titleView.frame.height, width: titleView.frame.width, height: 1))
        borderTopView.backgroundColor = darkColor.withAlphaComponent(0.2)
        contentView.addSubview(borderTopView)
        
        // done button
        doneButton = UIButton(type: .system)
        doneButton.frame = CGRect(x: 10, y: contentView.frame.height - 10 - 44, width: contentView.frame.width - 20, height: 44)
        doneButton.setTitle(doneButtonTitle, for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor = darkColor.withAlphaComponent(0.5)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        doneButton.layer.cornerRadius = 3
        doneButton.layer.masksToBounds = true
        doneButton.addTarget(self, action: #selector(MPDatePicker.dismissView(sender:)), for: .touchUpInside)
        contentView.addSubview(doneButton)
        
        // datePicker
        datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                y: borderTopView.frame.origin.y - 20,
                                                width: contentView.frame.width,
                                                height: doneButton.frame.origin.y - borderTopView.frame.origin.y + 40))
        datePicker.addTarget(self, action: #selector(MPDatePicker.updateSelectedDate), for: .valueChanged)
        datePicker.date = selectedDate
        if validatdRealTime {
            datePicker.minimumDate = minimumDate
            datePicker.maximumDate = maximumDate
        }
        contentView.insertSubview(datePicker, at: 1)
        
        contentView.isHidden = false
        
        // animate to show contentView
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
            self.contentView.frame = CGRect(x: 0,
                                            y: self.frame.height - self.contentHeight,
                                            width: self.frame.width,
                                            height: self.contentHeight)
        }, completion: nil)
        
    }
    
    @objc private func updateSelectedDate() {
        guard datePicker != nil else {
            return
        }
        selectedDate = datePicker.date
        resetViewTitle()
    }
    
    private func resetViewTitle() {
        guard viewTitleLabel != nil else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        if validatdSelectedDate() {
            viewTitleLabel.text = formatter.string(from: selectedDate)
            updateDoneButton(validated: true)
        } else {
            viewTitleLabel.text = "\(formatter.string(from: minimumDate)) -\n\(formatter.string(from: maximumDate))  "
            updateDoneButton(validated: false)
        }
        //        viewTitleLabel.sizeToFit()
        viewTitleLabel.center = CGPoint(x: contentView.frame.width / 2, y: 22)
    }
    
    @objc func setToday() {
        selectedDate = recommendedDate ?? Date()
        resetTime()
    }
    
    func resetTime() {
        datePicker.date = selectedDate
    }
    
    private func validatdSelectedDate() -> Bool {
        if let minimumDate = self.minimumDate,
            selectedDate.compare(minimumDate) == .orderedAscending {
            return false
        }
        
        if let maximumDate = self.maximumDate,
            selectedDate.compare(maximumDate) == .orderedDescending {
            return false
        }
        return true
    }
    
    private func updateDoneButton(validated: Bool) {
        guard doneButton != nil else {
            return
        }
        if validated {
            doneButton.setTitle(doneButtonTitle, for: .normal)
        } else {
            doneButton.setTitle(invalidTitle, for: .normal)
        }
    }
    
    @objc public func dismissView(sender: UIButton?=nil) {
        if !self.validatdRealTime && !self.validatdSelectedDate() && sender == self.doneButton {
            return
        }
        UIView.animate(withDuration: 0.3, animations: {
            // animate to show contentView
            self.contentView.frame = CGRect(x: 0,
                                            y: self.frame.height,
                                            width: self.frame.width,
                                            height: self.contentHeight)
        }) { (completed) in
            if sender == self.doneButton {
                self.completionHandler?(self.selectedDate)
            } else {
                self.dismissHandler?()
            }
            self.removeFromSuperview()
        }
    }
}

extension Date {
    var dateTrimSeconds: Date {
        let timeInterval = floor(self.timeIntervalSinceReferenceDate / 60.0) * 60
        return Date(timeIntervalSinceReferenceDate: timeInterval)
    }
}

