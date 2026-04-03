import { ArcSwiper, ArcSwiperAttribute, ArcDotIndicator, ArcDirection, ArcSwiperController, CrownEvent } from '@kit.ArkUI';
import { YOGA_TRAINING, YogaModel } from '../model/YogaModel'
import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode, ColorMetrics } from '@kit.ArkUI';
import { YogaViewModel } from '../viewmodel/YogaViewModel';

@Component
export struct TrainingPage {
  private wearableSwiperController: ArcSwiperController = new ArcSwiperController()
  yogaVm: YogaViewModel = new YogaViewModel();
  @State swiperIndex: number = 0
  @State slides: YogaModel[] = []

  aboutToAppear(): void {
    this.slides = YOGA_TRAINING
  }

  @Builder
  SlideView(y: YogaModel) {
    Column() {
      Image(y.trainingImagePath ? y.trainingImagePath : $r('app.media.mountain'))
        .objectFit(ImageFit.Auto)
        .height('100%')
        .width('100%')
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {

      ArcButton({
        options: new ArcButtonOptions({
          label: 'Back',
          position: ArcButtonPosition.TOP_EDGE,
          styleMode: ArcButtonStyleMode.CUSTOM,
          backgroundColor: ColorMetrics.resourceColor('#ffa75d1c'),
          onClick: () => {
            this.yogaVm.navigationService.pageInfos.pop()
          }
        })
      })
        .zIndex(2)
        .offset({ x: 0, y: -90 })

      ArcSwiper(this.wearableSwiperController) {
        ForEach(this.slides, (y: YogaModel, index: number) => {
          this.SlideView(y)
        }, (item: YogaModel, index: number) => item.title)
      }
      .index($$this.swiperIndex)
      .onCrownRotation((event: CrownEvent) => {
          if (event.degree > 0 && this.swiperIndex < this.slides.length - 1) {
              this.swiperIndex++
          } else if (event.degree < 0 && this.swiperIndex > 0) {
              this.swiperIndex--
          }
      })
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height('100%')
  }
}
