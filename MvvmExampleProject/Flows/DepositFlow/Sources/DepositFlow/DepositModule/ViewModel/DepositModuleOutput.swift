//
//  Copyright © Surf. All rights reserved.
//

protocol DepositModuleOutput: AnyObject {

    var onDepositDidOpened: (() -> Void)? { get set }

}
