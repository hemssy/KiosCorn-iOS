import UIKit
import SnapKit

class MenuItemCell: UICollectionViewCell {
    static let id = "MenuItemCell"

    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let cartAddButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.backgroundColor = .systemGray6
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true

        nameLabel.font = .systemFont(ofSize: 14, weight: .regular)
        priceLabel.font = .systemFont(ofSize: 16, weight: .regular)
        
        cartAddButton.setImage(UIImage(named: "buttonCartAdd"), for: .normal)

        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(cartAddButton)

        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(imageView.snp.width)  // 자동으로 정사각형 됨!!
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(7)
            $0.leading.trailing.equalToSuperview()
        }
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(2)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        cartAddButton.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.height.equalTo(30)
            $0.top.equalTo(imageView.snp.bottom).offset(18)
            $0.trailing.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) { fatalError() }

    func configure(_ item: MenuItem) {
        imageView.image = UIImage(named: item.imageName)
        nameLabel.text = item.name
        priceLabel.text = "\(item.price.formatted())원"
    }
}

