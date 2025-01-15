import { TAB_INFO } from '../model/TabBarClass'
import { TabBarClass } from '../model/TabBarClass'
import {BillInfoType,TempBills} from '../model/BillInfoType'
import {ProfilePage} from '../pages/ProfilePage'
import { CustomTabBar } from '../components/CustomTabBar'
import {BillPage} from '../components/BillPage'

import mediaquery from '@ohos.mediaquery';

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

    @State selectedIndex: number = 0;
    @State tabsInfo: TabBarClass[] = TAB_INFO;

    @State billInfo: BillInfoType[] = [];
    private controller: TabsController = new TabsController();
    @State currentBreakpoint: string = 'md';
    private xsListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(0vp<width<320vp)');
    private smListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(320vp<width<600vp)');
    private mdListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(600vp<width<840vp)');
    private lgListener: mediaquery.MediaQueryListener = mediaquery.matchMediaSync('(840vp<=width)');

    registerBreakpoint(){
        if (this.xsListener.matches) {
            this.updateCurrentBreakpoint('xs')
        }

        if (this.smListener.matches) {
            this.updateCurrentBreakpoint('sm')
        }

        if (this.mdListener.matches) {
            this.updateCurrentBreakpoint('md')
        }

        if (this.lgListener.matches) {
            this.updateCurrentBreakpoint('lg')
        }

    }

    updateCurrentBreakpoint(breakpoint: string) {
        if (this.currentBreakpoint !== breakpoint) {
            this.currentBreakpoint = breakpoint;
        }
    }

    onPageHide(): void {
    }
    aboutToAppear(): void {
        this.billInfo = TempBills;
        this.registerBreakpoint()

    }
    onPageShow(): void {
        //这里调用函数获取数据吗?还是在登录界面实现
        //应该是的，这里每次调用接口来获取更新后的数据
        this.billInfo = TempBills;
    }

    build() {




        Tabs({ barPosition: this.currentBreakpoint == 'lg' ? BarPosition.Start: BarPosition.End }) {
            TabContent() {
                Text('首页的内容' + this.currentBreakpoint).fontSize(30)
            }
            .tabBar('首页')

            TabContent() {
                BillPage({
                                    billInfo:$billInfo
                                })
            }
            .tabBar('明细')



            TabContent() {
                ProfilePage()
            }
            .tabBar("我的")
        }
        .vertical(this.currentBreakpoint == 'lg' ? true : false)
        .barWidth(this.currentBreakpoint == 'lg' ? 100 : '')
        .barHeight(this.currentBreakpoint == 'lg' ? 200 : '')
        }
}