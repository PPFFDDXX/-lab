// import { promptAction, router } from '@kit.ArkUI';
//
// @Entry
// @Component
// struct AddBalance {
//     @State message: string = 'Hello World';
//
//     build() {
//         RelativeContainer() {
//             Row(){
//                 Button("返回")
//                     .fontSize(10)
//                     .onClick(()=>{
//                         promptAction.showToast({ message: "待开发" });
//                         router.back()
//                     })
//             Text(this.message)
//                 .id('AddBalanceHelloWorld')
//                 .fontSize(50)
//                 .fontWeight(FontWeight.Bold)
//                 .alignRules({
//                     center: { anchor: '__container__', align: VerticalAlign.Center },
//                     middle: { anchor: '__container__', align: HorizontalAlign.Center }
//                 })
//             }
//
//         }
//
//         .height('100%')
//         .width('100%')
//     }
// }

// Copyright (c) 2023 Ericple
// OpenBill is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
// http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.
import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { defaultExpenseType, defaultIncomeType, IBillType } from '../model/BillType';

interface IKeyboardUnit {
    content: string | Resource,
    contentType?: string,
    callback?: () => void,
    bgColor?: ResourceColor,
    foreColor?: ResourceColor
}

@Entry
@Component
struct AddBalance {
    @State activeTab: number = 0;
    activeType: Resource = $r("app.media.salaryIcon");
    @State selectedTypeName: string = '';
    @State balanceAmount: string = "0";
    @State balanceTempAmount: string = "0";
    @State remark: string = "";
    @State calculateAction: number = 0;
    @State doneButtonText: string = "Ok";
    @State activeYear: number = (router.getParams() as ESObject)['year'];
    @State activeMonth: number = (router.getParams() as ESObject)['month'];
    @State activeDay: number = new Date().getDate();
    activeDate: Date = new Date();
    context = getContext(this) as common.UIAbilityContext;
    filesDir = this.context.filesDir;
    @State inputMarginTop: number = 1000;
    @State inputOpacity: number = 0;

    build() {
        Stack({ alignContent: Alignment.Bottom }) {
            Column() {
                Row() {
                    Row() {
                        Text("返回")
                            .fontSize(16)
                            .fontColor('white')
                            .onClick(() => {
                                router.back()
                            })
                            .padding({ bottom: 16 })
                            .margin({ top: 16, right: 16, left: 16 })
                    }

                    Row() {

                        Text($r("app.string.balance"))
                            .fontSize(16)
                            .fontColor('white')
                            .onClick(() => {
                                this.activeTab = 0;
                                this.selectedTypeName = '';
                                this.balanceAmount = "0";
                            })
                            .border({
                                width: {
                                    bottom: this.activeTab == 0 ? 2 : 0
                                },
                                color: 'white'
                            })
                            .padding({ bottom: 16 })
                            .margin({ top: 16, right: 16, left: 16 })
                        Text($r("app.string.income"))
                            .fontSize(16)
                            .fontColor('white')
                            .onClick(() => {
                                this.activeTab = 1;
                                this.selectedTypeName = '';
                                this.balanceAmount = "0";
                            })
                            .border({
                                width: {
                                    bottom: this.activeTab == 1 ? 2 : 0
                                },
                                color: 'white'
                            })
                            .padding({ bottom: 16 })
                            .margin({ top: 16, right: 16, left: 16 })
                    }


                    Text("取消")
                        .fontSize(16)
                        .fontColor('white')
                        .onClick(() => {
                            router.back()
                        })
                        .textAlign(TextAlign.End)
                        .margin({ right: 24 })
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .height(48)
                .backgroundColor($r('app.color.main_theme_blue'))
                .width('100%')

                GridRow({ columns: 4, gutter: 12 }) {
                    ForEach(this.activeTab == 0 ? defaultExpenseType : defaultIncomeType, (item: IBillType) => {
                        GridCol() {
                            Column({ space: 4 }) {
                                Row() {
                                    Image(item.img)
                                        .width(24)
                                        .height(24)
                                        .onClick(() => {
                                            this.selectedTypeName = item.title;
                                            this.activeType = item.img;
                                            animateTo({ duration: 800, curve: Curve.EaseOut }, () => {
                                                this.inputMarginTop = 0;
                                                this.inputOpacity = 1;
                                            })
                                        })
                                }
                                .shadow({ radius: 24, color: $r('app.color.main_theme_shadow') })
                                .borderRadius(16)
                                .backgroundColor(this.selectedTypeName == item.title ? "#ffcfe8ff" : "white")
                                .width(48)
                                .height(48)
                                .justifyContent(FlexAlign.Center)
                                .onClick(() => {
                                    this.selectedTypeName = ''
                                    animateTo({ duration: 800, curve: Curve.EaseOut }, () => {
                                        this.inputMarginTop = 1000;
                                        this.inputOpacity = 0;
                                    })
                                })

                                Row() {
                                    Text(item.title).fontSize(12)
                                }
                            }
                            .width(56)
                            .height(68)

                        }
                    })
                }
                .padding(12)
            }
            .width('100%')
            .height('100%')

        }
        .width('100%')
        .height('100%')
    }
}