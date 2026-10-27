#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
/* Apply a user stylesheet at event-loop entry, after the vendor CLI parser. */
int theme_exec(void) __asm__("_ZN12QApplication4execEv");
int theme_exec(void) {
    int (*original)(void)=dlsym(RTLD_NEXT,"_ZN12QApplication4execEv");
    void **instance=dlsym(RTLD_DEFAULT,"_ZN16QCoreApplication4selfE");
    void (*set)(void*,const void*)=dlsym(RTLD_DEFAULT,"_ZN12QApplication13setStyleSheetERK7QString");
    const char *path=getenv("SPFLASH_DARK_QSS");
    FILE *file=path?fopen(path,"rb"):NULL;
    if(file && instance && *instance && set) {
        char css[32768]; size_t n=fread(css,1,sizeof(css)-1,file); css[n]=0;
        void *qstring=NULL;
        void (*qt5)(void*,const char*,int)=dlsym(RTLD_DEFAULT,"_ZN7QString15fromUtf8_helperEPKci");
        void (*qt4)(void*,const char*,int)=dlsym(RTLD_DEFAULT,"_ZN7QString8fromUtf8EPKci");
        if(qt5) qt5(&qstring,css,(int)n);
        else if(qt4) qt4(&qstring,css,(int)n);
        if(qstring) { set(*instance,&qstring); fprintf(stderr,"SPFlash dark stylesheet applied\n"); }
        /* Keep this single QString allocation alive for the GUI lifetime. */
    }
    if(file) fclose(file);
    return original?original():1;
}
