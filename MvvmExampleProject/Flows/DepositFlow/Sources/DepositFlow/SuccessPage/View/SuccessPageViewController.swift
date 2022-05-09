//
//  Copyright © Surf. All rights reserved.
//

import UIKit
import Library
import Resources
import Combine

final class SuccessPageViewController<ViewModel: SuccessPageViewOutput>: UIViewController {

    // MARK: - Private Properties

    private let successImageView = UIImageView()
    private let successTitle = UILabel()
    private let closeButton = BlackButton(type: .system)
    private var cancellableEventsContainer: Set<AnyCancellable> = []
    private var viewModel: ViewModel?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }

    // MARK: - Internal Methods

    func setViewModel(_ viewModel: ViewModel) {
        self.viewModel = viewModel
    }

}

// MARK: - Private Methods

private extension SuccessPageViewController {

    func setupInitialState() {
        view.backgroundColor = .white

        configureSuccessImageView()
        configureSuccessTitle()
        configureCloseButton()
    }

    func configureSuccessImageView() {
        view.addSubview(successImageView)
        successImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            successImageView.heightAnchor.constraint(equalToConstant: 213),
            successImageView.widthAnchor.constraint(equalToConstant: 156),
            successImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            successImageView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor,
                constant: UIScreen.main.bounds.height * -0.12
            )
        ])
        successImageView.image = Assets.successLogo
    }

    func configureSuccessTitle() {
        view.addSubview(successTitle)
        successTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            successTitle.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 32),
            successTitle.centerXAnchor.constraint(equalTo: successImageView.centerXAnchor)
        ])
        successTitle.text = "Вклад открыт"
        successTitle.font = .boldSystemFont(ofSize: 29)
    }

    func configureCloseButton() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            closeButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            closeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        closeButton.setTitle("Понятно", for: .normal)
        closeButton.tapEventPublisher
            .sink { [weak viewModel] _ in
                viewModel?.didEventTriggered(.closeDidPressed)
            }
            .store(in: &cancellableEventsContainer)
    }

}
