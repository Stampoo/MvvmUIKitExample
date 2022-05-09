//
//  Copyright © Surf. All rights reserved.
//

protocol SuccessPageModuleOutput: AnyObject {

    var onCloseDidTriggered: (() -> Void)? { get set }
    
}
