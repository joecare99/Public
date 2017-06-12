// Earthworm Quest
// A nibbles clone for the ITG challenge at Birdie 17.
// By lft.

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <err.h>
#include <SDL/SDL.h>
#include <SDL/SDL_opengl.h>

// Include the graphics data.

#include 'soil.h'
#include 'stones.h'
#include 'flower.h'
#include 'font.h'
#include 'header.h'

// The window dimensions. Must me 4:3.

#define WIDTH 800
#define HEIGHT 600

// The playfield.

char board[] := 
	'################'
	'#..............#'
	'#..............#'
	'#..............#'
	'#..............#'
	'#.....#........#'
	'#..............#'
	'#..............#'
	'#..............#'
	'#..............#'
	'#.......##.....#'
	'#..............#'
	'#..............#'
	'#..............#'
	'#..............#'
	'################'
;


// Some parameters that can be adjusted for performance/playability tweaking.

#define MAXSEG 300
#define NPARTICLE 80

// Textures.

enum begin
 
	T_GROUND,
	T_STONES,
	T_FONT,
	T_HEADER,
	T_FLOWER
end;
 ;


// Data structures to keep track of the worm.

struct segment begin

	Doubledouble		x, z ;
		// [-2, 2]
end;
 ;


struct worm begin

	struct segment	segs[MAXSEG] ;

	Integerint		length ;
		// [30, MAXSEG]
	Integerint		growto ;
		// [30, MAXSEG]
	Integerint		angle ;
		// [0, 360]
	Doubledouble		speed ;
		// Starts out at .018
	Integerint		wobblecount ;
	// A simple up-counter used for animating the worm.
end;
 worm ;


// Data structures to keep track of the explosion animation.

struct blamparticle begin
 
	Doubledouble		x, y, z ;

	Doubledouble		dx, dy, dz ;

end;
 blamparticle[NPARTICLE] ;


// Data structures to keep track of the game status.

Doubledouble foodpos[2] ;
	// X and Z coordinates, [-2, 2]
Integerint growtimer ;

Integerint score ;

Integerint gameover ;


// OpenGL specific data.

GLUquadric *quad ;


// Scale the two-dimensional vector v down (or up) to unit length.

void normalize2(Doubledouble *v) begin
 
	Doubledouble length ;


	length := hypot(v[0], v[1]) ;

	v[0] / := length ;

	v[1] / := length ;

end;
 

// Draw a frame, based on current game and animation status.

void drawframe() begin
 
	Integerint i, y, x ;

	GLfloat fv[4] ;

	Doubledouble h, size ;

	Doubledouble eye[2], direction[2], lookat[2] ;

	Doubledouble length ;


	// Clear the screen.

	glClearColor(.1, .1, .3, 0) ;

	glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT) ;


	// Prepare to draw the ground.

	glMatrixMode(GL_PROJECTION) ;

	glLoadIdentity() ;

	gluPerspective(30, (Doubledouble) WIDTH / HEIGHT, 1, 200) ;

	glMatrixMode(GL_MODELVIEW) ;

	glLoadIdentity() ;


	glEnable(GL_DEPTH_TEST) ;

	glEnable(GL_LIGHTING) ;

	glEnable(GL_LIGHT0) ;

	glEnable(GL_NORMALIZE) ;

	glDisable(GL_CULL_FACE) ;

	glDisable(GL_BLEND) ;


	fv[0] := 0 ;

	fv[1] := 1 ;

	fv[2] := 1 ;

	fv[3] := 0 ;

	glLightfv(GL_LIGHT0, GL_POSITION, fv) ;

	fv[0] := .5 ;

	fv[1] := .4 ;

	fv[2] := .3 ;

	fv[3] := 0 ;

	glLightfv(GL_LIGHT0, GL_DIFFUSE, fv) ;

	fv[0] := .5 ;

	fv[1] := .5 ;

	fv[2] := .5 ;

	fv[3] := 0 ;

	glLightfv(GL_LIGHT0, GL_SPECULAR, fv) ;


	direction[0] := worm.segs[4].x - worm.segs[5].x ;

	direction[1] := worm.segs[4].z - worm.segs[5].z ;

	normalize2(direction) ;


	eye[0] := worm.segs[4].x - direction[0] * 3 ;

	eye[1] := worm.segs[4].z - direction[1] * 3 ;


	lookat[0] := worm.segs[4].x + direction[0] * 3 ;

	lookat[1] := worm.segs[4].z + direction[1] * 3 ;


	gluLookAt(eye[0], .8, eye[1], lookat[0], .1, lookat[1], 0, 1, 0) ;


	// Draw the ground (brown circle and grass above it).

	fv[0] := .2 ;

	fv[1] := 0 ;

	fv[2] := 0 ;

	fv[3] := 0 ;

	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv) ;

	glDisable(GL_TEXTURE_2D) ;

	glNormal3d(0, 1, 0) ;

	glBegin(GL_TRIANGLE_FAN) ;

	glVertex3d(0, 0, 0) ;

	while {for}
 (i := 0 ;
 i <= 128 ;
 i++) do begin
 begin
 
		glVertex3d(5 * cos(i * M_PI * 2 / 128), -.1, 5 * sin(i * M_PI * 2 / 128)) ;

	end;
 
	glEnd() ;


	fv[0] := 1 ;

	fv[1] := 1 ;

	fv[2] := 1 ;

	fv[3] := 0 ;

	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv) ;

	fv[0] := 0 ;

	fv[1] := 0 ;

	fv[2] := 0 ;

	fv[3] := 0 ;

	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, fv) ;


	glEnable(GL_TEXTURE_2D) ;

	glBindTexture(GL_TEXTURE_2D, T_GROUND) ;


	glNormal3d(0, 1, 0) ;

	glBegin(GL_QUADS) ;

	glTexCoord2d(-2, -2) ;

	glVertex3d(-2, 0, -2) ;

	glTexCoord2d(+2, -2) ;

	glVertex3d(+2, 0, -2) ;

	glTexCoord2d(+2, +2) ;

	glVertex3d(+2, 0, +2) ;

	glTexCoord2d(-2, +2) ;

	glVertex3d(-2, 0, +2) ;

	glEnd() ;


	// Draw the blocks of stone.

	h := .06 ;

	glBindTexture(GL_TEXTURE_2D, T_STONES) ;

	while {for}
(y := 0 ;
 y < 16 ;
 y++) do begin
 begin
 
		while {for}
 (x := 0 ;
 x < 16 ;
 x++) do begin
 begin

			Doubledouble cx, cy ;
	// Center of block.
			Doubledouble sz ;
	// Size of block (half the length of the side).

			cx := (-7.5 + x) * 2.0 / 8 ;

			cy := (-7.5 + y) * 2.0 / 8 ;

			sz := 2.0 / 8 / 2 ;


			if (board[y * 16 + x] = '#') then
 begin
 
				glBegin(GL_QUADS) ;


				fv[0] := 1 ;

				fv[1] := 1 ;

				fv[2] := 1 ;

				fv[3] := 0 ;

				glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv) ;

				glNormal3d(0, 1, 0) ;

				glTexCoord2d(cx - sz, cy - sz) ;

				glVertex3d(cx - sz, h, cy - sz) ;

				glTexCoord2d(cx + sz, cy - sz) ;

				glVertex3d(cx + sz, h, cy - sz) ;

				glTexCoord2d(cx + sz, cy + sz) ;

				glVertex3d(cx + sz, h, cy + sz) ;

				glTexCoord2d(cx - sz, cy + sz) ;

				glVertex3d(cx - sz, h, cy + sz) ;


				fv[0] := .5 ;

				fv[1] := .5 ;

				fv[2] := .5 ;

				fv[3] := 0 ;

				glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv) ;

				glNormal3d(0, 0, -1) ;

				glTexCoord2d(cx - sz, cy - sz) ;

				glVertex3d(cx - sz, h, cy - sz) ;

				glTexCoord2d(cx + sz, cy - sz) ;

				glVertex3d(cx + sz, h, cy - sz) ;

				glTexCoord2d(cx + sz, cy - 2 * sz) ;

				glVertex3d(cx + sz, 0, cy - sz) ;

				glTexCoord2d(cx - sz, cy - 2 * sz) ;

				glVertex3d(cx - sz, 0, cy - sz) ;


				glNormal3d(0, 0, 1) ;

				glTexCoord2d(cx + sz, cy + sz) ;

				glVertex3d(cx + sz, h, cy + sz) ;

				glTexCoord2d(cx - sz, cy + sz) ;

				glVertex3d(cx - sz, h, cy + sz) ;

				glTexCoord2d(cx - sz, cy + 2 * sz) ;

				glVertex3d(cx - sz, 0, cy + sz) ;

				glTexCoord2d(cx + sz, cy + 2 * sz) ;

				glVertex3d(cx + sz, 0, cy + sz) ;


				glNormal3d(1, 0, 0) ;

				glTexCoord2d(cx + sz, cy - sz) ;

				glVertex3d(cx + sz, h, cy - sz) ;

				glTexCoord2d(cx + sz, cy + sz) ;

				glVertex3d(cx + sz, h, cy + sz) ;

				glTexCoord2d(cx + 2 * sz, cy + sz) ;

				glVertex3d(cx + sz, 0, cy + sz) ;

				glTexCoord2d(cx + 2 * sz, cy - sz) ;

				glVertex3d(cx + sz, 0, cy - sz) ;


				glNormal3d(-1, 0, 0) ;

				glTexCoord2d(cx - sz, cy + sz) ;

				glVertex3d(cx - sz, h, cy + sz) ;

				glTexCoord2d(cx - sz, cy - sz) ;

				glVertex3d(cx - sz, h, cy - sz) ;

				glTexCoord2d(cx - 2 * sz, cy - sz) ;

				glVertex3d(cx - sz, 0, cy - sz) ;

				glTexCoord2d(cx - 2 * sz, cy + sz) ;

				glVertex3d(cx - sz, 0, cy + sz) ;


				glEnd() ;

			end;
 
		end;
 
	end;
 

	// Draw the earthworm.

	glDisable(GL_TEXTURE_2D) ;

	glEnable(GL_CULL_FACE) ;


	fv[0] := .4 ;

	fv[1] := .3 ;

	fv[2] := .1 ;

	fv[3] := 0 ;

	glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv) ;

	fv[0] := 1 ;

	fv[1] := 1 ;

	fv[2] := 1 ;

	fv[3] := 0 ;

	glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, fv) ;

	fv[0] := 90 ;

	glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, fv) ;


	while {for}
(i := 0 ;
 i < worm.length ;
 i++) do begin
 begin
 
		Doubledouble radius := .04 ;

		Integerint bevel := 10 + worm.length / 10, bevelsize := worm.length / 30 ;

		Doubledouble wobblex, wobblez, wobble ;

		
		if (i <= 15) then
 begin
 
			radius := .02 + .02 * sin(i * M_PI / 2 / 15) ;

		end
  else if (i  >= worm.length - 3) then
 begin
 
			radius  := .02 + .02 * sin((worm.length - i - 1) * M_PI / 2 / 3) ;

		end;
 

		if (i  >= bevel - bevelsize  and i  <= bevel + bevelsize) then
 radius  := radius + ( 0.01 );


		glPushMatrix() ;

		wobble  := .02 * sin((i + worm.wobblecount) * M_PI / 8) ;

		if(i) then
 begin
 
			Doubledouble length ;


			wobblex  := worm.segs[i].x - worm.segs[i - 1].x ;

			wobblez  := worm.segs[i].z - worm.segs[i - 1].z ;

			length  := hypot(wobblex, wobblez) ;

			wobblex /:= length ;

			wobblez /:= length ;

		end
  else  begin
 
			Doubledouble length ;


			wobblex  := worm.segs[1].x - worm.segs[0].x ;

			wobblez  := worm.segs[1].z - worm.segs[0].z ;

			length  := hypot(wobblex, wobblez) ;

			wobblex / := length ;

			wobblez / := length ;

		end;

		wobblex * := wobble ;

		wobblez * := wobble ;

		glTranslated(worm.segs[i].x + wobblex, .01, worm.segs[i].z + wobblez) ;

		gluSphere(quad, radius, 8, 8);

		glPopMatrix() ;

	 end;
 

	// Draw the flower.

	h := .08 * growtimer / 50;

	size  := .07 * growtimer / 50;

	glColor3d(.0, .3, .0) ;

	glDisable(GL_LIGHTING) ;

	glLineWidth(5) ;

	glBegin(GL_LINES) ;

	glVertex3d(foodpos[0], 0, foodpos[1]) ;

	glVertex3d(foodpos[0], h, foodpos[1]) ;

	glEnd() ;

	glEnable(GL_TEXTURE_2D) ;

	glBindTexture(GL_TEXTURE_2D, T_FLOWER) ;

	glDisable(GL_CULL_FACE) ;

	glEnable(GL_BLEND) ;

	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA) ;

	glColor3d(1, 1, 1);

	glBegin(GL_TRIANGLE_FAN) ;

	glTexCoord2d(.5, .5) ;

	glVertex3d(foodpos[0], h, foodpos[1]) ;

	 while {for}
 (i  := 0 ;
 i <= 8 ;
 i++) do begin
  begin
 
		glTexCoord2d(.5 + .5 * cos(i * M_PI * 2 / 8), .5 + .5 * sin(i * M_PI * 2 / 8)) ;

		glVertex3d(foodpos[0] + size * cos(i * M_PI * 2 / 8), h * 1.1, foodpos[1] + size * sin(i * M_PI * 2 / 8)) ;

	 end;
 
	glEnd() ;


	// If there should be an explosion, draw it.

	if (gameover) then
  begin
 
		glDisable(GL_DEPTH_TEST) ;

		glEnable(GL_BLEND) ;

		glBlendFunc(GL_ONE, GL_ONE) ;

		glEnable(GL_LIGHTING) ;

		glDisable(GL_TEXTURE_2D) ;

		fv[0]  := .8;

		fv[1]  := .3;

		fv[2]  := .1;

		fv[3]  := 0 ;

		glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT_AND_DIFFUSE, fv) ;

		fv[0]  := 1 ;

		fv[1]  := .4;

		fv[2]  := 0 ;

		fv[3]  := 0 ;

		glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, fv) ;

		fv[0]  := 90;

		glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, fv) ;

		while {for}
 (i  := 0 ;
 i < NPARTICLE ;
 i++) do begin
  begin
 
			glPushMatrix() ;

			glTranslated(blamparticle[i].x, blamparticle[i].y, blamparticle[i].z) ;

			gluSphere(quad, .03 + (50 - gameover) * .2 / 50, 8, 8);

			glPopMatrix() ;

		end;
 
	 end;
 

	// Draw the static image in the upper left corner.

	glMatrixMode(GL_PROJECTION) ;

	glLoadIdentity() ;

	glOrtho(-4, +4, -3, +3, -1, 1);

	glMatrixMode(GL_MODELVIEW) ;

	glLoadIdentity() ;


	glDisable(GL_LIGHTING) ;

	glDisable(GL_DEPTH_TEST) ;

	glEnable(GL_TEXTURE_2D) ;

	glEnable(GL_BLEND) ;

	glBlendFunc(GL_ONE, GL_ONE) ;

	glDisable(GL_CULL_FACE) ;

	glColor3d(1, 1, 1);


	glBindTexture(GL_TEXTURE_2D, T_HEADER) ;

	glBegin(GL_QUADS) ;

	glTexCoord2d(0, 0);

	glVertex3d(-3.7, 2.6, 0);

	glTexCoord2d(1, 0);

	glVertex3d(1, 2.6, 0);

	glTexCoord2d(1, 1);

	glVertex3d(1, 2.1, 0);

	glTexCoord2d(0, 1);

	glVertex3d(-3.7, 2.1, 0);

	glEnd() ;


	// Draw the current score.

	glBindTexture(GL_TEXTURE_2D, T_FONT) ;

	glBegin(GL_QUADS) ;

	i := score / 10;

	glTexCoord2d((Doubledouble) i / 10, 0);

	glVertex3d(2.6, 2.7, 0);

	glTexCoord2d((Doubledouble) (i + .93) / 10, 0);

	glVertex3d(3.2, 2.7, 0);

	glTexCoord2d((Doubledouble) (i + .93) / 10, 1);

	glVertex3d(3.2, 2.1, 0);

	glTexCoord2d((Doubledouble) i / 10, 1);

	glVertex3d(2.6, 2.1, 0);

	i := score  mod 10;

	glTexCoord2d((Doubledouble) i / 10, 0);

	glVertex3d(3.2, 2.7, 0);

	glTexCoord2d((Doubledouble) (i + .93) / 10, 0);

	glVertex3d(3.8, 2.7, 0);

	glTexCoord2d((Doubledouble) (i + .93) / 10, 1);

	glVertex3d(3.8, 2.1, 0);

	glTexCoord2d((Doubledouble) i / 10, 1);

	glVertex3d(3.2, 2.1, 0);

	glEnd() ;

end;
 

// Check whether a given point collides with a stone block or (possibly,
// depending on "justblocks") by the worm itself. If the point is occupied by
// the worm, the output parameter "hint" is set to the number of the colliding
// segment.

Integerint isfree(Doubledouble x, Doubledouble z, Integerint justblocks, Integerint *hint)  begin
 
	Integerint xblock, zblock ;

	Integerint i ;


	if (x  <= -2  or x >= 2 or z <= -2  or z >= 2)then
 {$message 'C2PAS: Exit'} Exit( 0 ) ;


	xblock  := (x + 2) * 4 ;

	zblock  := (z + 2) * 4 ;

	if(board[zblock * 16 + xblock] = '#') then
 {$message 'C2PAS: Exit'} Exit( 0 ) ;


	if (justblocks) then
 {$message 'C2PAS: Exit'} Exit( 1 ) ;


	 while {for}
 (i  := 20;
 i < worm.length ;
 i++) do begin
  begin
 
		Doubledouble dx, dz, dist ;


		dx  := x - worm.segs[i].x ;

		dz  := z - worm.segs[i].z ;

		dist  := dx * dx + dz * dz;

		if (dist < .01) then
  begin
 
			if (hint) then
 *hint  := i ;

			{$message 'C2PAS: Exit'} Exit( 0 ) ;

		end;

	 end;
 

	{$message 'C2PAS: Exit'} Exit( 1 ) ;

end;
 

// Enter game-over mode and set up the explosion animation.

void blam(Doubledouble x, Doubledouble z)  begin
 
	Integerint i ;


	gameover  := 50;

	 while {for}
 (i  := 0 ;
 i < NPARTICLE ;
 i++) do begin
  begin
 
		blamparticle[i].x  := x ;

		blamparticle[i].y  := .02 ;

		blamparticle[i].z  := z ;

		blamparticle[i].dx  := (Doubledouble) ((random(MaxInt)  and 127) - 64) * .0002 ;

		blamparticle[i].dy  := (Doubledouble) ((random(MaxInt)  and 127) - 64) * .0002 ;

		blamparticle[i].dz  := (Doubledouble) ((random(MaxInt)  and 127) - 64) * .0002 ;

	 end;
 
end;
 

// Place the flower at a random location.

void placefood()  begin
 
	 repeatdo  begin
 
		foodpos[0]  := (Doubledouble) ((random(MaxInt)  and 16383) - 8192) / 4096 ;

		foodpos[1]  := (Doubledouble) ((random(MaxInt)  and 16383) - 8192) / 4096 ;

	 end;
 while (
		not isfree(foodpos[0], foodpos[1], 0, 0)  or 
		not isfree(foodpos[0] + .1, foodpos[1], 0, 0)  or 
		not isfree(foodpos[0] - .1, foodpos[1], 0, 0)  or 
		not isfree(foodpos[0], foodpos[1] + .1, 0, 0)  or
		not isfree(foodpos[0], foodpos[1] - .1, 0, 0)) do
  ;

	growtimer  := 0 ;

end;
 

// Reset the game state.

void newgame()  begin
 
	Integerint i ;


	memset({$message 'C2PAS: Ref'}@worm, 0, sizeof(worm)) ;

	worm.length  := 30;

	worm.growto  := 30;

	worm.speed  := 0.018 ;

	 while {for}
 (i  := 0 ;
 i < worm.length ;
 i++) do begin
  begin
 
		worm.segs[i].x  := .5 - worm.speed * i ;

		worm.segs[i].z  := 0 ;

	 end;
 
	score  := 0 ;

	placefood() ;

end;
 

// Clock the game state machine once.

void rungame(Integerint rotation, Integerint uppressed)  begin
 
	Doubledouble dx, dz, side[2] ;

	Doubledouble speed ;

	Doubledouble length, dist ;

	Integerint i ;


	if (gameover) then
  begin
 
		// Run the explosion physics.

		while {for}
(i  := 0 ;
 i < NPARTICLE ;
 i++) do begin
  begin
 
			blamparticle[i].x  := x + ( blamparticle[i].dx ) ;

			blamparticle[i].y  := y + ( blamparticle[i].dy ) ;

			blamparticle[i].z  := z + ( blamparticle[i].dz ) ;

			if (blamparticle[i].y < .01) then
 blamparticle[i].y  := .01 ;

			blamparticle[i].dy  := dy - ( .0005 ) ;

		end;
 
		gameover-- ;

		if ( not gameover) then
  begin
 
			newgame() ;

		end;
 

		// Since we're in game-over state, there's nothing more for rungame() to do.

		{$message 'C2PAS: Exit'} Exit( ) ;

	 end;
 

	// Animate the flower and do the worm wobbling.

	if (growtimer < 50) then
 growtimer++ ;

	worm.wobblecount++ ;


	// Change the current direction according to user input.

	worm.angle  := angle + ( rotation ) ;


	// Move the worm.

	speed  := (uppressed? 1.9 : 1) * worm.speed ;

	dx  := speed * cos(worm.angle * M_PI / 180) ;

	dz  := speed * sin(worm.angle * M_PI / 180) ;


	if (worm.growto > worm.length) then
 worm.length++ ;

	 while {for}
 (i  := worm.length - 1 ;
 i;
 i--) do begin
  begin
 
		memcpy({$message 'C2PAS: Ref'}@worm.segs[i], {$message 'C2PAS: Ref'}@worm.segs[i - 1], sizeof(struct segment)) ;

	 end;
 

	worm.segs[0].x  := x + ( dx) ;

	worm.segs[0].z  := z + ( dz) ;


	// Check for collisions.

	side[0]  := dz;

	side[1]  := -dx ;

	normalize2(side) ;

	side[0] * := .04 ;

	side[1] * := .04 ;


	if ( not isfree(worm.segs[0].x, worm.segs[0].z, 0, 0)) then
  begin
 
		blam(worm.segs[0].x, worm.segs[0].z) ;

	 end

 else if ( not isfree(worm.segs[0].x + side[0], worm.segs[0].z + side[1], 1, {$message 'C2PAS: Ref'}@i)) then
  begin
 
		blam(worm.segs[i].x, worm.segs[i].z) ;

	end

 else if (not isfree(worm.segs[0].x - side[0], worm.segs[0].z - side[1], 1, {$message 'C2PAS: Ref'}@i)) then
  begin
 
		blam(worm.segs[i].x, worm.segs[i].z) ;

	 end;
 

	// Did the worm hit the flower?

	dx := worm.segs[0].x - foodpos[0] ;

	dz := worm.segs[0].z - foodpos[1] ;

	dist  := dx * dx + dz * dz;

	if (dist < .004) then
  begin
 
		// Yes! Increase score and difficulty.

		score++ ;

		if (score > 99) then
 score  := 99 ;


		worm.growto  := growto + ( 5 ) ;

		if (worm.growto > MAXSEG) then
 worm.growto  := MAXSEG ;

		worm.speed  := speed + ( .0005 ) ;


		placefood() ;

	 end;
 
 end;
 

// A recurrent timer callback from SDL, which generates an event. The event
// typically causes SDL_WaitEvent in the main loop to return.

Uint32 timercallback(Uint32 interval, void *dummy)  begin
 
	SDL_Event event ;


	event.type  := SDL_USEREVENT ;

	SDL_PushEvent({$message 'C2PAS: Ref'}@event) ;


	{$message 'C2PAS: Exit'} Exit( interval ) ;

 end;
 

// The entry point of the program.

Integerint main(Integerint argc, char **argv)  begin
 
	Integerint i, x, y;

	Integerint leftpressed  := 0, rightpressed  := 0, uppressed  := 0, rotation  := 0;

	unsigned char buf[64*64*4] ;

	Integerint fullscreen  := 0;


	if (argc = 2 and not StrCompstrcmp(argv[1], '-f')) then
 fullscreen  := 1;


	if (SDL_Init(SDL_INIT_TIMER  or SDL_INIT_VIDEO)) then
  begin
 
		err(1, 'SDL_Init') ;

	 end;
 

	atexit(SDL_Quit) ;


	if (notSDL_SetVideoMode(WIDTH, HEIGHT, 16, SDL_HWSURFACE  or SDL_OPENGL  or (fullscreen? SDL_FULLSCREEN : 0)))then
  begin
 
		err(1, 'SDL_SetVideoMode') ;

	 end;
 

	SDL_ShowCursor(0) ;


	// Initiate the game status.

	newgame() ;


	// Initiate OpenGL and load the textures.

	quad  := gluNewQuadric() ;

	if (not quad) then
 err(1, 'gluNewQuadric') ;

	gluQuadricDrawStyle(quad, GLU_FILL) ;


	glBindTexture(GL_TEXTURE_2D, T_GROUND) ;

	gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGB, soil_WIDTH, soil_HEIGHT, GL_RGB, GL_UNSIGNED_BYTE, soil_data) ;

	glBindTexture(GL_TEXTURE_2D, T_STONES) ;

	gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGB, stones_WIDTH, stones_HEIGHT, GL_RGB, GL_UNSIGNED_BYTE, stones_data) ;

	glBindTexture(GL_TEXTURE_2D, T_FONT) ;

	gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGB, font_WIDTH, font_HEIGHT, GL_RGB, GL_UNSIGNED_BYTE, font_data) ;

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP) ;

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP) ;

	glBindTexture(GL_TEXTURE_2D, T_HEADER) ;

	gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGB, header_WIDTH, header_HEIGHT, GL_RGB, GL_UNSIGNED_BYTE, header_data) ;

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP) ;

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP) ;


	// The flower texture needs an alpha component, but the pixel data
	// doesn't contain it. This code creates a local copy of the graphics
	// data, in which every black pixel is transparent.

	 while {for}
 (y := 0;
 y < 64;
 y++)do begin
  begin
 
		while {for}
 (x := 0;
 x < 64;
 x++)do begin
  begin
 
			unsigned char r, g, b, a;


			r := flower_data[y * 64 * 3 + x * 3 + 0];

			g := flower_data[y * 64 * 3 + x * 3 + 1];

			b := flower_data[y * 64 * 3 + x * 3 + 2];

			a := 255 ;

			if (r = 0 and g = 0 and b = 0)then
 a  := 0;

			buf[y * 64 * 4 + x * 4 + 0]  := r;

			buf[y * 64 * 4 + x * 4 + 1]  := g;

			buf[y * 64 * 4 + x * 4 + 2]  := b;

			buf[y * 64 * 4 + x * 4 + 3]  := a;

		end;
 
	end;
 
	glBindTexture(GL_TEXTURE_2D, T_FLOWER) ;

	gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, 64, 64, GL_RGBA, GL_UNSIGNED_BYTE, buf);


	// Start a recurrent 20 ms timer which will generate SDL_USEREVENT
	// events, which will eventually cause rungame() to be called at 50 Hz.

	SDL_AddTimer(20, timercallback, 0) ;


	 while {for}
 ( ;
 ;
)do begin
  begin
 
		SDL_Event event ;


		while (SDL_PollEvent({$message 'C2PAS: Ref'}@event)) do
  begin
 
			case (event.type) of
  begin
 
				caseSDL_USEREVENT:
					rungame(rotation * 5, uppressed) ;

					break ;

				caseSDL_KEYUP:
					case(event.key.keysym.sym) of
  begin
 
						caseSDLK_LEFT:
							leftpressed  := 0;

							if (rightpressed) then
  begin
 
								rotation  := 1;

							en;;
 else begin
 
								rotation  := 0;

							end;
 
							break;

						caseSDLK_RIGHT:
							rightpressed  := 0;

							if (leftpressed) then
  begin
 
								rotation  := -1;

							edd;
 else begin
 
								rotation  := 0 ;

							end;
 
							break;

						caseSDLK_UP:
							uppressed  := 0 ;

							break;

					 end;
 
					break;

				caseSDL_KEYDOWN:
					case (event.key.keysym.sym) of
  begin
 
						caseSDLK_LEFT:
							leftpressed  := 1 ;

							rotation  := -1;

							break;

						caseSDLK_RIGHT:
							rightpressed  := 1 ;

							rotation  := 1 ;

							break;

						caseSDLK_UP:
							uppressed  := 1 ;

							break;

						caseSDLK_ESCAPE:
							exit(0) ;

							break;

					 end;
 
					break;

			 end;
 
		 end;
 
		drawframe() ;

		SDL_GL_SwapBuffers() ;

	end;
 

	{$message 'C2PAS: Exit'} Exit( 0 ) ;

 end;

