import { TAB_INFO } from '../model/TabBarClass'
import { TabBarClass } from '../model/TabBarClass'
import { BillInfoType, TempBills } from '../model/BillInfoType'
import { ProfilePage } from '../pages/ProfilePage'
import { CustomTabBar } from '../components/CustomTabBar'
import { BillPage } from '../components/BillPage'
import { getData } from '../pages/AddBalance'
import mediaquery from '@ohos.mediaquery';
import axios, { AxiosResponse } from '@ohos/axios'
import { CalBill, CalIncome, SpliteBillsByDate, userData, concurrentRegister, IndexParams } from '../util/DealBill'
import { ap, bills, http_url } from '../common/trans'
import { http } from '@kit.NetworkKit'
import { taskpool } from '@kit.ArkTS'

let listener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(orientation: landscape)');


function onPortrait(mediaQueryResult: mediaquery.MediaQueryResult) {
    if (mediaQueryResult.matches as boolean) {
        // do something here
    } else {
        // do something here
    }
}

listener.on('change', onPortrait);

@Entry
@Component
struct Index {
    @State message: string = 'Hello World';

    @State index_params: IndexParams = new IndexParams();

    // @State selectedDate: Date = new Date();

    @State totalIncome: number = 0;
    @State totalBalance: number = 0;

    @State selectedIndex: number = 0;
    @State tabsInfo: TabBarClass[] = TAB_INFO;
    // @State billInfo: BillInfoType[] = [];
    // @State BillsByDate: Map<string, BillInfoType[]> = new Map();

    private controller: TabsController = new TabsController();
    // @State currentBreakpoint: string = 'md';
    // private xsListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(0vp<width<320vp)');
    // private smListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(320vp<width<600vp)');
    // private mdListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(600vp<width<840vp)');
    // private lgListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(840vp<=width)');

    registerBreakpoint() {
        if (this.index_params.xsListener.matches) {
            this.updateCurrentBreakpoint('xs')
        }

        if (this.index_params.smListener.matches) {
            this.updateCurrentBreakpoint('sm')
        }

        if (this.index_params.mdListener.matches) {
            this.updateCurrentBreakpoint('md')
        }

        if (this.index_params.lgListener.matches) {
            this.updateCurrentBreakpoint('lg')
        }

    }

    updateCurrentBreakpoint(breakpoint: string) {
        if (this.index_params.currentBreakpoint !== breakpoint) {
            this.index_params.currentBreakpoint = breakpoint;
        }
    }

    onPageHide(): void {
    }

    aboutToAppear(): void {
        // this.billInfo = TempBills;
        // axios.get<number, AxiosResponse<number>, null>(http_url.url_simulator+'5000/api/get_data/'+ap.account)
        //     .then((response: AxiosResponse) => {
        //         console.log("读取数据");
        //         this.billInfo = response.data['datas']
        //         this.BillsByDate = SpliteBillsByDate(this.billInfo,this.selectedDate);
        //     }
        //     )
        // this.registerBreakpoint()
        let task1: taskpool.Task = new taskpool.Task(getData, this.index_params)
        let task2: taskpool.Task = new taskpool.Task(concurrentRegister, this.index_params)

        taskpool.execute(task1)
        taskpool.execute(task2)
    }

    onPageShow(): void {
        let isChanged: boolean = bills.isChanged;
        if(isChanged){
            this.getUIContext().getPromptAction().showToast({
                'message':"重新获取数据",
                'duration':2000
            })
            axios.get<number, AxiosResponse<number>, null>(http_url.url_simulator+'5000/api/get_data/'+ap.account)
                .then((response: AxiosResponse) => {
                    console.log("读取数据");
                    console.log(response.data['data']);
                    this.index_params.billInfo = response.data['datas']
                    this.index_params.BillsByDate = SpliteBillsByDate(this.index_params.billInfo,this.index_params.selectedDate);
                    const Obj:[number,number] = CalBill(this.index_params.BillsByDate);
                    this.totalBalance = Obj[0];
                    this.totalIncome = Obj[1];
                }
                )
            bills.isChanged = false;
        }
    }

    build() {


        Tabs({ barPosition: this.index_params.currentBreakpoint == 'lg' ? BarPosition.Start : BarPosition.End }) {
            TabContent() {
                BillPage({
                    billInfo: $billInfo,
                    selectedDate:$selectedDate,
                    BillsByDate:$BillsByDate,
                    totalIncome:$totalIncome,
                    totalBalance:$totalBalance
                })
            }
            .tabBar('明细')


            TabContent() {
                ProfilePage()
            }
            .tabBar("我的")
        }
        .vertical(this.index_params.currentBreakpoint == 'lg' ? true : false)
        .barWidth(this.index_params.currentBreakpoint == 'lg' ? 100 : '')
        .barHeight(this.index_params.currentBreakpoint == 'lg' ? 200 : '')
    }
}