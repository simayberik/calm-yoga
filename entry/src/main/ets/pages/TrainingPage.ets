import { ArcSwiper, ArcSwiperAttribute, ArcDotIndicator, ArcDirection, ArcSwiperController } from '@kit.ArkUI';
import { YOGA_TRAINING, YogaModel } from '../model/YogaModel'
import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode, ColorMetrics } from '@kit.ArkUI';
import { YogaViewModel } from '../viewmodel/YogaViewModel';

@Component
export struct TrainingPage {
  private wearableSwiperController: ArcSwiperController = new ArcSwiperController()
  yogaVm: YogaViewModel = new YogaViewModel();
  @State swiperIndex: number = 0
  @State slides: YogaModel[] = []
  private crownAccumulator: number = 0;
  private readonly CROWN_SENSITIVITY: number = 30; // Threshold in degrees

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
      .focusable(true)
      .focusOnTouch(true)
      .defaultFocus(true)
      .onDigitalCrown((event: CrownEvent) => {
          event.stopPropagation();
          this.crownAccumulator += event.degree;

          if (Math.abs(this.crownAccumulator) >= this.CROWN_SENSITIVITY) {
              if (this.crownAccumulator > 0) {
                  this.wearableSwiperController.showNext();
              } else if (this.crownAccumulator < 0) {
                  this.wearableSwiperController.showPrevious();
              }
              this.crownAccumulator = 0;
          }
      })
    }
    .backgroundColor(Color.White)
    .width('100%')
    .height('100%')
  }
}
