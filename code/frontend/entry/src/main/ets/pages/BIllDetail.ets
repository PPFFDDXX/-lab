import { BillInfoType } from '../model/BillInfoType';
import { promptAction, router } from '@kit.ArkUI';

import { defaultType } from '../model/BillType'
import { isExpense } from '../util/DealBill';

interface billDetail{
    billInfo:BillInfoType
}

@Entry
@Component
struct BIllDetail {
    private bill: BillInfoType = (router.getParams() as billDetail).billInfo

    build() {
        RelativeContainer() {
            Column() {
                Blank()
                    .height('1%')
                    .width('100%')
                    .backgroundColor($r('app.color.main_theme_blue'))
                Row() {
                    SymbolGlyph($r('sys.symbol.arrow_left'))
                        .size({ height: '30%', width: '30%' })
                        .onClick(() => {
                            router.back();
                        })
                        .width('10%')
                    Column({ space: 8 }) {
                        Image(defaultType[this.bill.type].img)
                            .size({ height: 20, width: 20 })
                        Text(defaultType[this.bill.type].title)
                            .fontSize(16)
                    }
                    .width('80%')
                    Text("分享")
                        .onClick(() => {
                            promptAction.showToast({
                                message: "禁止分享",
                                duration: 2000
                            })
                        }).width('10%')
                        .padding(0)
                        .margin(0)

                }
                .height('10%')
                .width('100%')
                .padding({ left: 12, right: 12 })
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Top)
                .backgroundColor($r('app.color.main_theme_blue'))
                Blank()
                    .height('1%')
                    .width('100%')
                    .backgroundColor($r('app.color.main_theme_blue'))
                Flex({direction: FlexDirection.Column}){
                    Row(){
                        Blank().width('10%')
                        Text("类型").fontSize(12).fontColor(Color.Gray)
                        Blank().width('10%')
                        Text(isExpense(this.bill)?"支出":"收入").fontSize(14).fontColor(Color.Black)
                    }.width('100%').height('10%').borderWidth(1).borderColor(Color.Gray)
                    Row(){
                        Blank().width('10%')
                        Text("金额").fontSize(12).fontColor(Color.Gray)
                        Blank().width('10%')
                        Text(this.bill.money.toString()).fontSize(14).fontColor(Color.Black)
                    }.width('100%').height('10%').borderWidth(1).borderColor(Color.Gray)
                    Row() {
                        Blank().width('10%')
                        Text("日期").fontSize(12).fontColor(Color.Gray)
                        Blank().width('10%')
                        Text(this.bill.date).fontSize(14).fontColor(Color.Black)
                    }.width('100%').height('10%').borderWidth(1).borderColor(Color.Gray)
                    Row(){
                        Blank().width('10%')
                        Text("备注").fontSize(12).fontColor(Color.Gray)
                        Blank().width('10%')
                        Text(this.bill.content).fontSize(14).fontColor(Color.Black)
                    }.width('100%').height('10%').borderWidth(1).borderColor(Color.Gray)
                }
                .width('100%')
                .height('80%')
            }
        }
        .height('100%')
        .width('100%')
        .backgroundColor(Color.White)
    }

}