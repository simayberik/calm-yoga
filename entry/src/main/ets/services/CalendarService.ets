import { calendarManager } from '@kit.CalendarKit';
import { common } from '@kit.AbilityKit';
import { calendarMgr } from '../entryability/EntryAbility';

export class CalendarService {
  private static instance: CalendarService;
  private calendar: calendarManager.Calendar | null = null;

  private constructor() {}

  public static getInstance(): CalendarService {
    if (!CalendarService.instance) {
      CalendarService.instance = new CalendarService();
    }
    return CalendarService.instance;
  }

  private async getCalendar(): Promise<calendarManager.Calendar | null> {
    if (this.calendar) return this.calendar;
    if (!calendarMgr) return null;
    try {
      this.calendar = await calendarMgr.getCalendar();
      return this.calendar;
    } catch (err) {
      console.error(`Get calendar failed: ${JSON.stringify(err)}`);
      return null;
    }
  }

  public async addSession(title: string, durationMinutes: number = 30): Promise<number | null> {
    const calendar = await this.getCalendar();
    if (!calendar) return null;

    const start = new Date().getTime();
    const end = start + (durationMinutes * 60 * 1000);

    const event: calendarManager.Event = {
      title: `Yoga: ${title}`,
      startTime: start,
      endTime: end,
      type: calendarManager.EventType.NORMAL,
      reminderTime: [15],
      service: {
        type: calendarManager.ServiceType.SPORTS_EXERCISE,
        uri: 'calmyoga://start_flow',
        description: 'Start Exercise'
      }
    };

    try {
      const eventId = await calendar.addEvent(event);
      console.info(`Calendar event added successfully, id -> ${eventId}`);
      return eventId;
    } catch (err) {
      console.error(`Add calendar event failed: ${JSON.stringify(err)}`);
      return null;
    }
  }

  async getWeeklyStreak(): Promise<number> {
    const cal = await this.getCalendar();
    if (!cal) return 0;

    const now = new Date().getTime();
    const sevenDaysAgo = now - (7 * 24 * 60 * 60 * 1000);

    const filter = calendarManager.EventFilter.filterByTime(sevenDaysAgo, now);

    try {
      const events = await cal.getEvents(filter);
      const activeDays = new Set<string>();

      events.forEach(ev => {
        if (ev.title?.includes('Yoga')) {
          activeDays.add(new Date(ev.startTime).toDateString());
        }
      });

      return activeDays.size;
    } catch (err) {
      console.error(`Get streak failed: ${JSON.stringify(err)}`);
      return 0;
    }
  }

  async getSessions(): Promise<calendarManager.Event[]> {
    const cal = await this.getCalendar();
    if (!cal) return [];
    try {
      const filter = calendarManager.EventFilter.filterByTitle('Yoga');
      return await cal.getEvents(filter);
    } catch (err) {
      console.error(`Get sessions failed: ${JSON.stringify(err)}`);
      return [];
    }
  }
}
