/*

* 记录一个账单的信息
 */

export class BillInfoType {
    user_name: string;
    id:number;      //主键
    type: number;
    money: number;
    content: string;
    date: string; //"yyyy-mm-dd"

    constructor(user_name: string, id:number, type: number, money: number, content: string, date: string) {
        this.user_name = user_name;
        this.id = id;
        this.type = type;
        this.money = money;
        this.content = content;
        this.date = date;
    }
}

// 临时数据，用于测试
export const TempBills: BillInfoType[] = [
    new BillInfoType("test", 0, 2, 34, "哈哈", "2025-1-14"),
    new BillInfoType("test", 1, 1, 345.65, "bu哈哈", "2025-1-14"),
    new BillInfoType("test", 2, 4, 10000, "爽了", "2025-1-14"),
    new BillInfoType("test", 3, 6, 3, "bu哈哈", "2025-1-13"),
    new BillInfoType("test", 4, 20, 100, "xxs", "2025-2-12")

]