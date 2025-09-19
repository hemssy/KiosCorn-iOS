import UIKit
import SnapKit

final class ViewController: UIViewController {

    private let mainCategoryTab = MainCategoryTab()
    private let mainOrderButton = MainOrderButton()
    
    private var collectionView: UICollectionView!
    private let items = allItems
    private var filteredItems: [MenuItem] = [] //필터된 아이템을 따로 저장함

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
        let paySheet = UIViewController()
        let popUpView = PaymentPopUp()
        paySheet.view.addSubview(popUpView)
        popUpView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        popUpView.callStaffButton.addTarget(self, action: #selector(callStaffTapped), for: .touchUpInside)

        paySheet.modalPresentationStyle = .pageSheet
        if let sheet = paySheet.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }

        present(paySheet, animated: true, completion: nil)
    }
    
    @objc private func callStaffTapped() {
        let alert = UIAlertController(title: "직원을 호출하시겠습니까?",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "호출", style: .default))
        
        // presentedViewController ?? self 로 최상단이 있으면 그 최상단에 올리고, 없으면 self에서 띄우도록만든다. 지금 최상단은 장바구니 모달이니까 거기에 올리는거임
        let presenter = self.presentedViewController ?? self
        presenter.present(alert, animated: true)
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

