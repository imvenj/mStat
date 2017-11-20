//
//  data_usage.c
//  mStat Widget
//
//  Created by venj on 2017/11/17.
//  Copyright © 2017年 venj. All rights reserved.
//

#include "data_usage.h"

/*
 * Print a description of the network interfaces.
 */
data_usage get_data_usage(const char *interface) {
    u_int64_t obytes = 0;
    u_int64_t ibytes = 0;
    int mib[6];
    char *buf = NULL, *lim, *next;
    size_t len;
    struct if_msghdr *ifm;
    data_usage df = {0, 0};

    unsigned int ifindex = if_nametoindex(interface);

    if (ifindex == 0) { // Error
        return df;
    }

    mib[0]	= CTL_NET;			// networking subsystem
    mib[1]	= PF_ROUTE;			// type of information
    mib[2]	= 0;				// protocol (IPPROTO_xxx)
    mib[3]	= 0;				// address family
    mib[4]	= NET_RT_IFLIST2;	// operation
    mib[5]	= 0;
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return df;
    }
    if ((buf = malloc(len)) == NULL) {
        printf("malloc failed\n");
        return df;
    }
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        if (buf) { free(buf); }
        return df;
    }

    lim = buf + len;
    for (next = buf; next < lim; ) {
        ifm = (struct if_msghdr *)next;
        next += ifm->ifm_msglen;

        if (ifm->ifm_type == RTM_IFINFO2) {
            struct if_msghdr2 *if2m = (struct if_msghdr2 *)ifm;
            if (interface != 0 && if2m->ifm_index != ifindex) {
                continue;
            }
            obytes = if2m->ifm_data.ifi_obytes;
            ibytes = if2m->ifm_data.ifi_ibytes;

            df.upload = obytes;
            df.download = ibytes;
            break;
        }
    }
    free(buf);
    return df;
}
