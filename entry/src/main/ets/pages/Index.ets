import { NavigationService } from '../services/NavigationService';
import { HomePage } from './HomePage';
import { YogaPage } from './YogaPage';
import { TrainingPage } from './TrainingPage';
import { SchedulePage } from './SchedulePage';

@Entry
@Component
struct Index {
  navigationService: NavigationService = NavigationService.getInstance();

  @Builder
  routeMap(name: string) {
    NavDestination() {
      if (name === 'HomePage') {
        HomePage();
      } else if (name === 'TrainingPage') {
        TrainingPage();
      } else if (name === 'YogaPage') {
        YogaPage()
      } else if (name === 'SchedulePage') {
        SchedulePage()
      }
    }
    .hideTitleBar(true)
  }

  build() {
    Navigation(this.navigationService.pageInfos) {
      HomePage();
    }
    .mode(NavigationMode.Stack)
    .navDestination(this.routeMap)
    .ignoreLayoutSafeArea()
    .hideTitleBar(true)
    .width('100%')
    .height('100%')
  }
}
