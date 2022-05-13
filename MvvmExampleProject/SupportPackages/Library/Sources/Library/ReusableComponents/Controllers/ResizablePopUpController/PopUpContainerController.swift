//
//  PopUpContainerController.swift
//  Unicredit
//
//  Created by Илья Князьков on 24.01.2021.
//  Copyright © 2021 Surf. All rights reserved.
//

import UIKit
import Combine

open class PopUpContainerController: UIViewController {

    // MARK: - Private properties

    private let duration: TimeInterval
    private let contentView: UIView
    private let closureIndicatorView: CloseIndicatorView = .loadFromNibDirectly(bundle: .module)
    private let contentHeight: CGFloat
    private let isNeedCloseByTapOnOutside: Bool
    private let wholeSpaceBackgroundColor: UIColor
    private var cancellableEventsContainer: Set<AnyCancellable> = []

    // MARK: - Initialization and deinitialization

    public init(content: PopUpContentProtocol) {
        self.duration = 0.3
        self.contentView = content.asViewRepresentable
        self.contentHeight = content.estimateHeight
        self.isNeedCloseByTapOnOutside = content.isNeedCloseByTapOnBlurSpace
        self.wholeSpaceBackgroundColor = content.whiteSpaceBackgroundColor
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }

    required public init?(coder: NSCoder) {
        self.duration = 0.3
        self.contentView = UIView()
        self.contentHeight = .zero
        self.isNeedCloseByTapOnOutside = true
        self.wholeSpaceBackgroundColor = .clear
        super.init(coder: coder)
    }

    // MARK: - UIViewController

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialState()
    }

}

// MARK: - UIViewControllerTransitioningDelegate

extension PopUpContainerController: UIViewControllerTransitioningDelegate {

    public func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController
    ) -> UIPresentationController? {

        let presentationController = PresentationController(
            presentedViewController: presented,
            presenting: presenting ?? source,
            sizeOfContent: CGSize(width: UIScreen.main.bounds.width, height: contentHeight),
            relevantTo: UIScreen.main.bounds
        )
        presentationController.tapEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self, self.isNeedCloseByTapOnOutside else {
                    return
                }
                self.dismiss(animated: true, completion: nil)
            }
            .store(in: &cancellableEventsContainer)

        return presentationController

    }

    public func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        PresentAnimation(duration: duration)
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissAnimation(duration: duration)
    }

}

// MARK: - Private Methods

private extension PopUpContainerController {

    func setupInitialState() {
        view.backgroundColor = wholeSpaceBackgroundColor

        configureClosureIndicatorView()
        configureContentView()
    }

    func configureClosureIndicatorView() {
        view.addSubview(closureIndicatorView)

        closureIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closureIndicatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closureIndicatorView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            closureIndicatorView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

    func configureContentView() {
        view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: closureIndicatorView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

}
