#define P(X)write(1,X,1)
#define C 39
#define E 1024
int M[E]={2},*u=M,N[E],R=22,a[4],l[]={0,-1,C-1,-1},m[]={1,-C,-1,C},*b=N,*d=N,c,
e,f,g,i,s;main(){for(M[e=i=C*R-1]=E|8;f|d>=b;){c=M[g=i];i=e;for(s=f=0;s<4; s++)
if((e=m[s]+g)>=0&&e<C*R&&l[s]!=e%C&&(c&E)!=(M[e]&E))a[f++]=s;if(f){f=M[e=m[s=a[
rand()%f]]+g];f|=E;M[g]=c|1<<s;M[*d++=e]=f|1<<(s+2)%4;}else e=d>b++?b[-1]:e;}P(
" ");for(s=C;s--;P(" "))P("_");for(;P("\n"),R--;P("|"))for(e=C;e--;P("_ "+(*u++
/8)%2))P("| "+(*u/4)%2);}