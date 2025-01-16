import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import http from '@ohos.net.http';
import axios, { AxiosResponse } from '@ohos/axios'
import { ap } from '../common/trans';

export interface user {
    is_sign_up: boolean,
    user_name: string,
    password: string
}

@Entry
@Component
struct RegisterPage {
    @State account: string = ''
    @State password1: string = ''
    @State password2: string = ''

    build() {
        Column() {
            TextInput({ placeholder: '请输入账号' })
                .margin({ bottom: '20vp' })
                .width('320vp')
                .onChange((value: string) => {
                    this.account = value;
                })
            TextInput({ placeholder: '请输入密码' })
                .type(InputType.Password)
                .width('320vp')
                .onChange((value: string) => {
                    this.password1 = value;
                })
                .margin({ bottom: '20vp' })
            TextInput({ placeholder: '请再次输入密码' })
                .type(InputType.Password)
                .width('320vp')
                .onChange((value: string) => {
                    this.password2 = value;
                })
                .margin({ bottom: '20vp' })
            Button('注册')
                .width('100%')
                .type(ButtonType.Capsule)
                .margin({ bottom: '20vp' })
                .width('150vp')
                .onClick(() => {
                    if (this.account === '') {
                        promptAction.showToast({
                            message: '账号不能为空',
                            duration: 2000
                        })
                        return
                    }
                    if (this.password1 === '') {
                        promptAction.showToast({
                            message: '密码不能为空',
                            duration: 2000
                        })
                        return
                    }
                    if (this.password1 != this.password2) {
                        promptAction.showToast({
                            message: '两次输入密码不相同',
                            duration: 2000
                        })
                        return
                    }
                    //传递账号密码信息给数据库
                    // const httpReq=http.createHttp()
                    // const serve=httpReq.request('http://127.0.0.1:5000/api/sign',{
                    //   method:http.RequestMethod.POST,
                    //   header:{
                    //     "Content-Type":"application/json"
                    //   },
                    //   extraData:JSON.stringify({
                    //     'is_sign_up':true,
                    //     'user_name':this.account,
                    //     'password':this.password1
                    //   })
                    // })
                    // serve.then(res=>{
                    //   if(res.result&&JSON.parse(res.result as string).code==-3){
                    //     promptAction.showToast({
                    //       message:'账号已存在',
                    //       duration:2000
                    //     })
                    //     return
                    //   }
                    //   if(res.result&&JSON.parse(res.result as string).code==200){
                    //     promptAction.showToast({
                    //       message:'注册成功，请返回登录界面',
                    //       duration:2000
                    //     })
                    //   }
                    //
                    // })
                    
                    axios.post<number, AxiosResponse<number>, user>('http://127.0.0.1:5000/api/sign', {
                        is_sign_up: true,
                        user_name: this.account,
                        password: this.password1
                    }).then((response: AxiosResponse) => {
                        console.log('Response received:', JSON.stringify(response)); // 查看是否收到响应
                        //Request failed: Error: Internal error. UI execution context not found.
                        //UI 操作发生在非 UI 线程
                        //不能 直接showtoast
                        if (response.data['status'] == -3) {
                            console.log("账号已存在")
                            this.getUIContext().getPromptAction().showToast({
                                message: '账号已存在',
                                duration: 2000
                            })
                            return
                        }

                        //Request failed: Error: Param error. UI execution context not found.
                        // 不能router.back();
                        // console.log("注册成功")
                        //   router.back();
                        //

                        // 下面是注册成功
                        ap.account = this.account;
                        this.getUIContext().getPromptAction().showToast({
                            message: '注册成功',
                            duration: 2000
                        })
                        this.getUIContext().getRouter().back()
                    }).catch((error: Error) => {
                        console.error("Request failed:", error);
                    });
                })
        }
        .border({ width: 1 })
        .width("100%")
        .height("100%")
        .alignItems(HorizontalAlign.Center)
        .justifyContent((FlexAlign.Center))
    }
}