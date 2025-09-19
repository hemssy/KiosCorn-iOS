import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    
    private let mainCategoryTab = MainCategoryTab()
    private let mainOrderButton = MainOrderButton()
    
    private var collectionView: UICollectionView!
    private let items = allItems
    private var filteredItems: [MenuItem] = [] //필터된 아이템을 따로 저장함
    
    let tableViewContainer = PaymentPopUp()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        // 상단 카테고리 탭
        view.addSubview(mainCategoryTab)
        mainCategoryTab.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }
        
        // 카테고리 버튼 눌렸을 때 동작 연결
        mainCategoryTab.onCategorySelected = { [weak self] category in
            guard let self = self else { return }
            self.filteredItems = self.items.filter { $0.category == category }
            self.collectionView.reloadData()
        }
        
        // 앱 처음 켜졌을 때 기본으로 콤보필터 끼고있음
        filteredItems = items.filter { $0.category == .combo }
        
        
        // 하단 주문 버튼
        view.addSubview(mainOrderButton)
        mainOrderButton.configureButton(self)
        mainOrderButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(63)
        }
        
        // 컬렉션뷰
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.id)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(mainCategoryTab.snp.bottom)   // 탭 아래
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(mainOrderButton.snp.top)   // 버튼 위까지
        }
        collectionView.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        // 피그마에서 정한 마진/간격 + 셀 비율(160x216)
        let insetLR: CGFloat = 29
        let inter: CGFloat   = 23
        let line: CGFloat    = 35
        let available = collectionView.bounds.width - insetLR*2 - inter
        let w = available / 2
        let h = w * (216.0 / 160.0)
        
        flow.itemSize = CGSize(width: w, height: h)
        flow.minimumInteritemSpacing = inter
        flow.minimumLineSpacing = line
        flow.sectionInset = UIEdgeInsets(top: 12, left: insetLR, bottom: 24, right: insetLR)
    }
    
    
    // 결제창 하프모달뷰
    @objc func presentModalBtnTap(_ sender: UIButton) {
        guard presentedViewController == nil else { return }
        
        let paySheet = UIViewController()
        let popUpView = PaymentPopUp()
        
        paySheet.view.addSubview(popUpView)
        popUpView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        popUpView.presentAlert = { [weak paySheet] orderAlert in
            guard let paySheet, paySheet.presentedViewController == nil else { return }
            paySheet.present(orderAlert, animated: true)
        }
        
        // 주문 취소 버튼
        // popUpView 안에 클로저가 있고 클로저 안에서 다시 popUpView와 paySheet이 사용되므로 순환 참조 발생 -> weak로 해결
        popUpView.onDeleteAllTapped = { [weak paySheet, weak popUpView] in
            guard let paySheet = paySheet, let popUpView = popUpView else { return }
            
            let alert = UIAlertController(
                title: "주문을 취소할까요?",
                message: "주문내역이 모두 사라집니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "네", style: .destructive) { _ in
                popUpView.datas.removeAll()
                popUpView.tableView.reloadData()
            })
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel))
            
            // ✅ 모달 위에서 알럿 띄우기
            paySheet.present(alert, animated: true)
        }
        
        // 주문내역이 비어있는 상태에서 결제 버튼이 눌렸을 때
        popUpView.emptyTapped = {[weak paySheet, weak popUpView] in
            guard let paySheet = paySheet, let popUpView = popUpView else { return }
            guard popUpView.hasNoOrder else { return } // 비었을 때만 진행
            
            
            let emptyAlert = UIAlertController( title: "알림", message: "주문내역이 없습니다.", preferredStyle: .alert)
            emptyAlert.addAction(UIAlertAction(title: "확인", style: .default))
            paySheet.present(emptyAlert, animated: true)
        }
        
        // 모달뷰 레이아웃
        paySheet.modalPresentationStyle = .pageSheet
        if let sheet = paySheet.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }
        
        present(paySheet, animated: true)
    }
    
}





extension ViewController: UICollectionViewDataSource {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredItems.count
    }
    
    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: MenuItemCell.id, for: indexPath) as! MenuItemCell
        cell.configure(filteredItems[indexPath.item])
        return cell
    }
}

