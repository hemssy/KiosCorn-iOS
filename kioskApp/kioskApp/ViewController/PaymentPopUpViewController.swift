import UIKit
import SnapKit

final class PaymentPopUpViewController: UIViewController {
    
    let popUpView = PaymentPopUp()
    
    var onDismiss: (([PaymentPopUp.ItemList]) -> Void )?

    var cartItems: [PaymentPopUp.ItemList] = [] {
        didSet {

            popUpView.datas = cartItems
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = popUpView

    }
    
    // 뷰가 사라질 때 onDismiss 호출
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onDismiss?(self.popUpView.datas)
    }
    
}
