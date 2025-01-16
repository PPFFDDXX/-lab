import { BillInfoType } from '../model/BillInfoType';
import { CalBill, SpliteBillsByDate } from '../util/DealBill';
import { FormatDate } from '../util/DealTime'
import { promptAction } from '@kit.ArkUI';



@Component
export struct BalanceViewer {
    @Link selectedDate: Date;
    @Link totalIncome: number;
    @Link totalBalance: number;
    @Link billInfo: BillInfoType[]
    @Link BillsByDate: Map<string, BillInfoType[]>

    UpdateTotalMoney():void {
        //UI更新当月总支出和总收入
        const Obj:[number,number] = CalBill(this.BillsByDate);
        this.totalBalance = Obj[0];
        this.totalIncome = Obj[1];
    }

    aboutToAppear(): void {
        this.UpdateTotalMoney()

    }

    build() {
        Column() {
            Row() {
                Column() {
                    Row() {
                        Text(FormatDate(this.selectedDate, 'Y'))
                            .fontSize(12)
                            .fontColor($r('app.color.text_light_black'))
                        Text("年").fontSize(12).fontColor($r('app.color.text_light_black'))
                    }
                }.width('20%')

                Column() {
                    Text("收入")
                        .fontColor($r('app.color.text_light_black'))
                        .fontSize(12)
                        .textAlign(TextAlign.Start)
                        .width('100%')
                }.width('40%').margin({ left: 10 })

                Column() {
                    Text("支出")
                        .fontColor($r('app.color.text_light_black'))
                        .fontSize(12)
                        .textAlign(TextAlign.Start)
                        .width('100%')
                }.width('40%')
            }
            .height(12)
            .width('100%')

            Row() {
                Column() {
                    Button({ type: ButtonType.Normal }) {
                        Row() {
                            Text(FormatDate(this.selectedDate, 'M'))
                                .fontSize(22)
                                .fontColor(Color.Black)
                            Text("月")
                                .fontColor($r('app.color.text_light_black'))
                                .fontSize(12)
                                .align(Alignment.Bottom)
                                .height(22)
                                .margin(2)
                            Image($r("app.media.ic_public_extract_list_light"))
                                .width(8).height(8).margin({ top: 6, left: 8 })
                        }
                    }.onClick(() => {
                        DatePickerDialog.show({
                            start: new Date(`2000-01-01`),
                            selected: this.selectedDate,
                            onAccept: (v) => {

                                this.selectedDate.setFullYear(v.year, v.month, v.day);
                                if (this.billInfo.length == 0) {
                                    promptAction.showToast({
                                        message: "为空",
                                        duration: 2000
                                    })
                                } else {
                                    this.BillsByDate = SpliteBillsByDate(this.billInfo, this.selectedDate);
                                    this.UpdateTotalMoney();
                                }
                            }
                        });
                    })
                    .backgroundColor('#AAAAF0')
                    .width('100%')
                    .borderRadius(4)
                }
                .width('20%')
                .border({
                    style: BorderStyle.Solid,
                    color: { right: "gray" },
                    width: { right: 1 }
                })

                Column() {
                    Text(this.totalIncome.toFixed(2))
                        .fontColor(Color.Black)
                        .fontSize(20)
                        .textAlign(TextAlign.Start)
                        .width('100%')
                }.width('40%')
                .margin({ left: 10 })

                Column() {
                    Text(this.totalBalance.toFixed(2))
                        .fontColor(Color.Black)
                        .fontSize(20)
                        .textAlign(TextAlign.Start)
                        .width('100%')
                }.width('40%')
            }
            .height(60)
            .width('100%')
            .padding({
                top: 0,
                left: 8,
                right: 8,
                bottom: 8
            })
            .margin({ top: 0 })
        }.width('100%')
    }
}