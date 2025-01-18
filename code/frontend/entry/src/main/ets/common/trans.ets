export class ap{
  public static account:string|null=null;//当前账户
  public static isLogOut: boolean = false ;
}

export class bills{
  public static isChanged:boolean = false;//是否更改了账单
}



export class http_url{
  public static url_preview:string = 'http://127.0.0.1:';//previewer host地址
  public static url_simulator:string = 'http://10.0.2.2:';//simulator host地址
}