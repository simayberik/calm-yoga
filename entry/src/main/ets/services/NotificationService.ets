import { notificationManager } from '@kit.NotificationKit';
import { wantAgent, WantAgent, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = '[NotificationService]';

export class NotificationService {
  private static instance: NotificationService;

  private constructor() {}

  public static getInstance(): NotificationService {
    if (!NotificationService.instance) {
      NotificationService.instance = new NotificationService();
    }
    return NotificationService.instance;
  }

  public async requestPermission(context: common.UIAbilityContext): Promise<void> {
    try {
      const isEnabled = await notificationManager.isNotificationEnabled();
      if (!isEnabled) {
        await notificationManager.requestEnableNotification(context);
      }
      await this.addNotificationSlot();
    } catch (err) {
      console.error(`${TAG} request fail: ${JSON.stringify(err)}`);
    }
  }

  private async addNotificationSlot(): Promise<void> {
    try {
      await notificationManager.addSlot(notificationManager.SlotType.CONTENT_INFORMATION);
    } catch (err) {
      console.error(`${TAG} slot fail: ${JSON.stringify(err)}`);
    }
  }

  public async publishNotification(context: common.UIAbilityContext, title: string, content: string) {
    try {
      const wantAgentObj: WantAgent = await this.createWantAgent(context);

      let request: notificationManager.NotificationRequest = {
        id: 1,
        label: "YogaNotification",
        notificationSlotType: notificationManager.SlotType.CONTENT_INFORMATION,
        tapDismissed: true,
        wantAgent: wantAgentObj,
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal: {
            title: title,
            text: content,
            additionalText: 'CalmYoga Session'
          }
        }
      };

      await notificationManager.publish(request);
      console.info(`${TAG} Published notification ✅`);
    } catch (err) {
      console.error(`${TAG} Publish notification failed: ${JSON.stringify(err)}`);
    }
  }

  private async createWantAgent(context: common.UIAbilityContext): Promise<WantAgent> {
    const wantAgentInfo: wantAgent.WantAgentInfo = {
      wants: [{
        bundleName: context.abilityInfo.bundleName,
        abilityName: context.abilityInfo.name,
        parameters: {
          "targetPage": "HomePage"
        }
      }],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 0,
      actionFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
    };
    return await wantAgent.getWantAgent(wantAgentInfo);
  }
}
