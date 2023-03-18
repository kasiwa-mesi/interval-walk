//
//  RecordPresenter.swift
//  IntervalWalk
//
//  Created by kasiwa on 2023/02/24.
//

import Foundation

protocol RecordPresenterInput {
    func showErrorAlert(error: NSError?)
    func fetchRecords()
    var userId: String { get }
    var records: [RecordModel] { get }
    var numberOfItems: Int { get }
    func item(index: Int) -> RecordModel
}

protocol RecordPresenterOutput {
    func showErrorAlert(code: String, message: String)
    func update(loading: Bool)
    func showHowToView()
    func updateRecordModels()
}


final class RecordPresenter {
    private var output: RecordPresenterOutput!
    
    private var _userId: String
    var userId: String {
        get {
            return _userId
        }
    }
    
    private var _records: [RecordModel] = []
    var records: [RecordModel] {
        get {
            return _records
        }
    }
    
    init(output: RecordPresenterOutput) {
        let userId = AuthService.shared.getCurrentUserId()
        self._userId = userId ?? ""
        self.output = output
    }
}

extension RecordPresenter: RecordPresenterInput {
    var numberOfItems: Int { records.count }

    func item(index: Int) -> RecordModel { records[index] }
    
    func showErrorAlert(error: NSError?) {
        if let error {
            output.showErrorAlert(code: String(error.code), message: error.localizedDescription)
            return
        }
    }
    
    func fetchRecords() {
        output.update(loading: true)
        DatabaseService.shared.getCollection(userId: userId) { records, error in
            self.output.update(loading: false)
            
            self.showErrorAlert(error: error)
            
            if records.isEmpty {
                self.output.showHowToView()
                return
            }
            
            self._records = records
            self.output.updateRecordModels()
            return
        }
    }
}
