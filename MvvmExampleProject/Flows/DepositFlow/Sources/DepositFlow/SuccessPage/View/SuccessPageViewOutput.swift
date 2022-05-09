//
//  Copyright © Surf. All rights reserved.
//

import Core

enum SuccessPageEvents {
    case closeDidPressed
}

protocol SuccessPageViewOutput: BaseViewModuleOutput where Event == SuccessPageEvents { }
