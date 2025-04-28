//
//  UIDriverAvailabilityViewController.swift
//  XPDriver
//
//  Created by Waseem  on 21/10/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftDate

fileprivate enum SelectionType {
    case Single, Multi, Range
}

enum DriverAvailabilityStatus: Int {
    case Available = 0, NotAvailable
}

class UIDriverAvailabilityViewController: UIViewController, DriverAvailabilityOperations {
    
    //MARK: - IBOutlet -
    
    @IBOutlet weak var calendarView: JTACMonthView!
    @IBOutlet weak var driverSegment: UISegmentedControl!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewFirst: UIView!
    @IBOutlet weak var viewSec: UIView!
    @IBOutlet weak var viewThird: UIView!
    @IBOutlet weak var lblFirst: UILabel!
    @IBOutlet weak var lblSec: UILabel!
    @IBOutlet weak var lblThird: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblMon: UILabel!
    @IBOutlet weak var lblTue: UILabel!
    @IBOutlet weak var lblWed: UILabel!
    @IBOutlet weak var lblThu: UILabel!
    @IBOutlet weak var lblFri: UILabel!
    @IBOutlet weak var lblSat: UILabel!
    @IBOutlet weak var lblSun: UILabel!
    
    @IBOutlet weak var viewSubmit: UIView!
    
    //MARK: - Variables -
    
    var viewModel = DriverAvailabilityViewModel()
    private var type: SelectionType = .Single
    
    var fromDate: Date? = nil
    var toDate: Date?
    var arrayMulti: [Date] = []
    let df = DateFormatter()
    var twoDatesAlreadySelected: Bool {
        return fromDate != nil && calendarView.selectedDates.count > 1
    }
    var selectedColor = UIColor.white
    var normalTextColor = UIColor(hex: 0x0A0A0A)
    var handlerSelectedDates: ((Date?, Date?)->())? = nil
    
    var selectedLocation: JSON = JSON([:])
    var forTheMonth: Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driverSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        driverSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        df.dateFormat = "yyyy-MM-dd"
        
        viewModel.delegate = self
        
        configTabs()
        
        self.navigationItem.title = "Availability"
        
        lblLocation.text = "Select Location"
        lblLocation.textColor = .gray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.strMonth = Date().toFormat("yyyy-MM")
        viewModel.getAvailability()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.minimumZoomScale = 0
    }
    
    func setupCalendarLabel(date: Date) {
        forTheMonth = date
        
        df.dateFormat = "MMM yyyy"
        lblTitle.text = df.string(from: date)
        df.dateFormat = "yyyy-MM"
        viewModel.strMonth = df.string(from: date)
        viewModel.getAvailability()
        df.dateFormat = "yyyy-MM-dd"
    }
    
    func handleConfiguration(cell: JTACDayCell?, cellState: CellState) {
        guard let cell = cell as? CalenderCell else { return }
        
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
        
        configBottomOptions()
    }
    
    func handleCellColor(cell: CalenderCell, cellState: CellState) {
        cell.borderWidth = 0
        cell.dayLabel.textColor = normalTextColor
        if cellState.dateBelongsTo == .thisMonth {
            cell.isHidden = false
        } else {
            cell.isHidden = true
        }
    }
    
    func handleCellSelection(cell: CalenderCell, cellState: CellState) {
        
        let date = cellState.date
        
        cell.selectedView.isHidden = true
        cell.viewRightSide.isHidden = true
        cell.viewLeftSide.isHidden = true
        cell.viewMiddle.isHidden = true
        cell.viewMiddleForLineIssue.isHidden = true
        cell.viewMiddle.setCornerRadius(cornerRadius: 0)
        cell.selectedView.setCornerRadius(cornerRadius: Double(cell.selectedView.frame.size.height) / 2.0)
        
        let handlerSelected = {
            cell.dayLabel.textColor = self.selectedColor
        }
        
        let weekDay = Calendar.current.component(.weekday, from: date)
        
        if let from = fromDate, let end = toDate {
            if date == from {
                handlerSelected()
                cell.selectedView.isHidden = false
                cell.viewRightSide.isHidden = false
                
            } else if date == end {
                handlerSelected()
                cell.selectedView.isHidden = false
                cell.viewLeftSide.isHidden = false
            } else if date > from && date < end {
                cell.viewMiddle.isHidden = false
                if weekDay == 2 {
                    cell.viewMiddle.setCornerRadius(cornerRadius: Double(cell.viewMiddle.frame.height) / 2.0, corners: [.TopLeft, .BottomLeft])
                } else if weekDay == 1 {
                    cell.viewMiddle.setCornerRadius(cornerRadius: Double(cell.viewMiddle.frame.height) / 2.0, corners: [.TopRight, .BottomRight])
                } else {
                    cell.viewMiddleForLineIssue.isHidden = false
                }
            }
        } else if let from = fromDate, toDate == nil, from == cellState.date {
            handlerSelected()
            cell.selectedView.isHidden = false
        } else {
            if type == .Multi {
                arrayMulti.forEach({ dt in
                    if dt == cellState.date {
                        handlerSelected()
                        cell.selectedView.isHidden = false
                    }
                })
            }
        }
        
        let strDate = cellState.date.in(region: .local).toFormat("yyyy-MM-dd")
        cell.viewBorder.isHidden = true
        if let first = viewModel.arrayAvailability.filter({$0["date"].stringValue == strDate}).first {
            if first["status"].stringValue == "not-available" {
                cell.dayLabel.textColor = .white
                cell.viewBorder.isHidden = false
                cell.viewBorder.backgroundColor = .systemRed
            } else if first["status"].stringValue == "available" {
                cell.dayLabel.textColor = .white
                cell.viewBorder.isHidden = false
                cell.viewBorder.backgroundColor = UIColor(hex: "#619F32")
            }
        }
    }
    
    func configTabs() {
        
        viewFirst.backgroundColor = type == .Single ? UIColor(hex: "#394158") : .clear
        viewSec.backgroundColor = type == .Multi ? UIColor(hex: "#394158") : .clear
        viewThird.backgroundColor = type == .Range ? UIColor(hex: "#394158") : .clear
        
        lblFirst.textColor = type == .Single ? .white :.black
        lblSec.textColor = type == .Multi ? .white : .black
        lblThird.textColor = type == .Range ? .white : .black
        
        fromDate = nil
        toDate = nil
        arrayMulti = []
        
        calendarView.deselectAllDates()
        
        calendarView.allowsMultipleSelection = [.Multi, .Range].contains(type)
        calendarView.allowsRangedSelection = type == .Range
        calendarView.rangeSelectionMode = .continuous
        
        self.calendarView.scrollToDate(forTheMonth, animateScroll: false)
        
        configBottomOptions()
        
        configWeekDays()
        calendarView.reloadData()
    }
    
    //MARK: - IBAction -
    
    @IBAction func onClickFirst() {
        print("OnClickDone")
        type = .Single
        configTabs()
    }
    
    @IBAction func onClickSec() {
        print("OnClickDone")
        type = .Multi
        configTabs()
    }
    
    @IBAction func onClickThird() {
        print("OnClickDone")
        type = .Range
        configTabs()
    }
    
    @IBAction func onClickLocationDropDown() {
        let controller = UIDriverAttachedLocationsPopupViewController()
        controller.arrayLocations = viewModel.arrayLocations
        controller.selected = selectedLocation
        controller.handler = { location in
            self.selectedLocation = location
            self.lblLocation.text = location["name"].stringValue
            self.lblLocation.textColor = .black
            
            self.configBottomOptions()
            self.configWeekDays()
        }
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func onClickSubmit() {
        let status = driverSegment.selectedSegmentIndex == 0 ? "available" : "not-available"
        
        viewModel.addDriverAvailability(status: status, calendarView.selectedDates)
    }
    
    func configWeekDays() {
        selectedLocation["delivery_schedule"].arrayValue.forEach({ item in
            let special = item["special"].stringValue
            switch item["day"].stringValue {
            case "Monday":
                configLabel(status: special, &lblMon)
            case "Tuesday":
                configLabel(status: special, &lblTue)
            case "Wednesday":
                configLabel(status: special, &lblWed)
            case "Thursday":
                configLabel(status: special, &lblThu)
            case "Friday":
                configLabel(status: special, &lblFri)
            case "Saturday":
                configLabel(status: special, &lblSat)
            case "Sunday":
                configLabel(status: special, &lblSun)
            default:
                print("** wk nothing")
            }
        })
    }
    
    func configLabel(status: String, _ label: inout UILabel) {
        label.borderWidth = 0
        if status == "open" {
            label.borderWidth = 2
        }
    }
    
    func configBottomOptions() {
        var status = false
        if type == .Single {
            if fromDate != nil {
                status = true
            }
        } else if type == .Multi {
            if !arrayMulti.isEmpty {
                status = true
            }
        } else if type == .Range {
            if fromDate != nil && toDate != nil {
                status = true
            }
        }
        
        viewSubmit.alpha = status ? 1.0 : 0.5
        viewSubmit.isUserInteractionEnabled = status
    }
    
    //MARK: - DriverAvailabilityOperations -
    
    func showLoading() {
        self.showHud()
    }
    
    func hideLoading() {
        self.hideHud()
    }
    
    func showErrorMessage(message: String) {
    }
    
    func reloadData() {
        configWeekDays()
        fromDate = nil
        toDate = nil
        arrayMulti = []
        self.calendarView.reloadData()
    }
    
}

typealias CalenderCell = UIJTItemCell
extension UIDriverAvailabilityViewController: JTACMonthViewDelegate, JTACMonthViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        
        let startDate = (Date() - 5.years).dateAt(.startOfMonth)
        let endDate = (Date() + 5.years).dateAt(.endOfMonth)
        
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .monday)
        return parameter
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell:CalenderCell = calendar.cell(for: indexPath)
        cell.dayLabel.text = cellState.text
        df.dateFormat = "EEEE, MMM d, yyyy"
        cell.dayLabel.accessibilityLabel = df.string(from: date)
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupCalendarLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if type == .Single {
            fromDate = date
        } else if type == .Multi {
            var isAdd = true
            arrayMulti = arrayMulti.map({ dt in
                if dt == date {
                    isAdd = false
                    return nil
                }
                return dt
            }).compactMap({$0})
            
            if isAdd {
                arrayMulti.append(date)
            }
        } else if type == .Range {
            if let from = fromDate, from != date {
                
                if from > date {
                    toDate = fromDate
                    fromDate = date
                } else {
                    toDate = date
                }
                calendar.selectDates(from: fromDate!, to: toDate!,  triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: true)
            } else {
                fromDate = date
            }
        }
        
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        if type == .Single {
            fromDate = nil
            calendarView.deselectAllDates()
        } else if type == .Multi {
            
        } else if type == .Range {
            if twoDatesAlreadySelected && cellState.selectionType != .programatic {
                fromDate = nil
                toDate = nil
                let retval = !calendarView.selectedDates.contains(date)
                calendarView.deselectAllDates()
                return retval
            }
        }
        
        return true
    }
    
    func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        if type == .Range {
            if twoDatesAlreadySelected && cellState.selectionType != .programatic {
                fromDate = nil
                toDate = nil
                calendarView.deselectAllDates()
                return false
            }
        }
        
        return true
    }
}
