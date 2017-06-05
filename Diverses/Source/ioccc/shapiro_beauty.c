#define P(X)j=write(1,X,1)
#define C 39
int M[5000]={2},
 *u=M,
 N[5000],
 R=22,
 a[4],
 l[]={0,-1,39-1,-1},
 m[]={1,-39,-1,39},
 *b=N,
 *d=N,
 c,
 e,
 f,
 g,
 i,
 j,
 k,
 s;
main()
  {
    M[i = 39 * R - 1] = 24;
    while (f | d >= b)
      {
        c = M[ g = i];
	i = e;
	s = f = 0;
	while( s < 4 )
	  {
	  s++;
	  if( (k = m[s] + g) >= 0 && k < 39 * R && l[s] != k % 39 && ( !M[ k ] || !j && c >= 16 != M[ k ] >= 16))
	     a[f++] = s;
	  }
	  if( f )
	    {
		f = M[ e = m[ s = a[ rand() / (1+2147483647 / f) ] ] + g ];
		j = j < f ? f : j;
		f += c & - 16 * !j;
		M[ g ] = c | 1 << s;
		M[ *d++ = e ] = f | 1 << ( s + 2 ) % 4;
	    }
	else 
	  e = d > b++ ? b[ -1 ] : e;
    }
   write(1," ",1);
   s=39 ;
   while( --s )
     {
     write(1,"_",1);
     write(1," ",1);
     }
   while(write(1,"\n",1),R--)
     {
     write(1,"|",1);
     e = 39;
     while( e--)
       {
       write(1,"_ "+(*u++/8%2),1);
       write(1,"| "+(*u/4%2),1);
      } 
      }
   }