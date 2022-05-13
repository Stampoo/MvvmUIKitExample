//
//  VisualEffectViewWithIntensity.swift
//  Unicredit
//
//  Created by Князьков Илья on 11.08.2021.
//  Copyright © 2021 Surf. All rights reserved.
//

import UIKit

final class VisualEffectViewWithIntensity: UIVisualEffectView {

    // MARK: - Nested types

    enum EffectIntensity {

        /// - Custom: effect intencity from 0.0 (no effect) to 1.0 (full effect)
        case custom(_ intensity: CGFloat)

        /// - Max intensity: 1.0
        static var max: Self { .custom(1) }

        /// -  Medium intensity: 0.5
        static var medium: Self { .custom(0.5) }

        /// -  Low intensity: 0.3
        static var low: Self { .custom(0.3) }

        var value: CGFloat {
            switch self {
            case .custom(let intencity):
                return intencity
            }
        }

    }

    // MARK: - Private properties

    private let intensity: EffectIntensity
    private var animator: UIViewPropertyAnimator?

    // MARK: - Initialization

    init(effect: UIVisualEffect, intensity: EffectIntensity) {
        self.intensity = intensity
        super.init(effect: nil)
        setEffectIntensivity(effect, intensity: intensity)

    }

    required init?(coder aDecoder: NSCoder) {
        self.intensity = .medium
        super.init(coder: aDecoder)
        setEffectIntensivity(nil, intensity: .custom(.zero))
    }

    // MARK: - Internal methods

    func updateIntesity() {
        setEffectIntensivity(effect, intensity: intensity)
    }

    // MARK: - Private methods

    private func setEffectIntensivity(_ effect: UIVisualEffect?, intensity: EffectIntensity) {
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear) { [weak self] in
             self?.effect = effect
        }
        animator?.fractionComplete = intensity.value > 1 ? 1 : intensity.value
    }

}
