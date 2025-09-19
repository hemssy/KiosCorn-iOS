import UIKit
import SnapKit

class MainOrderButton: UIView {
    // 하단 주문하기 버튼
    let orderButton = UIButton()
    let paymentPopUp = PaymentPopUp()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton(nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
     func configureButton(_ vc: ViewController?) {
        
        addSubview(orderButton)
        orderButton.backgroundColor = UIColor(named: "#FDF6F6")
        orderButton.titleLabel?.font = .boldSystemFont(ofSize: 16) // 임시 폰트
        // 숫자는 장바구니 총 수량으로
        // `NSMutableAttributedString`적용?
        orderButton.setTitle("장바구니가 비어있습니다.", for: .normal)
        orderButton.setTitleColor(.black, for: .normal)
        orderButton.addTarget(vc,  action: #selector(ViewController.presentModalBtnTap), for: .touchUpInside)
        orderButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

    }
    
    func setTitle(count: Int) {
        
        let fullText = NSMutableAttributedString(string: "🍿" + "\(count)" + "개 주문하기")
        
        guard let countTextColor = UIColor(named: "PointColor") else {
            orderButton.setAttributedTitle(fullText, for: .normal)
            return
        }
        let countRange = (fullText.string as NSString).range(of: "\(count)")
        
        fullText.addAttribute(.foregroundColor, value: countTextColor, range: countRange)
        
        if count > 0 {
            orderButton.setAttributedTitle(fullText, for: .normal)
        } else {
            orderButton.setTitle("장바구니가 비어있습니다.", for: .normal)
        }
    }
    
    
    
}
