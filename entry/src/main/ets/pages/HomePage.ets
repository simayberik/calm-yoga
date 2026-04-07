import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode, ColorMetrics } from '@kit.ArkUI';
import { YogaViewModel } from '../viewmodel/YogaViewModel';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { ImageBlur } from '../utils/ImageBlur';
import { CalendarService } from '../services/CalendarService';

@Component
export struct HomePage {
  yogaVm: YogaViewModel = new YogaViewModel();
  @State imagePixelMap: image.PixelMap | null = null;
  @State streak: number = 0;
  private imageBuffer: ArrayBuffer | undefined = undefined;
  private calendar: CalendarService = CalendarService.getInstance();

  async getFileBuffer(): Promise<ArrayBuffer | undefined> {
    try {
      const context: Context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const fileData: Uint8Array = await context.resourceManager.getRawFileContent('yoga_bg.png');
      const buffer: ArrayBuffer = fileData.buffer.slice(0);
      return buffer;
    } catch (err) {
      return undefined
    }
  }

  async aboutToAppear(): Promise<void> {
    this.imageBuffer = await this.getFileBuffer();
    if (this.imageBuffer !== undefined) {
      this.imagePixelMap = await ImageBlur(this.imageBuffer);
    }
    this.streak = await this.calendar.getWeeklyStreak();
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {

      ArcButton({
        options: new ArcButtonOptions({
          label: 'Training',
          position: ArcButtonPosition.TOP_EDGE,
          styleMode: ArcButtonStyleMode.CUSTOM,
          backgroundColor: ColorMetrics.resourceColor('#ffa75d1c'),
          onClick: () => {
            this.yogaVm.navigateToPage('TrainingPage')
          }
        })
      })
        .zIndex(2)
        .offset({x: 0, y: -90})

      Column({ space: 8 }) {
        Text('CALMYOGA')
          .fontSize(26)
          .fontWeight(FontWeight.Bolder)
          .fontColor(Color.White)
          .textAlign(TextAlign.Center)

        Text('Find Your Calm')
          .fontSize(14)
          .fontWeight(FontWeight.Bolder)
          .fontColor('#ffeceaea')
          .textAlign(TextAlign.Center)

        if (this.streak > 0) {
          Text(`${this.streak} 🔥`)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(Color.Orange)
            .textAlign(TextAlign.Center)
            .margin({ top: 5 })
        }
      }
      .zIndex(2)

      Image(this.imagePixelMap)
        .zIndex(1)
        .width('100%')
        .height('100%')
        .opacity(0.6)

      ArcButton({
        options: new ArcButtonOptions({
          label: 'Go to Yoga',
          position: ArcButtonPosition.BOTTOM_EDGE,
          styleMode: ArcButtonStyleMode.CUSTOM,
          backgroundColor: ColorMetrics.resourceColor('#ffa75d1c'),
          onClick: () => {
            this.yogaVm.navigateToPage('YogaPage')
          }
        })
      })
        .offset({x: 0, y: 90})
        .zIndex(2)
    }
    .height('100%')
    .width('100%')
  }
}
