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
        self.setupFeedbackGenerator()
        self.bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = Date()
        self.calendarView.scrollToDate(date)
        self.calendarView.selectDate(date)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.calendarListView.maskRoundedRect(cornerRadius: 20, corners: [.topLeft, .topRight])
    }
    
    private func bind(_ viewModel: CalendarViewModel) {
        viewModel
            .viewModelEvent
            .withUnretained(self)
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { viewController, event in viewController.handle(event) })
            .disposed(by: self.disposeBag)
    }
    
    private func handle(_ event: CalendarViewModelEvent) {
        switch event {
        case .reloadData:
            self.calendarView.reloadData()
            self.calendarListView.reloadData()
            
        case .reloadDataWithDate(let date):
            self.calendarView.reloadData(date: date)
            
        case .scrollToDate(let date, let animated):
            self.calendarView.scrollToDate(date, animated: animated)
            
        case .selectDates(let date):
            self.calendarView.selectDate(date)
            
        case let .showRecordView(repository, targetDate):
            self.showRecordView(repository: repository, targetDate: targetDate)
            
        case let .showDetailView(repository, entity):
            self.showDetailView(repository: repository, entity: entity)
            
        case .updateEmptyView(let isHidden):
            if isHidden {
                self.calendarListView.hideEmptyView()
            } else {
                self.calendarListView.showEmptyView()
            }
            
        case .updateTitle(let text):
            self.navigationView.updateTitle(text)
            
        case .updateDateTitle(let text):
            self.dateView.showTitle(text)
            
        case .updateTodayButton(let isHidden):
            self.todayView.isHidden = isHidden
        }
    }
    
    private func setupLayout() {
        self.view.addSubview(self.statusView)
        self.statusView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeArea.top)
        }
        
        self.view.addSubview(self.navigationView)
        self.navigationView.snp.makeConstraints { make in
            make.top.equalTo(self.statusView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.view.addSubview(self.calendarView)
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35 * 7)
        }
        
        self.view.addSubview(self.calendarListView)
        self.calendarListView.snp.makeConstraints { make in
            make.top.equalTo(self.calendarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        self.view.addSubview(self.dateView)
        self.dateView.snp.makeConstraints { make in
            make.top.leading.equalTo(self.calendarListView).inset(10)
            make.size.equalTo(CGSize(width: 108, height: 55))
        }
        
        self.view.addSubview(self.createView)
        self.createView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 70, height: 70))
            make.trailing.bottom.equalToSuperview().inset(15)
        }
        
        self.view.addSubview(self.todayView)
        self.todayView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 55))
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    private func setupAttributes() {
        self.view.backgroundColor = .gray0
        
        self.statusView.do {
            $0.backgroundColor = .gray0
        }
        
        self.navigationView.do {
            $0.configure(.init(type: .none))
            $0.backgroundColor = .gray0
            $0.updateTintColor(.blueBlack)
        }
        
        self.calendarView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        
        self.calendarListView.do {
            $0.delegate = self
            $0.dataSource = self
        }
        
        self.dateView.do {
            $0.updateRadius(16)
            $0.updateBackgroundColor(.green2)
            $0.updateTintColor(.white)
            let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .semibold))
            $0.setImage(UIImage(systemName: "calendar.circle.fill", withConfiguration: config)?.withRenderingMode(.alwaysTemplate))
            $0.showTitle("")
        }
        
        self.createView.do {
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
        
        self.todayView.do {
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
    
    private func setupFeedbackGenerator() {
        self.selectionFeedbackGenerator = UISelectionFeedbackGenerator()
        self.selectionFeedbackGenerator?.prepare()
        
        self.impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        self.impactFeedbackGenerator?.prepare()
        
        self.notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        self.notificationFeedbackGenerator?.prepare()
    }
    
    private func selectionChanged() {
        self.selectionFeedbackGenerator?.selectionChanged()
        self.selectionFeedbackGenerator?.prepare()
    }
    
    private func impactOccurred() {
        self.impactFeedbackGenerator?.impactOccurred()
        self.impactFeedbackGenerator?.prepare()
    }
    
    private func notifictaionOccured(type: UINotificationFeedbackGenerator.FeedbackType) {
        self.notificationFeedbackGenerator?.notificationOccurred(type)
    }
    
    @objc private func createViewDidTap(_ sender: UIGestureRecognizer) {
        self.viewModel.createButtonDidTap()
    }
    
    @objc private func todayViewDidTap(_ sender: UIButton) {
        self.viewModel.todayButtonDidTap()
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
    
    private var selectionFeedbackGenerator: UISelectionFeedbackGenerator?
    private var impactFeedbackGenerator: UIImpactFeedbackGenerator?
    private var notificationFeedbackGenerator: UINotificationFeedbackGenerator?
    
    private let statusView = UIView(frame: .zero)
    private let navigationView = NavigationView(frame: .zero)
    private let calendarView = CalendarView(frame: .zero)
    private let calendarListView = CalendarListView(frame: .zero)
    private let dateView = CalendarFloatingView(frame: .zero)
    private let createView = CalendarFloatingView(frame: .zero)
    private let todayView = CalendarFloatingView(frame: .zero)
    private let viewModel: CalendarViewModel
    private let disposeBag = DisposeBag()
    
}

extension CalendarViewController: CalendarViewDelegate {
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        guard let cell = calendar.dequeueReusableCell(cell: CalendarDateCell.self, for: indexPath) else {
            return JTACDayCell()
        }
        let item = self.viewModel.calendarItem(state: cellState)
        cell.configure(item)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        let item = self.viewModel.calendarItem(state: cellState)
        cell.configure(item)
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        let item = self.viewModel.calendarItem(state: cellState)
        cell.configure(item)
        self.viewModel.didSelectDate(date: date)
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? CalendarDateCell else { return }
        let item = self.viewModel.calendarItem(state: cellState)
        cell.configure(item)
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return cellState.dateBelongsTo == .thisMonth
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
            cell.delegate = self
            cell.indexPath = indexPath
            return cell
        }
    }
    
}

extension CalendarViewController: CalendarListTableViewCellDelegate {
    
    func calendarListTableViewCellDidSelectComplete(_ cell: CalendarListTableViewCell, didSelectAt indexPath: IndexPath) {
        self.viewModel.didSelectComplete(at: indexPath)
        self.selectionChanged()
    }
    
}

extension CalendarViewController: RecordViewControllerDelegate {
    
    func recordViewControllerDidFinishRecord(_ viewController: RecordViewController, targetDate: Date) {
        let toastModel = ToastModel(message: "추가되었습니다", type: .success)
        ToastManager.showToast(toastModel)
        self.notifictaionOccured(type: .success)
    }
    
    func recordViewControllerDidFailRecord(_ viewController: RecordViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .fail)
        ToastManager.showToast(toastModel)
        self.notifictaionOccured(type: .error)
    }
    
    func recordViewControllerDidCancelRecord(_ viewController: RecordViewController) {
        print("## recordViewControllerDidCancelRecord")
    }
    
}

extension CalendarViewController: TodoDetailViewControllerDelegate {
    
    func todoDetailViewControllerDidFinish(_ viewController: TodoDetailViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .success)
        ToastManager.showToast(toastModel)
        self.notifictaionOccured(type: .success)
    }
    
    func todoDetailViewControllerDidFail(_ viewController: TodoDetailViewController, message: String) {
        let toastModel = ToastModel(message: message, type: .fail)
        ToastManager.showToast(toastModel)
        self.notifictaionOccured(type: .error)
    }
    
}

extension CalendarViewController: TopScrollable {
    
    func scrollToTop() {
        self.calendarListView.scrollToTop()
    }
    
}
