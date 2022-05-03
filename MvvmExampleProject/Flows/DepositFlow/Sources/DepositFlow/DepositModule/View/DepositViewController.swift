//
//  Copyright © Surf. All rights reserved.
//

import UIKit
import Library
import Combine

final class DepositViewController<ViewModel: DepositViewModel>: UIViewController {

    // MARK: - Private Properties

    private var viewModel: ViewModel?
    private let tableView = UITableView()
    private lazy var adapter = tableView.rddm.baseBuilder.build()
    private var cancellableEventsContainer: Set<AnyCancellable> = []
    private let availableDepositTerms: [DepositTerms] = [
        .threeMounth,
        .sixMounth,
        .nineMounth,
        .oneYear,
        .oneAndHalfYear
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
            getDepositTermCellGenerator()
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
        configureNavigationBar()
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    func configureNavigationBar() {
        title = "Вклад"
    }

}
