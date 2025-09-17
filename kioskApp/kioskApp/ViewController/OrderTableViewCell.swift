// UIStepper 각 아이템당 10개 이하
// 테이블뷰셀 스와이프로 삭제

import UIKit
import SnapKit

class OrderTableViewCell: UITableViewCell {
    static let identifier = "OrderTableViewCell"
    let itemImage = UIImage()
    let itemTitle = UILabel()
    let itemPrice = UILabel()
    let stepper = UIStepper()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
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
    
    func cellConfigure(data: String) {
        itemTitle.text = data
    }

}
