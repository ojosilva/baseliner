//XXXXXXXX JOB ST,SOPORTE,CLASS=$class,MSGCLASS=X,REGION=6M,$surr
//         NOTIFY=&SYSUID
/*JOBPARM SYSAFF=SYSB
//*
//     JCLLIB ORDER=BPSCM.ENDVD.LIBR.PROCLIB
//*
//CSV      EXEC PROCCSV
//APIEXTR  DD DISP=(,PASS),DSN=&&TEMP,
//         DCB=(DSORG=PS,RECFM=VB,LRECL=4092),
//         SPACE=(CYL,(5,1),RLSE)
//CSVIPT01 DD *
 LIST PAC ID *
          TO FILE APIEXTR
          .
/*
//*
//LIST     EXEC PGM=IEBGENER
//SYSPRINT DD SYSOUT=*
//SYSUT1   DD DISP=(OLD,DELETE),DSN=&&TEMP
//SYSUT2   DD SYSOUT=*
//SYSIN    DD DUMMY
//*	

