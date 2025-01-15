/*
存储关于Bill的一些函数(大概?)
 */

import {BillInfo} from '../model/BillInfo'
import { FormatDate, Translate } from './DealTime';


/*
*   由于判断支出收入的数据定义暂时还未确定
*   此处仅仅是一个暂时判断——money<0为支出,否则为收入
 */
export function isExpense(billinfo:BillInfo):boolean {
    return billinfo.money<0;
}


/*
* 这是一个将账单信息数组转换为map<'date'，账单信息>的函数
* 用处是在明细界面的UI展示
 */

export function SpliteBillsByDate(billinfos: BillInfo[], selectedDate: Date): Map<string, BillInfo[]> {
    const groupedBills: Map<string, BillInfo[]> = new Map();

    const selectedMon: number = selectedDate.getMonth() + 1;
    const selectedYear: number = selectedDate.getFullYear();

    billinfos.forEach(bill => {
        const date = bill.date; //  date 是字符串，格式为 'YYYY-MM-DD'
        const month = new Date(date).getMonth() + 1;
        const year = new Date(date).getFullYear();

        if (year == selectedYear && month === selectedMon && !groupedBills.has(date) ) {
            groupedBills.set(date, []);
        }
        if (groupedBills.has(date)) {
            groupedBills.get(date)!.push(bill);
        } else {
            console.error(`Date ${date} was not initialized correctly.`);
        }
    });

    return groupedBills;
}


/*
* 这是一个将账单信息数组转换为map<mon:number,账单信息[]>的函数
* 用处是在账单界面的UI展示
 */

export function SpliteBillsByMon(billinfos: BillInfo[], selectedDate: Date): Map<number, BillInfo[]> {
    const groupedBills: Map<number, BillInfo[]> = new Map();

    const selectedMon: number = selectedDate.getMonth() + 1;
    const selectedYear: number = selectedDate.getFullYear();

    billinfos.forEach(bill => {
        const date = bill.date; //  date 是字符串，格式为 'YYYY-MM-DD'
        const month = new Date(date).getMonth() + 1;
        const year = new Date(date).getFullYear();

        if (year == selectedYear  && !groupedBills.has(month) ) {
            groupedBills.set(month, []);
        }
        if (groupedBills.has(month)) {
            groupedBills.get(month)!.push(bill);
        } else {
            console.error(`Date ${month} was not initialized correctly.`);
        }
    });

    return groupedBills;
}


/*
* 这是一个计算当月支出和收入的函数
 */

export function CalBill(BillsByDate:Map<string, BillInfo[]>):[ number,number ]{
    let totalExpense : number = 0;
    let totalIncome : number = 0;

    BillsByDate.forEach(item =>{
       item.forEach(bill =>{
           if(bill.money < 0){
               totalExpense += -bill.money;
           }
           else{
               totalIncome += bill.money
           }
       })
    })

    return [totalExpense,totalIncome];
}

export function CalExpense(BillInfos:BillInfo[]):number {
    let totalExpense = 0;
    BillInfos.forEach((bill)=>{
        if(isExpense(bill)) totalExpense += Math.abs(bill.money);
    })
    return totalExpense;
}

export function CalIncome(BillInfos:BillInfo[]):number {
    let totalExpense = 0;
    BillInfos.forEach((bill)=>{
        if(!isExpense(bill)) totalExpense += Math.abs(bill.money);
    })
    return totalExpense;
}

export function CalLeft(BillInfos:BillInfo[]):number {
    let totalLeft = 0;
    BillInfos.forEach((bill)=>{
        (isExpense(bill))? totalLeft += Math.abs(bill.money):totalLeft -= Math.abs(bill.money);
    })
    return totalLeft;
}