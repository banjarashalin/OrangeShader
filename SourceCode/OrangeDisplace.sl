/* Function to calculate the surface displacement for an orange surface */

displacement OrangeDisplace (
	float Km = 0.12;
	string space="object";
	float trueDisp=1;)
{

/*Declaring Variables and intializing variables*/
	vector NN = normalize(N);
	point PP = transform("shader",P);
    float mag=0;	// Final Magnitude for Displacement...
	float mag1=0;	// Final Magnitude for creating big Pores...
	float mag2=0;	// Final Magnitude for creating minute Pores...
	float mag3=0;	// Final Magnitude for creating minute cellular surface pattern...
	float mag4=0;	// Final Magnitude for creating overall deformation of the surface...
	float mag5=0;	// Final Magnitude for creating larger cellular surface pattern..
	float mag6=0;	// Final Magnitude for creating Top Dent...
	float mag7=0;	// Final Magnitude for creating Top and Bottom Creases...
	float mag8=0;	// Final Magnitude for creating Bottom Dent...

/* Declaring Variables for creating surface pattern and overall surface deformation */

	float freq=1;
	float freq1=1; 
	float i=0;
	float t_mag;
	float inSpot=0;
	float disp=0;

/* Declaring Variables for creating Big Pores on the surface */

		float p_dist;
		float p_inDisk;
		float p_ss;
		float p_tt;
		point p_centre;
		point p_here;



/* Calculate Big Pores on the Surface */
if (t>0.09)
{
	p_ss=mod(s*80+(0.8*noise(PP)),1);
	p_tt=mod(t*80+(0.8*noise(PP)),1);
    p_centre=point (0.5,0.5,0);
	p_here=point(p_ss,p_tt,0);
    p_dist=distance(p_centre,p_here)+(0.15*(noise(PP*25)/0.2));
    p_inDisk=1-smoothstep(-0.01,(0.2*noise(PP))+0.5,p_dist);
    mag1=mix(0,1,p_inDisk);  
	mag1 /= length(vtransform("object",NN));
}
else
{
mag1=0;
}

/* Calculate minute pores on the surface */

	for(i=0;i<6;i+=1)
        {
		mag2+=abs(float noise(PP*freq)-0.5)*2/freq*freq;
        freq*=3;
		}
	mag2 /= length(vtransform("object",NN));

/* Calculate the minute cellular surface pattern */

	t_mag=0;
	t_mag=mix(0,0.4,float noise(PP*85));
	inSpot=smoothstep(0.3-0.3,0.7+0.3,t_mag);
	disp=smoothstep(0,1.25,inSpot);
	mag3=disp;

/* Calculate the larger cellular surface pattern */

	t_mag=0;
	t_mag=mix(0,0.4,float noise(PP*30));
	inSpot=smoothstep(0.3-0.3,0.7+0.3,t_mag);
	disp=smoothstep(0,1.85,inSpot);
	mag5=disp;


/* Calculate the overall deformation of the object */

    for(i=0;i<6;i+=1)
        {
		mag4+=abs(float noise(PP*freq1)-0.5)*2/freq1;
        freq1*=1.25;
		}
	mag4 /= length(vtransform("object",NN));


/* Calculating the top dent */

	float Top = smoothstep(0.008,0.0095+0.015,t);
	mag6 = mix(0,1,Top);

/* Calculating the bottom dent */

	float Bottom = smoothstep(0.999-0.015,0.999,t);
	mag8 = mix(0,1,Bottom);



/* Calculate top and bottom creases of the surface */

    float dist;
    float inDisk;
    float ss=mod(s*12,1);
    float tt=mod((1-t)*2,1);
    point centre=point (0.5,0.5,0);
    point here=point (ss,tt,0);
    dist=distance(centre,here);
    inDisk=1-smoothstep(0.1-0.2,0.3+0.25+(noise(PP*25)/5),dist);
    mag7=mix(0,-1,inDisk)-mix(noise(PP*5),-2,Top)*t;


/* Calculate final Magnitude */

mag=(mag1*-0.02)+(mag2*-0.0080)+(mag3*-0.055)+(mag4*0.2)+(mag5*-0.2)+(mag6*0.15)+(mag7*-0.1)+(mag8*-0.15);


/* Assigning the final displacement value the points */

	PP = P+(mag)*Km*NN;
    N=calculatenormal(PP);
    if(trueDisp==1)
	P=PP;
}

