unit Unt_Quest2;

{$mode objfpc}{$H+}

interface

Procedure Main;

implementation
 
//uses soil, stones, flower, font, header;
// Earthworm Quest
// A nibbles clone for the ITG challenge at Birdie 17.
// By lft.

uses
//#include <stdio.h>
//#include <string.h>
    math,
    sdl,
   opengl,

// Include the graphics data.

//#include
    unt_soil,
//#include '
    unt_stones,
   unt_flower,
//#include 'font.h'
//#include 'header.h'

// The window dimensions. Must me 4:3.

const WIDTH = 800;
const HEIGHT = 600;

// The playfield.

   board =
	'################'+
	'#..............#'+
	'#..............#'+
	'#..............#'+
	'#..............#'+
	'#.....#........#'+
	'#..............#'+
	'#..............#'+
	'#..............#'+
	'#..............#'+
	'#.......##.....#'+
	'#..............#'+
	'#..............#'+
	'#..............#'+
	'#..............#'+
	'################'
;

// Some parameters that can be adjusted for performance/playability tweaking.

const MAXSEG = 300;
const NPARTICLE = 80;

// Textures.
type
Textures =(
	T_GROUND,
	T_STONES,
	T_FONT,
	T_HEADER,
	T_FLOWER
);

// Data structures to keep track of the worm.

segment = record

	x, z : double;		// [-2, 2]

end;

var
worm : record

	segs:array [0..MAXSEG-1] of segment;
	length : integer;		// [30, MAXSEG]
	growto : integer;		// [30, MAXSEG]
	angle : integer;		// [0, 360]
	speed : double;		// Starts out at .018
	wobblecount : integer;	// A simple up-counter used for animating the worm.
end;

// Data structures to keep track of the explosion animation.

blamparticle :array[0..NPARTICLE-1] of  record

	x, y, z : double;
	dx, dy, dz : double;

end;

// Data structures to keep track of the game status.
var
 foodpos:array[0..1] of double;	// X and Z coordinates, [-2, 2]
growtimer : integer;
score : integer;
gameover : integer;

// OpenGL specific data.

GLUquadric: ^quad;

// Scale the two-dimensional vector v down (or up) to unit length.


procedure normalize2(v : Pdouble);
var
  length : double;
begin

	length := hypot(v[0], v[1]);
	v[0] /= length;
	v[1] /= length;
end;

// Draw a frame, based on current game and animation status.


procedure drawframe();
var
  cx, cy : double;
  h, size : double;
  i, y, x : integer;
  length : double;
  radius : double;
  sz : double;
  wobblex, wobblez, wobble : double;
  eye,direction,lookat:array[0..1] of double;

begin
	GLfloat fv[4];

	// Clear the screen.

	glClearColor(.1, .1, .3, 0);
	glClear(GL_COLOR_BUFFER_BIT  or  GL_DEPTH_BUFFER_BIT);

	// Prepare to draw the ground.

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluPerspective(30, (double) WIDTH / HEIGHT, 1, 200);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	glEnable(GL_DEPTH_TEST);
	glEnable(GL_LIGHTING);
	glEnable(GL_LIGHT0);
	glEnable(GL_NORMALIZE);
	glDisable(GL_CULL_FACE);
	glDisable(GL_BLEND);

	fv[0] = 0;
	fv[1] = 1;
	fv[2] = 1;
	fv[3] = 0;
	glLightfv(GL_LIGHT0, GL_POSITION, fv);
	fv[0] = .5;
	fv[1] = .4;
	fv[2] = .3;
	fv[3] = 0;
	glLightfv(GL_LIGHT0, GL_DIFFUSE, fv);
	fv[0] = .5;
	fv[1] = .5;
	fv[2] = .5;
	fv[3] = 0;
	glLightfv(GL_LIGHT0, GL_SPECULAR, fv);

	direction[0] = worm.segs[4].x - worm.segs[5].x;
	direction[1] = worm.segs[4].z - worm.segs[5].z;
	normalize2(direction);

	eye[0] = worm.segs[4].x - direction[0] * 3;
	eye[1] = worm.segs[4].z - direction[1] * 3;

	lookat[0] = worm.segs[4].x + direction[0] * 3;
	lookat[1] = worm.segs[4].z + direction[1] * 3;

	gluLookAt(eye[0], .8, eye[1], lookat[0], .1, lookat[1], 0, 1, 0);

	// Draw the ground (brown circle and grass above it).

	fv[0] = .2;
	fv[1] = 0;
	fv[2] = 0;
	fv[3] = 0;
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv);
	glDisable(GL_TEXTURE_2D);
	glNormal3d(0, 1, 0);
	glBegin(GL_TRIANGLE_FAN);
	glVertex3d(0, 0, 0);
	for (i := 0; i <= 128; PosInc(i)) do begin
		glVertex3d(5 * cos(i * M_PI * 2 / 128), -.1, 5 * sin(i * M_PI * 2 / 128));
	end;
	glEnd();

	fv[0] = 1;
	fv[1] = 1;
	fv[2] = 1;
	fv[3] = 0;
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv);
	fv[0] = 0;
	fv[1] = 0;
	fv[2] = 0;
	fv[3] = 0;
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, fv);

	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, T_GROUND);

	glNormal3d(0, 1, 0);
	glBegin(GL_QUADS);
	glTexCoord2d(-2, -2);
	glVertex3d(-2, 0, -2);
	glTexCoord2d(+2, -2);
	glVertex3d(+2, 0, -2);
	glTexCoord2d(+2, +2);
	glVertex3d(+2, 0, +2);
	glTexCoord2d(-2, +2);
	glVertex3d(-2, 0, +2);
	glEnd();

	// Draw the blocks of stone.

	h := .06;
	glBindTexture(GL_TEXTURE_2D, T_STONES);
	for (y := 0; y < 16; PosInc(y)) do begin
		for (x := 0; x < 16; PosInc(x)) do begin	// Center of block.	// Size of block (half the length of the side).

			cx := (-7.5 + x) * 2.0 / 8;
			cy := (-7.5 + y) * 2.0 / 8;
			sz := 2.0 / 8 / 2;

			if (board[y * 16 + x]  =  '#') then begin
				glBegin(GL_QUADS);

				fv[0] = 1;
				fv[1] = 1;
				fv[2] = 1;
				fv[3] = 0;
				glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv);
				glNormal3d(0, 1, 0);
				glTexCoord2d(cx - sz, cy - sz);
				glVertex3d(cx - sz, h, cy - sz);
				glTexCoord2d(cx + sz, cy - sz);
				glVertex3d(cx + sz, h, cy - sz);
				glTexCoord2d(cx + sz, cy + sz);
				glVertex3d(cx + sz, h, cy + sz);
				glTexCoord2d(cx - sz, cy + sz);
				glVertex3d(cx - sz, h, cy + sz);

				fv[0] = .5;
				fv[1] = .5;
				fv[2] = .5;
				fv[3] = 0;
				glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv);
				glNormal3d(0, 0, -1);
				glTexCoord2d(cx - sz, cy - sz);
				glVertex3d(cx - sz, h, cy - sz);
				glTexCoord2d(cx + sz, cy - sz);
				glVertex3d(cx + sz, h, cy - sz);
				glTexCoord2d(cx + sz, cy - 2 * sz);
				glVertex3d(cx + sz, 0, cy - sz);
				glTexCoord2d(cx - sz, cy - 2 * sz);
				glVertex3d(cx - sz, 0, cy - sz);

				glNormal3d(0, 0, 1);
				glTexCoord2d(cx + sz, cy + sz);
				glVertex3d(cx + sz, h, cy + sz);
				glTexCoord2d(cx - sz, cy + sz);
				glVertex3d(cx - sz, h, cy + sz);
				glTexCoord2d(cx - sz, cy + 2 * sz);
				glVertex3d(cx - sz, 0, cy + sz);
				glTexCoord2d(cx + sz, cy + 2 * sz);
				glVertex3d(cx + sz, 0, cy + sz);

				glNormal3d(1, 0, 0);
				glTexCoord2d(cx + sz, cy - sz);
				glVertex3d(cx + sz, h, cy - sz);
				glTexCoord2d(cx + sz, cy + sz);
				glVertex3d(cx + sz, h, cy + sz);
				glTexCoord2d(cx + 2 * sz, cy + sz);
				glVertex3d(cx + sz, 0, cy + sz);
				glTexCoord2d(cx + 2 * sz, cy - sz);
				glVertex3d(cx + sz, 0, cy - sz);

				glNormal3d(-1, 0, 0);
				glTexCoord2d(cx - sz, cy + sz);
				glVertex3d(cx - sz, h, cy + sz);
				glTexCoord2d(cx - sz, cy - sz);
				glVertex3d(cx - sz, h, cy - sz);
				glTexCoord2d(cx - 2 * sz, cy - sz);
				glVertex3d(cx - sz, 0, cy - sz);
				glTexCoord2d(cx - 2 * sz, cy + sz);
				glVertex3d(cx - sz, 0, cy + sz);

				glEnd();
			end;
		end;
	end;

	// Draw the earthworm.

	glDisable(GL_TEXTURE_2D);
	glEnable(GL_CULL_FACE);

	fv[0] = .4;
	fv[1] = .3;
	fv[2] = .1;
	fv[3] = 0;
	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv);
	fv[0] = 1;
	fv[1] = 1;
	fv[2] = 1;
	fv[3] = 0;
	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, fv);
	fv[0] = 90;
	glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, fv);

	for (i := 0; i < worm.length; PosInc(i)) do begin
		radius := .04;
		int bevel = 10 + worm.length / 10, bevelsize := worm.length / 30;

		if (i <= 15) then begin
			radius := .02 + .02 * sin(i * M_PI / 2 / 15);
		end; else if (i >= worm.length - 3) then begin
			radius := .02 + .02 * sin((worm.length - i - 1) * M_PI / 2 / 3);
		end;

		if (i >= bevel - bevelsize ) and ( i <= bevel + bevelsize) then radius += 0.01;

		glPushMatrix();
		wobble := .02 * sin((i + worm.wobblecount) * M_PI / 8);
		if (i) then begin

			wobblex := worm.segs[i].x - worm.segs[i - 1].x;
			wobblez := worm.segs[i].z - worm.segs[i - 1].z;
			length := hypot(wobblex, wobblez);
			wobblex /= length;
			wobblez /= length;
		end; else begin

			wobblex := worm.segs[1].x - worm.segs[0].x;
			wobblez := worm.segs[1].z - worm.segs[0].z;
			length := hypot(wobblex, wobblez);
			wobblex /= length;
			wobblez /= length;
		 end;
		wobblex *= wobble;
		wobblez *= wobble;
		glTranslated(worm.segs[i].x + wobblex, .01, worm.segs[i].z + wobblez);
		gluSphere(quad, radius, 8, 8);
		glPopMatrix();
	end;

	// Draw the flower.

	h := .08 * growtimer / 50;
	size := .07 * growtimer / 50;
	glColor3d(.0, .3, .0);
	glDisable(GL_LIGHTING);
	glLineWidth(5);
	glBegin(GL_LINES);
	glVertex3d(foodpos[0], 0, foodpos[1]);
	glVertex3d(foodpos[0], h, foodpos[1]);
	glEnd();
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, T_FLOWER);
	glDisable(GL_CULL_FACE);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glColor3d(1, 1, 1);
	glBegin(GL_TRIANGLE_FAN);
	glTexCoord2d(.5, .5);
	glVertex3d(foodpos[0], h, foodpos[1]);
	for (i := 0; i <= 8; PosInc(i)) do begin
		glTexCoord2d(.5 + .5 * cos(i * M_PI * 2 / 8), .5 + .5 * sin(i * M_PI * 2 / 8));
		glVertex3d(foodpos[0] + size * cos(i * M_PI * 2 / 8), h * 1.1, foodpos[1] + size * sin(i * M_PI * 2 / 8));
	end;
	glEnd();

	// If there should be an explosion, draw it.

	if (gameover) then begin
		glDisable(GL_DEPTH_TEST);
		glEnable(GL_BLEND);
		glBlendFunc(GL_ONE, GL_ONE);
		glEnable(GL_LIGHTING);
		glDisable(GL_TEXTURE_2D);
		fv[0] = .8;
		fv[1] = .3;
		fv[2] = .1;
		fv[3] = 0;
		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv);
		fv[0] = 1;
		fv[1] = .4;
		fv[2] = 0;
		fv[3] = 0;
		glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, fv);
		fv[0] = 90;
		glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, fv);
		for (i := 0; i < NPARTICLE; PosInc(i)) do begin
			glPushMatrix();
			glTranslated(blamparticle[i].x, blamparticle[i].y, blamparticle[i].z);
			gluSphere(quad, .03 + (50 - gameover) * .2 / 50, 8, 8);
			glPopMatrix();
		end;
	end;

	// Draw the {static} image in the upper left corner.

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(-4, +4, -3, +3, -1, 1);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	glDisable(GL_LIGHTING);
	glDisable(GL_DEPTH_TEST);
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_BLEND);
	glBlendFunc(GL_ONE, GL_ONE);
	glDisable(GL_CULL_FACE);
	glColor3d(1, 1, 1);

	glBindTexture(GL_TEXTURE_2D, T_HEADER);
	glBegin(GL_QUADS);
	glTexCoord2d(0, 0);
	glVertex3d(-3.7, 2.6, 0);
	glTexCoord2d(1, 0);
	glVertex3d(1, 2.6, 0);
	glTexCoord2d(1, 1);
	glVertex3d(1, 2.1, 0);
	glTexCoord2d(0, 1);
	glVertex3d(-3.7, 2.1, 0);
	glEnd();

	// Draw the current score.

	glBindTexture(GL_TEXTURE_2D, T_FONT);
	glBegin(GL_QUADS);
	i := score / 10;
	glTexCoord2d((double) i / 10, 0);
	glVertex3d(2.6, 2.7, 0);
	glTexCoord2d((double) (i + .93) / 10, 0);
	glVertex3d(3.2, 2.7, 0);
	glTexCoord2d((double) (i + .93) / 10, 1);
	glVertex3d(3.2, 2.1, 0);
	glTexCoord2d((double) i / 10, 1);
	glVertex3d(2.6, 2.1, 0);
	i := score % 10;
	glTexCoord2d((double) i / 10, 0);
	glVertex3d(3.2, 2.7, 0);
	glTexCoord2d((double) (i + .93) / 10, 0);
	glVertex3d(3.8, 2.7, 0);
	glTexCoord2d((double) (i + .93) / 10, 1);
	glVertex3d(3.8, 2.1, 0);
	glTexCoord2d((double) i / 10, 1);
	glVertex3d(3.2, 2.1, 0);
	glEnd();
end;

// Check whether a given point collides with a stone block or (possibly,
// depending on 'justblocks') by the worm itself. If the point is occupied by
// the worm, the output parameter 'hint' is set to the number of the colliding
// segment.


function isfree(x : double; z : double; justblocks : integer; hint : Pinteger):integer;
var
  dx, dz, dist : double;
  i : integer;
  xblock, zblock : integer;
begin

	if (x <= -2 ) or ( x >= 2 ) or ( z <= -2 ) or ( z >= 2) then exit(0);

	xblock := (x + 2) * 4;
	zblock := (z + 2) * 4;
	if (board[zblock * 16 + xblock]  =  '#') then exit(0);

	if (justblocks) then exit(1);

	for (i := 20; i < worm.length; PosInc(i)) do begin

		dx := x - worm.segs[i].x;
		dz := z - worm.segs[i].z;
		dist := dx * dx + dz * dz;
		if (dist < .01) then begin
			if (hint) then *hint := i;
			exit(0);
		end;
	end;

	exit(1);
end;

// Enter game-over mode and set up the explosion animation.


procedure blam(x : double; z : double);
var
  i : integer;
begin

	gameover := 50;
	for (i := 0; i < NPARTICLE; PosInc(i)) do begin
		blamparticle[i].x := x;
		blamparticle[i].y := .02;
		blamparticle[i].z := z;
		blamparticle[i].dx := (double) ((rand()  and  127) - 64) * .0002;
		blamparticle[i].dy := (double) ((rand()  and  127) - 64) * .0002;
		blamparticle[i].dz := (double) ((rand()  and  127) - 64) * .0002;
	end;
end;

// Place the flower at a random location.


procedure placefood();
begin
	do {
		foodpos[0] = (double) ((rand()  and  16383) - 8192) / 4096;
		foodpos[1] = (double) ((rand()  and  16383) - 8192) / 4096;
	} while(
		 not isfree(foodpos[0], foodpos[1], 0, 0) ) or (
		 not isfree(foodpos[0] + .1, foodpos[1], 0, 0) ) or (
		 not isfree(foodpos[0] - .1, foodpos[1], 0, 0) ) or (
		 not isfree(foodpos[0], foodpos[1] + .1, 0, 0) ) or (
		 not isfree(foodpos[0], foodpos[1] - .1, 0, 0));
	growtimer := 0;
end;

// Reset the game state.


procedure newgame();
var
  i : integer;
begin

	memset(@worm, 0, sizeof(worm));
	worm.length := 30;
	worm.growto := 30;
	worm.speed := 0.018;
	for (i := 0; i < worm.length; PosInc(i)) do begin
		worm.segs[i].x := .5 - worm.speed * i;
		worm.segs[i].z := 0;
	end;
	score := 0;
	placefood();
end;

// Clock the game state machine once.


procedure rungame(rotation : integer; uppressed : integer);
var
  i : integer;
  length, dist : double;
  speed : double;
begin
	double dx, dz, side[2];

	if (gameover) then begin
		// Run the explosion physics.

		for (i := 0; i < NPARTICLE; PosInc(i)) do begin
			blamparticle[i].x += blamparticle[i].dx;
			blamparticle[i].y += blamparticle[i].dy;
			blamparticle[i].z += blamparticle[i].dz;
			if (blamparticle[i].y < .01) then blamparticle[i].y := .01;
			blamparticle[i].dy -= .0005;
		end;
		PosDec(gameover);
		if ( not gameover) then begin
			newgame();
		end;

		// Since we're in game-over state, there's nothing more for rungame() to do.

		return;
	end;

	// Animate the flower and do the worm wobbling.

	if (growtimer < 50) then PosInc(growtimer);
	PosInc(worm.wobblecount);

	// Change the current direction according to user input.

	worm.angle += rotation;

	// Move the worm.

	speed := (uppressed? 1.9 : 1) * worm.speed;
	dx := speed * cos(worm.angle * M_PI / 180);
	dz := speed * sin(worm.angle * M_PI / 180);

	if (worm.growto > worm.length) then PosInc(worm.length);
	for (i := worm.length - 1; i; PosDec(i)) do begin
		Move(@worm.segs[i], @worm.segs[i - 1], sizeof(struct segment));
	end;

	worm.segs[0].x += dx;
	worm.segs[0].z += dz;

	// Check for collisions.

	side[0] = dz;
	side[1] = -dx;
	normalize2(side);
	side[0] *= .04;
	side[1] *= .04;

	if ( not isfree(worm.segs[0].x, worm.segs[0].z, 0, 0)) then begin
		blam(worm.segs[0].x, worm.segs[0].z);
	end; else if ( not isfree(worm.segs[0].x + side[0], worm.segs[0].z + side[1], 1, @i)) then begin
		blam(worm.segs[i].x, worm.segs[i].z);
	end; else if ( not isfree(worm.segs[0].x - side[0], worm.segs[0].z - side[1], 1, @i)) then begin
		blam(worm.segs[i].x, worm.segs[i].z);
	end;

	// Did the worm hit the flower?

	dx := worm.segs[0].x - foodpos[0];
	dz := worm.segs[0].z - foodpos[1];
	dist := dx * dx + dz * dz;
	if (dist < .004) then begin
		// Yes not  Increase score and difficulty.

		PosInc(score);
		if (score > 99) then score := 99;

		worm.growto += 5;
		if (worm.growto > MAXSEG) then worm.growto := MAXSEG;
		worm.speed += .0005;

		placefood();
	end;
end;

// A recurrent timer callback from SDL, which generates an event. The event
// typically causes SDL_WaitEvent in the main loop to return.


function timercallback(interval : TUint32; dummy : Ppointer):TUint32;
var
  event : TSDL_Event;
begin

	event.type := SDL_USEREVENT;
	SDL_PushEvent(@event);

	exit(interval);
end;

// The entry point of the program.


function main(argc : integer; *argv : Pchar):integer;
var
  char r, g, b, a : unsigned;
  event : TSDL_Event;
  fullscreen : integer;
  i, x, y : integer;
begin
	int leftpressed = 0, rightpressed = 0, uppressed = 0, rotation := 0;
	unsigned char buf[64*64*4];
	fullscreen := 0;

	if (argc  =  2 ) and (  not strcmp(argv[1], '-f')) then fullscreen := 1;

	if (SDL_Init(SDL_INIT_TIMER  or  SDL_INIT_VIDEO)) then begin
		err(1, 'SDL_Init');
	end;

	atexit(SDL_Quit);

	if ( not SDL_SetVideoMode(WIDTH, HEIGHT, 16, SDL_HWSURFACE  or  SDL_OPENGL  or  (fullscreen? SDL_FULLSCREEN : 0))) then begin
		err(1, 'SDL_SetVideoMode');
	end;

	SDL_ShowCursor(0);

	// Initiate the game status.

	newgame();

	// Initiate OpenGL and load the textures.

	quad := gluNewQuadric();
	if ( not quad) then err(1, 'gluNewQuadric');
	gluQuadricDrawStyle(quad, GLU_FILL);

	glBindTexture(GL_TEXTURE_2D, T_GROUND);
	gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGB, soil_WIDTH, soil_HEIGHT, GL_RGB, GL_UNSIGNED_BYTE, soil_data);
	glBindTexture(GL_TEXTURE_2D, T_STONES);
	gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGB, stones_WIDTH, stones_HEIGHT, GL_RGB, GL_UNSIGNED_BYTE, stones_data);
	glBindTexture(GL_TEXTURE_2D, T_FONT);
	gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGB, font_WIDTH, font_HEIGHT, GL_RGB, GL_UNSIGNED_BYTE, font_data);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);
	glBindTexture(GL_TEXTURE_2D, T_HEADER);
	gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGB, header_WIDTH, header_HEIGHT, GL_RGB, GL_UNSIGNED_BYTE, header_data);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP);

	// The flower texture needs an alpha component, but the pixel data
	// doesn't contain it. This code creates a local copy of the graphics
	// data, in which every black pixel is transparent.

	for y := 0 to 63 do begin
		for (x := 0; x < 64; PosInc(x)) do begin

			r := flower_data[y * 64 * 3 + x * 3 + 0];
			g := flower_data[y * 64 * 3 + x * 3 + 1];
			b := flower_data[y * 64 * 3 + x * 3 + 2];
			a := 255;
			if (r  =  0 ) and ( g  =  0 ) and ( b  =  0) then a := 0;
			buf[y * 64 * 4 + x * 4 + 0] = r;
			buf[y * 64 * 4 + x * 4 + 1] = g;
			buf[y * 64 * 4 + x * 4 + 2] = b;
			buf[y * 64 * 4 + x * 4 + 3] = a;
		end;
	end;
	glBindTexture(GL_TEXTURE_2D, T_FLOWER);
	gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, 64, 64, GL_RGBA, GL_UNSIGNED_BYTE, buf);

	// Start a recurrent 20 ms timer which will generate SDL_USEREVENT
	// events, which will eventually cause rungame() to be called at 50 Hz.

	SDL_AddTimer(20, timercallback, 0);

	while true do begin

		while (SDL_PollEvent(@event)) do begin
			case (event.type) of
				SDL_USEREVENT: rungame(rotation * 5, uppressed);

				SDL_KEYUP: case (event.key.keysym.sym) of
						SDLK_LEFT:
							leftpressed := 0;
							if (rightpressed) then begin
								rotation := 1;
							end; else begin
								rotation := 0;
							 end;

						SDLK_RIGHT: rightpressed := 0;
							if (leftpressed) then begin
								rotation := -1;
							end; else begin
								rotation := 0;
							 end;

						SDLK_UP: uppressed := 0;

					end;
					break;
				SDL_KEYDOWN: case (event.key.keysym.sym) of
						SDLK_LEFT:
							leftpressed := 1;
							rotation := -1;

						SDLK_RIGHT: rightpressed := 1;
							rotation := 1;

						SDLK_UP: uppressed := 1;

						SDLK_ESCAPE: exit(0);

					end;
					break;
			end;
		end;
		drawframe();
		SDL_GL_SwapBuffers();
	end;

	exit(0);
end;


end.

