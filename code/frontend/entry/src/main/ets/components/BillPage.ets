import { FunctionSelect } from './FunctionSelect'
import { BalanceViewer } from './BalanceViewer'
import { BillInfoType } from '../model/BillInfoType'

import { defaultType} from '../model/BillType'

import { isExpense, SpliteBillsByDate } from '../util/DealBill'

import { promptAction, router } from '@kit.ArkUI';
import { CommonConstants } from '../common/CommonConstants'


@Component
export struct BillPage {
    @State selectedDate: Date = new Date();
    @State totalIncome: number = 0;
    @State totalBalance: number = 0;
    @Link billInfo: BillInfoType[]
    @State BillsByDate: Map<string, BillInfoType[]> = SpliteBillsByDate(this.billInfo,this.selectedDate);

    // onPageShow(): void {
    //     this.totalIncome = 4;
    //     this.totalBalance = 4;
    // }
    aboutToAppear(): void {
        const BillsByDate: Map<string, BillInfoType[]> = SpliteBillsByDate(this.billInfo,this.selectedDate);
    }

    deleteBill(bill:BillInfoType){
        const index = this.billInfo.indexOf(bill);
        if (index > -1) {
            this.billInfo.splice(index, 1);
            this.BillsByDate = SpliteBillsByDate(this.billInfo, this.selectedDate);

            //todo:这里调用delete_data(Object O)

            promptAction.showToast({
                'message':"删除成功",
                'duration':2000
            })
        } else {
            promptAction.showToast({
                'message':"删除失败!",
                'duration':2000
            })
        }
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
                selectedDate: $selectedDate,
                billInfo: $billInfo
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
                    ForEach(Array.from(this.BillsByDate.entries()), (item: [date: string, bills: BillInfoType[]]) => {
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
    BillItem(billInfo: BillInfoType) {

            Row() {
                Row({space:12}) {
                    Image(defaultType[billInfo.type].img)
                        .padding(8)
                        .size({ height: 32, width: 32 })
                    Text(defaultType[billInfo.type].title)
                        .fontSize(12)
                }
                Text((isExpense(billInfo)?'-':'')+billInfo.money.toString())
                    .fontColor(Color.Black)
                    .fontSize(12)
                    .fontWeight(FontWeight.Bold)
            }
            .margin({left:16,right:16})
            .width('90%')
            .justifyContent(FlexAlign.SpaceBetween)
            .gesture(LongPressGesture({ repeat: true })
                // 这里是长按调用
                .onActionEnd((event: GestureEvent) => {
                    ActionSheet.show({

                        title: '',
                        message: '',
                        autoCancel: true,
                        showInSubWindow: true,
                        isModal: true,
                        width: '40%',
                        height: '15%',
                        cornerRadius: 20,
                        borderWidth: 1,
                        borderStyle: BorderStyle.Solid,
                        backgroundColor: Color.White,
                        shadow: ({ radius: 20, color: Color.Grey, offsetX: 50, offsetY: 0}),
                        transition:TransitionEffect.asymmetric(TransitionEffect.OPACITY
                            .animation({ duration: 500, curve: Curve.Sharp }).combine(TransitionEffect.scale({x: 1.5, y: 1.5}).animation({duration: 400, curve: Curve.Sharp})),
                            TransitionEffect.OPACITY.animation({ duration: 100, curve: Curve.Smooth })
                                .combine(TransitionEffect.scale({x: 0.5, y: 0.5}).animation({duration: 100, curve: Curve.Smooth}))),
                        // confirm: {
                        //     defaultFocus: true,
                        //     value: 'Confirm button',
                        //     action: () => {
                        //         console.log('Get Alert Dialog handled')
                        //     }
                        // },
                        cancel: () => {
                            console.log('actionSheet canceled')
                        },
                        onWillDismiss:(dismissDialogAction: DismissDialogAction)=> {
                            console.info("reason=" + JSON.stringify(dismissDialogAction.reason))
                            console.log("dialog onWillDismiss")
                            if (dismissDialogAction.reason == DismissReason.PRESS_BACK) {
                                dismissDialogAction.dismiss()
                            }
                            if (dismissDialogAction.reason == DismissReason.TOUCH_OUTSIDE) {
                                dismissDialogAction.dismiss()
                            }
                        },
                        alignment: DialogAlignment.Center,
                        offset: { dx: 0, dy: -10 },
                        sheets: [
                            {
                                title: '删除',
                                action: () => {
                                    this.deleteBill(billInfo)
                                }
                            },
                            {
                                title: '修改',
                                action: () => {
                                    router.pushUrl({
                                        url: "pages/AddBalance",
                                        params: {
                                            year: this.selectedDate.getFullYear(),
                                            month: this.selectedDate.getMonth() + 1,
                                            isUpdate: true,
                                            updateBillInfo:billInfo
                                        }
                                    })
                                }
                            },
                            {
                                title: '查看明细',
                                action: () => {
                                    console.log('pears')
                                }
                            }
                        ]
                    })
                })
            )
    }

    @Builder
    BillDateList(billInfoarray: BillInfoType[]) {

        List({ space: 2 }) {
            ForEach(billInfoarray, (item: BillInfoType) => {
                ListItem() {
                    this.BillItem(item)
                }
            },)
        }
        .borderWidth({ bottom: 1 })
        .borderColor(Color.White)

    }


}