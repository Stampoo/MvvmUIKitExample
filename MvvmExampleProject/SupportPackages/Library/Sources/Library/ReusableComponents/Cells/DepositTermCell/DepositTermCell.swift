//
//  DepositTermCell.swift
//  
//
//  Created by Князьков Илья on 02.05.2022.
//

import UIKit
import Core
import Combine

public final class DepositTermCell: UITableViewCell, ConfigurableItem {

    // MARK: - Nested Types

    public struct Model {
        let title: String
        let terms: [TermModel]

        public init(title: String, terms: [TermModel]) {
            self.title = title
            self.terms = terms
        }
    }

    public struct TermModel {
        let title: String
        let selectEventTransceiver = BaseEventTransceiver<Void, Never>()

        public var selectEventPublisher: AnyPublisher<Void, Never> {
            selectEventTransceiver.publisher.eraseToAnyPublisher()
        }
        public init(title: String) {
            self.title = title
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Private Properties

    private lazy var adapter = collectionView.rddm.baseBuilder.build()
    private var cancellableEventsContainer: Set<AnyCancellable> = []

    // MARK: - UITableViewCell

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    // MARK: - ConfigurableItem

    public func configure(with model: Model) {
        titleLabel.text = model.title
        adapter.clearCellGenerators()
        let generators: [CollectionCellGenerator] = model.terms.map { term in
            let termModel = DepositTermItemCollectionCell.Model(title: term.title)
            termModel.selectEventPublisher
                .sink(receiveValue: term.selectEventTransceiver.send(newValue:))
                .store(in: &cancellableEventsContainer)
            let generator = BaseCollectionCellGenerator<DepositTermItemCollectionCell>(with: termModel)
            return generator
        }
        adapter.addCellGenerators(generators)
    }

    public static func bundle() -> Bundle? {
        Bundle.module
    }

}

// MARK: - Private Methods

private extension DepositTermCell {

    func setupInitialState() {
        configureTitleLabel()
    }

    func configureTitleLabel() {
        titleLabel.textColor = .systemGray
        titleLabel.font = .systemFont(ofSize: 14)
    }

}


