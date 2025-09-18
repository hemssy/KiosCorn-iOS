// PaymentPopUp.swift

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
    let titleStack = UIStackView()
    let valueStack = UIStackView()
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
        didSet { totalCount.text = "\(totalNumCount)" }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 테이블뷰 레이아웃
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
        
        tableView.register(OrderTableViewCell.self,
                           forCellReuseIdentifier: OrderTableViewCell.identifier)
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
            self.datas.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.updateSummary()
            completion(true)
        }
        action.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // 수량 / 가격 스택뷰
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
        
        // 왼쪽 타이틀
        let total = UILabel()
        total.text = "총 수량"
        total.font = .systemFont(ofSize: 16, weight: .medium)
        
        let orderPrice = UILabel()
        orderPrice.text = "결제 금액"
        orderPrice.font = .systemFont(ofSize: 16, weight: .medium)
        
        titleStack.axis = .vertical
        titleStack.spacing = 10
        [total, orderPrice].forEach { titleStack.addArrangedSubview($0) }
        
        // 오른쪽 숫자
        totalCount.text = "0"
        totalCount.font = .systemFont(ofSize: 16, weight: .bold)
        totalCount.textAlignment = .right
        
        totalPrice.text = "₩0"
        totalPrice.font = .systemFont(ofSize: 16, weight: .bold)
        totalPrice.textAlignment = .right
        
        valueStack.axis = .vertical
        valueStack.spacing = 10
        [totalCount, totalPrice].forEach { valueStack.addArrangedSubview($0) }
        
        hStackView.addArrangedSubview(titleStack)
        hStackView.addArrangedSubview(valueStack)
        
        // 좌우 비율 맞추기
        titleStack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        valueStack.setContentHuggingPriority(.required, for: .horizontal)
    }
    
    // 메인 레이아웃 (버튼 바)
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
    
    // 합계 갱신
    private func updateSummary() {
        totalNumCount = datas.reduce(0) { $0 + $1.count }
        let sum = datas.reduce(0) { $0 + ($1.price * $1.count) }
        totalPrice.text = "₩\(formatPrice(sum))"
    }
    
    func formatPrice(_ price: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
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
            self.updateSummary()
        }
        return cell
    }
}

