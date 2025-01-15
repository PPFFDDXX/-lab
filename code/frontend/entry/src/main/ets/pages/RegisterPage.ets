import router from '@ohos.router';
import { promptAction } from '@kit.ArkUI';

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
          if(this.account=='abc'){
            promptAction.showToast({
              message:'已存在该账号',
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
              message:'请重新输入密码',
              duration:2000
            })
            return
          }
          //传递账号密码信息给数据库
          router.replaceUrl({
            url:'pages/Index'
          })
        })
    }.border({width:1})
    .width("100%")
    .height("100%")
    .alignItems(HorizontalAlign.Center)
    .justifyContent((FlexAlign.Center))
  }
}