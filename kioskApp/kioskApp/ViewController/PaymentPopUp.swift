// 결제창 UI

import Foundation
import UIKit
import SnapKit

class PaymentPopUp: UIView {
    
    // 임시방편 배열입니다.
    //var datas = ["가나디", "농담곰", "치이카와", "춘식이", "하치와레"]
    let paymentPop = UIView()
    let cancelButton = UIButton()
    let callStaffButton = UIButton()
    let payButton = UIButton()
    let tableView = UITableView()
    let stackView = UIStackView()
    let buttonBar = UIStackView() // <취소/직원호출/결제>버튼을 스택뷰로 묶음
    
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
        let price: String
    }
    
    var datas: [ItemList] = [
        ItemList(imageName: "kioscornLogo_popcorn", name: "가나디", price: "16,500"),
        ItemList(imageName: "kioscornLogo_popcorn", name: "농담곰", price: "16,500"),
        ItemList(imageName: "kioscornLogo_popcorn", name: "치이카와", price: "16,500"),
        ItemList(imageName: "kioscornLogo_popcorn", name: "춘식이", price: "16,500"),
        ItemList(imageName: "kioscornLogo_popcorn", name: "하치와레", price: "16,500")
    ]
    
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
         self.addSubview(stackView)
         
         stackView.axis = .vertical
         stackView.spacing = 10
         
         stackView.snp.makeConstraints {
             $0.leading.equalToSuperview().inset(26)
             $0.trailing.equalToSuperview().offset(-26)
             $0.top.equalTo(tableView.snp.bottom).offset(40)
         }
         
         let total = UILabel()
         let orderPrice = UILabel()
         
         total.text = "총 수량"
         orderPrice.text = "결제 금액"
         
         stackView.addArrangedSubview(total)
         stackView.addArrangedSubview(orderPrice)
         orderPrice.textAlignment = .left
     
     }
    
    /*
     기본 레이아웃 설정
     */
    func mainConfigure() {
        [paymentPop, buttonBar].forEach { addSubview($0) }
        paymentPop.backgroundColor = UIColor(named: "DefaultColor")
        paymentPop.snp.makeConstraints { $0.edges.equalToSuperview() }
        sendSubviewToBack(paymentPop)

        // 스택뷰(버튼들 묶은거) 설정
        buttonBar.axis = .horizontal
        buttonBar.alignment = .fill
        buttonBar.distribution = .fill
        buttonBar.spacing = 10
        [cancelButton, callStaffButton, payButton].forEach { buttonBar.addArrangedSubview($0) }

        // 버튼 크기만 고정 (위치 제약은 스택뷰 영역이 가짐!)
        [cancelButton, callStaffButton, payButton].forEach { b in
            b.snp.makeConstraints {
                $0.width.equalTo(116)
                $0.height.equalTo(46)
            }
        }

        // 스택뷰를 가운데배치 + 아래 여백 설정 + 위에 있는 총수량/결제금액 영역이랑 23 간격
        buttonBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()           // 묶음이 가운데로 오게해줌
            $0.bottom.equalToSuperview().inset(35)
            $0.top.equalTo(stackView.snp.bottom).offset(23)
            $0.height.equalTo(46)
        }
        
        // 취소
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.layer.cornerRadius = 8
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.black.cgColor

        // 직원호출
        callStaffButton.setTitle("직원호출", for: .normal)
        callStaffButton.setTitleColor(.black, for: .normal)
        callStaffButton.backgroundColor = .white
        callStaffButton.layer.cornerRadius = 8
        callStaffButton.layer.borderWidth = 1
        callStaffButton.layer.borderColor = UIColor.black.cgColor

        // 결제
        payButton.setTitle("결제", for: .normal)
        payButton.setTitleColor(.white, for: .normal)
        payButton.backgroundColor = UIColor(named: "PointColor")
        payButton.layer.cornerRadius = 8

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
        return cell
    }
}
