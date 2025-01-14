import { FunctionSelect } from './FunctionSelect'
import { BalanceViewer } from './BalanceViewer'
import { BillInfo } from '../model/BillInfo'

import { defaultExpenseType, defaultIncomeType } from '../model/BillType'

import { isExpense, SpliteBillsByDate } from '../util/DealBill'

@Component
export struct BillPage {
    @State selectedDate: Date = new Date();
    @State totalIncome: number = 0;
    @State totalBalance: number = 0;
    @Link billInfo: BillInfo[]
    @State BillsByDate: Map<string, BillInfo[]> = SpliteBillsByDate(this.billInfo,this.selectedDate);

    // onPageShow(): void {
    //     this.totalIncome = 4;
    //     this.totalBalance = 4;
    // }
    aboutToAppear(): void {
        const BillsByDate: Map<string, BillInfo[]> = SpliteBillsByDate(this.billInfo,this.selectedDate);
    }

    build() {
        Column() {
            Column() {
                Row() {
                    Text($r("app.string.app_title"))
                        .fontColor(Color.Black)
                        .fontSize(24)
                        .fontWeight(FontWeight.Bold)
                        .textAlign(TextAlign.Center)
                        .width('100%')
                }
                .padding(24)
                .width('100%')
                .backgroundColor(Color.White)

                BalanceViewer({
                    selectedDate: $selectedDate,
                    totalIncome: $totalIncome,
                    totalBalance: $totalBalance,
                    billInfo: $billInfo,
                    BillsByDate: $BillsByDate
                })
            }
            .width('100%')
            .backgroundColor(Color.White)

            FunctionSelect({
                selectedDate: $selectedDate
            })

            if (this.billInfo.length == 0 || this.BillsByDate.size == 0) {
                Column() {

                    Image($r('app.media.zanwushuju'))
                        .width(64)
                        .height(64)
                        .objectFit(ImageFit.Contain)
                        .padding({ left: 8 }) //为了美观使得图片和文字对齐
                    Text('暂无数据')
                        .fontSize(16)
                        .padding(8)
                        .fontColor(Color.Grey)
                }
                .height('70%')
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)

            } else {
                List() {
                    ForEach(Array.from(this.BillsByDate.entries()), (item: [date: string, bills: BillInfo[]]) => {
                        ListItem() {
                            // 日期标题
                            Column() {
                                Row() {
                                    Text(item[0])
                                        .fontColor(Color.Black)
                                        .fontSize(12)
                                        .fontWeight(FontWeight.Normal)
                                        .padding(8)

                                }
                                .width('100%')
                                .justifyContent(FlexAlign.Start)

                                // 渲染分组账单
                                this.BillDateList(item[1]);
                            }
                            .width('100%')
                        }
                        .width('100%')
                    })
                }
                .width('100%')
            }

        }
        .height('90%')
    }

    @Builder
    BillItem(billInfo: BillInfo) {
        if (isExpense(billInfo)) {
            Row() {
                Row({space:12}) {
                    Image(defaultExpenseType[billInfo.type].img)
                        .padding(8)
                        .size({ height: 32, width: 32 })
                    Text(defaultExpenseType[billInfo.type].title)
                        .fontSize(12)
                }
                Text(billInfo.money.toString())
                    .fontColor(Color.Black)
                    .fontSize(12)
                    .fontWeight(FontWeight.Bold)
            }
            .margin({left:16,right:16})
            .width('90%')
            .justifyContent(FlexAlign.SpaceBetween)
        }
        else {
            Row() {
                Row({space:12}) {
                    Image(defaultIncomeType[billInfo.type].img)
                        .padding(8)
                        .size({ height: 32, width: 32 })
                    Text(defaultIncomeType[billInfo.type].title)
                        .fontColor(Color.Black)
                        .fontSize(12)
                }
                Text(billInfo.money.toString())
                    .fontColor(Color.Black)
                    .fontSize(12)
                    .fontWeight(FontWeight.Bold)

            }
            .margin({left:16,right:16})
            .width('90%')
            .justifyContent(FlexAlign.SpaceBetween)
        }

    }

    @Builder
    BillDateList(billInfoarray: BillInfo[]) {

        List({ space: 2 }) {
            ForEach(billInfoarray, (item: BillInfo) => {
                ListItem() {
                    this.BillItem(item)
                }
            },)
        }
        .borderWidth({ bottom: 1 })
        .borderColor(Color.White)

    }
}