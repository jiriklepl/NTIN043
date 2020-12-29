module smartHome

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

// Every service in a home is for an accessory in the same home
fact { all a : Home, b : a.services | b.accessory in a.accessories }

// Every accessory in a home is in a room of the same home
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

fact { all a : Accessory, b : Accessory | (a.name = b.name && a.room = b.room) => a = b }

fact { all a : Accessory | a in a.room.accessories }
fact { all a : Room, b : a.accessories | b.room = a }

sig Service {
    name : one Name,
    type : one ServiceType,
    accessory : one Accessory,
    characteristics: set Characteristic
}

sig ServiceType {}

fact { all a : Service, b : Service | (a.name = b.name && a.accessory = b.accessory) => a = b }

fact { all a : Service | a in a.accessory.services }
fact { all a : Accessory, b : a.services | b.accessory = a }

sig Characteristic {
    name : one Name,
    value : lone CharacteristicValue, // TODO: why lone and not one?
    type : one CharacteristicType,
    service : one Service
}

fact { all a : Characteristic, b : Characteristic | (a.name = b.name && a.service = b.service) => a = b }

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

fact { ServiceType = ServiceTypeFan + ServiceTypeLightbulb + ServiceTypeOutlet }
fact { AccessoryCategory = AccessoryCategoryFan + AccessoryCategoryLightbulb + AccessoryCategoryOutlet }
fact { CharacteristicType = CharacteristicTypeBrightness + CharacteristicTypeCurrentLightLevel + CharacteristicTypeOutletInUse + CharacteristicTypeRotationSpeed }


fact { all a : Room | (some b : a.accessories, c : a.accessories | b.category = AccessoryCategoryOutlet && c.category = AccessoryCategoryOutlet && b != c) }
fact { all a : Room | (some b : a.accessories | b.category = AccessoryCategoryLightbulb) }

run {} for 20 but exactly 1 Home, exactly 3 Room, exactly 12 Accessory
