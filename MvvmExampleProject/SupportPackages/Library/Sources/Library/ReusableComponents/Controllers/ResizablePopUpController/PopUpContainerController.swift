//
//  PopUpContainerController.swift
//
//
//  Created by Князьков Илья on 14.05.2022.
//

import UIKit
import Combine

open class PopUpContainerController: UIViewController {

    // MARK: - Private properties

    private let duration: TimeInterval
    private let contentView: UIView
    private let contentHeight: CGFloat
    private let isNeedCloseByTapOnOutside: Bool
    private let wholeSpaceBackgroundColor: UIColor
    private var cancellableEventsContainer: Set<AnyCancellable> = []
    private var estimateHeight: CGFloat {
        contentHeight
    }
    private let transitionInterractionBridge = InteractiveTransitionBridge()
    private lazy var presentationFrame = CGSize(width: view.frame.width, height: estimateHeight)
    private lazy var transitionDelegate = PopUpTransitionDelegate(
        presentationControllerBuilder: .init(sizeOfContent: presentationFrame, parentFrame: UIScreen.main.bounds),
        interactiveTransitionBridge: transitionInterractionBridge,
        transitionDuration: duration
    )

    // MARK: - Initialization and deinitialization

    public init(content: PopUpContentProtocol) {
        self.duration = 0.3
        self.contentView = content.asViewRepresentable
        self.contentHeight = content.estimateHeight
        self.isNeedCloseByTapOnOutside = content.isNeedCloseByTapOnBlurSpace
        self.wholeSpaceBackgroundColor = content.whiteSpaceBackgroundColor
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = transitionDelegate
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

// MARK: - Private Methods

private extension PopUpContainerController {

    func setupInitialState() {
        view.isUserInteractionEnabled = true
        view.backgroundColor = wholeSpaceBackgroundColor

        configureContentView()
    }

    func configureContentView() {
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }

}
