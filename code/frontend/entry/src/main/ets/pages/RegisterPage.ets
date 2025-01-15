import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';
import http from '@ohos.net.http';
@Entry
@Component
struct RegisterPage{
  @State account:string=''
  @State password1:string=''
  @State password2:string=''
  build(){
    Column(){
      TextInput({placeholder:'请输入账号'})
        .margin({bottom:'20vp'})
        .width('320vp')
        .onChange((value:string)=>{
          this.account=value;
        })
      TextInput({placeholder:'请输入密码'})
        .type(InputType.Password)
        .width('320vp')
        .onChange((value:string)=>{
          this.password1=value;
        })
        .margin({bottom:'20vp'})
      TextInput({placeholder:'请再次输入密码'})
        .type(InputType.Password)
        .width('320vp')
        .onChange((value:string)=>{
          this.password2=value;
        })
        .margin({bottom:'20vp'})
      Button('注册').width('100%').type(ButtonType.Capsule)
        .margin({bottom:'20vp'})
        .width('150vp')
        .onClick(()=>{
          if(this.account===''){
            promptAction.showToast({
              message:'账号不能为空',
              duration:2000
            })
            return
          }
          if(this.password1===''){
            promptAction.showToast({
              message:'密码不能为空',
              duration:2000
            })
            return
          }
          if(this.password1!=this.password2){
            promptAction.showToast({
              message:'两次输入密码不相同',
              duration:2000
            })
            return
          }
          //传递账号密码信息给数据库
          const httpReq=http.createHttp()
          const serve=httpReq.request('http://127.0.0.1:5000/api/sign',{
            method:http.RequestMethod.POST,
            header:{
              "Content-Type":"application/json"
            },
            body:JSON.stringify({
              is_sign_up:true,
              user_name:this.account,
              password:this.password1
            })
          })
          serve.then(res=>{
            if(res.result&&JSON.parse(res.result as string).code==-3){
              promptAction.showToast({
                message:'账号已存在',
                duration:2000
              })
              return
            }
            if(res.result&&JSON.parse(res.result as string).code==200){
              promptAction.showToast({
                message:'注册成功，请返回登录界面',
                duration:2000
              })
            }

          })

        })
    }.border({width:1})
    .width("100%")
    .height("100%")
    .alignItems(HorizontalAlign.Center)
    .justifyContent((FlexAlign.Center))
  }
}