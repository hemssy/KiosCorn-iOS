// 결제창 UI

import Foundation
import UIKit
import SnapKit

class PaymentPopUp: UIView {
    
    let paymentPop = UIView()
    let cancelButton = UIButton()
    let callStaffButton = UIButton()
    let payButton = UIButton()
    let tableView = UITableView()
    
    // 총 수량/금액 표시용
    let stackView = UIStackView()
    let vStackView = UIStackView()
    let totalCount = UILabel()
    let totalPrice = UILabel()
    let hStackView = UIStackView()
    
    // 버튼 바 (취소/직원호출/결제)
    let buttonBar = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableConfigure()
        stackConfigure()
        mainConfigure()
        setTableViewDelegate()
    }
    
    struct ItemList {
        let imageName: String
        let name: String
        var price: Int
        var count: Int
    }
    
    var datas: [ItemList] = [
        ItemList(imageName: "kioscornLogo_popcorn", name: "가나디", price: 16500, count: 0),
        ItemList(imageName: "kioscornLogo_popcorn", name: "농담곰", price: 16500, count: 0),
        ItemList(imageName: "kioscornLogo_popcorn", name: "치이카와", price: 16500, count: 0),
        ItemList(imageName: "kioscornLogo_popcorn", name: "춘식이", price: 16500, count: 0),
        ItemList(imageName: "kioscornLogo_popcorn", name: "하치와레", price: 16500, count: 0)
    ]
    
    private var totalNumCount = 0 {
        didSet {
            totalCount.text = "\(totalNumCount)"
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 테이블뷰 레이아웃
    func tableConfigure() {
        self.addSubview(tableView)
        
        tableView.rowHeight = 85
        tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 10
        tableView.snp.makeConstraints {
            $0.width.equalTo(370)
            $0.height.equalTo(197)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().inset(30)
        }
        
        self.tableView.register(OrderTableViewCell.self,
                                forCellReuseIdentifier: OrderTableViewCell.identifier)
    }
    
    func setTableViewDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // 스와이프시 셀 삭제
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: nil) { [weak self](action, view, completion) in
            guard let self = self else { return }
            self.datas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        action.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    // 수량 / 가격 스택뷰
    func stackConfigure() {
        self.addSubview(hStackView)
        [vStackView, stackView].forEach { hStackView.addArrangedSubview($0) }
        
        hStackView.axis = .horizontal
        hStackView.spacing = 170
        hStackView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        // 텍스트 라벨
        let total = UILabel()
        let orderPrice = UILabel()
        total.text = "총 수량"
        orderPrice.text = "결제 금액"
        [total, orderPrice].forEach { stackView.addArrangedSubview($0) }
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        // 숫자 라벨
        [totalCount, totalPrice].forEach { vStackView.addArrangedSubview($0) }
        vStackView.axis = .vertical
        vStackView.spacing = 10
        vStackView.alignment = .trailing
        
        totalCount.text = "0"
        totalCount.font = .systemFont(ofSize: 16)
        totalPrice.text = "₩"
        totalPrice.font = .systemFont(ofSize: 16)
    }
    
    // 메인 레이아웃
    func mainConfigure() {
        [paymentPop, buttonBar].forEach { addSubview($0) }
        paymentPop.backgroundColor = UIColor(named: "DefaultColor")
        paymentPop.snp.makeConstraints { $0.edges.equalToSuperview() }
        sendSubviewToBack(paymentPop)
        
        // 버튼 스택뷰
        buttonBar.axis = .horizontal
        buttonBar.alignment = .fill
        buttonBar.distribution = .fillEqually
        buttonBar.spacing = 10
        [cancelButton, callStaffButton, payButton].forEach { buttonBar.addArrangedSubview($0) }
        
        buttonBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(35)
            $0.top.equalTo(hStackView.snp.bottom).offset(23)
            $0.height.equalTo(46)
        }
        
        // 버튼 스타일
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.black.cgColor
        
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
    }
    
    private func updateTotalCount() {
        totalNumCount = datas.reduce(into: 0) { $0 += $1.count }
    }
    
    private func updateTotalPrice() {
        let sum = datas.reduce(into: 0) { result, data in
            result += data.count * data.price
        }
        self.totalPrice.text = "\(self.formatPrice(sum))원"
    }
    
    func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.locale = Locale(identifier: "ko")
        return formatter.string(from: NSNumber(value: price)) ?? "\(price)"
    }
}

extension PaymentPopUp: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: OrderTableViewCell.identifier,
            for: indexPath
        ) as? OrderTableViewCell else { return OrderTableViewCell() }
        
        let data = datas[indexPath.row]
        cell.itemImage.image = UIImage(named: data.imageName)
        cell.cellConfigure(data: data)
        
        cell.onCountChanged = { [weak self] newCount in
            guard let self = self else { return }
            self.datas[indexPath.row].count = newCount
            self.updateTotalPrice()
            self.updateTotalCount()
        }
        return cell
    }
}

