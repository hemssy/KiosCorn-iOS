import UIKit
import SnapKit

final class ViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let items = sampleMenuItems

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.id)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }

        collectionView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let flow = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        // 피그마에서 정한 마진,간격 + 정했던 셀 비율(160x216)
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

