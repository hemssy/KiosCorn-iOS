import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let mainCategoryTab = MainCategoryTab()
    private let mainorderButton = MainOrderButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //임시 배경
        view.backgroundColor = .yellow
        
        view.addSubview(mainCategoryTab)
        mainCategoryTab.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        view.addSubview(mainorderButton)
        mainorderButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(63)
        }
    }


}

