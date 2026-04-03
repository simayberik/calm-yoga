import { calendarManager } from '@kit.CalendarKit';
import { common } from '@kit.AbilityKit';

export class CalendarService {
  private static instance: CalendarService;
  private calendar: calendarManager.Calendar | undefined = undefined;

  private constructor() {}

  public static getInstance(): CalendarService {
    if (!CalendarService.instance) {
      CalendarService.instance = new CalendarService();
    }
    return CalendarService.instance;
  }

  private async getCalendar(context: common.Context): Promise<calendarManager.Calendar | undefined> {
    if (this.calendar) return this.calendar;
    try {
      const manager = calendarManager.getCalendarManager(context);
      this.calendar = await manager.getCalendar();
      return this.calendar;
    } catch (err) {
      console.error(`Get calendar failed: ${JSON.stringify(err)}`);
      return undefined;
    }
  }

  public async addYogaEvent(context: common.Context, title: string, startTime: number, durationMinutes: number) {
    const calendar = await this.getCalendar(context);
    if (!calendar) return;

    const event: calendarManager.Event = {
      title: title,
      startTime: startTime,
      endTime: startTime + durationMinutes * 60 * 1000,
      type: calendarManager.EventType.NORMAL,
      location: { location: "Yoga Mat" }
    };

    try {
      const eventId = await calendar.addEvent(event);
      console.info(`Calendar event added successfully, id -> ${eventId}`);
    } catch (err) {
      console.error(`Add calendar event failed: ${JSON.stringify(err)}`);
    }
  }
}
