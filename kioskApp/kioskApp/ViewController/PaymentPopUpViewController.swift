import UIKit
import SnapKit

final class PaymentPopUpViewController: UIViewController {

    let popUpView = PaymentPopUp()

    // 모달을 종료했을 때 최신 장바구니를 전달함
    var onDismiss: (([PaymentPopUp.ItemList]) -> Void)?

    var cartItems: [PaymentPopUp.ItemList] = [] {
        didSet { popUpView.datas = cartItems }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = popUpView
        
        // 직원 호출 알럿
        popUpView.callStaffButton.addTarget(self, action: #selector(didTapCallStaff), for: .touchUpInside)
        
        // 수량제한 알럿
        popUpView.presentAlert = { [weak self] alert in
            self?.present(alert, animated: true)
        }
        
        // 주문취소 알럿
        popUpView.onDeleteAllTapped = { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(
                title: "주문을 취소할까요?",
                message: "주문내역이 모두 사라집니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "네", style: .destructive) { _ in
                self.popUpView.datas.removeAll()
                self.popUpView.tableView.reloadData()
            })
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
            self.present(alert, animated: true)
        }
        
        // 결제버튼 알림
        popUpView.onPayTapped = { [weak self] count in
            guard let self = self else { return }
            
            if count > 0 {
                let payAlert = UIAlertController(
                    title: "알림",
                    message: "결제가 완료되었습니다",
                    preferredStyle: .alert)
                payAlert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                    self.popUpView.datas.removeAll()
                    self.popUpView.tableView.reloadData()
                })
                self.present(payAlert, animated: true)
            } else {
                guard self.popUpView.hasNoOrder else { return }
                let emptyalert = UIAlertController(
                    title: "알림",
                    message: "주문내역이 없습니다.",
                    preferredStyle: .alert
                )
                emptyalert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(emptyalert, animated: true)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        onDismiss?(popUpView.datas)
    }

    // 직원 호출
    @objc private func didTapCallStaff() {
        let alert = UIAlertController(title: "직원을 호출하시겠습니까?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

