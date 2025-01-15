import { BillInfo } from '../model/BillInfo';
import { CalExpense, CalLeft, isExpense, SpliteBillsByMon } from '../util/DealBill';

@Entry
@Component
struct BillInfos {
    @Prop billInfo: BillInfo[] = [];
    @State activeDate: Date = new Date();
    @State yearlyLeft: number = 0;
    @State yearlyExpense: number = 0;
    @State yearlyIncome: number = 0;
    private BillsByMon: Map<number, BillInfo[]> = SpliteBillsByMon(this.billInfo, this.activeDate);

    onPageShow(): void {
        this.BillsByMon.forEach((item) => {
            item.forEach((bill) => {
                isExpense(bill) ? this.yearlyExpense += Math.abs(bill.money) : this.yearlyIncome += Math.abs(bill.money)
            })
        })
        this.yearlyLeft = this.yearlyIncome - this.yearlyExpense;
    }

    build() {
        RelativeContainer() {
            Column() {
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
                        }
                    })
                })


                List() {
                    ForEach(Array.from(this.BillsByMon.entries()), (item: [mon: number, bills: BillInfo[]]) => {
                        ListItem() {
                            GridRow({ columns: 4 }) {
                                GridCol() {
                                    Text(`${item[0]}月`).fontSize(16)
                                }

                                GridCol() {
                                    Text(`${CalExpense(item[1])}`).fontSize(14)
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
                }
            }

        }
        .height('100%')
        .width('100%')
    }
}