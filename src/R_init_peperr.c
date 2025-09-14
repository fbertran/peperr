//
// 2021-02-26. Author F. Bertrand <frederic.bertrand@lecnam.net>
// Copyright (c) Universite de technologie de Troyes
//

#include <stdlib.h> // for NULL
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include "noinf_R.h" // for NULL

#define CALLDEF(name, n)  {#name, (DL_FUNC) &name, n}

static R_NativePrimitiveArgType C_noinf_t[] = {
  REALSXP, INTSXP, REALSXP, INTSXP, INTSXP, REALSXP
};

static const R_CMethodDef cMethods[] = {
  {"C_noinf", (DL_FUNC) &C_noinf, 6, C_noinf_t},
  {NULL, NULL, 0, NULL}
};

void R_init_peperr(DllInfo * info)
{
  R_registerRoutines(info, cMethods, NULL, NULL, NULL);
  R_useDynamicSymbols(info, FALSE);
  R_forceSymbols(info, TRUE);
}



