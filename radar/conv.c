#include <stdio.h>

int dump(int argc, char **argv) {
	printf("argc=[%d]", argc);
	int i;
	for (i=0; i < argc; i++) printf("[%s]", argv[i]);
	printf("\n");

}

int usage(void) {
	printf("p0x,p0y,q0x,q0y p1x,p1y,q1x,q1y p2x,p2y \n");
	return -1;
}


struct Place {
	double	lat_s;
	double	long_e;
	double	gifx;
	double	gify;
	//char	name[32];
};



// -------------------------
//int	place_getgif(void);

// -------------------------
void	place_dump(struct Place *place){
	if (place==NULL) {
		printf("<NULL>\n");
	} else {
		printf("place:: Map[%f, %f] Gif[%f, %f]\n",
			place-> lat_s, place-> long_e, 
			place-> gifx, place-> gify );
	}
};
// -------------------------
int place_load(int argc, char **argv, struct Place *place) {
	if (place==NULL) return -1;
	if (argc<2) return -2;
	if (sscanf(argv[0], "%lf", &place-> lat_s) <1) return -3;
	if (sscanf(argv[1], "%lf", &place-> long_e) <1) return -4;
	if (argc<4) {
		place-> gifx = 0;
		place-> gify = 0;
	} else  {
		if (sscanf(argv[2], "%lf", &place-> gifx) <1) return -5;
		if (sscanf(argv[3], "%lf", &place-> gify) <1) return -6;
	}
	return 0;
}
// -------------------------
int	place_getmap(struct Place *p0, struct Place *p1, struct Place *p2){
	if ((p0==NULL)||(p1==NULL)||(p2==NULL)) return -1;

	struct Place diff;
	diff.lat_s =  p1-> lat_s  - p0-> lat_s;
	diff.long_e = p1-> long_e - p0-> long_e;
	diff.gifx = p1-> gifx - p0-> gifx;
	diff.gify = p1-> gify - p0-> gify;
	double mult_x = diff.gifx / diff.long_e;
	double mult_y = diff.gify / diff.lat_s;

	//printf("(diff) = "); place_dump(&diff);


	p2-> gifx = ((p2 ->long_e - p0 ->long_e) * mult_x) + p0-> gifx;
	p2-> gify = ((p2 ->lat_s  - p0 ->lat_s ) * mult_y) + p0-> gify;

	//printf("p2 () = "); place_dump(p2);
	printf("%f,%f\n", p2-> gifx, p2-> gify);
	return 0;
}
// -------------------------

int main(int argc, char **argv) {
	//dump(argc, argv);
	if (argc!=11) { return usage(); }
/*
	// p0 = Jugiong
	struct Place p0;
	p0.lat_s = -34.809353;
	p0.long_e = 148.333878;
	p0.gifx = 43.0;
	p0.gify = 78.0;
	//printf("p0 (Jugiong) = "); place_dump(&p0);

	// p1 = Bermagui
	struct Place p1;
	p1.lat_s = -36.439493;
	p1.long_e = 150.060527;
	p1.gifx = 358.0;
	p1.gify = 429.0;
	//printf("p1 (Bermagui) = "); place_dump(&p1);
*/
	struct Place	p0;
	if (place_load(argc-1, &argv[1], &p0) <0) return -1;
	//printf("p0= "); place_dump(&p0);

	struct Place	p1;
	if (place_load(argc-5, &argv[5], &p1) <0) return -1;
	//printf("p1= "); place_dump(&p1);

	struct Place	p2;
	if (place_load(argc-9, &argv[9], &p2) <0) return -1;
	//printf("p2= "); place_dump(&p2);

	// -------------
	return	place_getmap(&p0, &p1, &p2);

}
