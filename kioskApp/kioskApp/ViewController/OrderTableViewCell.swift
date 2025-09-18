import UIKit
import SnapKit

class OrderTableViewCell: UITableViewCell {
    static let identifier = "OrderTableViewCell"
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
        self.addSubview(imageStackview)
        [cartStackview, itemImage]
            .forEach { imageStackview.addArrangedSubview($0) }
        
        imageStackview.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.left.equalTo(cartStackview.snp.left).offset(-30)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(50)
            $0.height.equalTo(50)
        }
        
        itemImage.image = UIImage(named: "kioscornLogo_popcorn")
        itemImage.contentMode = .scaleAspectFit
        itemImage.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageStackview.axis = .horizontal
       
        
        // 장바구니 수직뷰 (제품명, 제품가격)
        self.addSubview(cartStackview)
        [itemTitle, itemPrice]
            .forEach { cartStackview.addArrangedSubview($0) }
        
        itemTitle.textColor = .black
        itemTitle.font = UIFont.systemFont(ofSize: 15)
        itemPrice.textColor = .black
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
        self.addSubview(countStackView)
        [minusButton, amount, plusButton]
            .forEach { countStackView.addArrangedSubview($0) }
        countStackView.addSubview(bg)
        
        minusButton.setTitle("-", for: .normal)
        minusButton.setTitleColor(.black, for: .normal)
        plusButton.setTitle("+", for: .normal)
        plusButton.setTitleColor(.black, for: .normal)
        amount.text = "0"
        amount.textColor = .black
        
        bg.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        countStackView.sendSubviewToBack(bg)
    
        bg.layer.borderColor = UIColor.init(named: "StepperColor")?.cgColor
        bg.layer.borderWidth = 0.5
        bg.layer.masksToBounds = true
        bg.backgroundColor = .white
        bg.layer.cornerCurve = .continuous
        bg.layer.cornerRadius = 15

        
        
        countStackView.backgroundColor = .clear
        countStackView.axis = .horizontal
        countStackView.distribution = .equalSpacing
        countStackView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(30)
            $0.trailing.equalToSuperview().offset(-15)
            $0.centerY.equalToSuperview()
        }
   

    }

    
    func cellConfigure(data: PaymentPopUp.ItemList) {
        itemImage.image = UIImage(named: data.imageName)
        itemTitle.text = data.name
        itemPrice.text = "\(data.price)원"
    }

}
