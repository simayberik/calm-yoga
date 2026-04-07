import { YOGA_TRAINING, YogaModel } from '../model/YogaModel'
import { HapticService } from '../services/HapticService'
import { CalendarService } from '../services/CalendarService'
import { common } from '@kit.AbilityKit';

@Component
export struct YogaPage {
  private gradientColor: LinearGradient = new LinearGradient([
    { color: Color.Yellow, offset: 0.5 },
    { color: Color.Orange, offset: 1.0 }
  ])
  textTimerController: TextTimerController = new TextTimerController()
  format: string = 'mm:ss'
  currentIndex: number = 0
  @State count: number = 0
  @State totalSec: number = 1
  @State currSec: number = 0
  @State finished: boolean = false
  @State currPose: YogaModel = YOGA_TRAINING[0]
  private haptic: HapticService = new HapticService();
  private calendar: CalendarService = CalendarService.getInstance();

  aboutToAppear(): void {
    this.startPose(0)
    this.restartTimerForPose()
  }

  aboutToDisappear(): void {
    this.textTimerController.reset()
    this.textTimerController.pause()
  }

  onBackPress(): boolean | void {
    this.textTimerController.reset()
    this.textTimerController.pause()
  }

  private startPose(index: number) {
    const pose = YOGA_TRAINING[index]
    if (!pose) {
      return
    }

    this.currPose = pose
    this.currentIndex = index
    const sec = pose.time ?? 30
    this.totalSec = sec
    this.currSec = 0
    this.count = sec * 1000
  }

  private async goNextPose() {
    const nextIndex = this.currentIndex + 1
    const pose = YOGA_TRAINING[nextIndex]

    if (!pose) {
      await this.calendar.addSession('Daily Routine', 30);
      this.finished = true
      this.textTimerController.reset()
      this.textTimerController.pause()
      return
    }

    this.currPose = pose
    this.currentIndex = nextIndex
    const sec = pose.time ?? 30
    this.totalSec = sec
    this.currSec = 0
    this.count = sec * 1000

    this.restartTimerForPose()
  }

  private restartTimerForPose() {
    this.textTimerController.pause()
    this.textTimerController.reset()

    setTimeout(() => {
      this.textTimerController.start()
    }, 0)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Progress({ value: 0, total: this.totalSec, type: ProgressType.Ring })
        .width('100%')
        .style({ strokeWidth: 12 })
        .color(this.gradientColor)
        .zIndex(3)
        .value(this.currSec)

      Column() {
        if (this.currPose && !this.finished) {
          Text(this.currPose.title ?? '')
            .fontSize(20)
            .padding({top: 10})
            .width('50%')
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bold)
        }

        if (this.currPose && !this.finished) {
          Image(this.currPose.yogaImagePath!)
            .width(130)
            .height(130)
            .objectFit(ImageFit.Contain)
        }

        TextTimer({ isCountDown: true, count: this.count, controller: this.textTimerController })
          .format(this.format)
          .fontColor(Color.Black)
          .fontSize(20)
          .visibility(this.finished ? Visibility.Hidden : Visibility.Visible)
          .onAppear(() => {
            this.textTimerController.start()
          })
          .onTimer((utc: number, elapsedTime: number) => {
            this.currSec = elapsedTime

            if (this.currSec >= this.totalSec) {
              this.goNextPose()
              this.haptic.ok();

            }
          })

        if (this.finished) {
          Text('Session Complete')
            .fontSize(20)
            .fontColor(Color.Black)
            .fontWeight(FontWeight.Bold)
        }
      }
      .zIndex(2)
    }
    .backgroundColor(Color.White)
  }
}
