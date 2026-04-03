import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode, ColorMetrics } from '@kit.ArkUI';
import { YOGA_TRAINING, YogaModel } from '../model/YogaModel';
import { CalendarService } from '../services/CalendarService';
import { NavigationService } from '../services/NavigationService';
import { common } from '@kit.AbilityKit';

@Component
export struct SchedulePage {
  @State selectedIndex: number = 0;
  @State scheduleHour: number = 10; // Default to 10 AM
  private calendar: CalendarService = CalendarService.getInstance();
  private nav: NavigationService = NavigationService.getInstance();

  async scheduleSession() {
    const context = getContext(this) as common.UIAbilityContext;
    const now = new Date();
    const scheduleTime = new Date(now.getFullYear(), now.getMonth(), now.getDate(), this.scheduleHour, 0);

    // If today's time passed, schedule for tomorrow
    if (scheduleTime < now) {
      scheduleTime.setDate(scheduleTime.getDate() + 1);
    }

    const pose = YOGA_TRAINING[this.selectedIndex];
    await this.calendar.addYogaEvent(context, `CalmYoga: ${pose.title}`, scheduleTime.getTime(), 30);
    this.nav.pageInfos.pop();
  }

  build() {
    Column() {
      Text('Schedule Session')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .padding(10)
        .fontColor(Color.Black)

      Row() {
        Text('Hour: ')
        Counter() {
          Text(this.scheduleHour.toString()).fontColor(Color.Black)
        }.onInc(() => {
          if (this.scheduleHour < 23) this.scheduleHour++;
        }).onDec(() => {
          if (this.scheduleHour > 0) this.scheduleHour--;
        })
      }.padding(5)

      List({ space: 5 }) {
        ForEach(YOGA_TRAINING, (item: YogaModel, index: number) => {
          ListItem() {
            Text(item.title)
              .width('100%')
              .height(40)
              .textAlign(TextAlign.Center)
              .backgroundColor(this.selectedIndex === index ? '#ffa75d1c' : '#f0f0f0')
              .fontColor(this.selectedIndex === index ? Color.White : Color.Black)
              .borderRadius(10)
              .onClick(() => {
                this.selectedIndex = index;
              })
          }
        })
      }.height('50%')

      ArcButton({
        options: new ArcButtonOptions({
          label: 'Schedule',
          position: ArcButtonPosition.BOTTOM_EDGE,
          styleMode: ArcButtonStyleMode.CUSTOM,
          backgroundColor: ColorMetrics.resourceColor('#ffa75d1c'),
          onClick: () => {
            this.scheduleSession();
          }
        })
      }).offset({ x: 0, y: 10 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
    .padding(20)
  }
}
