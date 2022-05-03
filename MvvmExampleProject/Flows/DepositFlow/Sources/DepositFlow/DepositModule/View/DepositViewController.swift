//
//  Copyright © Surf. All rights reserved.
//

import UIKit
import Library
import Combine

final class DepositViewController<ViewModel: DepositViewModel>: UIViewController {

    // MARK: - Nested Types

    private enum Constants {
        static var openDepositButtonHeight: CGFloat { 48 }
    }

    // MARK: - Private Properties

    private var viewModel: ViewModel?
    private let tableView = TableViewWithCancelEditingRecognizer()
    private let openDepositButton = BlackButton(type: .system)
    private lazy var adapter = tableView.rddm.baseBuilder.build()
    private var cancellableEventsContainer: Set<AnyCancellable> = []
    private let availableDepositTerms: [DepositTerms] = [
        .threeMounth,
        .sixMounth,
        .nineMounth,
        .oneYear,
        .oneAndHalfYear
    ]

    private let availableDepositConditions: [DepositCondition] = [
        .withReplenishCondition,
        .withWithdrawCondition,
        .withPercentCondition
    ]

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
        fillAdapter()
    }

    // MARK: - Internal Methods

    func setViewModel(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

}

// MARK: - Generators

private extension DepositViewController {

    func fillAdapter() {
        let generators: [TableCellGenerator] = [
            getVerticalSpaceGenerator(height: 14),
            getDepositSumCellGenerator(),
            getVerticalSpaceGenerator(height: 32),
            getDepositTermCellGenerator(),
            getVerticalSpaceGenerator(height: 32),
            getDepositConditionsCellGenerator(),
            getVerticalSpaceGenerator(height: 32),
            getDepositInfoBannerCellGenerator()
        ]
        adapter.addCellGenerators(generators)
    }

    func getDepositSumCellGenerator() -> TableCellGenerator {
        let model = DepositSumCell.Model(
            title: "Сумма депозита",
            state: .common(text: "От 15 000 ₽")
        )
        model.sumDidChangePublisher
            .sink { _ in }
            .store(in: &cancellableEventsContainer)
        let depositSumCellGenerator = BaseNonReusableCellGenerator<DepositSumCell>(with: model)
        return depositSumCellGenerator
    }

    func getDepositTermCellGenerator() -> TableCellGenerator {
        let termModels: [DepositTermCell.TermModel] = availableDepositTerms.map { term in
            let model = DepositTermCell.TermModel(title: term.title)
            model.selectEventPublisher
                .sink { _ in }
                .store(in: &cancellableEventsContainer)
            return model
        }
        let model = DepositTermCell.Model(title: "Срок", terms: termModels)
        let depositTermCellGenerator = BaseNonReusableCellGenerator<DepositTermCell>(with: model)
        return depositTermCellGenerator
    }

    func getDepositConditionsCellGenerator() -> TableCellGenerator {
        let conditions: [DepositConditionsCell.ConditionModel] = availableDepositConditions.map { condition in
            let model = DepositConditionsCell.ConditionModel(
                title: condition.title,
                description: condition.description
            )
            model.selectEventPublisher
                .sink { _ in }
                .store(in: &cancellableEventsContainer)
            return model
        }
        let depositConditionCellGenerator = BaseNonReusableCellGenerator<DepositConditionsCell>(
            with: .init(conditions: conditions)
        )
        return depositConditionCellGenerator
    }

    func getDepositInfoBannerCellGenerator() -> TableCellGenerator {
        let model = DepositCalculatorBannerCell.Model(
            percent: 17.62,
            amount: 30456.6
        )
        let depositBannerCellGenerator = BaseNonReusableCellGenerator<DepositCalculatorBannerCell>(
            with: model
        )
        return depositBannerCellGenerator
    }

    func getVerticalSpaceGenerator(height: CGFloat) -> TableCellGenerator {
        let verticalSpaceCellGenerator = BaseNonReusableCellGenerator<VerticalSpaceCell>(with: .init(height: height))
        return verticalSpaceCellGenerator
    }

}

// MARK: - Private Methods

private extension DepositViewController {

    func setupInitialState() {
        view.backgroundColor = .white

        configureTableView()
        configureOpenDepositButton()
        configureNavigationBar()
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.contentInset.bottom = Constants.openDepositButtonHeight
        tableView.sectionHeaderTopPadding = .zero
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    func configureOpenDepositButton() {
        view.addSubview(openDepositButton)
        openDepositButton.translatesAutoresizingMaskIntoConstraints = false
        openDepositButton.setTitle("Открыть вклад", for: .normal)
        openDepositButton.tapEventPublisher
            .sink { _ in }
            .store(in: &cancellableEventsContainer)

        NSLayoutConstraint.activate([
            openDepositButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            openDepositButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            openDepositButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            openDepositButton.heightAnchor.constraint(equalToConstant: Constants.openDepositButtonHeight)
        ])
    }

    func configureNavigationBar() {
        title = "Вклад"
    }

}
