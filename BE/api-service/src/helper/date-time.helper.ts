import * as moment from 'moment';

export class DateTimeHelper {
  static convertToUtc(dateTime, format = '') {
    return moment(dateTime).utc().format(format);
  }

  static convertDateToDateByTimeZone(date, utcOffset, format = '') {
    return moment(date).utcOffset(utcOffset).format(format);
  }
}
