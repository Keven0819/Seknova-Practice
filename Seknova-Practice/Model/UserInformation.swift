//
//  UserInformation.swift
//  Seknova-Practice
//
//  Created by imac-2627 on 2024/10/17.
//

import RealmSwift

class UserInformation: Object {
    //uuid
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var FirstName: String
    @Persisted var LastName: String
    @Persisted var Birthday: String
    @Persisted var Email: String
    @Persisted var Phone: String
    @Persisted var Address: String
    @Persisted var Gender: String
    @Persisted var Height: String
    @Persisted var Weight: String
    @Persisted var Race: String
    @Persisted var Liquor: String
    @Persisted var Smoke: String
    @Persisted var Check: Bool
    @Persisted var Phone_Verified: Bool
    
    convenience init(FirstName: String, LastName: String,
                     Birthday: String, Email: String, Phone: String,
                     Address: String, Gender: String, Height: String,
                     Weight: String, Race: String, Liquor: String,
                     Smoke: String, Check: Bool, Phone_Verified: Bool) {
        self.init()
        self.FirstName = FirstName
        self.LastName = LastName
        self.Birthday = Birthday
        self.Email = Email
        self.Phone = Phone
        self.Address = Address
        self.Gender = Gender
        self.Height = Height
        self.Weight = Weight
        self.Race = Race
        self.Liquor = Liquor
        self.Smoke = Smoke
        self.Check = Check
        self.Phone_Verified = Phone_Verified
    }
}
