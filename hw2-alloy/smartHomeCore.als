module smartHomeCore

// Name is an identifier unique among the objects of the same type in the same home/room/...
sig Name {
}

sig Home {
    name : one Name,
    rooms : set Room,
    accessories : set Accessory,
    services : set Service
}

// Every home has a distinct name
fact { all a : Home, b : Home | a.name = b.name => a = b }

// Every service in a home is for an accessory in the same home and vice versa
fact { all a : Home, b : a.rooms, c : b.accessories, d : c.services | d in a.services }
fact { all a : Home, b : a.services | b.accessory in a.accessories }

// Every accessory in a home is in a room of the same home and vice versa
fact { all a : Home, b : a.rooms, c : b.accessories | c in a.accessories }
fact { all a : Home, b : a.accessories | b.room in a.rooms }

sig Room {
    name : one Name,
    home : one Home,
    accessories : set Accessory
}

// All rooms in a home have distinct names
fact { all a : Room, b : Room | (a.name = b.name && a.home = b.home) => a = b }

// The rooms in a home refer to it and it to them
fact { all a : Room | a in a.home.rooms }
fact { all a : Home, b : a.rooms | b.home = a }

sig Accessory {
    name : one Name,
    category : one AccessoryCategory,
    room : one Room,
    services: set Service
}

sig AccessoryCategory {}

// All accessories in a room have distinct names
fact { all a : Accessory, b : Accessory | (a.name = b.name && a.room = b.room) => a = b }

// All accessories in a home have distinct names
fact { all h : Home, a : h.accessories, b : h.accessories | a.name = b.name => a = b }

// The accessories in a room refer to it and it refers to them
fact { all a : Accessory | a in a.room.accessories }
fact { all a : Room, b : a.accessories | b.room = a }

sig Service {
    name : one Name,
    type : one ServiceType,
    accessory : one Accessory,
    characteristics: set Characteristic
}

sig ServiceType {}

// All servicesof an accessory have distinct names
fact { all a : Service, b : Service | (a.name = b.name && a.accessory = b.accessory) => a = b }

// All services in a home have distinct names
fact { all h : Home, a : h.services, b : h.services | a.name = b.name => a = b }

// All services of an accessory refer to it and it refers to them
fact { all a : Service | a in a.accessory.services }
fact { all a : Accessory, b : a.services | b.accessory = a }

sig Characteristic {
    name : one Name,
    value : lone CharacteristicValue,
    type : one CharacteristicType,
    service : one Service
}

// All characteristics of a service have distinct names
fact { all a : Characteristic, b : Characteristic | (a.name = b.name && a.service = b.service) => a = b }

// All characteristics of a service refer to it and it refers to them
fact { all a : Characteristic | a in a.service.characteristics }
fact { all a : Service, b : a.characteristics | b.service = a }

sig CharacteristicType {}
sig CharacteristicValue {}

sig CharacteristicValueLux extends CharacteristicValue {}
sig CharacteristicValuePercentage extends CharacteristicValue {}

sig CharacteristicValueBoolean extends CharacteristicValue {}
one sig CharacteristicValueTrue extends CharacteristicValueBoolean {}
one sig CharacteristicValueFalse extends CharacteristicValueBoolean {}

fact { CharacteristicValue = CharacteristicValueBoolean + CharacteristicValueLux + CharacteristicValuePercentage }
fact { CharacteristicValueBoolean = CharacteristicValueFalse + CharacteristicValueTrue }

// Lightbulbs
one sig AccessoryCategoryLightbulb extends AccessoryCategory {}
one sig ServiceTypeLightbulb extends ServiceType {}
one sig CharacteristicTypeBrightness extends CharacteristicType {}
one sig CharacteristicTypeCurrentLightLevel extends CharacteristicType {}

fact { all a : Accessory | a.category = AccessoryCategoryLightbulb => (one b : a.services | b.type = ServiceTypeLightbulb) }
fact { all a : Accessory | a.category = AccessoryCategoryLightbulb => (#a.services = 1) }

fact { all a : Service | a.type = ServiceTypeLightbulb => (one b : a.characteristics | b.type = CharacteristicTypeBrightness) }
fact { all a : Service | (#a.characteristics = 2 && a.type = ServiceTypeLightbulb) => (one b : a.characteristics | b.type = CharacteristicTypeCurrentLightLevel) }
fact { all a : Service | a.type = ServiceTypeLightbulb => (#a.characteristics <= 2) }

fact { all a : Characteristic | a.type = CharacteristicTypeBrightness => (one a.value && a.value in CharacteristicValuePercentage) }
fact { all a : Characteristic | a.type = CharacteristicTypeCurrentLightLevel => (one a.value && a.value in CharacteristicValueLux) }

// Outlets
one sig AccessoryCategoryOutlet extends AccessoryCategory {}
one sig ServiceTypeOutlet extends ServiceType {}
one sig CharacteristicTypeOutletInUse extends CharacteristicType {}

fact { all a : Accessory | a.category = AccessoryCategoryOutlet => (one b : a.services | b.type = ServiceTypeOutlet) }
fact { all a : Accessory | a.category = AccessoryCategoryOutlet => (#a.services = 1) }

fact { all a : Service | a.type = ServiceTypeOutlet => (one b : a.characteristics | b.type = CharacteristicTypeOutletInUse) }
fact { all a : Service | a.type = ServiceTypeOutlet => (#a.characteristics = 1) }

fact { all a : Characteristic | a.type = CharacteristicTypeOutletInUse => (one a.value && a.value in CharacteristicValueBoolean) }

// Fans
one sig AccessoryCategoryFan extends AccessoryCategory {}
one sig ServiceTypeFan extends ServiceType {}
one sig CharacteristicTypeRotationSpeed extends CharacteristicType {}

fact { all a : Accessory | a.category = AccessoryCategoryFan => (one b : a.services | b.type = ServiceTypeFan) }
fact { all a : Accessory | a.category = AccessoryCategoryFan => (#a.services = 1) }

fact { all a : Service | a.type = ServiceTypeFan => (one b : a.characteristics | b.type = CharacteristicTypeRotationSpeed) }
fact { all a : Service | a.type = ServiceTypeFan => (#a.characteristics = 1) }

fact { all a : Characteristic | a.type = CharacteristicTypeRotationSpeed => (one a.value && a.value in CharacteristicValuePercentage) }

// Windows
one sig AccessoryCategoryWindow extends AccessoryCategory {}
one sig ServiceTypeWindow extends ServiceType {}
one sig CharacteristicTypeOpennes extends CharacteristicType {}

fact { all a : Accessory | a.category = AccessoryCategoryWindow => (one b : a.services | b.type = ServiceTypeWindow) }
fact { all a : Accessory | a.category = AccessoryCategoryWindow => (#a.services = 1) }

fact { all a : Service | a.type = ServiceTypeWindow => (one b : a.characteristics | b.type = CharacteristicTypeOpennes) }
fact { all a : Service | a.type = ServiceTypeWindow => (#a.characteristics = 1) }

fact { all a : Characteristic | a.type = CharacteristicTypeOpennes => (one a.value && a.value in CharacteristicValuePercentage) }

// Alarms
one sig AccessoryCategoryAlarm extends AccessoryCategory {}
one sig ServiceTypeAlarm extends ServiceType {}
one sig CharacteristicTypeAlarmOff extends CharacteristicType {}

fact { all a : Accessory | a.category = AccessoryCategoryAlarm => (one b : a.services | b.type = ServiceTypeAlarm) }
fact { all a : Accessory | a.category = AccessoryCategoryAlarm => (#a.services = 1) }

fact { all a : Service | a.type = ServiceTypeAlarm => (one b : a.characteristics | b.type = CharacteristicTypeAlarmOff) }
fact { all a : Service | a.type = ServiceTypeAlarm => (#a.characteristics = 1) }

fact { all a : Characteristic | a.type = CharacteristicTypeAlarmOff => (one a.value && a.value in CharacteristicValueBoolean) }


fact { AccessoryCategory = AccessoryCategoryFan + AccessoryCategoryLightbulb + AccessoryCategoryOutlet + AccessoryCategoryWindow + AccessoryCategoryAlarm }
fact { ServiceType = ServiceTypeFan + ServiceTypeLightbulb + ServiceTypeOutlet + ServiceTypeWindow + ServiceTypeAlarm }
fact { CharacteristicType = CharacteristicTypeBrightness + CharacteristicTypeCurrentLightLevel + CharacteristicTypeOutletInUse + CharacteristicTypeRotationSpeed + CharacteristicTypeOpennes + CharacteristicTypeAlarmOff }

pred addRoom [a : Home, b : Room] {
    b.home = a
    a.rooms = a.rooms + b
    a.accessories = a.accessories + b.accessories
    a.services = a.services + b.accessories.services
}

pred addAccessory [a : Home, b : Room, c : Accessory] {
    c.room = b
    b.accessories = b.accessories + c
    a.accessories = a.accessories + c
    a.services = a.services + c.services
}
