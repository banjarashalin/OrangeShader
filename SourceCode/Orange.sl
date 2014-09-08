/* Function to calculate the surface shading for an orange surface */

surface Orange (
		float Ka = 0.65;	// Ambience Contribution 
 		float Kd = 0.8;		// Diffuse Contribution
		float Ks = 0.8;		// Specular Contribution
		float Kr = 0.05;	// Reflection Contribution
		float roughness = 0.05;
		color specularcolor = 1;)
{
/* Declaring and Initializing Variables */
    normal Nf = faceforward (normalize(N),I);
    vector V = -normalize(I);
 	color Ct;
	color red= color "rgb" (0.8,0.4,0);
 	color orange =color "rgb" (1,0.5,0);
	color green=color "rgb" (0.6,0.6,0);;
    color inSpot;
	point PP = transform("shader",P);

/* Blending orange green colour for the surface */

    float mag =float noise(PP*0.985);
	inSpot=smoothstep(0.39-0.3,0.4+0.3,mag);
    Ct=mix(green,orange,inSpot);

/* Calculating Circular spot patterns on the orange surface */

if (t>0.09)
{
	float p_ss=mod(s*80+(0.82*noise(PP)),1);
	float p_tt=mod(t*80+(0.82*noise(PP)),1);
    point p_centre=point (0.5,0.5,0);
	point p_here=point(p_ss,p_tt,0);
    float p_dist=distance(p_centre,p_here)+(0.15*(noise(PP*25)/0.2));
    float p_inDisk=1-smoothstep(-0.01,(0.2*noise(PP*0.05))+0.5,p_dist);
    Ct=mix(Ct,red,p_inDisk); 
}


/* Calculating enviornment rection on the surface */

    vector Rcurrent=reflect(I,Nf);
    vector Rworld=vtransform("world",Rcurrent);
    color Cr=color environment("studio.tx",Rworld);

/* Assigning final Colour value by the Default(Plastic Illumination) Renderman BRDF Model */

    Oi = Os;
    Ci = Oi * ( Ct * (Ka*ambient() + Kd*diffuse(Nf)) +
		specularcolor * Ks*specular(Nf,V,roughness)+ Kr*Cr);
}



