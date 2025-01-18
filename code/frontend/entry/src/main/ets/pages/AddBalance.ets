import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import { defaultType, IBillType } from '../model/BillType';
import { promptAction } from '@kit.ArkUI';
import { BillInfoType } from '../model/BillInfoType';
import { formatDateToYMD } from '../util/DealTime';
import axios, { AxiosResponse } from '@ohos/axios';

import { addForm, updateForm, SpliteBillsByDate } from '../util/DealBill';
import { ap, bills, http_url } from '../common/trans';


interface IKeyboardUnit {
    content: string | Resource,
    contentType?: string,
    callback?: () => void,
    bgColor?: ResourceColor,
    foreColor?: ResourceColor
}

interface UrlParam {
    year: number,
    month: number,
    isUpdate: boolean,
    updateBillInfo:BillInfoType
}


enum calculateAction {
    start,
    input,
    precal,
    cal
}


// @Concurrent
// export function getData(billInfo: BillInfoType[], BillsByDate: Map<string, BillInfoType[]>, selectedDate: Date) {
//     axios.get<number, AxiosResponse<number>, null>(http_url.url_simulator+'5000/api/get_data/'+ap.account)
//         .then((response: AxiosResponse) => {
//             console.log("读取数据");
//             billInfo = response.data['datas']
//             BillsByDate = SpliteBillsByDate(billInfo, selectedDate);
//         }
//     )
// }

// @Concurrent
// export async function deleteData(
//     userName: string,
//     id: number,
//     type: number,
//     money: number,
//     content: string,
//     date: string
// ): Promise<number> {
//     const response: AxiosResponse = await axios.post<number, AxiosResponse<number>, updateForm>(http_url.url_simulator+'5000/api/delete', {
//         user_name: userName,
//         id: id,
//         type: type,
//         money: money,
//         content: content,
//         date: date
//     })
//     if (response.data['status'] == 200) {
//         console.log('成功删除')
//     }
//     return response.data['status']
// }
//
// @Concurrent
// export async function addData(
//     userName: string,
//     type: number,
//     money: number,
//     content: string,
//     date: string
// ): Promise<number> {
//     const response: AxiosResponse = await axios.post<number, AxiosResponse<number>, addForm>(http_url.url_simulator+'5000/api/add', {
//         user_name: userName,
//         type: type,
//         money: money,
//         content: content,
//         date: date
//     })
//     if (response.data['status'] == 200) {
//         console.log('成功存入')
//     }
//     return response.data['status']
// }
//
// @Concurrent
// export async function updateData(
//     userName: string,
//     id: number,
//     type: number,
//     money: number,
//     content: string,
//     date: string
// ): Promise<number> {
//     const response: AxiosResponse = await axios.post<number, AxiosResponse<number>, updateForm>(http_url.url_simulator+'5000/api/update', {
//         user_name: userName,
//         id: id,
//         type: type,
//         money: money,
//         content: content,
//         date: date
//     })
//     if (response.data['status'] == 200) {
//         console.log('成功更改')
//     }
//     return response.data['status']
// }

@Entry
@Component
struct AddBalance {

    @State activeYear: number = (router.getParams() as UrlParam).year ;
    @State activeMonth: number = (router.getParams() as UrlParam).month;
    @State isUpdate: boolean = (router.getParams() as UrlParam).isUpdate; //判断当前是update还是 add
    @State updateBillInfo: BillInfoType=
        (router.getParams() as UrlParam).updateBillInfo ; // 要update的bill的信息
    @State activeTab: number = (this.isUpdate) ? (this.updateBillInfo.type > 17 ? 1 : 0) : 0;
    activeTypeRes: Resource = $r("app.media.salaryIcon");
    @State selectedTypeName: string = (this.isUpdate) ? (defaultType[this.updateBillInfo.type].title) : '';
    @State selectedType :  number = (this.isUpdate) ?this.updateBillInfo.type : -1;

    @State balanceAmount: string = (this.isUpdate) ? (this.updateBillInfo.money.toFixed(2)) : "0.00";
    @State calOp: string = "";
    @State content: string = (this.isUpdate) ? this.updateBillInfo.content : "";
    @State calculateAction: calculateAction = (this.isUpdate) ? calculateAction.input : calculateAction.start;
    @State doneButtonText: string = "√";
    @State activeDay: number = new Date().getDate();
    activeDate: Date =(this.isUpdate) ?(new Date(this.updateBillInfo.date)): new Date();
    context = getContext(this) as common.UIAbilityContext;
    filesDir = this.context.filesDir;
    @State inputMarginTop: number = (this.isUpdate) ? 0 : 1000; //输入控件的上外边距
    @State inputOpacity: number = (this.isUpdate) ? 1 : 0; //输入控件的透明度

    aboutToAppear(): void {
        //获取URL参数来初始化
    }

    ChangeUnit(number: string): void {
        if (this.balanceAmount == "0.00" || this.balanceAmount == "0") {
            this.balanceAmount = number;
        } else {
            this.balanceAmount += number;
        }

        if (this.calculateAction == calculateAction.start) {
            this.calculateAction = calculateAction.input;
        } else if (this.calculateAction == calculateAction.precal) {
            this.calculateAction = calculateAction.cal;
            this.balanceInputUnits[15].content = '=' //似乎没有用
            this.doneButtonText = '='; //似乎没有用
        }
    }

    ClearInput(): void {
        this.balanceAmount = '0.00';
        this.calculateAction = calculateAction.start;
        this.calOp = '';
        this.content = '';

    }

    AddBill(user_name: string|null,
        type: number,
        money: number,
        content: string,
        date: string) {

        //这里调用add_data

        axios.post<number, AxiosResponse<number>, addForm>(http_url.url_simulator+'5000/api/add', {
            user_name: user_name,
            type: type,
            money: money,
            content: content,
            date: date
        })
            .then((response: AxiosResponse) => {
                console.log("finish!");
                if (response.data['status'] == 200) {
                    console.log("finished!");
                    setTimeout(() => {
                        this.getUIContext().getPromptAction().showToast({
                            message: "上传成功！",
                            duration: 2000
                        })
                    }, 1000)
                }
                setTimeout(()=>{
                    this.ClearInput();
                    this.inputMarginTop = 1000;
                    this.inputOpacity = 0;
                    bills.isChanged = true;
                },0)


            }
            )


    }
    UpdateBill(user_name: string|null,
        id:number,
        type: number,
        money: number,
        content: string,
        date: string) {

        //这里调用update_data

        axios.post<number, AxiosResponse<number>, updateForm>(http_url.url_simulator+'5000/api/update', {
            user_name: user_name,
            id: id,
            type: type,
            money: money,
            content: content,
            date: date
        })
            .then((response: AxiosResponse) => {
                console.log("finish!");
                if (response.data['status'] == 200) {
                    console.log("finished!");
                    setTimeout(() => {
                        this.getUIContext().getPromptAction().showToast({
                            message: "修改成功！",
                            duration: 2000
                        })
                    }, 1000)
                }


                    this.ClearInput();
                    this.inputMarginTop = 1000;
                    this.inputOpacity = 0;
                    bills.isChanged = true;
                this.getUIContext().getRouter().back();


            }
            )


    }

    balanceInputUnits: IKeyboardUnit[] =
        [
            {
                content: "7",
                callback: () => {
                    this.ChangeUnit("7")
                }
            },
            {
                content: "8",
                callback: () => {
                    this.ChangeUnit("8")
                }
            },
            {
                content: "9",
                callback: () => {
                    this.ChangeUnit("9")
                }
            },
            {
                content: "日期",
                callback: () => {
                    DatePickerDialog.show({
                        start: new Date("2000-01-01"),
                        onAccept: (v) => {
                            this.activeYear = v.year;
                            this.activeMonth = v.month;
                            this.activeDay = v.day;
                            this.activeDate.setFullYear(v.year,v.month,v.day)
                        },
                        selected: this.activeDate
                    })
                }
            },
            {
                content: "4",
                callback: () => {
                    this.ChangeUnit("4")
                }
            },
            {
                content: "5",
                callback: () => {
                    this.ChangeUnit("5")
                }
            },
            {
                content: "6",
                callback: () => {
                    this.ChangeUnit("6")
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
                    this.ChangeUnit("1")
                }
            },
            {
                content: "2",
                callback: () => {
                    this.ChangeUnit("2")
                }
            },
            {
                content: "3",
                callback: () => {
                    this.ChangeUnit("3")
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
                            this.calculateAction = calculateAction.precal //
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
                    if (this.balanceAmount == "0" || this.balanceAmount == "0.00") {
                        return;
                    }
                    this.ChangeUnit("0")
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
                            message: "金额不能为0",
                            duration: 2000
                        })
                        return;
                    }

                    if (parseFloat(this.balanceAmount) < 0) {
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
                    if (this.isUpdate) {
                        this.UpdateBill(ap.account,this.updateBillInfo.id,this.selectedType,parseFloat(this.balanceAmount),this.content,
                            formatDateToYMD(this.activeDate))
                    } else {
                        this.AddBill(ap.account, this.selectedType, parseFloat(this.balanceAmount), this.content,
                            formatDateToYMD(this.activeDate))
                    }
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
                                this.balanceAmount = "0.00";
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
                                this.balanceAmount = "0.00";
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
                        .onClick(() => {
                            animateTo({ duration: 800, curve: Curve.EaseOut }, () => {
                                this.inputMarginTop = 1000;
                                this.inputOpacity = 0;
                            })
                        })
                }
                .justifyContent(FlexAlign.SpaceBetween)
                .height(48)
                .backgroundColor($r('app.color.main_theme_blue'))
                .width('100%')

                GridRow({ columns: 4, gutter: 12 }) {
                    ForEach(this.activeTab == 0 ? defaultType.slice(0, 18) : defaultType.slice(18, 23),
                        (item: IBillType) => {
                            GridCol() {
                                Column({ space: 4 }) {
                                    Row() {
                                        Image(item.img)
                                            .width(24)
                                            .height(24)
                                            .onClick(() => {
                                                this.selectedTypeName = item.title;
                                                this.activeTypeRes = item.img;
                                                this.selectedType = item.typeID;
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
                    TextInput({
                        placeholder: (this.isUpdate) ? "" : "点击填写备注",
                        text: this.content
                    })
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