import UIKit
import SnapKit

class OrderTableViewCell: UITableViewCell {
    static let identifier = "OrderTableViewCell"
    let itemImage = UIImage()
    let itemTitle = UILabel()
    let itemPrice = UILabel()
    let stepper = UIStepper()
    let countStackView = UIStackView()
    let minusButton = UIButton()
    let amount = UILabel()
    let plusButton = UIButton()
    let tableView = PaymentPopUp()
    let bg = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        counterUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        [itemTitle, itemPrice]
            .forEach { contentView.addSubview($0) }
        itemTitle.textColor = .black
        itemTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(50)
            $0.trailing.equalToSuperview().offset(-100)
            $0.top.equalToSuperview().offset(10)
        }
    }
    
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
        countStackView.spacing = 10
        countStackView.distribution = .equalSpacing
        countStackView.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(30)
            $0.trailing.equalToSuperview().offset(-10)
        }
   

    }

    
    func cellConfigure(data: String) {
        itemTitle.text = data
    }

}
