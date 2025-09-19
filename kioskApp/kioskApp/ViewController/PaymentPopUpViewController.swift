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

        popUpView.callStaffButton.addTarget(self, action: #selector(didTapCallStaff), for: .touchUpInside)
    }
    
    // 뷰가 사라질 때 onDismiss 호출
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.onDismiss?(self.popUpView.datas)
    }
    
    @objc private func didTapCallStaff() {
        let alert = UIAlertController(title: "직원을 호출하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
}
