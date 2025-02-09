import { BillInfoType } from '../model/BillInfoType';
import { CalExpense, CalIncome, CalLeft, isExpense, SpliteBillsByMon } from '../util/DealBill';
import { router } from '@kit.ArkUI';
import { taskpool } from '@kit.ArkTS'

interface reNumber {
    yearlyLeft: number,
    yearlyIncome: number,
    yearlyExpense: number
}

@Concurrent
//多线程部分
function calMoney(billInfo: BillInfoType[]): reNumber {
    let yearlyExpense: number = 0;
    let yearlyIncome: number = 0;
    let yearlyLeft: number = 0;

    billInfo.forEach((bill) => {
        isExpense(bill) ? yearlyExpense += Math.abs(bill.money) : yearlyIncome += Math.abs(bill.money)
    })
    yearlyLeft = yearlyIncome - yearlyExpense;
    return {
        yearlyLeft: yearlyLeft,
        yearlyIncome: yearlyIncome,
        yearlyExpense: yearlyExpense
    };

}

@Entry
@Component
struct BillInfos {
    @State billInfo: BillInfoType[] = (router.getParams() as ESObject)['billInfo'];
    @State activeDate: Date = new Date();
    @State yearlyLeft: number = 0;
    @State yearlyExpense: number = 0;
    @State yearlyIncome: number = 0;
    @State BillsByMon: Map<number, BillInfoType[]> = SpliteBillsByMon(this.billInfo, this.activeDate);

    updateTotalNumber(): void {
        this.yearlyLeft = 0;
        this.yearlyIncome = 0;
        this.yearlyExpense = 0;
        let BillsByMon = Array.from(this.BillsByMon.entries());
        let tasks: taskpool.Task[] = []

        this.BillsByMon.forEach((item) => {
            let task: taskpool.Task = new taskpool.Task(calMoney, item)
            tasks.push(task);
        })
        tasks.forEach((task) => {
            taskpool.execute(task).then((ret) => {
                this.yearlyExpense += (ret as reNumber).yearlyExpense;
                this.yearlyIncome += (ret as reNumber).yearlyIncome;
                this.yearlyLeft += (ret as reNumber).yearlyLeft;
            }).catch((e: object) => {
                console.info("task5 catch e: " + e);
            })
        })
    }

    onPageShow(): void {
        this.updateTotalNumber();
    }

    build() {
        RelativeContainer() {
            Column() {
                Row() {
                    SymbolGlyph($r('sys.symbol.arrow_left'))
                        .size({ height: 16, width: 16 })
                        .onClick(() => {
                            router.back();
                        })
                    Row() {

                        Text(`${this.activeDate.getFullYear()}`)
                            .fontSize(16)
                            .margin({ left: 16 })
                        Text($r("app.string.year"))
                            .fontSize(14)
                        Image($r("app.media.ic_public_extract_list_dark"))
                            .width(8)
                            .height(8)
                            .margin({ left: 8 })
                    }.onClick(() => {
                        DatePickerDialog.show({
                            start: new Date("2000-01"),
                            onAccept: (v) => {
                                this.activeDate.setFullYear(v.year, v.month, v.day);
                                this.BillsByMon = SpliteBillsByMon(this.billInfo, this.activeDate);
                                this.updateTotalNumber();
                            }
                        })
                    })

                }
                .height(36)
                .margin(16)
                .width('90%')
                .justifyContent(FlexAlign.SpaceBetween)

                Row() {
                    Column() {
                        Row() {
                            Text("年结余").fontSize(14).fontColor('#ffffff').margin(4).height(22)
                        }
                        .width('100%')
                        .justifyContent(FlexAlign.Start)

                        Row() {
                            Text(`${this.yearlyLeft}`).fontSize(28).fontColor('#ffffff').margin(4).height(36)
                        }
                        .width('100%')
                        .justifyContent(FlexAlign.Start)

                        Row() {
                            Text(`年收入 ${this.yearlyIncome}`)
                                .fontColor('#ffffff')
                                .fontSize(14)
                                .height(30)
                            Blank()
                                .width('40%')
                            Text(`年支出 ${this.yearlyExpense}`)
                                .fontColor('#ffffff')
                                .fontSize(14)
                                .height(30)
                        }
                        .justifyContent(FlexAlign.Start)
                        .width('100%')
                    }
                    .padding({
                        left: 24,
                        right: 24,
                        top: 16,
                        bottom: 16
                    })
                }
                .height(132)
                .backgroundColor($r("app.color.main_theme_blue"))
                .margin({ left: 16, right: 16 })
                .borderRadius(12)
                .shadow({ radius: 12, color: $r('app.color.main_theme_shadow') })

                Row() {
                    Column() {
                        GridRow({ columns: 4 }) {
                            GridCol() {
                                Text("月份").fontSize(12).fontColor($r("app.color.text_gray"))
                            }

                            GridCol() {
                                Text("月收入").fontSize(12).fontColor($r("app.color.text_gray"))
                            }

                            GridCol() {
                                Text("月支出").fontSize(12).fontColor($r("app.color.text_gray"))
                            }

                            GridCol() {
                                Text("月结余").fontSize(12).fontColor($r("app.color.text_gray"))
                            }
                        }
                        .width('100%')
                        .margin({ bottom: 8 })

                        Row() {
                            List() {
                                ForEach(Array.from(this.BillsByMon.entries()),
                                    (item: [mon: number, bills: BillInfoType[]]) => {
                                        ListItem() {
                                            GridRow({ columns: 4 }) {
                                                GridCol() {
                                                    Text(`${item[0]}月`).fontSize(16)
                                                }

                                                GridCol() {
                                                    Text(`${CalIncome(item[1])}`).fontSize(14)
                                                }

                                                GridCol() {
                                                    Text(`${CalExpense(item[1])}`).fontSize(14)
                                                }

                                                GridCol() {
                                                    Text(`${CalLeft(item[1])}`).fontSize(14)
                                                }
                                            }
                                            .padding(12)
                                            .border({
                                                width: { top: 0.5 },
                                                color: $r("app.color.text_gray")
                                            })
                                            .width('100%')
                                        }
                                    })
                            }.listDirection(Axis.Vertical)
                        }
                        .width('100%')
                    }
                }
                .padding(16)
                .width('100%')
            }
        }
    }
}