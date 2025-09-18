// 결제창 UI

import Foundation
import UIKit
import SnapKit

class PaymentPopUp: UIView {
    
    // 임시방편 배열입니다.
    var datas = ["가나디", "농담곰", "치이카와", "춘식이", "하치와레"]
    let paymentPop = UIView()
    let cancelButton = UIButton()
    let payButton = UIButton()
    let tableView = UITableView()
    let stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainConfigure()
        tableConfigure()
        setTableViewDelegate()
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
    
}



extension PaymentPopUp: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(datas.count)
        return datas.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.identifier, for: indexPath) as? OrderTableViewCell
            else { return.init() }
        
        let data = datas[indexPath.row]
        cell.cellConfigure(data: data)
        return cell
    }
}
