import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import http from '@ohos.net.http';
import { ap, http_url } from '../common/trans';
import axios, { AxiosResponse } from '@ohos/axios'
import { user } from './RegisterPage';

@Entry
@Component
struct LauncherPage {
    @State account: string = '';
    @State password: string = '';
    private countDownSeconds: number = 100000000 //登录界面持续时间，后面删除；应改为密码账号正确才可进入
    private timeId: number = 0;

    onPageShow(): void {
        this.timeId = setInterval(() => {
            this.countDownSeconds--;
            if (this.countDownSeconds === 0) {
                clearInterval(this.timeId); // 关闭定时器
                router.replaceUrl({ url: 'pages/Index' });
            }
        }, 1000)
    }

    build() {
        // RelativeContainer() {
        //     Text("这里实现登录注册界面，正确则进入app主页，否则保持登录界面。\n")
        //       .id('Launch')
        //       .fontSize(20)
        //       .alignRules({
        //         center: { anchor: '__container__', align: VerticalAlign.Center },
        //         middle: { anchor: '__container__', align: HorizontalAlign.Center }
        //       })
        //     // Text(this.message)
        //     //   .id('Launch')
        //     //   .fontSize(50)
        //     //   .fontWeight(FontWeight.Bold)
        //     //   .alignRules({
        //     //     center: { anchor: '__container__', align: VerticalAlign.Center },
        //     //     middle: { anchor: '__container__', align: HorizontalAlign.Center }
        //     //   })
        // }
        // .height('100%')
        // .width('100%')
        Column() {
            Image($r('app.media.bird'))
                .width(80)
                .height(80)
                .borderRadius(50)
                .margin({ top: "120vp" })
            Text("欢迎使用")
                .fontColor(Color.Black)
                .fontSize(14)
                .margin({ top: "25vp", bottom: '10vp' })
            TextInput({ placeholder: '请输入账号' })
                .margin({ bottom: '10vp' })
                .width('320vp')
                .onChange((value: string) => {
                    this.account = value;
                })
            TextInput({ placeholder: '请输入密码' })
                .type(InputType.Password)
                .width('320vp')
                .onChange((value: string) => {
                    this.password = value;
                })
                .margin({ bottom: '20vp' })
            Button('登录')
                .width('100%')
                .type(ButtonType.Capsule)
                .margin({ bottom: '15vp' })
                .width('150vp')
                .onClick(() => {
                    this.login();
                })
            Text('注册账号').fontColor(Color.Blue).fontSize(14)
                .onClick(() => {
                    router.pushUrl({
                        url: 'pages/RegisterPage'
                    })
                })
            LoadingProgress().width(50).height(50).color(Color.Blue)
            Blank()

        }
        .border({ width: 1 })
        .width("100%")
        .height("100%")
        .alignItems(HorizontalAlign.Center)
        .justifyContent((FlexAlign.Center))
    }

    login() {
        //判断是否存在账号
        if (this.account == '' || this.password == '') {
            promptAction.showToast({
                message: '账号或密码不能为空',
                duration: 2000
            })
            return
        }
        axios.post<number, AxiosResponse<number>, user>(http_url.url_simulator+'5000/api/sign', {
            is_sign_up: false,
            user_name: this.account,
            password: this.password
        }).then((response: AxiosResponse) => {
            //
            if (response && response.data['status'] == -2) {
                this.getUIContext().getPromptAction().showToast({
                    message: response.data['message'],
                    duration: 2000
                })
                return
            } else if (response && response.data['status'] == -1) {
                this.getUIContext().getPromptAction().showToast({
                    message: response.data['message'],
                    duration: 2000
                })
                return
            }
            ap.account = this.account
            this.getUIContext().getPromptAction().showToast({
                message: response.data['message'],
                duration: 2000
            })
            this.getUIContext().getRouter().replaceUrl({
                url: 'pages/Index'
            })
        });

    }
}