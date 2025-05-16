
// dig +short _netblocks.google.com TXT
// "v=spf1 ip4:35.190.247.0/24 ip4:64.233.160.0/19 ip4:66.102.0.0/20 ip4:66.249.80.0/20 ip4:72.14.192.0/18 ip4:74.125.0.0/16 ip4:108.177.8.0/21 ip4:173.194.0.0/16 ip4:209.85.128.0/17 ip4:216.58.192.0/19 ip4:216.239.32.0/19 ~all"



// v=spf1 ip4:172.217.0.0/19 ip4:172.217.32.0/20 ip4:172.217.128.0/19 ip4:172.217.160.0/20 ip4:172.217.192.0/19 ip4:172.253.56.0/21 ip4:172.253.112.0/20 ip4:108.177.96.0/19 ip4:35.191.0.0/16 ip4:130.211.0.0/22 ~all"



// v=spf1 ip4:40.92.0.0/15 ip4:40.107.0.0/16 ip4:52.100.0.0/15 ip4:52.102.0.0/16 ip4:52.103.0.0/17 ip4:104.47.0.0/17 ip6:2a01:111:f400::/48 ip6:2a01:111:f403::/49 ip6:2a01:111:f403:8000::/51 ip6:2a01:111:f403:c000::/51 ip6:2a01:111:f403:f000::/52 -all"



// ay 4 23:02:51 smtp2 postfix/smtpd[2073198]: connect from mail-uaenorthazon11022105.outbound.protection.outlook.com[40.107.55.105]
// May 4 23:02:52 smtp2 postfix/smtpd[2073198]: NOQUEUE: client=mail-uaenorthazon11022105.outbound.protection.outlook.com[40.107.55.105]
// May 4 23:02:54 smtp2 pmg-smtp-filter[2065603]: 2C225C6817C7EEE1481: new mail message-id=<DX1P273MB1377B66941D9750030CF6A86E68F2@DX1P273MB1377.AREP273.PROD.OUTLOOK.COM>#012
// May 4 23:02:57 smtp2 pmg-smtp-filter[2065603]: 2C225C6817C7EEE1481: SA score=0/5 time=2.975 bayes=undefined autolearn=no autolearn_force=no hits=DKIM_INVALID(0.1),DKIM_SIGNED(0.1),HTML_IMAGE_RATIO_06(0.001),HTML_MESSAGE(0.001),KAM_DMARC_STATUS(0.01),RCVD_IN_DNSWL_BLOCKED(0.001),RCVD_IN_MSPIKE_H2(0.001),RCVD_IN_VALIDITY_CERTIFIED_BLOCKED(0.001),RCVD_IN_VALIDITY_RPBL_BLOCKED(0.001),SPF_HELO_PASS(-0.001),SPF_PASS(-0.001),URIBL_BLOCKED(0.001)
// May 4 23:02:58 smtp2 postfix/smtpd[2073253]: connect from localhost[127.0.0.1]
// May 4 23:02:58 smtp2 postfix/smtpd[2073253]: 032F62C229B: client=localhost[127.0.0.1], orig_client=mail-uaenorthazon11022105.outbound.protection.outlook.com[40.107.55.105]
// May 4 23:02:58 smtp2 postfix/cleanup[2073254]: 032F62C229B: message-id=<DX1P273MB1377B66941D9750030CF6A86E68F2@DX1P273MB1377.AREP273.PROD.OUTLOOK.COM>
// May 4 23:02:58 smtp2 postfix/qmgr[2574125]: 032F62C229B: from=<Ehab.Malallah@idcentriq.com>, size=1392371, nrcpt=2 (queue active)
// May 4 23:02:58 smtp2 postfix/smtpd[2073253]: disconnect from localhost[127.0.0.1] ehlo=1 xforward=1 mail=1 rcpt=2 data=1 commands=6
// May 4 23:02:58 smtp2 pmg-smtp-filter[2065603]: 2C225C6817C7EEE1481: accept mail to <behailu.adugna@insa.gov.et> (032F62C229B) (rule: default-accept)
// May 4 23:02:58 smtp2 pmg-smtp-filter[2065603]: 2C225C6817C7EEE1481: accept mail to <hanibal@insa.gov.et> (032F62C229B) (rule: default-accept)
// May 4 23:02:58 smtp2 pmg-smtp-filter[2065603]: 2C225C6817C7EEE1481: processing time: 3.15 seconds (2.975, 0.019, 0)
// May 4 23:02:58 smtp2 postfix/smtpd[2073198]: proxy-accept: END-OF-MESSAGE: 250 2.5.0 OK (2C225C6817C7EEE1481); from=<Ehab.Malallah@idcentriq.com> to=<behailu.adugna@insa.gov.et> proto=ESMTP helo=<DX2P273CU003.outbound.protection.outlook.com>
// May 4 23:02:58 smtp2 postfix/smtpd[2073198]: disconnect from mail-uaenorthazon11022105.outbound.protection.outlook.com[40.107.55.105] ehlo=1 mail=1 rcpt=2 data=1 quit=1 commands=6
// May 4 23:02:58 smtp2 postfix/smtp[2073255]: Untrusted TLS connection established to smtp.insa.gov.et[102.218.2.10]:587: TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits) key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256
// May 4 23:02:58 smtp2 postfix/smtp[2073255]: 032F62C229B: to=<behailu.adugna@insa.gov.et>, relay=smtp.insa.gov.et[102.218.2.10]:587, delay=0.83, delays=0.09/0.02/0.45/0.28, dsn=2.6.0, status=sent (250 2.6.0 Message received)
// May 4 23:02:58 smtp2 postfix/smtp[2073255]: 032F62C229B: to=<hanibal@insa.gov.et>, relay=smtp.insa.gov.et[102.218.2.10]:587, delay=0.83, delays=0.09/0.02/0.45/0.28, dsn=2.6.0, status=sent (250 2.6.0 Message received)
// May 4 23:02:58 smtp2 postfix/qmgr[2574125]: 032F62C229B: removed






