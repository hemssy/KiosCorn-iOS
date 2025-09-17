import UIKit
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // 임시방편 버튼, 삭제 가능
        let btn = UIButton(type: .system)
        view.addSubview(btn)
        btn.frame = .init(x: 10, y: 100, width: 200, height: 100)
        btn.setTitle("(임시) 장바구니 버튼", for: .normal)
        btn.addTarget(self, action: #selector(presentModalBtnTap), for: .touchUpInside)
    }
    
    
    func configure() {
        view.backgroundColor = .white
    }
    
    
    // 결제창 하프모달뷰
    @objc private func presentModalBtnTap() {
        let paySheet = UIViewController()
        
        
        let popUpView = PaymentPopUp()
        paySheet.view.addSubview(popUpView)
        popUpView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        paySheet.modalPresentationStyle = .pageSheet
        if let sheet = paySheet.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }
        
        present(paySheet, animated: true, completion: nil)
    }
    
    
    
}





