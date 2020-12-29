module smartHome
open smartHomeCore

// Our home has to have at least two outlets in each room
fact { all a : Room | (some b : a.accessories, c : a.accessories | b.category = AccessoryCategoryOutlet && c.category = AccessoryCategoryOutlet && b != c) }
// ... and al least lightbulb in each room
fact { all a : Room | (some b : a.accessories | b.category = AccessoryCategoryLightbulb) }
// ... and at least one window in each room
fact { all a : Room | (some b : a.accessories | b.category = AccessoryCategoryWindow) }
// ... and one fan for the whole home
fact { all a : Home | (one b : a.accessories | b.category = AccessoryCategoryFan) }
// ... and one alarm for the whole home
fact { all a : Home | (one b : a.accessories | b.category = AccessoryCategoryAlarm) }

run addAccessory for 20 but exactly 1 Home, exactly 4 Room, exactly 18 Accessory
// run addRoom for 20 but exactly 1 Home, exactly 4 Room, exactly 18 Accessory
