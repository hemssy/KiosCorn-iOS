import UIKit
import SnapKit

final class ViewController: UIViewController {
    // feature/#5
    private let mainCategoryTab = MainCategoryTab()
    private let mainOrderButton = MainOrderButton()
    
    // develop
    private var collectionView: UICollectionView!
    private let items = sampleMenuItems

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // 상단 카테고리 탭
        view.addSubview(mainCategoryTab)
        mainCategoryTab.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(150)
        }

        // 하단 주문 버튼
        view.addSubview(mainOrderButton)
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

        // (임시) 장바구니 버튼 — 필요 없으면 삭제해도 됨
        let btn = UIButton(type: .system)
        view.addSubview(btn)
        btn.frame = .init(x: 10, y: 100, width: 200, height: 100)
        btn.setTitle("(임시) 장바구니 버튼", for: .normal)
        btn.addTarget(self, action: #selector(presentModalBtnTap), for: .touchUpInside)
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
    @objc private func presentModalBtnTap() {
        let paySheet = UIViewController()

        let popUpView = PaymentPopUp()
        paySheet.view.addSubview(popUpView)
        popUpView.snp.makeConstraints { $0.edges.equalToSuperview() }

        paySheet.modalPresentationStyle = .pageSheet
        if let sheet = paySheet.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.preferredCornerRadius = 30
            sheet.prefersGrabberVisible = true
        }

        present(paySheet, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ cv: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ cv: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: MenuItemCell.id, for: indexPath) as! MenuItemCell
        cell.configure(items[indexPath.item])
        return cell
    }
}

