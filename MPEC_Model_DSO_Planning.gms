*Code developed by Athir Nouicer
*Mail: nouicer.athir@gmail.com

*This model has been developed for the paper 'The economics of explicit demand-side flexibility in distribution grids'
*Authors of the paper: Athir Nouicer, Leonardo Meeus, and Erik Delarue


option mpec=knitro
*Path needs to be adjusted to your local computer
$CALL GDXXRW Input="C:\Users\anouicer\Dropbox\My PC (LAPTOP-FCO5SP92)\Desktop\gams\201710MSinput48_w24.xlsx" Output="C:\Users\anouicer\Dropbox\My PC (LAPTOP-FCO5SP92)\Desktop\gams\201710MSinput48_w2.gdx" @"C:\Users\anouicer\Dropbox\My PC (LAPTOP-FCO5SP92)\Desktop\gams\201710MSInputFile_d2.txt"
$GDXIN C:\Users\anouicer\Dropbox\My PC (LAPTOP-FCO5SP92)\Desktop\gams\201710MSinput48_w2.gdx

Sets
i Agents  /i1*i2/
t Timestep /t1*t24/
tsub1(t) /t1*t23/
tsub2(t) /t2*t24/
daytype /normal, extreme/


;


* Parameters set in the code
Parameters

MS(i) Maximum solar (peak) capacity is allowed for an agent [kW]
/
i1 4
i2 0
/
MB(i) Maximum battery (energy) capacity can be installed by agent i [kWh]

/
i1 8
i2 0
/


NM Type of volumetric charges   /0/


VOLL Value of lost load /5.33/

************************************************************************
;

* Loaded parameters from excel
Parameters


*incrGC  Linear increment or decrease in network costs per aggregated peak kW increase or decrease [€ per kW]
IncrGC /400/
A /0/
FrF  /1/
OPAggMaxAbs  Original aggregated peak demand  [kW]
dt Time step lenght as a fraction of an hour [-]

EBP(t) Energy price to be paid the agent for buying from the grid [€ per kWh]
ESP(t) Energy price to received by the agent for selling to the grid [€ per kWh]
comp(t,daytype,i)  compensation parameter
dpd(t,daytype,i)  demand parameter
*wdt_pd(daytype)  Scaling factor to annualize
wdt_pd(daytype)
AFS Annuity factor solar [-]
AFB Annuity factor battery [-]
ICS Investment cost of solar [€ per kW]
PST Prosumertariff per kwp of PV installed [€ per kwp]
FT Feed-in tariff for solar energy produced (either consumed or sold) [€ per kWh]
ICB Investement cost of batteries [€ per kWh]
EffSolar System efficiency solar [%]
BDRatio Ratio of max power output in kW and capacity in kWh [-]
BCRatio Ratio of max power input in kW and capacity in kWh [-]
SOC0 Initial and final state of charge of the battery [kWh]
BEff_out Efficiency of discharging [%]
BEff_in  Efficiency of charging [%]
phi Leakage of battery [%]
CF(t,i) Capacity factor of the solar panel at time step t of agent i [%]
MD(i) Maximum demand of agent i [kW]
ConsProp(i) Number of customers in each customer group


*objLimits(lll) Underlimit of the objective function for computational speed
;
$LOAD comp,wdt_pd,OPAggMaxAbs,dt,dpd,EBP,ESP,AFS,AFB,ICS,PST,FT,ICB,EffSolar,BDRatio,BCRatio,BEff_out,BEff_in,phi,SOC0,CF,MD,ConsProp

*,objLimits
;

******************************************************************************************************
******************************************Variables***************************************************
******************************************************************************************************
FREE VARIABLES


objD

mu1(t,daytype,i) Dual of the power balance equation
mu2(t,daytype,i) Dual of the battery balance equation
mu3(t,daytype,i) Dual of the battery balance equation



Positive Variables

Flex  flex volume calculation
CPeak instant peak
qcurt(t,daytype,i) curtailement quantity
VNT  Volumetric network tariff [€ per kWh]
CNT Power charge for network usage [€ per kWyearly]
FNT   Fixed network charge
qw(t,daytype,i) Energy bought at time step t by agent i [kW]
qi(t,daytype,i) Energy sold at time step t by agent i [kW]
qmax(i) Yearly peak demand of agent i [kW]
SOC(t,DAYTYPE,i) State of charge of the battery [kWh]
qBout(t,daytype,i) Output of the battery [kW]
qBin(t,daytype,i) Input of the battery [kW]
IS(i)   Installed capacity of solar by agent i [kW]
IB(i)   Installed capacity of battery by agent i [kWh]




* Duals needed for disjunctive constraints in LL
l1(t,daytype,i),l2(t,daytype,i),l3(t,daytype,i),l4(t,daytype,i),l5(t,daytype,i),l6(t,daytype,i),l7(t,daytype,i),l8(t,daytype,i),l9(t,daytype,i),
l10(i),l11(i), l12(i),l13(i),theta(t,daytype,i), x,y,z


 ;
******************************************************************************************************
******************************************Equations***************************************************
******************************************************************************************************



**************************** Objective function *****************************************
 Equations

objDSO
flexlevel
PAggMaxAbseq1(t,daytype)
PAggmaxAbseq2(t,daytype)
poscurt_theta(t,daytype,i)
posfnt_x
poscnt_y
pstvnt_z
GCR_alf
curtceiling_qdual(t,daytype,i)
poscurt(t,daytype,i)
consbalance_mu1(t,daytype,i)
stateofcharge_mu2(t,daytype,i)
stateofcharget1_mu2(t,daytype,i)
stateofcharget24_mu3(t,daytype,i)

*stateofcharget25_mu3(i)
stateofcharget24_mu2(t,daytype,i)
peakcons_l1(t,daytype,i)
maxbat_l2(t,daytype,i)
maxdischarge_l3(t,daytype,i)
maxcharge_l4(t,daytype,i)
posqw_l5(t,daytype,i)
 posqi_l6(t,daytype,i)
possoc_l7(t,daytype,i)
posqbout_l8(t,daytype,i)
posqbin_l9(t,daytype,i)
maxcaps_l10(i)
maxcapb_l11(i)
posis_l12(i)
posib_l13(i)
conskkt1_qw(t,daytype,i)
conskkt2_qi(t,daytype,i)
conskkt3_qmax(i)
conskkt4_SOC(t,daytype,i)
kkttmax_SOC(t,daytype,i)
conskkt5_qbout(t,daytype,i)
conskkt6_qbin(t,daytype,i)
conskkt7_is(i)
conskkt8_ib(i)

*posqmax_qq(i)

;


**************************** Objective function *****************************************


objDSO..

objD=e=sum(i,ConsProp(i)*sum(daytype,sum(t,(dpd(t,daytype,i)-qcurt(t,daytype,i))*VOLL*wdt_pd(daytype))))+sum(i,ConsProp(i)*sum(daytype,sum(t,comp(t,daytype,i)*qcurt(t,daytype,i)*wdt_pd(daytype))))- (sum(i,ConsProp(i)*IS(i)*ICS*AFS) + sum(i,ConsProp(i)*IB(i)*ICB*AFB)+sum(daytype,sum(t,sum(i,ConsProp(i)*(qw(t,daytype,i)*EBP(t)-qi(t,daytype,i)*ESP(t))*wdt_pd(daytype))))  +cnt*sum((i),ConsProp(i)*qmax(i)) )
;

flexlevel..
Flex=e=100*(sum(i,sum(daytype, wdt_pd(daytype)*sum(t,qcurt(t,daytype,i))))/sum(i,sum(daytype, sum(t ,wdt_pd(daytype)*dpd(t,daytype,i)))))

;

PAggMaxAbseq1(t,daytype)..
CPeak - sum(i, ConsProp(i)*(qw(t,daytype,i)-qi(t,daytype,i)))=g= 0
;


PAggmaxAbseq2(t,daytype)..
         CPeak - sum(i, ConsProp(i)*(qi(t,daytype,i)-qw(t,daytype,i)))  =g= 0
;

poscurt_theta(t,daytype,i)..
qcurt(t,daytype,i) =g=0
;


poscnt_y..
CNT =g=0
;


GCR_alf..

(((1-FrF)*OPAggMaxAbs+FrF*CPeak)*incrGC+A + sum(t,sum(daytype,sum(i, ConsProp(i)*comp(t,daytype,i)*qcurt(t,daytype,i))*wdt_pd(daytype))))=e=( sum((i),ConsProp(i)*qmax(i)*cnt))
;

poscurt(t,daytype,i)..

-qcurt(t,daytype,i)=l=0;

**************consumer constraints*****************************************************
consbalance_mu1(t,daytype,i)..
         qw(t,daytype,i) -qi(t,daytype,i) +IS(i)*EffSolar*CF(t,i)+qBout(t,daytype,i)-qBin(t,daytype,i)+qcurt(t,daytype,i)-Dpd(t,daytype,i) =e=0
;


stateofcharge_mu2(t,daytype,i)$tsub2(t)..
         SOC(t,daytype,i)-qBin(t,daytype,i)*BEff_in*dt+qBout(t,daytype,i)*dt/BEff_out-SOC(t-1,daytype,i)*(1-phi*dt) =e= 0
;


stateofcharget1_mu2('t1',daytype,i)..
SOC('t1',daytype,i)-qBin('t1',daytype,i)*BEff_in*dt+qBout('t1',daytype,i)*dt/BEff_out-SOC0 =e= 0
  ;


stateofcharget24_mu3('t24',daytype,i)..
SOC('t24',daytype,i)-SOC0 =e= 0
;


peakcons_l1(t,daytype,i)..
qmax(i)-qw(t,daytype,i)- qi(t,daytype,i)=g= 0
;



maxbat_l2(t,daytype,i)..
         IB(i) -SOC(t,daytype,i) =g= 0
 ;

maxdischarge_l3(t,daytype,i)..
         IB(i)*BDRatio -qBout(t,daytype,i)=g= 0

;
maxcharge_l4(t,daytype,i)..
         IB(i)*BCRatio -qBin(t,daytype,i)=g= 0
;

posqw_l5(t,daytype,i)..
         qw(t,daytype,i) =g= 0
;

posqi_l6(t,daytype,i)..
         qi(t,daytype,i) =g= 0
;

possoc_l7(t,daytype,i)..
  soc(t,daytype,i) =g=0
;

posqbout_l8(t,daytype,i)..
         qbout(t,daytype,i) =g=0
;

posqbin_l9(t,daytype,i)..
         qbin(t,daytype,i)  =g=0
;

maxcaps_l10(i)..
         MS(i)-IS(i) =g= 0
;

maxcapb_l11(i)..
         MB(i)-IB(i) =g= 0
;

posis_l12(i)..
         is(i) =g=0
;
posib_l13(i)..
        ib(i) =g=0
;

conskkt1_qw(t,daytype,i)..
wdt_pd(daytype)*EBP(t)+ mu1(t,daytype,i) + l1(t,daytype,i) -l5(t,daytype,i) =e=   0
;

conskkt2_qi(t,daytype,i)..
-wdt_pd(daytype)*ESP(t)-mu1(t,daytype,i) + l1(t,daytype,i) -l6(t,daytype,i) =e=   0
;

conskkt3_qmax(i)..
CNT-sum(daytype,sum(t,l1(t,daytype,i)))  =e=   0;

conskkt4_SOC(t,daytype,i)$tsub1(t)..
         mu2(t,daytype,i)-mu2(t+1,daytype,i)*(1-phi*dt)+l2(t,daytype,i)-l7(t,daytype,i) =e=   0;

kkttmax_SOC('t24',daytype,i)..
mu2('t24',daytype,i)+mu2('t1',daytype,i)+l2('t24',daytype,i)-l7('t24',daytype,i) =e=   0;

conskkt5_qbout(t,daytype,i)..
          mu1(t,daytype,i) +mu2(t,daytype,i)*dt/BEff_out+l3(t,daytype,i) -l8(t,daytype,i) =e=   0;
conskkt6_qbin(t,daytype,i)..
           -mu1(t,daytype,i) -mu2(t,daytype,i)*BEff_in*dt+l4(t,daytype,i) -l9(t,daytype,i) =e=  0;

conskkt7_is(i)..
ICS*AFS + sum(daytype,sum(t, mu1(t,daytype,i)*EffSolar*CF(t,i)))+l10(i)-l12(i) =e=  0;

conskkt8_ib(i)..
ICB*AFB - sum(daytype,sum(t, l2(t,daytype,i))) -sum(daytype,sum(t,l3(t,daytype,i)*BDRatio)) - sum(daytype,sum(t,l4(t,daytype,i)*BCRatio))+l11(i) -l13(i) =e=  0 ;






******************************************************************************************************
******************************************Solve statements********************************************
******************************************************************************************************



OPTION RESLIM = 10000000000;
option threads=3;
option decimals=4;
* 0 means using all threads
*OPTION relaxfixedinfeas=on;
option  sys12=1 ;
*option  execerr=2e9 ;
*option Execerr=2e9;
*option nlp=baron;
*option ms_maxtime_cpu
*option  opttol    = 0e0;

model modeldisMPEC


/

objDSO
flexlevel
GCR_alf
PAggMaxAbseq1
PAggMaxAbseq2
poscurt_theta
poscurt
poscnt_y
conskkt1_qw.qw
conskkt2_qi.qi
conskkt3_qmax.qmax
conskkt4_SOC.SOC
kkttmax_SOC.SOC
conskkt5_qbout.qbout
conskkt6_qbin.qbin
conskkt7_is.is
conskkt8_ib.ib
**consumer constraints
consbalance_mu1.mu1
stateofcharge_mu2.mu2
stateofcharget1_mu2.mu2
peakcons_l1.l1
maxbat_l2.l2
maxdischarge_l3.l3
maxcharge_l4.l4
posqw_l5.l5
posqi_l6.l6
possoc_l7.l7
posqbout_l8.l8
posqbin_l9.l9
maxcaps_l10.l10
maxcapb_l11.l11
posis_l12.l12
posib_l13.l13

/

;
parameters

CPeakl
Al
IncrGCL
Gridcost
TGClist
INVCost
curtcostl(i)
qcurtl(t,daytype,i)
qwl(t,daytype,i)
qil(t,daytype,i)
qmaxl(i)
ISL(i)
IBL(i)
CNTL
FNTL
COMPL(t,daytype,i)
maxcurtl(i)
DL(t,daytype,i)
ConsumerProfile(t,daytype,i)
EnerCostl(i)
GridChargesagent(i)
GridChargesl
Solaroutput(t,i)
qboutl(t,daytype,i)
qbinl(t,daytype,i)
totalenergycostsl
Utilityconstype(i)
Utilitycons
totalsystemcost
Grossystemwelfare
Systemwelfare
flexlevell
CostRECCHECK ;

*For the scenario of capacity-based tariffs. to be changed according to the scenario
*vnt.up = 0;
*fnt.up=40;

*set lower or upper bounds for the Objective function to
objd.lo=23000;


solve modeldisMPEC maximising objD using mpec  ;
display consprop;
modeldisMPEC.optfile=1;
CPeakl=CPeak.l      ;
AL=A;
IncrGCL=IncrGC ;
Gridcost=   ((1-FrF)*OPAggMaxAbs+FrF*CPeakl)*IncrGCl+AL ;
TGClist = Gridcost+ sum(i,ConsProp(i)*sum(daytype,(sum(t,comp(t,daytype,i)*qcurt.l(t,daytype,i)*wdt_pd(daytype)))))  ;
INVCost=((1-FrF)**OPAggMaxAbs+FrF*CPeak.l)*IncrGCL   ;
curtcostl(i)=sum(daytype,sum(t,comp(t,daytype,i)*qcurt.l(t,daytype,i))*wdt_pd(daytype));
qcurtl(t,daytype,i)=qcurt.l(t,daytype,i)               ;
qwl(t,daytype,i)=qw.l(t,daytype,i);
qil(t,daytype,i)=qi.l(t,daytype,i) ;
qmaxl(i)=qmax.l(i) ;
ISL(i) =IS.l(i);
IBL(i)=IB.l(i);
CNTL =cnt.l ;
COMPL(t,daytype,i)=comp(t,daytype,i);
DL(t,daytype,i)=Dpd(t,daytype,i);
ConsumerProfile(t,daytype,i)  =qw.l(t,daytype,i)-qi.l(t,daytype,i)   ;
EnerCostl(i) =sum(daytype,sum(t,qw.l(t,daytype,i)*ebp(t)-qi.l(t,daytype,i)*esp(t))*wdt_pd(daytype)) ;
GridChargesagent(i)=cntl *qmaxl(i) ;
GridChargesl = cntl *sum((i),ConsProp(i)*qmaxl(i)) ;
Solaroutput(t,i)=ISL(i)*EffSolar*CF(t,i)  ;
qboutl(t,daytype,i)=qbout.l(t,daytype,i)   ;
qbinl(t,daytype,i)=qbin.l(t,daytype,i)  ;
totalenergycostsl  = sum(i,  consprop(i)*EnerCostl(i) )          ;
Utilityconstype(i)=sum(daytype,sum(t,(dpd(t,daytype,i)-qcurt.l(t,daytype,i))*VOLL*wdt_pd(daytype)  +comp(t,daytype,i)*qcurt.l(t,daytype,i)*wdt_pd(daytype)))-(EnerCostl(i)+ GridChargesagent(i) +IS.l(i)* ICS*AFS + IB.l(i)*ICB*AFB);
Utilitycons = sum(i, consprop(i)*Utilityconstype(i));
totalsystemcost  =   sum(i,ConsProp(i)*ISL(i)* ICS*AFS)+ sum(i, consprop(i)* IBL(i)*ICB*AFB)+ sum(i,ConsProp(i)*EnerCostl(i))+ GridChargesl    ;


Grossystemwelfare = sum(i,ConsProp(i)*sum(daytype,sum(t,(dpd(t,daytype,i)-qcurt.l(t,daytype,i))*VOLL*wdt_pd(daytype)+comp(t,daytype,i)*qcurt.l(t,daytype,i)*wdt_pd(daytype)))) ;
Systemwelfare=Grossystemwelfare-totalsystemcost ;
Flexlevell=100*(sum(i,sum(daytype, wdt_pd(daytype)*sum(t,qcurt.l(t,daytype,i))))/sum(i,sum(daytype, sum(t ,wdt_pd(daytype)*dpd(t,daytype,i)))))
;
CostRECCHECK= sum(i,consprop(i)*curtcostl(i)) + AL  + (((1-FrF)*OPAggMaxAbs+FrF*CPeakl )*IncrGCL ) - cntl *sum((i),ConsProp(i)*qmaxl(i))


*******Set path for the results file*******
file results /C:\Users\anouicer\Dropbox\My PC (LAPTOP-FCO5SP92)\Desktop\gams\DSO_planning_Results.csv/;
results.pc = 5;
results.pw = 255;
results.nd= 8;

put results;

* model statistics
put '++++++++++++++++++++++++++++++++ General +++++++++++++++++++++++++++++'
put /


put 'Proportions of agents', loop(i, put i.tl)
put /

put ' '

loop(i, put ConsProp(i))
put /

put 'Run on ' system.date ' using source file ' system.ifile ;
put /
put '*********Important parameters*************'
put /
put 'Friction factor'
put FrF
put /

put /

put /

put /
put /


put '********************************************************************************************************'
put /
put 'Flex level'
put /
put Flexlevell
put /
put /

put 'Total Grid Cost'
put /
put (AL +IncrGCL *CPeakl )
put /
put /
put 'Variable network costs'
put /
put  IncrGCL
put/
put/
put/
put 'Sunk network costs'
put/
put AL
put/
put/
put'FRF'
put /
put/ frf
put /
put /
put'CPeak'
put /
put CPeakl
put /
put /

put'Total Grid investment costs'
put /
put INVCost ;
put /
put /
put 'compensation level',
put /
loop(daytype, put daytype.tl)
put /
loop(daytype,
put COMPL('t1',daytype,'i1')


)
put /
put /

put /

put /

put 'annual curtailment Volume by agent',
put /
 loop(i, put i.tl)
put /
 loop (i, put sum(daytype,sum(t,qcurtl(t,daytype,i)*wdt_pd(daytype)) ))
put /
put /
put' Total curtailment volume'
put /
 put sum(i,consprop(i)* sum(daytype,sum(t,qcurtl(t,daytype,i)*wdt_pd(daytype))))
put /
put /
put 'annual curtailment cost by agent',
put /
 loop(i, put i.tl)
put /

loop (i, put curtcostl(i))
put /
put' Total curtailment costs'
put /
put sum(i,consprop(i)*curtcostl(i));
put /

put /
put 'Total DSO costs'
put /
put TGClist
put /
put /

put 'System Utility'
put Systemwelfare
put /
put /


***
put'Gross system welfare' put 'total system costs' put  'Grid cost'  put 'PV costs' put' Battery costs' put 'energy costs'  put 'Curtailment cost'  put 'Grid Charges'
put /
put  Grossystemwelfare put totalsystemcost  put (((1-FrF)*OPAggMaxAbs+FrF*CPeakl )*IncrGCL +AL ) put sum(i,ConsProp(i)*(ISL(i)* ICS*AFS)) put (sum(i, consprop(i)* IBL(i)*ICB*AFB)) put sum((i), ConsProp(i)*EnerCostl(i)) put sum(i,  consprop(i)*curtcostl(i))
 put GridChargesl
put /

put /
put /
put ' Consumer welfare by agent',
put /

 put 'Active' put 'Passive'
put /
loop(i, put Utilityconstype(i))
put /
put /
put ' Aggregated consumer welfare ',
put /
put Utilitycons  put/
put/
put/
put /

put 'Active customer Utility element'  put /

put 'Gross consumer surplus'  put'Curtailment revenue included in the surplus' put 'PV investment cost' put 'battery investment cost' put 'Energy cost' put 'Grid Charges' put /
put sum(daytype,(sum(t,(DL(t,daytype,'i1')-qcurtl(t,daytype,'i1'))*VOLL*wdt_pd(daytype)+qcurtl(t,daytype,'i1')*compl(t,daytype,'i1')*wdt_pd(daytype)) )) put sum(daytype,sum(t,qcurtl(t,daytype,'i1')*compl(t,daytype,'i1')*wdt_pd(daytype))) put (ISL('i1')*ICS*AFS) put  (IBL('i1')*ICB*AFB) put (EnerCostl('i1'))   put GridChargesagent('i1')  put/
put /
put /
put 'Passive customer Utility element'  put /

put 'Gross consumer surplus' put' curtailment revenue included in the surplus'  put 'PV investment cost' put 'battery investment cost' put 'Energy cost' put 'Grid Charges'put /
put (sum(daytype,sum(t,(DL(t,daytype,'i2')-qcurtl(t,daytype,'i2'))*VOLL*wdt_pd(daytype)+ qcurtl(t,daytype,'i2')*compl(t,daytype,'i2')*wdt_pd(daytype)) )) put sum(daytype,sum(t,qcurtl(t,daytype,'i2')*compl(t,daytype,'i2')*wdt_pd(daytype)))  put (ISL('i2')*ICS*AFS) put  (IBL('i2')*ICB*AFB) put (EnerCostl('i2'))  put GridChargesagent('i2')  put/
put /
put 'Total system costs '
put /
put totalsystemcost
put /
put /
put /
put 'CNT'
put ' '
put cntl
put /
put /
put /
put /
put 'Solar investment by agent',
put /
loop(i, put i.tl)
put/
loop(i,put ISL(i))
put/
put /
put 'Battery investment by agent' ,
 put /
 loop(i, put i.tl)
put/
loop(i, put IBL(i) )

put /
put /
put 'Total Energy cost'
put /
put totalenergycostsl ;
put /
put /
put /
put 'Energy cost by agent'
put /
put put 'Active' put 'Passive'
put /
put loop(i, put EnerCostl(i)   )
put /
put /
put ' curtailment profile by agent',
put /

 put 'Active' put 'Passive'
put /


loop(daytype,put daytype.tl  put / loop(t,  loop(i, put (qcurtl(t,daytype,i) ))put/))
put /

put /
put 'Individual demand'
put /
put ' '
put 'Original'
put ' '
 put 'qw'
put ' '
 put 'qi'
put ' '
 put 'Consumer Profile'
put ' '
 put 'Solar Output'
put ' '
 put 'Battery Output'
put ' '
 put 'Battery input'

put /
put ' ' put 'Active' put 'Passive' put 'Active' put 'Passive'  put 'Active' put 'Passive' put 'Active' put 'Passive' put 'Active' put 'Passive' put 'Active' put 'Passive' put 'Active' put 'Passive'

put /
loop (daytype, put daytype.tl put / loop(t, put t.tl loop(i, put Dpd(t,daytype,i)) loop(i, put qwl(t,daytype,i)) loop(i, put qil(t,daytype,i)) loop(i, put ConsumerProfile(t,daytype,i)) loop(i,put Solaroutput(t,i)) loop(i,put qboutl(t,daytype,i)) loop(i,put qbinl(t,daytype,i))
put /)   )
put /


put /
put /
put 'Grid cost recovery check'
put /
put /
put' Total curtailment costs'  put'sunk grid cost' put 'grid investment costs' put 'Minus grid charges'  put 'cost REC CHECK'
put /
put sum(i,consprop(i)*curtcostl(i)) put AL  put (((1-FrF)*OPAggMaxAbs+FrF*CPeakl )*IncrGCL ) put (-cntl *sum((i),ConsProp(i)*qmaxl(i)) )   put CostRECCHECK





put /
;
