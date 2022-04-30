//
//  Copyright © Surf. All rights reserved.
//

import Core

enum DepositEvents { }

protocol DepositViewOutput: BaseViewModuleOutput where Event == DepositEvents { }
