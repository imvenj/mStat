//
//  data_usage.h
//  Monit
//
//  Created by venj on 2017/11/17.
//  Copyright © 2017年 venj. All rights reserved.
//

#ifndef data_usage_h
#define data_usage_h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <net/route.h>
#include <net/if.h>

typedef struct {
    unsigned long long upload;
    unsigned long long download;
} data_usage;

data_usage get_data_usage(const char *interface);

#endif /* data_usage_h */
