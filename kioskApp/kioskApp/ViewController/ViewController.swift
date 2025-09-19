import UIKit
import SnapKit

final class ViewController: UIViewController {

    private let mainCategoryTab = MainCategoryTab()
    private let mainOrderButton = MainOrderButton()

    private var cartItems: [PaymentPopUp.ItemList] = []

    private var collectionView: UICollectionView!
    private let items = allItems
    private var filteredItems: [MenuItem] = [] // 필터된 아이템 저장

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // 상단 카테고리 탭
        view.addSubview(mainCategoryTab)
        mainCategoryTab.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }

        // 카테고리 선택 시 필터링
        mainCategoryTab.onCategorySelected = { [weak self] category in
            guard let self = self else { return }
            self.filteredItems = self.items.filter { $0.category == category }
            self.collectionView.reloadData()
        }

        // 앱 처음 켜졌을 때 기본: 콤보
        filteredItems = items.filter { $0.category == .combo }

        // 하단 주문 버튼
        view.addSubview(mainOrderButton)
        mainOrderButton.configureButton(self) // 내부에서 presentModalBtnTap 타깃 연결
        mainOrderButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(63)
        }

        // 컬렉션뷰
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delaysContentTouches = false
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.id)
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(mainCategoryTab.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(mainOrderButton.snp.top)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        // 피그마 기준 (160 x 216) 비율 + 마진/간격
        let insetLR: CGFloat = 29
        let inter: CGFloat   = 23
        let line: CGFloat    = 35
        let available = collectionView.bounds.width - insetLR * 2 - inter
        let w = available / 2
        let h = w * (216.0 / 160.0)

        flow.itemSize = CGSize(width: w, height: h)
        flow.minimumInteritemSpacing = inter
        flow.minimumLineSpacing = line
        flow.sectionInset = UIEdgeInsets(top: 12, left: insetLR, bottom: 24, right: insetLR)
    }

    // 하프모달: 결제창
    @objc func presentModalBtnTap(_ sender: UIButton) {
        let paySheetVC = PaymentPopUpViewController()

        // 현재 장바구니 전달
        paySheetVC.cartItems = self.cartItems

        // 모달 닫힐 때 최신 장바구니 반영
        paySheetVC.onDismiss = { [weak self] updatedItems in
            self?.cartItems = updatedItems
            self?.updateOrderButton()
        }

        paySheetVC.modalPresentationStyle = .pageSheet
        if let sheet = paySheetVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }
        present(paySheetVC, animated: true)
    }
}


// MARK: - DataSource & Cell Delegate
extension ViewController: UICollectionViewDataSource, MenuItemCellDelegate {

    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filteredItems.count
    }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: MenuItemCell.id, for: indexPath) as! MenuItemCell
        let item = filteredItems[indexPath.item]
        cell.configure(item)
        cell.delegate = self
        return cell
    }

    // 추가 버튼 → 장바구니에 담기
    func didTapAddButton(with item: MenuItem) {
        if let idx = cartItems.firstIndex(where: { $0.menuItem.id == item.id }) {
            cartItems[idx].count += 1
        } else {
            cartItems.append(.init(menuItem: item, count: 1))
        }
        // ✅ 담은 뒤, 하단 주문 버튼에 총 수량 반영
        self.updateOrderButton()
    }

    // ✅ 총 수량을 하단 주문 버튼 타이틀에 반영
    func updateOrderButton() {
        let totalCount = self.cartItems.reduce(0) { $0 + $1.count }
        mainOrderButton.setTitle(count: totalCount)
    }
}

