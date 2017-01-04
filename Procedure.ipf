#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#include <All IP Procedures>
#include <Image Saver>
#include <FilterDialog> menus=0


function avgcurv(wav1, field)  //take a 2d wave, calculate average wave (squeeze away columns, row=0 to 399)
wave wav1
wave field
variable i=0

	variable numrows = dimsize(wav1,0)
	variable numcols = dimsize(wav1,1)
	
//prepare storage for averaged wave, half of the number of rows of the 2d wave	initialize the storage wave
make/o/n=(numrows/2) wavavg  
wavavg=0


//do average
do

duplicate/o/R=[0,399][i] wav1 tmp1
wavavg=wavavg+tmp1
i=i+1
while(i<5)


wavavg=wavavg/5



//store average into destination wave
string wav1n=nameofwave(wav1)

duplicate/o wavavg $(wav1n+"avg")

duplicate/o/R=[0,399] field field2

display $(wav1n+"avg") vs field2
//setscale

end





function avgcurvb(wav1, field, section)  //take a 2d wave, calculate average wave (squeeze away columns, row=0 to 399)
wave wav1
wave field
variable section
//section=1


variable startp, endp
variable i=0
	variable numrows = dimsize(wav1,0)
	variable numcols = dimsize(wav1,1)
	
//prepare storage for averaged wave, half of the number of rows of the 2d wave	initialize the storage wave
make/o/n=(numrows/2) wavavg  
wavavg=0


if (section==1)
startp=0
endp=399
elseif (section==2)
startp=400
endp=799

endif

//do average
do

duplicate/o/R=[startp,endp][i] wav1 tmp1
wavavg=wavavg+tmp1
i=i+1
while(i<numcols)


wavavg=wavavg/numcols



//store average into destination wave
string wav1n=nameofwave(wav1)

duplicate/o wavavg $(wav1n+"avg")

duplicate/o/R=[startp,endp] field field2

display $(wav1n+"avg") vs field2
//setscale

//getting curvature:
////find center of tmp1
//variable centr
//wavestats $(wav1n+"avg")
//centr=V_minRowLoc
//radius=1
//CurveFit/NTHR=0 poly 3,  $(wav1n+"avg")[centr-radius, centr+radius] /X=field2 /D 
end




function avgcurvc(wav1, field, section)  //take a 2d wave, calculate average wave (squeeze away columns, row=0 to 399)
wave wav1
wave field
variable section
//section=1


variable startp, endp
variable i=0
	variable numrows = dimsize(wav1,0)
	variable numcols = dimsize(wav1,1)
	
//prepare storage for averaged wave, half of the number of rows of the 2d wave	initialize the storage wave
make/o/n=(numrows/2) wavavg  
wavavg=0


if (section==1)
startp=0
endp=numrows/2-1//399
elseif (section==2)
startp=numrows/2//400
endp=numrows-1//799

endif

//do average
do

duplicate/o/R=[startp,endp][i] wav1 tmp1
wavavg=wavavg+tmp1
i=i+1
while(i<numcols)


wavavg=wavavg/numcols



//store average into destination wave
string wav1n=nameofwave(wav1)

duplicate/o wavavg $(wav1n+"avg")

duplicate/o/R=[startp,endp] field field2

display $(wav1n+"avg") vs field2
//setscale

//getting curvature:
////find center of tmp1
variable centr
wavestats/Q $(wav1n+"avg")
centr=V_minRowLoc
variable radius=40   //radius=40 from dat163 to dat145
CurveFit/NTHR=0 poly 3,  $(wav1n+"avg")[centr-radius, centr+radius] /X=field2 /D 




//find D
//wavestats tmp2
variable n2=6.878e16  //density of hb2 at 4K
variable Dtmp=3.65291e9*(1/sqrt(n2))*V_min //calculate D


//find rate
variable ee=1.6e-19, h0=6.63e-34, hbar=h0/(2*pi)
variable rate=(ee*Dtmp/hbar)/( sqrt(  (3*pi*h0/(4*ee*ee))* (2*K2/1e-6)     )    )

print "rate=", rate

end






function avgcurvd(wav1, field, section)  //take a 2d wave, calculate average wave (squeeze away columns, row=0 to 399)
wave wav1
wave field
variable section
//section=1


variable startp, endp
variable i
	variable numrows = dimsize(wav1,0)
	variable numcols = dimsize(wav1,1)
	
//prepare storage for averaged wave, half of the number of rows of the 2d wave	initialize the storage wave
make/o/n=(numrows/2) wavavg  
wavavg=0


if (section==1)
startp=0
endp=numrows/2-1//399
elseif (section==2)
startp=numrows/2//400
endp=numrows-1//799

endif

i=1
//do average
do

duplicate/o/R=[startp,endp][i] wav1 tmp1
wavavg=wavavg+tmp1
i=i+1
while(i<numcols)


wavavg=wavavg/(numcols-1)  //previously(before 6.49142e+10) forgot to change it to numcols-1



//store average into destination wave
string wav1n=nameofwave(wav1)

duplicate/o wavavg $(wav1n+"avg")

duplicate/o/R=[startp,endp] field field2

display $(wav1n+"avg") vs field2
//setscale

//getting curvature:
////find center of tmp1
variable centr
wavestats/Q $(wav1n+"avg")
centr=V_minRowLoc
variable radius=50//40   //radius=40 from dat163 to dat145
CurveFit/NTHR=0 poly 3,  $(wav1n+"avg")[centr-radius, centr+radius] /X=field2 /D 




//find D
//wavestats tmp2
variable n2=6.878e16  //density of hb2 at 4K
variable Dtmp=3.65291e9*(1/sqrt(n2))*V_min //calculate D


//find rate
variable ee=1.6e-19, h0=6.63e-34, hbar=h0/(2*pi)
variable rate=(ee*Dtmp/hbar)/( sqrt(  (3*pi*h0/(4*ee*ee))* (2*K2/1e-6)     )    )

print "rate=", rate

end



function avgcurve(wav1, field, section)  //use Lorentzian fitting to find center, better centering 161225//take a 2d wave, calculate average wave (squeeze away columns, row=0 to 399)
wave wav1
wave field
variable section
//section=1


variable startp, endp
variable i=0
	variable numrows = dimsize(wav1,0)
	variable numcols = dimsize(wav1,1)
	
//prepare storage for averaged wave, half of the number of rows of the 2d wave	initialize the storage wave
make/o/n=(numrows/2) wavavg  
wavavg=0


if (section==1)
startp=0
endp=numrows/2-1//399
elseif (section==2)
startp=numrows/2//400
endp=numrows-1//799

endif

//do average
do

duplicate/o/R=[startp,endp][i] wav1 tmp1
wavavg=wavavg+tmp1
i=i+1
while(i<numcols)


wavavg=wavavg/numcols



//store average into destination wave
string wav1n=nameofwave(wav1)

duplicate/o wavavg $(wav1n+"avg")

duplicate/o/R=[startp,endp] field field2


//setscale

//getting curvature:
////find center of tmp1
make/o/n=4 W_coef
variable centr
wavestats/Q $(wav1n+"avg")
centr=V_minRowLoc
variable cond=V_min //save conductivity at B=0
variable radius=40   //radius=40 from dat163 to dat145



 //do Lorentzian fitting to find center
 duplicate/o $(wav1n+"avg") forc
 display forc vs field2
CurveFit/NTHR=0 lor, forc[centr-radius, centr+radius] /X=field2 /D  

centr=W_coef[2]
//print "new centr:", centr
duplicate/o field2 tmpn

//display tmpn
findlevel tmpn centr

print "new centr:", floor(V_LevelX)

centr=floor(V_LevelX)
 //do Lorentzian fitting to find center
 
 
 
//poly fitting to find curvature
display $(wav1n+"avg") vs field2
CurveFit/NTHR=0 poly 3,  $(wav1n+"avg")[centr-radius, centr+radius] /X=field2 /D 

//find D
//wavestats tmp2
variable n2=6.878e16  //density of hb2 at 4K
variable Dtmp=3.65291e9*(1/sqrt(n2))*cond //calculate D


//find rate
variable ee=1.6e-19, h0=6.63e-34, hbar=h0/(2*pi)
variable rate=(ee*Dtmp/hbar)/( sqrt(  (3*pi*h0/(4*ee*ee))* (2*K2/1e-6)     )    )

print "rate=", rate

end



function avgcurvf(wav1, field, section, radi)  //use Lorentzian fitting to find center, better centering 161225//take a 2d wave, calculate average wave (squeeze away columns, row=0 to 399)
wave wav1
wave field
variable section
variable radi
//section=1


variable startp, endp
variable i=0
	variable numrows = dimsize(wav1,0)
	variable numcols = dimsize(wav1,1)
	
//prepare storage for averaged wave, half of the number of rows of the 2d wave	initialize the storage wave
make/o/n=(numrows/2) wavavg  
wavavg=0


if (section==1)
startp=0
endp=numrows/2-1//399
elseif (section==2)
startp=numrows/2//400
endp=numrows-1//799

endif

i=1
//do average
do

duplicate/o/R=[startp,endp][i] wav1 tmp1
wavavg=wavavg+tmp1
i=i+1
while(i<numcols)


wavavg=wavavg/(numcols-1)



//store average into destination wave
string wav1n=nameofwave(wav1)

duplicate/o wavavg $(wav1n+"avg")

duplicate/o/R=[startp,endp] field field2


//setscale

//getting curvature:
////find center of tmp1
make/o/n=4 W_coef
variable centr
wavestats/Q $(wav1n+"avg")
centr=V_minRowLoc
variable cond=V_min //save conductivity at B=0
variable radius=radi//40   //radius=40 from dat163 to dat145



 //do Lorentzian fitting to find center
 duplicate/o $(wav1n+"avg") forc
 display forc vs field2
CurveFit/NTHR=0 lor, forc[centr-radius, centr+radius] /X=field2 /D  

centr=W_coef[2]
//print "new centr:", centr
duplicate/o field2 tmpn

//display tmpn
findlevel tmpn centr

print "new centr:", floor(V_LevelX)

centr=floor(V_LevelX)
 //do Lorentzian fitting to find center
 
 
 
//poly fitting to find curvature
display $(wav1n+"avg") vs field2
CurveFit/NTHR=0 poly 3,  $(wav1n+"avg")[centr-radius, centr+radius] /X=field2 /D 

//find D
//wavestats tmp2
variable n2=6.878e16  //density of hb2 at 4K
variable Dtmp=3.65291e9*(1/sqrt(n2))*cond //calculate D


//find rate
variable ee=1.6e-19, h0=6.63e-34, hbar=h0/(2*pi)
variable rate=(ee*Dtmp/hbar)/( sqrt(  (3*pi*h0/(4*ee*ee))* (2*K2/1e-6)     )    )

print "rate=", rate

end




function plotwaterfall(wav1, field, section)

wave wav1
wave field
variable section


variable startp, endp
variable i=0
	variable numrows = dimsize(wav1,0)
	variable numcols = dimsize(wav1,1)
	
//prepare storage for averaged wave, half of the number of rows of the 2d wave	initialize the storage wave
//make/o/n=(numrows/2) wavavg  
//wavavg=0


if (section==1)
startp=0
endp=numrows/2-1////99//399
elseif (section==2)
startp=numrows/2//100//400
endp=numrows-1//199//799

endif


//display wav1[startp,endp][0] vs field[startp, endp]; append dat151HB2_cond2d[0,399][1] vs dat151B[0,399]
//      string wv=wav1+"1"  //make sure there is a number followed wave name
//     String cmd
//     sprintf cmd, "DoWindow/K %s; display /N=%s",wv,wv
//     print cmd
//     Execute cmd         
     //sprintf cmd, "display/HOST=%s/N=VsScale/W=(0,0,1,0.5) dat147HB2_cond",wav1
      // Execute cmd



dowindow/K tt
display/N=tt
string tmp2
tmp2=nameofwave(wav1)

do
duplicate/o/R=[startp,endp][i] wav1 $(tmp2+num2str(i))
appendtograph/W=tt $(tmp2+num2str(i)) vs field[startp, endp];
ModifyGraph offset($(tmp2+num2str(i)))={0,i*4e-06}

i=i+1
//print i
while(i<numcols)



end















function getcurvrated(wav1,bp)

string wav1
variable bp
variable centr,radius=40//54
duplicate/o $wav1 tmp1
duplicate/o $wav1 tmp2





//display tmp1

//find center of tmp1
wavestats tmp1
centr=V_minRowLoc



//find center of wave
wave W_coef
CurveFit/NTHR=0 poly 3,  tmp1[centr-radius,centr+radius] /D   //todo: find minimum pnt, minimum pnt+/-radius


print -w_coef[1]/2/w_coef[2];

//center the wave:
setscale/P x,dimoffset( tmp1,0)-( -w_coef[1]/2/w_coef[2]), dimdelta( tmp1,0), tmp2


//find curvature of tmp2
//CurveFit/NTHR=0 poly 3,   tmp2[702,758] /D

CurveFit/NTHR=0 poly 3,   tmp2[centr-radius,centr+radius] /D //todo: find minimum pnt, minimum pnt+/-radius

//find D
wavestats tmp2
variable n2=6.878e16  //density of hb2 at 4K
variable Dtmp=3.65291e9*(1/sqrt(n2))*V_min //calculate D


//display

      string wv=wav1+"1"  //make sure there is a number followed wave name
     String cmd
     sprintf cmd, "DoWindow/K %s; display /N=%s",wv,wv
     print cmd
     Execute cmd         
     //sprintf cmd, "display/HOST=%s/N=VsScale/W=(0,0,1,0.5) dat147HB2_cond",wav1
      // Execute cmd

sprintf cmd, "display/HOST=%s/N=VsScale/W=(0,0,1,0.5) %s",wv, nameofwave(tmp1)
Execute cmd
sprintf cmd, "display/HOST=%s/N=VsScale/W=(0,0.333,1,0.666) %s",wv, nameofwave(tmp2)
Execute cmd


/////////





///////



//find rate
variable ee=1.6e-19, h0=6.63e-34, hbar=h0/(2*pi)
variable rate=(ee*Dtmp/hbar)/( sqrt(  (3*pi*h0/(4*ee*ee))* (2*K2/1e-6)     )    )


print rate
TextBox/C/N=text0/A=MC/X=0/Y=-300 "rate="+num2str(rate);


TextBox/C/N=text1/A=MC/X=0/Y=300 wav1;

//string bp="Bpara=500mT"
//sprintf cmd, "TextBox/C/N=text2/A=MC/X=0/Y=-200 %s" "rate2"
//Execute cmd

TextBox/C/N=text2/A=MC/X=0/Y=-200 "Bpara="+num2str(bp)+"mT"


end






function findcenters(wave1, scale1, wave2, scale2)
wave wave1
wave wave2
wave scale1
wave scale2


//find center for wave1
//duplicate/o wave1 $(nameofwave(wave1)+"ah")
wavestats/Q  wave1//$(nameofwave(wave1)+"ah")
variable centr1=V_minRowLoc
variable radius1=40
make/o/n=4 W_coef
CurveFit/NTHR=0 lor, wave1[centr1-radius1, centr1+radius1] /X=scale1 /D  


centr1=W_coef[2]
//print "new centr:", centr
duplicate/o scale1 tmpn1

//display tmpn
findlevel tmpn1 centr1

print "new centr of wave1:", floor(V_LevelX)

variable center1
center1=floor(V_LevelX)
 //do Lorentzian fitting to find center of wave1





//find center for wave2
//duplicate/o wave1 $(nameofwave(wave1)+"ah")
wavestats/Q  wave2//$(nameofwave(wave1)+"ah")
variable centr2=V_minRowLoc
variable radius2=40
make/o/n=4 W_coef
CurveFit/NTHR=0 lor, wave2[centr2-radius2, centr2+radius2] /X=scale2 /D  


centr2=W_coef[2]
//print "new centr:", centr
duplicate/o scale2 tmpn2

//display tmpn
findlevel tmpn2 centr2

print "new centr of wave2:", floor(V_LevelX)

variable center2
center2=floor(V_LevelX)
 //do Lorentzian fitting to find center of wave2


variable offset=center2-center1
if (offset>0)
make/o/n=(dimsize(wave1,0)-offset)  newwave2

variable i=0
do
newwave2[i]=wave2[i+1]
i=i+1
while(i<dimsize(newwave2,0))


duplicate/o/R=[0, (dimsize(wave1,0)-offset-1)] wave1 newwave1


elseif (offset<0)


make/o/n=(dimsize(wave2,0)-abs(offset))  newwave1

variable j=0
do
newwave1[j]=wave1[j+1]
j=j+1
while(j<dimsize(newwave1,0))


duplicate/o/R=[0, (dimsize(wave2,0)-abs(offset)-1)] wave2 newwave2



else   //offset=0 case

make/o/n=(dimsize(wave2,0)-abs(offset))  newwave1

variable k=0
do
newwave1[k]=wave1[k]
k=k+1
while(k<dimsize(newwave1,0))


duplicate/o/R=[0, (dimsize(wave2,0)-abs(offset)-1)] wave2 newwave2

endif


display newwave1, newwave2

return newwave2  //cause non-stop looping, need to get better understanding of return function of igor. no waves received by this way.
//try use old-fashiond familiar global string-refered wave created during running 
end






function findcentersb(wave1, scale1, wave2, scale2)
wave wave1
wave wave2
wave scale1
wave scale2


//find center for wave1
//duplicate/o wave1 $(nameofwave(wave1)+"ah")
wavestats/Q  wave1//$(nameofwave(wave1)+"ah")
variable centr1=V_minRowLoc
variable radius1=40
make/o/n=4 W_coef
CurveFit/NTHR=0 lor, wave1[centr1-radius1, centr1+radius1] /X=scale1 /D  


centr1=W_coef[2]
//print "new centr:", centr
duplicate/o scale1 tmpn1

//display tmpn
findlevel tmpn1 centr1

print "new centr of wave1:", floor(V_LevelX)

variable center1
center1=floor(V_LevelX)
 //do Lorentzian fitting to find center of wave1





//find center for wave2
//duplicate/o wave1 $(nameofwave(wave1)+"ah")
wavestats/Q  wave2//$(nameofwave(wave1)+"ah")
variable centr2=V_minRowLoc
variable radius2=40
make/o/n=4 W_coef
CurveFit/NTHR=0 lor, wave2[centr2-radius2, centr2+radius2] /X=scale2 /D  


centr2=W_coef[2]
//print "new centr:", centr
duplicate/o scale2 tmpn2

//display tmpn
findlevel tmpn2 centr2

print "new centr of wave2:", floor(V_LevelX)

variable center2
center2=floor(V_LevelX)
 //do Lorentzian fitting to find center of wave2


variable offset=center2-center1
if (offset>=0)
make/o/n=(dimsize(wave1,0)-offset)  newwave2

variable i=0
do
newwave2[i]=wave2[i+1]
i=i+1
while(i<dimsize(newwave2,0))   //need offset=0 case, otherwise routine trying to read out of index range


duplicate/o/R=[0, (dimsize(wave1,0)-offset-1)] wave1 newwave1


else


make/o/n=(dimsize(wave2,0)-abs(offset))  newwave1

variable j=0
do
newwave1[j]=wave1[j+1]
j=j+1
while(j<dimsize(newwave1,0))


duplicate/o/R=[0, (dimsize(wave2,0)-abs(offset)-1)] wave2 newwave2


endif



end





Function DownloadWebPageExample()
	String webPageText = FetchURL("http://www.wavemetrics.com")
	if (numtype(strlen(webPageText)) == 2)
		Print "There was an error while downloading the web page."
	endif
	Variable count, pos
	do
		pos = strsearch(webPageText, "Igor", pos, 2)
		if (pos == -1)
			break			// No more occurrences of "Igor"
		else
			pos += 1
			count += 1
		endif		
	while (1)
	Printf "The text \"Igor\" was found %d times on the web page.\r", count
End


Function WebQueryExample()
	String keywords
	String baseURL = "http://www.google.com/search"
	
	// Prompt the user to enter search keywords.
	Prompt keywords, "Search for"
	DoPrompt "", keywords
	if (V_flag == 1)		// User clicked cancel button.
		return 0
	endif
	
	// Pass the search terms through URLEncode to
	// properly percent-encode them.
	keywords = URLEncode(keywords)
	
	// Build the full URL.
	String url = ""
	sprintf url, "%s?q=%s", baseURL, keywords
	
	// Fetch the results.
	String response
	response = FetchURL(url)
	//print response
	Variable error = GetRTError(1)
	if (error != 0 || numtype(strlen(response)) != 0)
		Print "Error fetching search results."
		return -1
	endif
	
	// Try to extract the URL of the first result.
	String regExp = "<h3 class=\"r\">.+?href=\"(.+?)\".*"
	String firstURL
	SplitString/E=regExp response, firstURL
	print firstURL
	if (V_flag == 1)
		BrowseURL firstURL
	else
		Print "Could not extract the first result from the"
		Print "results page. Your search terms might not"
		Print "have given any results, or the format of"
		Print "the results may have changed so that the"
		Print "first result cannot be extracted."
	endif
End





function testcsrwave()


Wave yWave=CsrWaveRef(A)  //get waveref at cursor A //how to make 'A' an input variable? A is not a string here

Wave xWave=CsrXWaveRef(A) //get waveref at cursor A

variable isXY

isXY=WaveExists(xWave) //check whether it is a xy pair




if (isXY)
display yWave vs xWave
else
display yWave

endif


end




function testcsrwaveb(whichcursor)  //print fit_wave is already internally-scaled, not xy pair anymore, just append it, no need to search for its x pair

variable whichcursor

print "put target graph on top first, using 'dowindow/F'"

dowindow/F Graph1

if (whichcursor==1)

Wave yWave=CsrWaveRef(A)  //get waveref at cursor A //how to make 'A' an input variable? A is not a string here

Wave xWave=CsrXWaveRef(A) //get waveref at cursor A


else

//duplicate/o yWave yWave
//KillWaves yWave
//KillWaves xWave
//print "B"
Wave yWave=CsrWaveRef(B)  //get waveref at cursor A //how to make 'A' an input variable? A is not a string here

Wave xWave=CsrXWaveRef(B) //get waveref at cursor A

endif




variable isXY

isXY=WaveExists(xWave) //check whether it is a xy pair




if (isXY)
display yWave vs xWave
else
display yWave

endif


end





function avgcurve2(wav1, field, section)  //use Lorentzian fitting to find center, better centering 161225//take a 2d wave, calculate average wave (squeeze away columns, row=0 to 399)
wave wav1
wave field
variable section
//section=1


variable startp, endp
variable i=0
	variable numrows = dimsize(wav1,0)
	variable numcols = dimsize(wav1,1)
	
//prepare storage for averaged wave, half of the number of rows of the 2d wave	initialize the storage wave
make/o/n=(numrows/2) wavavg  
wavavg=0


if (section==1)
startp=0
endp=numrows/2-1//399
elseif (section==2)
startp=numrows/2//400
endp=numrows-1//799

endif

//do average
do

duplicate/o/R=[startp,endp][i] wav1 tmp1
wavavg=wavavg+tmp1
i=i+1
while(i<numcols)


wavavg=wavavg/numcols



//store average into destination wave
string wav1n=nameofwave(wav1)

duplicate/o wavavg $(wav1n+"avg")

duplicate/o/R=[startp,endp] field field2


//setscale

//getting curvature:
////find center of tmp1
make/o/n=4 W_coef
variable centr
wavestats/Q $(wav1n+"avg")
centr=V_minRowLoc
variable cond=V_min //save conductivity at B=0
variable radius=200   //radius=40 from dat163 to dat145



 //do Lorentzian fitting to find center
 duplicate/o $(wav1n+"avg") forc
 display forc vs field2
CurveFit/NTHR=0 lor, forc[centr-radius, centr+radius] /X=field2 /D  

centr=W_coef[2]
//print "new centr:", centr
duplicate/o field2 tmpn

//display tmpn
findlevel tmpn centr

print "new centr:", floor(V_LevelX)

centr=floor(V_LevelX)
 //do Lorentzian fitting to find center
 
 
 
//poly fitting to find curvature
display $(wav1n+"avg") vs field2
CurveFit/NTHR=0 poly 3,  $(wav1n+"avg")[centr-radius, centr+radius] /X=field2 /D 

//find D
//wavestats tmp2
variable n2=6.878e16  //density of hb2 at 4K
variable Dtmp=3.65291e9*(1/sqrt(n2))*cond //calculate D


//find rate
variable ee=1.6e-19, h0=6.63e-34, hbar=h0/(2*pi)
variable rate=(ee*Dtmp/hbar)/( sqrt(  (3*pi*h0/(4*ee*ee))* (2*K2/1e-6)     )    )

print "rate=", rate

end


