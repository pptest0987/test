//
//  UnicodeConversionClass.m
//  sample-chat
//
//  Created by Parkhya Solutions on 1/10/17.
//  Copyright © 2017 Quickblox. All rights reserved.
//

#import "UnicodeConversionClass.h"

@implementation UnicodeConversionClass

- (NSString *)StringToConvert:(NSString *)Str
{
    NSData *UnicodedStr = [Str dataUsingEncoding:NSUTF8StringEncoding];
    NSString *StringValue = [[NSString alloc] initWithData:UnicodedStr encoding:NSNonLossyASCIIStringEncoding];

    if (StringValue == NULL) {
        StringValue=Str;
    }
    
    return StringValue;
}
- (NSString *)timeStampWithDate11:(NSString *)dateStr {
    /*
     "date_time" = "2017-01-10 10:23:56";
     "time_zone" = UTC;
     */
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSString *ServerDate=[userDefaults valueForKey:@"ServerDate"];
//    NSString *time_zone=[userDefaults valueForKey:@"time_zone"];

    
   /* NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    // from server dateFormat
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // get date from server
    NSDate * dateTemp = [format dateFromString:dateStr];
    // new date format
    [format setDateFormat:@"dd MMM, YYYY hh:mm a"];
    
    // convert Timezone
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:dateTemp];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:dateTemp];
    NSTimeInterval gmtInterval =   currentGMTOffset - gmtOffset;
    
    // get final date in LocalTimeZone
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:dateTemp];
    // convert to String
    NSString *dateStr11 = [format stringFromDate:destinationDate];
    NSLog(@"dateStr11...%@",dateStr11);*/
    
   /* NSDateFormatter* gmtDf = [[NSDateFormatter alloc] init];
    [gmtDf setTimeZone:currentTimeZone];//[NSTimeZone timeZoneWithName:@"GMT"]];
    [gmtDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* gmtDate = [gmtDf dateFromString:dateStr];
    NSLog(@"%@",gmtDate);
    
    NSDateFormatter* estDf = [[NSDateFormatter alloc] init];
    [estDf setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [estDf setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *estDate = [estDf dateFromString:[gmtDf stringFromDate:gmtDate]]; // you can also use str
    NSLog(@"%@",estDate);
    NSString *dateStr11 = [format stringFromDate:estDate];*/
    
    
    //UTC time
    NSDateFormatter *utcDateFormatter = [[NSDateFormatter alloc] init];
    [utcDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [utcDateFormatter setTimeZone :[NSTimeZone timeZoneForSecondsFromGMT: 0]];
    
    // utc format
    NSDate *dateInUTC = [utcDateFormatter dateFromString: dateStr];
    
    // offset second
    NSInteger seconds = [[NSTimeZone systemTimeZone] secondsFromGMT];
    
    // format it and send
    NSDateFormatter *localDateFormatter = [[NSDateFormatter alloc] init];
    [localDateFormatter setDateFormat:@"dd MMM, YYYY hh:mm a"];
    [localDateFormatter setTimeZone :[NSTimeZone timeZoneForSecondsFromGMT: seconds]];
    
    // formatted string
    NSString *localDate = [localDateFormatter stringFromDate: dateInUTC];
    return localDate;
    
}

@end
