/*

* 记录一个账单的信息
 */

export class BillInfo {
    user_name: string;
    type: number;
    money: number;
    content: string;
    date: string; //"yyyy-mm-dd"

    constructor(user_name: string, type: number, money: number, content: string, date: string) {
        this.user_name = user_name;
        this.type = type;
        this.money = money;
        this.content = content;
        this.date = date;
    }
}

// 临时数据，用于测试
export const TempBills: BillInfo[] = [
    new BillInfo("test", 2, -34, "哈哈", "2025-1-14"),
    new BillInfo("test", 1, -345.65, "bu哈哈", "2025-1-14"),
    new BillInfo("test", 1, +10000, "爽了", "2025-1-14"),
    new BillInfo("test", 6, -3, "bu哈哈", "2025-1-13"),
    new BillInfo("test", 8, -78, "bu哈哈", "2025-1-12")
]