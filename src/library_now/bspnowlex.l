%{
#ifndef DEBUG
#define ECHO    /* do nothing */
#endif
#define MAX_LINE_SIZE 1024

/* Error message stuff */
char linebuf[MAX_LINE_SIZE];     /* line buffer for tokens */
int curoffs;                     /* start of current token */
int nextcuroffs;

void add_linebuf();
void clr_linebuf();
void rst_linebuf();
%}

alnum [a-zA-Z0-9]

%%
\n                    {
                      rst_linebuf();
                      bsphost_lineno++;
                      ECHO;
                      }

[ \t]+                {
                      add_linebuf();
                      ECHO;
                      }

#.*                   {
                      add_linebuf();
                      ECHO;
                      }

\${alnum}+            {
                      add_linebuf();
                      yylval.text = malloc(strlen(yytext));
                      strcpy(yylval.text,yytext+1);
                      ECHO;
                      return ENVVAR;
                      }

host                  {
                      add_linebuf();
                      ECHO;
                      return _HOST; 
                      }

\"[^\"\n]*\"          {
                      add_linebuf();
                      yylval.text = malloc(strlen(yytext));
                      strcpy(yylval.text,yytext+1);
                      yylval.text[strlen(yylval.text)-1] = 0;
                      ECHO;
                      return NAME;
                      }

{alnum}+([-_.:]|{alnum})* {
                      add_linebuf();
                      yylval.text = malloc(strlen(yytext)+1);
                      strcpy(yylval.text,yytext);
                      ECHO;
                      return NAME;
                      }

;                     {
                      clr_linebuf();
                      ECHO;
                      return yytext[0];
                      }

.                     {
                      add_linebuf();
                      ECHO;
                      return yytext[0];
                      }
%%
int yywrap(void) { return 1; }

/**********************************************************************
*                                                                     *
*                                                                     *
* From compilers Thu May 28 14:54:41 EDT 1992                         *
* Xref: iecc comp.unix.programmer:5616 comp.compilers:2899            *
* Newsgroups: comp.unix.programmer,comp.compilers                     *
* Path: iecc!compilers-sender                                         *
* From: johnl@iecc.cambridge.ma.us (John R. Levine)                   *
* Subject: Re: LEX/YACC - grammar problems and printing error messages*
* Message-ID: <92-05-149@comp.compilers>                              *
* Keywords: lex, errors                                               *
* Sender: compilers-sender@iecc.cambridge.ma.us                       *
* Reply-To: johnl@iecc.cambridge.ma.us (John R. Levine)               *
* Organization: I.E.C.C.                                              *
* References: <92-05-148@comp.compilers>                              *
* Date: Thu, 28 May 1992 18:38:40 GMT                                 *
* Approved: compilers@iecc.cambridge.ma.us                            *
*                                                                     *
* In article <92-05-148@comp.compilers> you write:                    *
* >[how can I get the entire line where an error occurs into an       *
* >error message?]                                                    *
*                                                                     *
* Yacc promises to complain as soon as it sees a token you can't      *
* parse so it's mostly a matter of having the current line available  *
* when the error occurs.                                              *
*                                                                     *
* Basically, you have to buffer the line yourself.  In AT&T lex one   *
* possibility is to rewrite the input() macro to do line buffering,   *
* but here's a sketch of how to do it in a portable way that should   *
* work with flex, the version of lex that all sensible people use.    *
* This should extend in a straightforward way to multi-line records   *
* so long as the lexer can tell where the record boundaries are.      *
*                                                                     *
* < Code Deleted >                                                    *
* Regards,                                                            *
* John Levine, johnl@iecc.cambridge.ma.us,                            *
*                                                                     *
**********************************************************************/

/* initialize the line buffer */
void clr_linebuf() {
  linebuf[0]  = '\0';
  curoffs     = 0;
  nextcuroffs = 0;
}

void rst_linebuf() {
  curoffs     = 0;
  nextcuroffs = 0;
  strcat(linebuf, yytext);                        /* append current */
}			

/* add the current token to the current line */
void add_linebuf() {
  curoffs     = nextcuroffs;                      /* start of current */
  nextcuroffs = nextcuroffs + strlen(yytext);     /* start of current */
  strcat(linebuf, yytext);                        /* append current */
}

void yyerror(char *errmsg) {
   extern int curoffs;
   char c,*p, restOfLine[MAX_LINE_SIZE];
   int going= (yytext[yyleng-1]!='\n');  /* dont read any more if at
   end of line */

   /* get the rest of the line if not at end */

   p = restOfLine;

   /* LEX uses 1 symbol look ahead. When an error occurs it reads in the
   token that was in error, then *sometimes* reads in one more
   character (bastard !!!). Unfortunatly it doesnt tell me if it did
   this, so I have to peek into its internal buffer (ouch !!) to see
   if it did
   This may cause problems.......
   Jon
   */
   while(going) {
     c=input();

     if (c == '&') {
       *p++=c;
       while ((*p++=input()) != '\n');
     } else {
       if (c == '\n') going = 0;
       else *p++=c;
     }
   }
   *p='\0';

   /* linebuf[] now has the line up to the error message
      restOfLine[] contains the rest.
   */
   
   fprintf(stderr,"\n%s: (line %d) %s.\n%s",
           BSPTCP_COMPONENT,bsphost_lineno,errmsg,linebuf);

   /* Output restLine *UPTO* a newline or the end if no newline seen */
   p = restOfLine;
   while ((*p != '\0') && (*p != '\n')) fprintf(stderr,"%c",*p++) ;

   /* Output the funny Marker */
   /* curoffs points to one char before the *start* of the token in error,
   therefore curoffs spaces, then a ^ */

   fprintf(stderr,"\n%*s^\n", (curoffs >0) ? curoffs  : 0, "");
   fprintf(stderr,"%*s|\n",   (curoffs >0) ? curoffs  : 0, "");
   fprintf(stderr,"%*sHere\n", (curoffs >0) ? curoffs-1 : 0  , "");

   /* Output the rest of the input (i.e after a newline )*/
   fprintf(stderr,"%s\n\n",p);
}


