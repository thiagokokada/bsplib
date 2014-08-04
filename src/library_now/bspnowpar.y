%{ 
#include <string.h>
#include <ctype.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

/* C declarations */
void yyerror(char *);
int  envvar_ncpus(envvar_t *);

int bsphost_lineno = 1;            /* for reporting errors in yyerror() */
%}

%union 
  { /* see %token and %type statements below for use of members */
  char *text;
  envvar_t *envvar;
  bsphost_t *host;  
  }

%token _HOST
%token _EOF
 
%token <text>    NAME 
%token <text>    ENVVAR 

%type <text>     name
%type <envvar>   env, env_list, opt_env_list
%type <host>     host, host_list, opt_host_list

%start host_data

%%

host_data          : host_list
                     {
                     bsptcp_host_list = $1;
                     }
                   ;

host_list          : host opt_host_list
                     {
                     $$ = $1;
                     $$->link = $2;
                     }
                   ;

opt_host_list      : host_list
                     {
                     $$ = $1;
                     }
                   | 
                     {
                     $$ = NULL;
                     }
                   ;

host               : _HOST '(' name ')' opt_env_list
                     {
                     bsphost_t *host;
                     struct hostent *hostinfo;

                     host = GUARDNZP(malloc(sizeof(bsphost_t)),
                        "malloc(host element)");
                     host->link      = NULL;
                     host->name      = $3;
                     hostinfo = gethostbyname(host->name);
                     GUARDNZP(hostinfo,"invalid host name");
                     host->name= GUARDNZP(malloc(1+strlen(hostinfo->h_name)),
					  "malloc(host name)");
                     strcpy(host->name,hostinfo->h_name);
		     if (getenv("BSPTCP_HOSTNAMES"))
		       {
		       host->envvars   =GUARDNZP(malloc(sizeof(envvar_t)),
                          "malloc(environment variable element)");
		       host->envvars->name ="BSPTCP_HOSTNAMES";
		       host->envvars->value=GUARDNZP(malloc(1+strlen(
			  getenv("BSPTCP_HOSTNAMES"))),
		          "malloc(bsptcp_hostnames env)");
		       strcpy(host->envvars->value,getenv("BSPTCP_HOSTNAMES"));
                       host->envvars->link = $5;
		       } 
                     else 
		       {
                       host->envvars=$5;
                       }
                     host->load_avg  = BSPTCP_INFTY_LOAD;
                     host->time_stamp= 0;
		     host->mflops    = 0.0;
		     host->bspactive = 0;
		     host->nice      = 0;
		     host->nice_time = 0;
		     host->ncpus     = envvar_ncpus(host->envvars);
		     if (host->ncpus<=0 || host->ncpus>=1024)
		       host->ncpus=1;
                     $$ = host;
                     }
                   ;

opt_env_list       : env_list
                     {
                     $$ = $1;
                     }
                   | ';'
                     {
                     $$ = NULL;
                     }
                   ;

env_list           : env opt_env_list
                     {
                     $$ = $1;
                     $$->link = $2;
                     }
                   ;

env                : name '(' name ')'
                     {
                     int i;
		     envvar_t *envvar;
                     char *envname;

                     envvar = GUARDNZP(malloc(sizeof(envvar_t)),
                        "malloc(environment variable element)");
                     envname = GUARDNZP(malloc(strlen($1)+8),
                        "malloc(environment variable name)");
                     envvar->link = NULL;
                    
                     sprintf(envname,"BSPTCP_%s",$1);
                     free($1);
                     for (i = 7; i < strlen(envname); i++) 
                        envname[i] = toupper(envname[i]);
                     envvar->name = envname;
                     envvar->value = $3;
                     $$ = envvar;
                     }
                   ;
 
name               : NAME   
                     {
                     $$ = $1;
                     } 
                   | ENVVAR
                     {
                     $$ = getenv($1);
                     if (!$$)
                        {
                        fprintf(stderr,
                           "%s: Environment variable %s, not found.\n",
                           BSPTCP_COMPONENT,$1);
                        exit(1);
                        }
                     }
                   ;
%%

int envvar_ncpus(envvar_t *xs) {
  int result=1;

  if (xs) {
    if (xs->name==NULL || xs->value==NULL) {
      result=envvar_ncpus(xs->link);
    } else if (strcmp(xs->name,"BSPTCP_NCPUS")!=0) {
      result=envvar_ncpus(xs->link);
    } else {
      sscanf(xs->value,"%d",&result);
    } 
  }
  return result;
}
