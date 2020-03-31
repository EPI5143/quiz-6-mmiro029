*By Marcel Miron-Celis(8298424);
libname bigdata '/folders/myshortcuts/Myfolders/Large databases/Assignments';
libname clasdata '/folders/myshortcuts/Myfolders/Large databases/Master Data Sets';
proc contents data=clasdata.nencounter;
run;
*After removing duplicate patient IDs, there is 17,345 observations, thus there should be 17,345 observations in the flatened dataset;
proc sort data=clasdata.nencounter out=quiz6spine nodupkey;
by encpatwid;
run;
proc sort data=clasdata.nencounter out=bigdata.quiz6data;
by encpatwid;
run;
*This is the procedure to flaten the nencounter dataset. The flatened dataset contains 17,345 observations, mission accomplished;
data bigdata.quiz6encounters;
set bigdata.quiz6data;
by encpatwid;
if first.encpatwid then do;
encounter=0; encountercount=0;
end;
if year (datepart(encstartdtm))=2003 then do;
encounter=1; encountercount=encountercount+1;
end;
if last.encpatwid then output;
retain encounter encountercount;
run;
*Question a, there was 950 patients with at least one inpatient encounter that started in 2003;
proc freq data=bigdata.quiz6encounters;
table encounter;
where EncVisitTypeCd="INPT";
run;
*Question b, there was 1,941 patients with at least one emergency room encounter that started in 2003;
proc freq data=bigdata.quiz6encounters;
table encounter;
where EncVisitTypeCd="EMERG";
run;
*Question c, there was 2,891 patients with at least one emergency room or inpatient encounter that started in 2003;
proc freq data=bigdata.quiz6encounters;
table encounter;
where EncVisitTypeCd="EMERG" or EncVisitTypeCd="INPT";
run;
*Question d, the encountercount variable counts the number of encounters of either type in 2003 for each patient the table output is shown below the code in text form;
options formchar="|----|+|---+=|-/\<>*";
proc printto file = '/folders/myshortcuts/Myfolders/Large databases/Assignments/Quiz6questionD.txt' new; 
proc freq data=bigdata.quiz6encounters;
table encountercount;
where EncVisitTypeCd="EMERG" or EncVisitTypeCd="INPT";
run;
proc printto;
run;
 The FREQ Procedure

                                                                           Cumulative    Cumulative
                                encountercount    Frequency     Percent     Frequency      Percent
                                -------------------------------------------------------------------
                                             0       14454       83.33         14454        83.33  
                                             1        2556       14.74         17010        98.07  
                                             2         270        1.56         17280        99.63  
                                             3          45        0.26         17325        99.88  
                                             4          14        0.08         17339        99.97  
                                             5           3        0.02         17342        99.98  
                                             6           1        0.01         17343        99.99  
                                             7           1        0.01         17344        99.99  
                                            12           1        0.01         17345       100.00  

