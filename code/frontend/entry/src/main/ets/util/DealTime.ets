/*
* 此文件处理时间有关的通用函数
* 下面函数没什么用，可自行修改删除或使用
 */


/*
* 这是一个获取并格式处理日期的函数
* 如 2024/12/03 ，调用返回 '03'
*/
export function getCurrentDay(): string {
    const currentDate = new Date();
    const day = currentDate.getDate();
    if (day < 10) {
        return '0' + day.toString();
    }
    else {
        return day.toString();
    }
}


/*
* 这是一个获取并格式处理年乐的函数
* 如 2024/12/03 ，调用返回 'Dec.2024'
*/
export function getCurrentMonYear(): string {
    const currentDate = new Date();
    const year = currentDate.getFullYear();
    const month = 1 + currentDate.getMonth();
    switch (month) {
        case 1:
            return 'Jan.' + year.toString();
        case 2:
            return 'Feb.' + year.toString();
        case 3:
            return 'Mar.' + year.toString();
        case 4:
            return 'Apr.' + year.toString();
        case 5:
            return 'May.' + year.toString();
        case 6:
            return 'Jun.' + year.toString();
        case 7:
            return 'Jul.' + year.toString();
        case 8:
            return 'Aug.' + year.toString();
        case 9:
            return 'Sep.' + year.toString();
        case 10:
            return 'Oct.' + year.toString();
        case 11:
            return 'Nov.' + year.toString();
        case 12:
            return 'Dec.' + year.toString();
        default:
            return 'Invalid month';
    }
}

