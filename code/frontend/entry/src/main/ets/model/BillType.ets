export interface IBillType {
    typeID:number; title: string; img: Resource;
}
export const defaultType: IBillType[] = [
    {typeID:0,title: "餐饮", img: $r("app.media.eatIcon")},
    {typeID:1,title: "购物", img: $r("app.media.shoppingIcon")},
    {typeID:2,title: "蔬菜", img: $r("app.media.vegetablesExpenseIcon")},
    {typeID:3,title: "日用", img: $r("app.media.dailyExpenseIcon")},
    {typeID:4,title: "交通", img: $r("app.media.metroExpenseIcon")},
    {typeID:5,title: "旅行", img: $r("app.media.travelExpenseIcon")},
    {typeID:6,title: "宠物", img: $r("app.media.petExpenseIcon")},
    {typeID:7,title: "知识", img: $r("app.media.knowledgeExpenseIcon")},
    {typeID:8,title: "服装", img: $r("app.media.clothExpenseIcon")},
    {typeID:9,title: "数码", img: $r("app.media.digitalProductExpenseIcon")},
    {typeID:10,title: "烟酒", img: $r("app.media.wineExpenseIcon")},
    {typeID:11,title: "零食", img: $r("app.media.snacksExpenseIcon")},
    {typeID:12,title: "医疗", img: $r("app.media.medicalExpenseIcon")},
    {typeID:13,title: "住房", img: $r("app.media.houseExpenseIcon")},
    {typeID:14,title: "儿童", img: $r("app.media.childExpenseIcon")},
    {typeID:15,title: "汽车", img: $r("app.media.carExpenseIcon")},
    {typeID:16,title: "礼物", img: $r("app.media.giftExpenseIcon")},
    {typeID:17,title: "捐赠", img: $r("app.media.supportExpenseIcon")},
    // 下面是收入
    {typeID:18,title: "工资", img: $r("app.media.salaryIcon")},
    {typeID:19,title: "理财", img: $r("app.media.foundationIcon")},
    {typeID:20,title: "礼金", img: $r("app.media.giftMoneyIcon")},
    {typeID:21,title: "兼职", img: $r("app.media.partTimeIncomeIcon")},
    {typeID:22,title: "其它", img: $r("app.media.otherIcon")}
]