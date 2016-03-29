//
//  NSDate+HRDate.m
//  HRDate
//
//  Created by Ivan Shevelev on 29/03/16.
//  Copyright © 2016 Ivan Shevelev. All rights reserved.
//

#import "NSDate+HRDate.h"
#import "NSDateComponents+HRAllComponents.h"
#import "NSCalendar+HRUTCCalendar.h"
#import "NSDateFormatter+HRUTCDateFormatter.h"

NSUInteger const HRDateHoursInDay = 24;

NSUInteger const HRDateMinutesInHour = 60;
NSUInteger const HRDateMinutesInDay = 1440;

NSUInteger const HRDateSecondsInMinute = 60;
NSUInteger const HRDateSecondsInHour = 3600;
NSUInteger const HRDateSecondsInDay = 86400;

@implementation NSDate (HRCommon)

#pragma mark - Date Components

-(NSDateComponents *)_hrDateComponents {
    static NSDateComponents *dateComponents = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        dateComponents = [NSDateComponents hrUTCAllComponentsFromDate:self];
    });
    return dateComponents;
}

#pragma mark - Date Formatter With Date Format

+(NSDateFormatter *)_hrDateFormatterWithDateFormat:(nonnull NSString *)dateFormat {
    NSParameterAssert(dateFormat);
    NSDateFormatter *dateFormatter = [NSDateFormatter hrUTCDateFormatter];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

-(NSDateFormatter *)_hrDateFormatterWithDateFormat:(nonnull NSString *)dateFormat {
    return [self.class _hrDateFormatterWithDateFormat:dateFormat];
}

#pragma mark - Date Components With Date Style

+(NSDateFormatter *)_hrDateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle
                                  andTimeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *dateFormatter = [NSDateFormatter hrUTCDateFormatter];
    dateFormatter.dateStyle = dateStyle;
    dateFormatter.timeStyle = timeStyle;
    return dateFormatter;
}

-(NSDateFormatter *)_hrDateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle
                                  andTimeStyle:(NSDateFormatterStyle)timeStyle {
    return [self.class _hrDateFormatterWithDateStyle:dateStyle
                                     andTimeStyle:timeStyle];
}

@end

@implementation NSDate (HRDateCompare)

-(BOOL)hrIsEqualToDateIgnoringTime:(NSDate *)date {
    NSParameterAssert(date);
    NSDateComponents *selfDateComponenets = [self _hrDateComponents];
    NSDateComponents *anotherDateComponenets = [NSDateComponents hrUTCAllComponentsFromDate:date];
    
    return
    selfDateComponenets.year  == anotherDateComponenets.year  &&
    selfDateComponenets.month == anotherDateComponenets.month &&
    selfDateComponenets.day   == anotherDateComponenets.day;
}

-(BOOL)hrIsToday {
    NSCalendar *calendar = [NSCalendar hrUTCCalendar];
    return [calendar isDateInToday:self];
}

-(BOOL)hrIsTomorrow {
    NSCalendar *calendar = [NSCalendar hrUTCCalendar];
    return [calendar isDateInTomorrow:self];
}

-(BOOL)hrIsYesterday {
    NSCalendar *calendar = [NSCalendar hrUTCCalendar];
    return [calendar isDateInYesterday:self];
}

@end

@implementation NSDate (HRDateComponents)

-(NSInteger)hrEra {
    return [self _hrDateComponents].era;
}

-(NSInteger)hrDay {
    return [self _hrDateComponents].day;
}

-(NSInteger)hrMonth {
    return [self _hrDateComponents].month;
}

-(NSInteger)hrYear {
    return [self _hrDateComponents].year;
}

-(NSInteger)hrHour {
    return [self _hrDateComponents].hour;
}

-(NSInteger)hrMinute {
    return [self _hrDateComponents].minute;
}

-(NSInteger)hrSecond {
    return [self _hrDateComponents].second;
}

-(NSInteger)hrWeekday {
    return [self _hrDateComponents].weekday;
}

-(NSInteger)hrWeekdayOrdinal {
    return [self _hrDateComponents].weekdayOrdinal;
}

-(NSInteger)hrWeekOfMonth {
    return [self _hrDateComponents].weekOfMonth;
}

-(NSInteger)hrWeekOfYear {
    return [self _hrDateComponents].weekOfYear;
}

-(NSInteger)hrYearForWeekOfYear {
    return [self _hrDateComponents].yearForWeekOfYear;
}

-(NSInteger)hrNanosecond {
    return [self _hrDateComponents].nanosecond;
}

-(NSTimeZone *)hrTimeZone {
    return [self _hrDateComponents].timeZone;
}

-(NSCalendar *)hrCalendar {
    return [self _hrDateComponents].calendar;
}

@end

@implementation NSDate (HRDateFactory)

-(nonnull NSDate *)hrDateAfterDays:(NSInteger)days {
    return [self dateByAddingTimeInterval:(NSInteger)HRDateSecondsInDay * days];
}

+(nonnull NSDate *)hrYesterday {
    return [[self.class date] hrDateAfterDays:-1];
}

+(nonnull NSDate *)hrTomorrow {
    return [[self.class date] hrDateAfterDays:1];
}

+(nullable NSDate *)hrDateFromString:(nonnull NSString *)string
                      withDateFormat:(nonnull NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [self _hrDateFormatterWithDateFormat:dateFormat];
    return [dateFormatter dateFromString:string];
}

+(nullable NSDate *)hrDateFromString:(nonnull NSString *)string
                       withDateStyle:(NSDateFormatterStyle)dateStyle
                        andTimeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *dateFormatter = [self _hrDateFormatterWithDateStyle:dateStyle andTimeStyle:timeStyle];
    return [dateFormatter dateFromString:string];
}

@end

@implementation NSDate (HRDateString)

-(nullable NSString *)hrDateStringWithDateFormat:(nonnull NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [self _hrDateFormatterWithDateFormat:dateFormat];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}

-(nonnull NSString *)hrDateStringWithDateStyle:(NSDateFormatterStyle)dateStyle
                                  andTimeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *dateFormatter = [self _hrDateFormatterWithDateStyle:dateStyle
                                                            andTimeStyle:timeStyle];
    NSString *dateString = [dateFormatter stringFromDate:self];
    return dateString;
}

@end
