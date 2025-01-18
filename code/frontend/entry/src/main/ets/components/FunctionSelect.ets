
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { BillInfoType } from '../model/BillInfoType';

@Component
export struct FunctionSelect {
    @Link selectedDate: Date;
    @Link billInfo: BillInfoType[];

    build() {
        Row() {
            Flex({ justifyContent: FlexAlign.SpaceAround }) {
                Button({ type: ButtonType.Normal }) {
                    Column() {
                        Row() {
                            Image($r("app.media.ic_public_budget"))
                                .width(32)
                                .height(32)
                        }

                        Row() {
                            Text("账单")
                                .fontSize(10)
                                .width('100%')
                                .textAlign(TextAlign.Center)
                        }.height(12).width(48)
                    }.width(48)
                }.backgroundColor(Color.Transparent).borderRadius(8).onClick(() => {
                    router.pushUrl({
                        url: "pages/BillInfos",
                        params: {
                            date: this.selectedDate,
                            billInfo:this.billInfo
                        }
                    });
                })

                Button({ type: ButtonType.Normal }) {
                    Column() {
                        Row() {
                            Image($r("app.media.ic_public_opensource_info"))
                                .width(32)
                                .height(32)
                        }

                        Row() {
                            Text("开源信息")
                                .fontSize(10)
                                .width('100%')
                                .textAlign(TextAlign.Center)
                        }.height(12).width(48)
                    }.width(48).alignItems(HorizontalAlign.Center)
                }.backgroundColor(Color.Transparent).onClick(() => {
                    return;
                }).borderRadius(8)

                Button({ type: ButtonType.Normal }) {
                    Column() {
                        Row() {
                            Image($r("app.media.ic_public_billing_graphic"))
                                .width(32)
                                .height(32)
                        }

                        Row() {
                            Text("经济图表")
                                .fontSize(10)
                                .width('100%')
                                .textAlign(TextAlign.Center)
                        }.height(12).width(48)
                    }.width(48).alignItems(HorizontalAlign.Center)
                }.backgroundColor(Color.Transparent).borderRadius(8).onClick(() => {
                    promptAction.showToast({ message: "待开发" })
                })

                Button({ type: ButtonType.Normal }) {
                    Column() {
                        Row() {
                            Image($r("app.media.ic_public_add_billing"))
                                .width(32)
                                .height(32)
                        }

                        Row() {
                            Text("记账")
                                .fontSize(10)
                                .width('100%')
                                .textAlign(TextAlign.Center)
                        }.height(12).width(48)
                    }.width(48).alignItems(HorizontalAlign.Center)
                }.stateEffect(false).backgroundColor(Color.Transparent).onClick(() => {
                    router.pushUrl({
                        url: "pages/AddBalance",
                        params: {
                            year: this.selectedDate.getFullYear(),
                            month: this.selectedDate.getMonth() + 1,
                            isUpdate: false,
                            updateBillInfo:undefined
                        }
                    })
                }).borderRadius(8)
            }
            .height(64)
            .width('100%')
            .backgroundColor(Color.White)
            .borderRadius(8)
            .padding(8)
            .shadow({ radius: 24, color: $r('app.color.main_theme_shadow') })
        }
        // .linearGradient({
        //     angle: 180,
        //     colors: [
        //         [$r('app.color.main_theme_blue'), 0],
        //         ["#ffffff", 1]
        //     ],
        //     repeating: false
        // })
        .padding({ top: 16, left: 8, right: 8, bottom: 8 })
    }
}