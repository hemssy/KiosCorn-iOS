// 결제창 UI

import Foundation
import UIKit
import SnapKit

class PaymentPopUp: UIView {
    

    let paymentPop = UIView()
    let cancelButton = UIButton()
    let payButton = UIButton()
    let tableView = UITableView()
    let stackView = UIStackView()
    let vStackView = UIStackView()
    let totalCount = UILabel()
    let totalPrice = UILabel()
    let hStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainConfigure()
        tableConfigure()
        stackConfigure()
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
    
    /*
     테이블뷰 설정
     */
    
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

        
        self.tableView.register(OrderTableViewCell.self, forCellReuseIdentifier: OrderTableViewCell.identifier)
    }
    
    func setTableViewDelegate() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
    // 스와이프시 셀 삭제
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           
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
    
    // 스택뷰 레이아웃
     func stackConfigure() {
         
         // 아래 두 수직뷰 합치는 수평뷰
         self.addSubview(hStackView)
         [vStackView, stackView]
             .forEach { hStackView.addArrangedSubview($0) }
         
         hStackView.axis = .horizontal
         hStackView.spacing = 170
         hStackView.snp.makeConstraints {
             $0.bottom.equalToSuperview().offset( -30)
         }
        
         
         
         
         // 총 수량 및 가격 수직뷰
         self.addSubview(stackView)
         
         stackView.axis = .vertical
         stackView.spacing = 10
         
         stackView.snp.makeConstraints {
             $0.leading.equalToSuperview().inset(26)
             //$0.trailing.equalToSuperview().offset(-26)
             $0.top.equalTo(tableView.snp.bottom).offset(40)
         }
         
         let total = UILabel()
         let orderPrice = UILabel()
         
         total.text = "총 수량"
         orderPrice.text = "결제 금액"
         
         [total, orderPrice]
             .forEach { stackView.addArrangedSubview($0) }
         
         orderPrice.textAlignment = .left
         
         // 수량 및 가격 숫자 수직뷰
         self.addSubview(vStackView)
         [totalCount, totalPrice]
             .forEach { vStackView.addArrangedSubview($0) }
         
         vStackView.axis = .vertical
         vStackView.spacing = 10
         
         
         totalCount.text = "0"
         totalCount.textColor = .black
         totalPrice.text = "₩"
         totalCount.textColor = .black
         totalCount.font = UIFont.systemFont(ofSize: 16)
         vStackView.alignment = .trailing
         
         
         vStackView.snp.makeConstraints {
             $0.trailing.equalToSuperview().offset(-26)
             $0.top.equalTo(tableView.snp.bottom).offset(40)
         }
         
        
    
     
     }
    
    /*
     기본 레이아웃 설정
     */
    func mainConfigure() {
        [paymentPop, cancelButton, payButton]
            .forEach { self.addSubview($0) }
        paymentPop.backgroundColor = UIColor(named: "DefaultColor")
        
        paymentPop.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 취소 버튼
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.snp.makeConstraints {
            $0.width.equalTo(165)
            $0.height.equalTo(52)
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-35)
            // $0.center.equalToSuperview()
        }
        
        // 결제 버튼
        payButton.setTitle("결제", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = UIColor(named: "PointColor")
        payButton.layer.cornerRadius = 8
        payButton.snp.makeConstraints {
            $0.width.equalTo(165)
            $0.height.equalTo(52)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-35)
        }
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
        print(datas.count)
        return datas.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as? OrderTableViewCell
            else { return OrderTableViewCell() }
        
        let data = datas[indexPath.row]
        cell.itemImage.image = UIImage(named: "kioscornLogo_popcorn")
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
