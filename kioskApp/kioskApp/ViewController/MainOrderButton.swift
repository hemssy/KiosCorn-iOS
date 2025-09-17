import UIKit
import SnapKit

class MainOrderButton: UIView {
    // 하단 주문하기 버튼
    let orderButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureButton()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureButton() {
        
        addSubview(orderButton)
        orderButton.backgroundColor = UIColor(named: "#FDF6F6")
        orderButton.titleLabel?.font = .boldSystemFont(ofSize: 16) // 임시 폰트
        // 숫자는 장바구니 총 수량으로
        // `NSMutableAttributedString`적용?
        orderButton.setTitle("🍿2개 주문하기", for: .normal)
        orderButton.setTitleColor(.black, for: .normal)
        orderButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
    
    
    
    
}
