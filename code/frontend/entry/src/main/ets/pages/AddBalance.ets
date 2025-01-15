import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { defaultExpenseType, defaultIncomeType, IBillType } from '../model/BillType';
import { promptAction } from '@kit.ArkUI';

interface IKeyboardUnit {
    content: string | Resource,
    contentType?: string,
    callback?: () => void,
    bgColor?: ResourceColor,
    foreColor?: ResourceColor
}

enum calculateAction {
    start,
    input,
    precal,
    cal
}

@Entry
@Component
struct AddBalance {
    @State activeTab: number = 0;
    activeType: Resource = $r("app.media.salaryIcon");
    @State selectedTypeName: string = '';
    @State balanceAmount: string = "0.00";
    @State calOp: string = "";
    @State content: string = "";
    @State calculateAction: calculateAction = calculateAction.start;
    @State doneButtonText: string = "√";
    @State activeYear: number = (router.getParams() as ESObject)['year'];
    @State activeMonth: number = (router.getParams() as ESObject)['month'];
    @State activeDay: number = new Date().getDate();
    activeDate: Date = new Date();
    context = getContext(this) as common.UIAbilityContext;
    filesDir = this.context.filesDir;
    @State inputMarginTop: number = 1000; //输入控件的上外边距
    @State inputOpacity: number = 0; //输入控件的透明度

    CaangeUnit(number: string): void {
        if (this.balanceAmount == "0.00") {
            this.balanceAmount = number;
        } else {
            this.balanceAmount += number;
        }

        if (this.calculateAction == calculateAction.start) {
            this.calculateAction = calculateAction.input;
        } else if (this.calculateAction == calculateAction.precal) {
            this.calculateAction = calculateAction.cal;
            this.balanceInputUnits[15].content = '='
            this.doneButtonText = '=';
        }
    }

    ClearInput():void {
        this.balanceAmount = '0.00';
        this.calculateAction = calculateAction.start;
        this.calOp = '';
    }

    cost_data() {
        promptAction.showToast({
            message: "上传成功！",
            duration: 2000
        })
        this.ClearInput()
        // 这里调用cost函数
    }

    balanceInputUnits: IKeyboardUnit[] =
        [
            {
                content: "7",
                callback: () => {
                    this.CaangeUnit("7")
                }
            },
            {
                content: "8",
                callback: () => {
                    this.CaangeUnit("8")
                }
            },
            {
                content: "9",
                callback: () => {
                    this.CaangeUnit("9")
                }
            },
            {
                content: "今天",
                callback: () => {
                    DatePickerDialog.show({
                        start: new Date("2000-01-01"),
                        onAccept: (v) => {
                            this.activeYear = v.year;
                            this.activeMonth = v.month;
                            this.activeDay = v.day;
                        },
                        selected: this.activeDate
                    })
                }
            },
            {
                content: "4",
                callback: () => {
                    this.CaangeUnit("4")
                }
            },
            {
                content: "5",
                callback: () => {
                    this.CaangeUnit("5")
                }
            },
            {
                content: "6",
                callback: () => {
                    this.CaangeUnit("6")
                }
            },
            {
                content: "+",
                callback: () => {
                    if (this.calculateAction == calculateAction.start ||
                        (this.calculateAction == calculateAction.precal && this.calOp == '+')) {
                        return;
                    }
                    if (this.balanceAmount.endsWith(".")) {
                        this.balanceAmount += "0";
                    }
                    switch (this.calculateAction) {
                        case calculateAction.input:
                            this.calOp = '+';
                            this.balanceAmount += '+';
                            this.calculateAction = calculateAction.precal
                            break;

                        case calculateAction.precal:
                            this.calOp = '+';
                            this.balanceAmount = this.balanceAmount.substring(0, this.balanceAmount.length - 1) + '+';
                            break;

                        case calculateAction.cal:
                            const leftAmount = this.balanceAmount.split(this.calOp)[0]
                            const rightAmount = this.balanceAmount.split(this.calOp)[1];
                            if (this.calOp == '+') {
                                this.balanceAmount =
                                    (parseFloat(leftAmount) + parseFloat(rightAmount)).toFixed(2) + '+';
                            } else {
                                this.balanceAmount =
                                    (parseFloat(leftAmount) - parseFloat(rightAmount)).toFixed(2) + '+';
                            }
                            this.calOp = '+';
                            this.calculateAction = calculateAction.precal;
                    }

                }
            },
            {
                content: "1",
                callback: () => {
                    this.CaangeUnit("1")
                }
            },
            {
                content: "2",
                callback: () => {
                    this.CaangeUnit("2")
                }
            },
            {
                content: "3",
                callback: () => {
                    this.CaangeUnit("3")
                }
            },
            {
                content: "-",
                callback: () => {
                    if (this.calculateAction == calculateAction.start ||
                        (this.calculateAction == calculateAction.precal && this.calOp == '-')) {
                        return;
                    }
                    if (this.balanceAmount.endsWith(".")) {
                        this.balanceAmount += "0";
                    }
                    switch (this.calculateAction) {
                        case calculateAction.input:
                            this.calOp = '-';
                            this.balanceAmount += '-';
                            this.calculateAction = calculateAction.precal//
                            break;


                        case calculateAction.precal:
                            this.calOp = '-';
                            this.balanceAmount = this.balanceAmount.substring(0, this.balanceAmount.length - 1) + '-';
                            break;
                        case calculateAction.cal:
                            const leftAmount = this.balanceAmount.split(this.calOp)[0];
                            const rightAmount = this.balanceAmount.split(this.calOp)[1];
                            if (this.calOp == '+') {
                                this.balanceAmount =
                                    (parseFloat(leftAmount) + parseFloat(rightAmount)).toFixed(2) + '-';
                            } else {
                                this.balanceAmount =
                                    (parseFloat(leftAmount) - parseFloat(rightAmount)).toFixed(2) + '-';
                            }
                            this.calOp = '-';
                            this.calculateAction = calculateAction.precal;

                    }
                }
            },
            {
                content: ".",
                callback: () => {
                    this.balanceAmount += "."
                }
            },
            {
                content: "0",
                callback: () => {
                    if (this.balanceAmount == "0") {
                        return;
                    }
                    this.balanceAmount += "0";
                }
            },
            {
                content: $r("app.media.delete"),
                contentType: "image",
                callback: () => {
                    this.ClearInput()
                }
            },
            {
                content: '√',
                bgColor: $r('app.color.main_theme_blue'),
                foreColor: Color.White,
                callback: () => {

                    if (this.calculateAction == calculateAction.cal) {
                        const leftAmount = this.balanceAmount.split(this.calOp)[0];
                        const rightAmount = this.balanceAmount.split(this.calOp)[1];
                        if (this.calOp == '+') {
                            this.balanceAmount =
                                (parseFloat(leftAmount) + parseFloat(rightAmount)).toFixed(2);
                        } else if (this.calOp == '-') {
                            this.balanceAmount =
                                (parseFloat(leftAmount) - parseFloat(rightAmount)).toFixed(2);
                        }
                        this.calculateAction = calculateAction.input;
                        return;
                    } else if (this.calculateAction == calculateAction.precal) {
                        this.balanceAmount = this.balanceAmount.substring(0, this.balanceAmount.length - 1);
                        this.calculateAction = calculateAction.input;
                        this.calOp = '';
                        return;
                    }
                    // 错误检测
                    if (this.calculateAction == calculateAction.start || this.balanceAmount == "0") {
                        promptAction.showToast({
                            message: "数字不能为0",
                            duration: 2000
                        })
                        return;
                    }

                    if (parseFloat(this.balanceAmount) < 0){
                        promptAction.showToast({
                            message: "金额不能为负",
                            duration: 2000
                        })
                        return;
                    }
                    if (this.content == "") {
                        promptAction.showToast({
                            message: "备注不能为空",
                            duration: 2000
                        })
                        return;
                    }
                    if (this.content.length > 24) {
                        promptAction.showToast({
                            message: "备注不能超过24个字符",
                            duration: 2000
                        })
                        return;
                    }
                    this.cost_data()
                }
            }
        ];

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


            Column() {
                Row() {
                    Text(this.balanceAmount)
                        .textAlign(TextAlign.End).width('100%').padding(8)
                        .fontSize(24)
                }.height(36)

                Row() {
                    TextInput({ placeholder: "点击填写备注" })
                        .margin(16)
                        .borderRadius(8)
                        .onChange((v) => {
                            this.content = v;
                        })
                }

                GridRow({ columns: 4, gutter: 0 }) {
                    ForEach(this.balanceInputUnits, (unit: IKeyboardUnit) => {
                        GridCol() {
                            Button({ type: ButtonType.Normal }) {
                                if (unit.contentType == "image") {
                                    Image(unit.content).width(18)
                                } else {
                                    Text(unit.content).fontSize(18).fontColor(unit.foreColor ?? "black")
                                }
                            }
                            .height(49)
                            .backgroundColor(unit.bgColor ?? "white")
                            .width('100%')
                            .borderRadius(0)
                            .onClick(unit.callback ?? (() => {
                                return;
                            }))
                        }.border({
                            width: {
                                top: 0.5,
                                right: 0.5,
                                bottom: 0,
                                left: 0
                            },
                            color: '#ffcdcdcd'
                        })
                    })
                }
            }
            .width('100%')
            .shadow({
                radius: 20,
                offsetY: 16
            })
            .margin({ top: this.inputMarginTop })
            .opacity(this.inputOpacity)
            .backgroundColor(Color.White)
        }
        .width('100%')
        .height('100%')
    }
}