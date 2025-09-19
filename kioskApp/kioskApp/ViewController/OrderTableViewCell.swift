import UIKit
import SnapKit

class OrderTableViewCell: UITableViewCell {
    static let identifier = "OrderTableViewCell"
    
    // UIAlertController용 콜백 (취소버튼/최대수량/주문내역 공백)
    var onCountChanged: ((Int) -> Void)?
    var maxOrderTapped: ((UIAlertController) -> Void)?
    var emptyAlert: (() -> Void)?
    
    
    var count: Int = 0 {
        didSet {
            amount.text = "\(count)"
            minusButton.isEnabled = count > 0 // 0이면 버튼 비활성화
        }
    }
    let itemImage = UIImageView()
    let itemTitle = UILabel()
    
    let itemPrice = UILabel()
    let stepper = UIStepper()
    let countStackView = UIStackView()
    let minusButton = UIButton()
    let amount = UILabel()
    let plusButton = UIButton()
    let tableView = PaymentPopUp()
    let bg = UIView()
    let cartStackview = UIStackView()
    let imageStackview = UIStackView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        counterUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    // 장바구니
    // 장바구니 수평뷰 (이미지 및 cartStackview)
    func configureUI() {
        contentView.addSubview(imageStackview)
        [cartStackview, itemImage]
            .forEach { imageStackview.addArrangedSubview($0) }
        
        imageStackview.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.left.equalTo(cartStackview.snp.left).offset(-30)
            $0.centerY.equalToSuperview()
        }
        
        itemImage.snp.makeConstraints {
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        
        // itemImage.image = UIImage(named: "kioscornLogo_popcorn")
        itemImage.contentMode = .scaleAspectFit
        itemImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageStackview.axis = .horizontal
        
        
        // 장바구니 수직뷰 (제품명, 제품가격)
        contentView.addSubview(cartStackview)
        [itemTitle, itemPrice]
            .forEach { cartStackview.addArrangedSubview($0) }
        
        itemTitle.textColor = .label
        itemTitle.font = UIFont.systemFont(ofSize: 15)
        itemPrice.textColor = .label
        itemPrice.font = UIFont.systemFont(ofSize: 14)
        cartStackview.axis = .vertical
        cartStackview.spacing = 13
        cartStackview.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(80)
            $0.trailing.equalToSuperview().offset(-100)
            $0.center.equalToSuperview()
        }
    }
    
    
    
    // 수량 카운팅 STEPPER
    func counterUI() {
        contentView.addSubview(countStackView)
        [minusButton, amount, plusButton]
            .forEach { countStackView.addArrangedSubview($0) }
        countStackView.addSubview(bg)
        
        
        amount.text = "0"
        amount.textColor = .label
        
        minusButton.isEnabled = false
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.label, for: .normal)
        minusButton.setTitleColor(.lightGray, for: .disabled)
        minusButton.addTarget(self, action: #selector(minusTapped), for: .touchUpInside)
        
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.label, for: .normal)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)
        
        
        
        
        bg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        countStackView.sendSubviewToBack(bg)
        countStackView.insertSubview(bg, at: 0)
        bg.isUserInteractionEnabled = false
        bg.layer.borderColor = UIColor.init(named: "StepperColor")?.cgColor
        bg.layer.borderWidth = 0.5
        bg.layer.masksToBounds = true
        bg.backgroundColor = UIColor(named: "DefaultColor")
        bg.layer.cornerCurve = .continuous
        bg.layer.cornerRadius = 15
        
        
        
        countStackView.backgroundColor = .clear
        countStackView.axis = .horizontal
        countStackView.distribution = .equalSpacing
        countStackView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.leading.equalToSuperview().inset(230)
            $0.height.equalTo(30)
            $0.trailing.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
    }
    
    
    func cellConfigure(data: PaymentPopUp.ItemList) {
        self.count = data.count
        itemImage.image = UIImage(named: data.menuItem.imageName)
        itemTitle.text = data.menuItem.name
        itemPrice.text = "\(data.menuItem.price)원"
    }
    
    
    // 최대 주문 수량 알림창
    @objc func plusTapped() {
        if count >= 10 {
            amount.text = "\(count)"
            let orderAlert = UIAlertController(title: "알림", message: "10개 이상은 주문할 수 없습니다.", preferredStyle: .alert)
            orderAlert.addAction(UIAlertAction(title: "확인", style: .default))
            orderAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
            
            maxOrderTapped?(orderAlert)
            return
            
        } else {
            count += 1
            amount.text = "\(count)"
            onCountChanged?(count)
        }
        
    }
    
    @objc func minusTapped() {
        guard count > 0 else { return }
        count -= 1
        amount.text = "\(count)"
        onCountChanged?(count)
    }
}
