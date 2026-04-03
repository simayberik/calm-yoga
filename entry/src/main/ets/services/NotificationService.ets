import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';

export class NotificationService {
  private static instance: NotificationService;

  private constructor() {}

  public static getInstance(): NotificationService {
    if (!NotificationService.instance) {
      NotificationService.instance = new NotificationService();
    }
    return NotificationService.instance;
  }

  public async requestPermission(context: common.UIAbilityContext) {
    try {
      await notificationManager.requestEnableNotification(context);
    } catch (err) {
      console.error(`Request notification permission failed: ${JSON.stringify(err)}`);
    }
  }

  public async publishNotification(title: string, content: string) {
    let request: notificationManager.NotificationRequest = {
      id: 1,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: title,
          text: content,
          additionalText: 'Yoga Session'
        }
      }
    };

    try {
      await notificationManager.publish(request);
      console.info('Notification published successfully');
    } catch (err) {
      console.error(`Publish notification failed: ${JSON.stringify(err)}`);
    }
  }
}
