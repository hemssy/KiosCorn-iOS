import Foundation

struct MenuItem: Hashable {
    let id: Int // 셀 아이디
    let name: String // 표시할 이름
    let price: Int // 표시할 가격
}

let sampleMenuItems: [MenuItem] = [
    .init(id: 1, name: "메뉴아이템", price: 16900),
    .init(id: 2, name: "메뉴아이템", price: 16900),
    .init(id: 3, name: "메뉴아이템", price: 16900),
    .init(id: 4, name: "메뉴아이템", price: 16900),
    .init(id: 5, name: "메뉴아이템", price: 16900),
    .init(id: 6, name: "메뉴아이템", price: 16900),
]

