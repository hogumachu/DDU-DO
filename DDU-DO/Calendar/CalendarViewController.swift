//
//  CalendarViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/10/21.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import Then
import JTAppleCalendar

protocol CalendarDataSource: AnyObject {
    var startDate: Date { get }
    var endDate: Date { get }
    func calendarItem(state: CellState) -> CalendarDateCellModel
}

protocol CalendarPresentableListener: AnyObject {
    func didTapCreate()
    func didTapToday()
    func didSelect(at indexPath: IndexPath)
    func didSelect(date: Date)
    func didSelectComplete(at indexPath: IndexPath)
    func willDisplay(date: Date)
}

final class CalendarViewController: UIViewController, CalendarPresentable, CalendarViewControllable {
    
    weak var listener: CalendarPresentableListener?
    
    weak var calendarDataSource: CalendarDataSource?
    
    private let statusView = UIView(frame: .zero)
    private let navigationView = NavigationView(frame: .zero)
    private let calendarView = CalendarView(frame: .zero)
    private let calendarListView = CalendarListView(frame: .zero)
    private let dateView = CalendarFloatingView(frame: .zero)
    private let createView = CalendarFloatingView(frame: .zero)
    private let todayView = CalendarFloatingView(frame: .zero)
    
    private var sections: [CalendarSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupAttributes()
    }
    
    func updateSections(_ sections: [CalendarSection]) {
        self.sections = sections
        calendarView.reloadData()
        calendarListView.reloadData()
    }
    
    func reloadData(date: Date) {
        calendarView.reloadData(date: date)
    }
    
    func updateTitle(_ title: String) {
        navigationView.updateTitle(title)
    }
    
    private func setupLayout() {
        view.addSubview(statusView)
        statusView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeArea.top)
        }
        
        view.addSubview(navigationView)
        navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.statusView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35 * 7)
        }
        
        view.addSubview(calendarListView)
        calendarListView.snp.makeConstraints { make in
            make.top.equalTo(calendarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(dateView)
        dateView.snp.makeConstraints { make in
            make.top.leading.equalTo(calendarListView).inset(10)
            make.size.equalTo(CGSize(width: 108, height: 55))
        }
        
        view.addSubview(createView)
        createView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 70))
            make.trailing.bottom.equalToSuperview().inset(15)
        }
        
        view.addSubview(todayView)
        todayView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 55))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setupAttributes() {
        view.backgroundColor = .gray0
        
        statusView.do {
            $0.backgroundColor = .gray0
        }
        
        navigationView.do {
            $0.configure(.init(type: .none))
            $0.backgroundColor = .gray0
            $0.updateTintColor(.blueBlack)
        }
        
        calendarView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        
        calendarListView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        
        dateView.do {
            $0.updateRadius(16)
            $0.updateBackgroundColor(.green2)
            $0.updateTintColor(.white)
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .semibold))
            $0.setImage(UIImage(systemName: "calendar.circle.fill", withConfiguration: config)?.withRenderingMode(.alwaysTemplate))
            $0.showTitle("")
        }
        
        createView.do {
            $0.updateRadius(25)
            $0.updateBackgroundColor(.green2)
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .heavy))
            $0.setImage(UIImage(systemName: "plus", withConfiguration: config)?.withRenderingMode(.alwaysTemplate))
            $0.updateTintColor(.white)
            $0.hideTitle()
            $0.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(createViewDidTap(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
        
        todayView.do {
            $0.updateRadius(16)
            $0.updateBackgroundColor(.gray2)
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 13, weight: .heavy))
            $0.setImage(UIImage(systemName: "arrow.up", withConfiguration: config)?.withRenderingMode(.alwaysTemplate))
            $0.updateTintColor(.blueBlack)
            $0.showTitle("오늘")
            $0.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(todayViewDidTap(_:)))
            $0.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc private func createViewDidTap(_ sender: UIGestureRecognizer) {
        listener?.didTapCreate()
    }
    
    @objc private func todayViewDidTap(_ sender: UIButton) {
        listener?.didTapToday()
    }
    
}

extension CalendarViewController: CalendarViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableCell(cell: CalendarDateCell.self, for: indexPath),
              let item = calendarDataSource?.calendarItem(state: cellState)
        else {
            return JTACDayCell()
        }
        cell.configure(item)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell,
              let item = calendarDataSource?.calendarItem(state: cellState)
        else {
            return
        }
        cell.configure(item)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell, let item = calendarDataSource?.calendarItem(state: cellState) else { return }
        cell.configure(item)
        listener?.didSelect(date: date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell, let item = calendarDataSource?.calendarItem(state: cellState) else { return }
        cell.configure(item)
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return cellState.dateBelongsTo == .thisMonth
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        listener?.willDisplay(date: date)
    }
    
}

extension CalendarViewController: CalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let startDate = calendarDataSource?.startDate ?? Date()
        let endDate = calendarDataSource?.endDate ?? Date()
        return ConfigurationParameters(
            startDate: startDate,
            endDate: endDate,
            numberOfRows: 6,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfRow,
            hasStrictBoundaries: true
        )
    }
    
}

extension CalendarViewController: CalendarListViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.didSelect(at: indexPath)
    }
    
}

extension CalendarViewController: CalendarListViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = sections[safe: indexPath.section]?.items[safe: indexPath.row] else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(cell: CalendarListTableViewCell.self, for: indexPath)
        cell.configure(item.model)
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    
}

extension CalendarViewController: CalendarListTableViewCellDelegate {
    
    func calendarListTableViewCellDidSelectComplete(_ cell: CalendarListTableViewCell, didSelectAt indexPath: IndexPath) {
        listener?.didSelectComplete(at: indexPath)
    }
    
}

extension CalendarViewController: RecordViewControllerDelegate {
    
    func recordViewControllerDidFinishRecord(_ viewController: RecordViewController, targetDate: Date) {
        //        let toastModel = ToastModel(message: "추가되었습니다", type: .success)
        //        ToastManager.showToast(toastModel)
        //        self.notifictaionOccured(type: .success)
    }
    
    func recordViewControllerDidFailRecord(_ viewController: RecordViewController, message: String) {
        //        let toastModel = ToastModel(message: message, type: .fail)
        //        ToastManager.showToast(toastModel)
        //        self.notifictaionOccured(type: .error)
    }
    
    func recordViewControllerDidCancelRecord(_ viewController: RecordViewController) {
        print("## recordViewControllerDidCancelRecord")
    }
    
}

extension CalendarViewController: TodoDetailViewControllerDelegate {
    
    func todoDetailViewControllerDidFinish(_ viewController: TodoDetailViewController, message: String) {
        //        let toastModel = ToastModel(message: message, type: .success)
        //        ToastManager.showToast(toastModel)
        //        self.notifictaionOccured(type: .success)
    }
    
    func todoDetailViewControllerDidFail(_ viewController: TodoDetailViewController, message: String) {
        //        let toastModel = ToastModel(message: message, type: .fail)
        //        ToastManager.showToast(toastModel)
        //        self.notifictaionOccured(type: .error)
    }
    
}

extension CalendarViewController: TopScrollable {
    
    func scrollToTop() {
        calendarListView.scrollToTop()
    }
    
}
