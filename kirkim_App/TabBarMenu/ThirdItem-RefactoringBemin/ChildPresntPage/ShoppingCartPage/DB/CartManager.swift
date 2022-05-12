//
//  CartManager.swift
//  kirkim_App
//
//  Created by 김기림 on 2022/05/11.
//

import Foundation
import RxSwift
import RxCocoa

class CartManager {
    static let shared = CartManager()
    private var itemDatas: [CartMenuItem]?
    private let dataObserver = BehaviorRelay<[ShoppingCartSectionModel]>(value: [])
    private let isValidObserver = BehaviorRelay<Bool>(value: true)
    private let userDefaults = UserDefaults(suiteName: "ShoppingCart")!
    
    private init() {
        saveItem(data: [
            CartMenuItem(title: "찹스테이크", thumbnailUrl: "", menuString: ["굽기: rare"], price: 20000, count: 3),
            CartMenuItem(title: "포테이토칩", thumbnailUrl: "", menuString: ["salt: 많이", "소스: 머스타드"], price: 5000, count: 7),
            CartMenuItem(title: "투움바 파스타", thumbnailUrl: "", menuString: ["사리: 면사리추가, 소스추가"], price: 15000, count: 2),
        ])
        update()
    }
    
    private func update() {
        var dataValue: [ShoppingCartSectionModel] = []
        let items = getItem()
        if (items?.count != 0 && items != nil) {
            let type = getType()
            let deliveryTip = getDeliveryTip()
            
            self.itemDatas = items // 앱을 껏다켰을때 최신데이터를 임시데이터에 저장
            
            var totalPrice = 0
            items!.forEach { item in
                totalPrice += item.price * item.count
            }
            
            let itemData = ShoppingCartSectionModel.cartMenuSection(items: items!)
            let cartTypeData = ShoppingCartSectionModel.cartTypeSection(items: [type])
            let priceData = ShoppingCartSectionModel.cartPriceSection(items: [CartPriceItem(deliveryTip: deliveryTip, menuPrice: totalPrice)])
            
            dataValue = [itemData, cartTypeData, priceData]
            self.isValidObserver.accept(true)
        } else {
            self.isValidObserver.accept(false)
        }
        dataObserver.accept(dataValue)
    }
    
    func deleteItem(indexPath: IndexPath) {
        guard self.itemDatas != nil else {
            return
        }
        self.itemDatas!.remove(at: indexPath.row)
        saveItem(data: self.itemDatas!)
        update()
    }
    
    func getIsValidObserver() -> BehaviorRelay<Bool> {
        return self.isValidObserver
    }
    
    func getDataObserver() -> BehaviorRelay<[ShoppingCartSectionModel]> {
        update()
        return self.dataObserver
    }
    
    func changeItemCount(indexPath: IndexPath, value: Int) {
        guard var itemDatas = self.itemDatas else {
            return
        }
        
        itemDatas[indexPath.row].count = value
        self.saveItem(data: itemDatas)
        update()
    }
    
    private func saveItem(data: [CartMenuItem]) {
        self.itemDatas = data // 메뉴아이템섹션의 셀은 여러개 나중에 수정할때 참고하기위한 변수
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            userDefaults.setValue(encoded, forKey: "item")
        }
    }
    
    private func getItem() -> [CartMenuItem]? {
        if let savedData = userDefaults.object(forKey: "item") as? Data {
            let decoder = JSONDecoder()
            let savedObject = try? decoder.decode([CartMenuItem].self, from: savedData)
            return savedObject
        }
        return nil
    }
    
    private func saveType(data: CartTypeItem) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(data) {
            userDefaults.setValue(encoded, forKey: "type")
        }
    }
    
    private func getType() -> CartTypeItem {
        if let savedData = userDefaults.object(forKey: "type") as? Data {
            let decoder = JSONDecoder()
            let savedObject = try? decoder.decode(CartTypeItem.self, from: savedData)
            return savedObject ?? CartTypeItem(type: .delivery)
        }
        return CartTypeItem(type: .delivery)
    }
    
    private func saveDeliveryTip(data: Int) {
        self.userDefaults.set(data, forKey: "deliveryTip")
    }

    private func getDeliveryTip() -> Int {
        let savedData = userDefaults.integer(forKey: "deliveryTip")
        return savedData
    }
}