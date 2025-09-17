import UIKit
import SnapKit

class MainCategoryTab: UIView {
    private let backgroundView = UIView()
    private let logoText = UIImageView()
    private let logoImage = UIImageView()
    private let categoryTab = UIStackView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        // 로고 + 카테고리탭 백그라운드
        backgroundView.backgroundColor = UIColor.white
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 로고 텍스트만
        logoText.image = UIImage(named: "kioscornLogo_text")
        logoText.contentMode = .scaleToFill
        addSubview(logoText)
        logoText.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(152)
            make.trailing.equalToSuperview().offset(-113)
        }
        // 로고 팝콘이미지
        logoImage.image = UIImage(named: "kioscornLogo_popcorn")
        logoImage.contentMode = .scaleToFill
        addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.trailing.equalTo(logoText.snp.leading).inset(-9)
            make.width.equalTo(31)
            make.height.equalTo(37)
        }
        // 카테고리 탭 스택뷰
        categoryTab.axis = .horizontal
        categoryTab.spacing = 8
        categoryTab.distribution = .equalSpacing
        addSubview(categoryTab)
        categoryTab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(115)
            make.leading.equalToSuperview().offset(29)
            make.trailing.equalToSuperview().offset(-29)
            make.centerX.equalToSuperview()
        }
        
        // 카테고리 탭 스택뷰에 버튼 추가
        let categoryImages = ["Combo", "Popcorn", "Snack", "Drink"]
        for (index, name) in categoryImages.enumerated() {
            let categoryButton = UIButton(type: .custom)
            
            // 흰색 버튼
            let normalImage = UIImage(named: "button\(name)W")
            // 빨간색 버튼
            let selectedImage = UIImage(named: "button\(name)R")
            
            //버튼 상태에 따른 이미지
            categoryButton.setImage(normalImage, for: .normal)
            categoryButton.setImage(selectedImage, for: .selected)
            
            // 버튼에 태그 설정
            categoryButton.tag = index
            
            categoryButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            
            categoryTab.addArrangedSubview(categoryButton)
        }
        
    }
    
    // 버튼 클릭 시 이미지 변경하는 함수
    @objc func didTapButton(_ sender: UIButton) {
        // 모든 버튼 선택 해제
        for subview in categoryTab.arrangedSubviews {
            if let button = subview as? UIButton {
                button.isSelected = false
            }
        }
        
        sender.isSelected = true
    }
}

