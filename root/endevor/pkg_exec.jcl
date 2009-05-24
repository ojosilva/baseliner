//XXXXXXXX JOB ST,SOPORTE,CLASS=<% $class %>,MSGCLASS=X,REGION=6M,
// NOTIFY=HARVEST,<% $surr %>
/*JOBPARM SYSAFF=SYSB                                        
//*                                                          
//     JCLLIB ORDER=BPSCM.ENDVD.LIBR.PROCLIB                 
//*                                                          
//PKGEXEC  EXEC PROCPKG                                      
//ENPSCLIN DD *                                              
EXECUTE PACKAGE '<% $package %>'                                    
 .                                                           
/* 


