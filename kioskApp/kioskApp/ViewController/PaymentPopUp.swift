import UIKit
import SnapKit

class PaymentPopUp: UIView {

    // UIAlert 콜백
    var onDeleteAllTapped: (() -> Void)?                  // 주문취소
    var maxOrderTapped: ((UIAlertController) -> Void)?
    var emptyTapped: (() -> Void)?                        // 결제(빈주문)

    // UI
    let paymentPop = UIView()
    let cancelButton = UIButton()
    let callStaffButton = UIButton()
    let payButton = UIButton()
    let tableView = UITableView()

    // 합계 UI
    let titleStack = UIStackView()
    let valueStack = UIStackView()
    let totalCount = UILabel()
    let totalPrice = UILabel()
    let hStackView = UIStackView()

    // 버튼 바
    let buttonBar = UIStackView()

    // 외부에 최신 장바구니를 전달할 때 쓰는 용도임(VC에서 사용)
    var onDismiss: (([ItemList]) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableConfigure()
        stackConfigure()
        mainConfigure()
        setTableViewDelegate()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // 장바구니 아이템
    struct ItemList {
        let menuItem: MenuItem
        var count: Int
    }

    // 데이터
    var datas: [ItemList] = [] {
        didSet {
            updateSummary()
            tableView.reloadData()
        }
    }

    private var totalNumCount = 0 {
        didSet { totalCount.text = "\(totalNumCount)"
        }
    }

    var hasNoOrder: Bool {
        datas.isEmpty || datas.allSatisfy { $0.count == 0 }
    }


    func tableConfigure() {
        addSubview(tableView)
        tableView.rowHeight = 85
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        tableView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(197)
        }
        tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
    }

    func setTableViewDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    // 스와이프 삭제
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self = self else { return }
            tableView.performBatchUpdates({
                self.datas.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }, completion: { _ in
                self.updateSummary()
                completion(true)
            })
        }
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }

    // 합계/금액 스택
    func stackConfigure() {
        addSubview(hStackView)
        hStackView.axis = .horizontal
        hStackView.alignment = .center
        hStackView.distribution = .fill
        hStackView.spacing = 8
        hStackView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(26)
        }

        let totalTitle = UILabel()
        totalTitle.text = "총 수량"
        totalTitle.font = .systemFont(ofSize: 16, weight: .medium)

        let priceTitle = UILabel()
        priceTitle.text = "결제 금액"
        priceTitle.font = .systemFont(ofSize: 16, weight: .medium)

        titleStack.axis = .vertical
        titleStack.spacing = 10
        [totalTitle, priceTitle].forEach { titleStack.addArrangedSubview($0) }

        totalCount.text = "0"
        totalCount.font = .systemFont(ofSize: 16, weight: .bold)
        totalCount.textAlignment = .right

        totalPrice.text = "₩ 0"
        totalPrice.font = .systemFont(ofSize: 16, weight: .bold)
        totalPrice.textAlignment = .right

        valueStack.axis = .vertical
        valueStack.spacing = 10
        [totalCount, totalPrice].forEach { valueStack.addArrangedSubview($0) }

        hStackView.addArrangedSubview(titleStack)
        hStackView.addArrangedSubview(valueStack)

        titleStack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueStack.setContentHuggingPriority(.required, for: .horizontal)
    }

    // 메인 레이아웃(버튼바)
    func mainConfigure() {
        [paymentPop, buttonBar].forEach { addSubview($0) }
        paymentPop.backgroundColor = UIColor(named: "DefaultColor")
        paymentPop.snp.makeConstraints { $0.edges.equalToSuperview() }
        sendSubviewToBack(paymentPop)

        buttonBar.axis = .horizontal
        buttonBar.alignment = .fill
        buttonBar.distribution = .fillEqually
        buttonBar.spacing = 10
        [cancelButton, callStaffButton, payButton].forEach { buttonBar.addArrangedSubview($0) }

        buttonBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            $0.top.equalTo(hStackView.snp.bottom).offset(23)
            $0.height.equalTo(46)
        }

        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        callStaffButton.setTitle("직원호출", for: .normal)
        callStaffButton.setTitleColor(.black, for: .normal)
        callStaffButton.backgroundColor = .white
        callStaffButton.layer.cornerRadius = 8
        callStaffButton.layer.borderWidth = 1
        callStaffButton.layer.borderColor = UIColor.black.cgColor

        payButton.setTitle("결제", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = UIColor(named: "PointColor")
        payButton.layer.cornerRadius = 8
        payButton.addTarget(self, action: #selector(emptyOrderTapped), for: .touchUpInside)
    }

    @objc private func cancelTapped() { onDeleteAllTapped?() }
    @objc private func emptyOrderTapped() { emptyTapped?() }

    private func updateSummary() {
        totalNumCount = datas.reduce(0) { $0 + $1.count }
        let sum = datas.reduce(0) { $0 + ($1.menuItem.price * $1.count) }
        totalPrice.text = "₩ \(formatPrice(sum))"
    }

    func formatPrice(_ price: Int) -> String {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        return f.string(from: NSNumber(value: price)) ?? "\(price)"
    }

    // 동일 ID면 +1, 아니면 추가
    func addMenuItem(_ item: MenuItem) {
        if let i = datas.firstIndex(where: { $0.menuItem.id == item.id }) {
            datas[i].count += 1
        } else {
            datas.append(.init(menuItem: item, count: 1))
        }
    }
}


extension PaymentPopUp: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OrderTableViewCell.identifier,
            for: indexPath
        ) as? OrderTableViewCell else { return OrderTableViewCell() }

        let data = datas[indexPath.row]
        cell.itemImage.image = UIImage(named: data.menuItem.imageName)
        cell.cellConfigure(data: data)

        // 셀 → 팝업뷰 → VC 알럿 전달
        cell.maxOrderTapped = { [weak self] alert in
            self?.maxOrderTapped?(alert)
        }

        // 수량 변경 시 합계 갱신
        cell.onCountChanged = { [weak self] newCount in
            guard let self = self else { return }
            self.datas[indexPath.row].count = newCount
            self.updateSummary()
        }
        return cell
    }
}

