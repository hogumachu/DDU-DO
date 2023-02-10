//
//  CalendarViewController.swift
//  DDU-DO
//
//  Created by 홍성준 on 2023/01/21.
//

import UIKit
import SnapKit
import Then
import JTAppleCalendar
import RxSwift

final class CalendarViewController: UIViewController {
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setupLayout()
        self.setupAttributes()
        self.bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        self.calendarView.scrollToDate(date)
        self.calendarView.selectDates([date])
    }
    
    private func bind(_ viewModel: CalendarViewModel) {
        viewModel
            .viewModelEvent
            .withUnretained(self)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: CalendarViewModelEvent) {
        switch event {
        case .reloadData:
            self.calendarListView.reloadData()
            
        case .reloadDataWithDate(let date):
            self.calendarView.reloadData(date: date)
            
        case let .showRecordView(repository, targetDate):
            self.showRecordView(repository: repository, targetDate: targetDate)
            
        case let .showDetailView(repository, entity):
            self.showDetailView(repository: repository, entity: entity)
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(self.statusView)
        self.statusView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeArea.top)
        }
        
        self.view.addSubview(self.calendarView)
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.statusView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35 * 7)
        }
        
        self.view.addSubview(self.calendarListView)
        self.calendarListView.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.view.addSubview(self.createButton)
        self.createButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 40, height: 40))
            make.trailing.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func setupAttributes() {
        self.statusView.do {
            $0.backgroundColor = .white
        }
        
        self.calendarView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
        }
        
        self.calendarListView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .white
        }
        
        self.createButton.do {
            $0.layer.cornerRadius = 40 / 2
            $0.backgroundColor = .systemOrange
            $0.addTarget(self, action: #selector(createButtonDidTap(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func createButtonDidTap(_ sender: UIButton) {
        self.viewModel.createButtonDidTap()
    }
    
    private func showRecordView(repository: TodoRepository<TodoEntity>, targetDate: Date) {
        let recordViewModel = RecordViewModel(todoRepository: repository, targetDate: targetDate)
        let recordViewController = RecordViewController(viewModel: recordViewModel)
        recordViewController.delegate = self
        recordViewController.presentWithAnimation(from: self)
    }
    
    private func showDetailView(repository: TodoRepository<TodoEntity>, entity: TodoEntity) {
        let detailViewModel = TodoDetailViewModel(repository: repository, entity: entity)
        let detailViewController = TodoDetailViewController(viewModel: detailViewModel)
        detailViewController.presentWithAnimation(from: self)
        detailViewController.delegate = self
    }
    
    private let statusView = UIView(frame: .zero)
    private let calendarView = CalendarView(frame: .zero)
    private let calendarListView = CalendarListView(frame: .zero)
    private let createButton = UIButton(frame: .zero)
    private let viewModel: CalendarViewModel
    private let disposeBag = DisposeBag()
    
}

extension CalendarViewController: CalendarViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableCell(cell: CalendarDateCell.self, for: indexPath) else {
            return JTACDayCell()
        }
        cell.configure(cellState)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.configure(cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.configure(cellState)
        self.viewModel.didSelectDate(date: date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        cell.configure(cellState)
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return cellState.dateBelongsTo == .thisMonth
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        guard let view = calendar.dequeueReusableView(view: CalendarDateHeaderView.self, for: indexPath) else { return JTACMonthReusableView() }
        let formatter = DateFormatter().then {
            $0.dateFormat = "yyyy년 MM월"
            $0.locale = Locale(identifier: "ko_kr")
        }
        view.configure(formatter.string(from: range.start))
        return view
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        return MonthSize(defaultSize: 60)
    }
    
    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let date = visibleDates.monthDates.first?.date else { return }
        self.viewModel.willDisplay(date: date)
    }
    
}

extension CalendarViewController: CalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        return ConfigurationParameters(
            startDate: self.viewModel.startDate,
            endDate: self.viewModel.endDate,
            numberOfRows: 6,
            generateInDates: .forAllMonths,
            generateOutDates: .tillEndOfRow,
            hasStrictBoundaries: true
        )
    }
    
}

extension CalendarViewController: CalendarListViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didSelectRow(at: indexPath)
    }
    
}

extension CalendarViewController: CalendarListViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.viewModel.cellItem(at: indexPath) else { return UITableViewCell() }
        
        switch item {
        case .content(let model, _):
            guard let cell = tableView.dequeueReusableCell(cell: CalendarListTableViewCell.self, for: indexPath) else { return UITableViewCell() }
            cell.configure(model)
            return cell
        }
    }
    
}

extension CalendarViewController: RecordViewControllerDelegate {
    
    func recordViewControllerDidFinishRecord(_ viewController: RecordViewController, targetDate: Date) {
        let toastModel = ToastModel(message: "추가되었습니다", type: .success)
        ToastManager.showToast(toastModel)
    }
    
    func recordViewControllerDidFailRecord(_ viewController: RecordViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .fail)
        ToastManager.showToast(toastModel)
    }
    
    func recordViewControllerDidCancelRecord(_ viewController: RecordViewController) {
        print("## recordViewControllerDidCancelRecord")
    }
    
}

extension CalendarViewController: TodoDetailViewControllerDelegate {
    
    func todoDetailViewControllerDidFinish(_ viewController: TodoDetailViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .success)
        ToastManager.showToast(toastModel)
    }
    
    func todoDetailViewControllerDidFail(_ viewController: TodoDetailViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .fail)
        ToastManager.showToast(toastModel)
    }
    
}
