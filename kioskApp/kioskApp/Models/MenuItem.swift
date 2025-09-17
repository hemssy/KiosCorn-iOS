import Foundation

enum Category: CaseIterable, Hashable {
    case popcorn, drinks, snack, combo
    
    var title: String {
        switch self {
        case .combo:   return "Combo"
        case .popcorn: return "Popcorn"
        case .snack:    return "Snacks"
        case .drinks:  return "Drinks"
        }
    }
}

struct MenuItem: Hashable {
    let id = UUID()
    let name: String
    let price: Int
    let imageName: String        // Assets.xcassets 안에 있는 이미지 이름
    let category: Category
}

let allItems: [MenuItem] = [
    .init(name: "크림새우 콤보", price: 20900, imageName: "combo01", category: .combo),
    .init(name: "통찡어콤보", price: 21900, imageName: "combo02", category: .combo),
    .init(name: "즉석구이콤보", price: 19900, imageName: "combo03", category: .combo),
    .init(name: "나쵸콤보", price: 16900, imageName: "combo04", category: .combo),
    .init(name: "비어세트", price: 15900, imageName: "combo05", category: .combo),
    .init(name: "핫도그콤보", price: 15900, imageName: "combo06", category: .combo),
    
    .init(name: "구운양파팝콘L", price: 8500, imageName: "popcorn01", category: .popcorn),
    .init(name: "구운양파팝콘R", price: 7500, imageName: "popcorn02", category: .popcorn),
    .init(name: "반반팝콘L", price: 8500, imageName: "popcorn03", category: .popcorn),
    .init(name: "스키피땅콩버터팝콘R", price: 7500, imageName: "popcorn04", category: .popcorn),
    .init(name: "더블카라멜&치즈팝콘", price: 6900, imageName: "popcorn05", category: .popcorn),
    .init(name: "팝콘", price: 5500, imageName: "popcorn06", category: .popcorn),
    
    .init(name: "통찡어", price: 11900, imageName: "snack01", category: .snack),
    .init(name: "크림새우", price: 10900, imageName: "snack02", category: .snack),
    .init(name: "즉석오징어", price: 9500, imageName: "snack03", category: .snack),
    .init(name: "순살치킨", price: 9500, imageName: "snack04", category: .snack),
    .init(name: "포테이토", price: 6500, imageName: "snack05", category: .snack),
    .init(name: "포테이토앤소시지", price: 6900, imageName: "snack06", category: .snack),
    
    .init(name: "탄산", price: 3900, imageName: "drink01", category: .drinks),
    .init(name: "망고밀크쉐이크", price: 7900, imageName: "drink02", category: .drinks),
    .init(name: "멜론쉐이크", price: 6900, imageName: "drink03", category: .drinks),
    .init(name: "커피쉐이크", price: 6900, imageName: "drink04", category: .drinks),
    .init(name: "밀크쉐이크", price: 6900, imageName: "drink05", category: .drinks),
    .init(name: "오렌지에이드", price: 5900, imageName: "drink06", category: .drinks),
]

