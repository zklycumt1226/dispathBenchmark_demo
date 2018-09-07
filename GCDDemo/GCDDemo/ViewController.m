//
//  ViewController.m
//  GCDDemo
//
//  Created by zkzk on 2018/9/7.
//  Copyright © 2018年 1707002. All rights reserved.
//

#import "ViewController.h"

// 因为是私有api 所以需要声明一下
extern uint64_t dispatch_benchmark(size_t count, void(^bock)(void));

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self dispathBenchmarkFunc2];
    
    //[self dateTimeTest];
    
    //[self absoluteTimeTest];
    //[self currentMediaTimeTest];
    
    [self clockTimeTest];
}

- (void)clockTimeTest{
    clock_t startTime = clock();
    @autoreleasepool{
        for (int i = 0; i < 1000; ++i) {
            NSMutableArray* array = [NSMutableArray array];
            for (int i = 0; i < 1000; ++i) {
                [array addObject:@1];
            }
        }
    }
    clock_t endTime = clock();
    //endTime - startTime is = 23116, is 0.023116 second
    NSLog(@"endTime - startTime is = %lu, is %f second",endTime - startTime,(endTime - startTime)*1.0/CLOCKS_PER_SEC);
}

// 使用data 进行时间测试
- (void)dateTimeTest{
     NSDate* date = [[NSDate alloc] init];
    
    // 参考日期以来的间隔
    NSTimeInterval startTime = [date timeIntervalSinceReferenceDate];
    
    @autoreleasepool{
        for (int i = 0; i < 1000; ++i) {
            NSMutableArray* array = [NSMutableArray array];
            for (int i = 0; i < 1000; ++i) {
                [array addObject:@1];
            }
        }
    }
    NSTimeInterval endTime = [[NSDate date] timeIntervalSinceReferenceDate];
    // endTime - startTime is = 0.023026 单位s
    NSLog(@"endTime - startTime is = %f",endTime - startTime);
}

- (void)absoluteTimeTest{
    
    /* absolute time is the time interval since the reference date */
    /* the reference date (epoch) is 00:00:00 1 January 2001. */
    // 你会发现 其实和NSDate 原理是一样的,与参考时间进行计算
    CFAbsoluteTime absoluteTimeStart =  CFAbsoluteTimeGetCurrent();
    @autoreleasepool{
        for (int i = 0; i < 1000; ++i) {
            NSMutableArray* array = [NSMutableArray array];
            for (int i = 0; i < 1000; ++i) {
                [array addObject:@1];
            }
        }
    }
    
    CFAbsoluteTime absoluteTimeEnd = CFAbsoluteTimeGetCurrent();
    
    // absoluteTimeEnd - absoluteTimeStart = 0.022538  单位s
    NSLog(@"absoluteTimeEnd - absoluteTimeStart = %f",absoluteTimeEnd - absoluteTimeStart);
}

- (void)currentMediaTimeTest{
    /* Returns the current CoreAnimation absolute time. This is the result of
     * calling mach_absolute_time () and converting the units to seconds. */
    // 通过coreAnimation 层绝对时间进行计算,单位是s
    CFTimeInterval startTimeInterval = CACurrentMediaTime();
    @autoreleasepool{
        for (int i = 0; i < 1000; ++i) {
            NSMutableArray* array = [NSMutableArray array];
            for (int i = 0; i < 1000; ++i) {
                [array addObject:@1];
            }
        }
    }
    CFTimeInterval endTimeInterval = CACurrentMediaTime();
    
    //endTimeInterval - startTimeInterval = 0.022399
    NSLog(@"endTimeInterval - startTimeInterval = %f",endTimeInterval - startTimeInterval);
}

//benckmark 基准的意思
- (void)dispathBenchmarkFunc2{
    
    // block执行次数
    size_t count = 10000;
    size_t signalCount = 1000;
    //benchmarkTime 为执行该block count 次所需要的总时间,单位μs
    // block内部的代码会循环执行count * signalCount 次
    uint64_t benchmarkTime = dispatch_benchmark(count, ^{
        @autoreleasepool{
            NSMutableArray* array = [NSMutableArray array];
            for (int i = 0; i < signalCount; ++i) {
                [array addObject:@1];
            }
        }
    });
    
    // 单位μs  这个时间单位有问题
    /*
     1秒=1000毫秒(ms),1毫秒=1／1000秒(s)；
     1秒=1000000 微秒(μs),1微秒=1／1000000秒(s)；
     1秒=1000000000 纳秒(ns),1纳秒=1／1000000000秒(s)；
     1秒=1000000000000皮秒 1皮秒==1/1000000000000秒.
     */
    //benchmark time is = 22885, is 0.022885 secound
    NSLog(@"benchmark time is = %llu, is %f secound",benchmarkTime,benchmarkTime*1.0/1000000);
}


@end
