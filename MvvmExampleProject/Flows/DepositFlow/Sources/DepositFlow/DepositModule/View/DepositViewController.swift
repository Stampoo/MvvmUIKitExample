//
//  Copyright © Surf. All rights reserved.
//

import UIKit
import Library
import Combine

final class DepositViewController<ViewModel: DepositViewOutput>: UIViewController {

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

    // MARK: - Internal Methods

    func setViewModel(_ viewModel: ViewModel) {
        self.viewModel = viewModel
        setupInitialState()
        subscribeOnViewModelEvents()
        viewModel.didEventTriggered(.viewDidLoad)
    }

}

// MARK: - Generators

private extension DepositViewController {

    func subscribeOnViewModelEvents() {
        viewModel?.infoPreinitPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: fillAdapter(from:))
            .store(in: &cancellableEventsContainer)
    }

    func fillAdapter(from model: DepositInformationPreinitModel) {
        let generators: [TableCellGenerator] = [
            getVerticalSpaceGenerator(height: 14),
            getDepositSumCellGenerator(),
            getVerticalSpaceGenerator(height: 32),
            getDepositTermCellGenerator(terms: model.availableDepositTerms),
            getVerticalSpaceGenerator(height: 32),
            getDepositConditionsCellGenerator(conditions: model.availableDepositConditions),
            getVerticalSpaceGenerator(height: 32),
            getDepositInfoBannerCellGenerator()
        ]
        adapter.addCellGenerators(generators)
        adapter.forceRefill()
    }

    func getDepositSumCellGenerator() -> TableCellGenerator {
        var model = DepositSumCell.Model(
            title: "Сумма депозита",
            state: .common(text: "")
        )
        model.sumDidChangePublisher
            .sink { [weak self] newSum in
                self?.viewModel?.didEventTriggered(.sumDidChanged(newSum))
            }
            .store(in: &cancellableEventsContainer)
        let depositSumCellGenerator = BaseNonReusableCellGenerator<DepositSumCell>(with: model)

        viewModel?.depositSumValidationPublisher
            .sink { validationResult in
                validationResult.isValid
                    ? model.set(state: .common(text: validationResult.description))
                    : model.set(state: .error(text: validationResult.description))
                depositSumCellGenerator.update(model: model)
            }
            .store(in: &cancellableEventsContainer)
        return depositSumCellGenerator
    }

    func getDepositTermCellGenerator(terms: [DepositTerm]) -> TableCellGenerator {
        let termModels: [DepositTermCell.TermModel] = terms.map { term in
            let model = DepositTermCell.TermModel(title: term.title)
            model.selectEventPublisher
                .sink { [weak self] _ in
                    self?.viewModel?.didEventTriggered(.termDidChanged(term.termInMonth))
                }
                .store(in: &cancellableEventsContainer)
            return model
        }
        let model = DepositTermCell.Model(title: "Срок", terms: termModels)
        let depositTermCellGenerator = BaseNonReusableCellGenerator<DepositTermCell>(with: model)
        return depositTermCellGenerator
    }

    func getDepositConditionsCellGenerator(conditions: [DepositCondition]) -> TableCellGenerator {
        let depositConditionCellGenerator = BaseNonReusableCellGenerator<DepositConditionsCell>(
            with: getDepositConditionsGeneratorModels(conditions: conditions)
        )
        viewModel?.depositConditionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] conditions in
                guard let self = self else {
                    return
                }
                depositConditionCellGenerator.update(
                    model: self.getDepositConditionsGeneratorModels(conditions: conditions)
                )
            }
            .store(in: &cancellableEventsContainer)
        return depositConditionCellGenerator
    }

    func getDepositInfoBannerCellGenerator() -> TableCellGenerator {
        let model = DepositCalculatorBannerCell.Model(
            percent: .zero,
            amount: .zero
        )
        let depositBannerCellGenerator = BaseNonReusableCellGenerator<DepositCalculatorBannerCell>(
            with: model
        )
        viewModel?.depositInfoPublisher
            .receive(on: DispatchQueue.main)
            .sink { newBannerInfo in
                depositBannerCellGenerator.update(
                    model: .init(percent: newBannerInfo.percent, amount: newBannerInfo.amount)
                )
            }
            .store(in: &cancellableEventsContainer)
        return depositBannerCellGenerator
    }

    func getVerticalSpaceGenerator(height: CGFloat) -> TableCellGenerator {
        let verticalSpaceCellGenerator = BaseNonReusableCellGenerator<VerticalSpaceCell>(with: .init(height: height))
        return verticalSpaceCellGenerator
    }

}

// MARK: - Models for generators

private extension DepositViewController {

    func getDepositConditionsGeneratorModels(conditions: [DepositCondition]) -> DepositConditionsCell.Model {
        let conditions: [DepositConditionsCell.ConditionModel] = conditions.map { condition in
            let model = DepositConditionsCell.ConditionModel(
                title: condition.title,
                description: condition.description,
                state:  condition.isDisabled ? .cannotBeChosen : condition.isSelected ? .selected : .canBeChosen
            )
            model.selectEventPublisher
                .sink { [weak viewModel] _ in
                    viewModel?.didEventTriggered(.conditionDidChanged(condition))
                }
                .store(in: &cancellableEventsContainer)
            return model
        }
        return .init(conditions: conditions)
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
            .sink { [weak viewModel] _ in
                viewModel?.didEventTriggered(.openDepositDidPressed)
            }
            .store(in: &cancellableEventsContainer)
        viewModel?.openDepositPossibilityPublisher
            .assign(to: \.isEnabled, on: openDepositButton)
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
