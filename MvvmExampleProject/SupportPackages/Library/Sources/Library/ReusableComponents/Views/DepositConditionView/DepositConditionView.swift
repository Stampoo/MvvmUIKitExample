//
//  DepositConditionView.swift
//  
//
//  Created by Князьков Илья on 03.05.2022.
//

import UIKit
import Core
import Combine
import Resources

public final class DepositConditionView: UIView {

    // MARK: - Nested Types

    struct Model {
        let title: String
        let description: String
        fileprivate let selectEventTransceiver = BaseEventTransceiver<Void, Never>()

        var selectEventPublisher: AnyPublisher<Void, Never> {
            selectEventTransceiver.publisher.eraseToAnyPublisher()
        }
    }

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var checkBoxContainer: UIView!
    @IBOutlet private weak var checkBoxView: UIImageView!

    // MARK: - Private Properties

    private var model: Model?
    private var state: DepositConditionState = .canBeChosen

    // MARK: - UITableViewCell

    override public func awakeFromNib() {
        super.awakeFromNib()
        setupInitialState()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        checkBoxContainer.layer.cornerRadius = checkBoxContainer.frame.height / 2
    }

    // MARK: - ConfigurableItem

    func setState(_ state: DepositConditionState) {
        guard !state.isDisabled else {
            isUserInteractionEnabled = false
            configureAsDisabled()
            return
        }
        isUserInteractionEnabled = true
        switch state.isSelected {
        case true:
            configureAsIsSelected()
        case false:
            configureAsIsDiselected()
        }

        self.state = state
    }

    func configure(with model: Model) {
        self.model = model
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        setState(state)
    }

    public static func loadFromNibDirectly() -> Self {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: .module)

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            preconditionFailure("\(Self.self) was not loaded from nib")
        }
        return view
    }

}

// MARK: - Private Methods

private extension DepositConditionView {

    func configureAsIsSelected() {
        titleLabel.textColor = .black
        checkBoxView.isHidden = false
        checkBoxContainer.backgroundColor = .black
        checkBoxContainer.layer.borderWidth = .zero
    }

    func configureAsIsDiselected() {
        checkBoxContainer.layer.borderColor = UIColor.black.cgColor
        titleLabel.textColor = .black
        checkBoxView.isHidden = true
        checkBoxContainer.backgroundColor = .clear
        checkBoxContainer.layer.borderWidth = 1
    }

    func configureAsDisabled() {
        configureAsIsDiselected()

        checkBoxContainer.layer.borderColor = UIColor.systemGray.cgColor
        titleLabel.textColor = .systemGray
    }

    func setupInitialState() {
        layer.cornerRadius = 12

        configureTitleLabel()
        configureDescriptionLabel()
        configureCheckBox()
        configureTapRecognizer()
    }

    func configureTapRecognizer() {
        isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onDidTap))
        addGestureRecognizer(recognizer)
    }

    @objc
    func onDidTap() {
        guard !state.isSelected else {
            return
        }
        model?.selectEventTransceiver.send(newValue: Void())
    }

    func configureCheckBox() {
        checkBoxView.image = Assets.checkmark
        checkBoxView.backgroundColor = .clear
        checkBoxView.contentMode = .scaleAspectFit
        checkBoxView.layer.borderColor = UIColor.systemGray.cgColor
        configureAsIsDiselected()
    }

    func configureTitleLabel() {
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 17)
    }

    func configureDescriptionLabel() {
        descriptionLabel.textColor = .systemGray
        descriptionLabel.font = .systemFont(ofSize: 14)
    }

}


extension DepositConditionView: PopUpContentProtocol {

    public var asViewRepresentable: UIView {
        self
    }

    public var estimateHeight: CGFloat {
        frame.height
    }

}
