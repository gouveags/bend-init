#include <sys/stat.h>

static void dir_make_call(IoWork* w) {
  io_sys_end(w, mkdir(w->data, 0755));
}

static Term dir_make_pack(Env e, IoWork* w) {
  Term result = w->code != 0 ? io_fail(e, w->code, NULL)
    : io_done(e, term_pak(CID_UNIT, 0));
  free(w->data);
  return result;
}

Term dir_make_run(Env e, Term* f, IoWork* w) {
  w->data = io_cstr(e, f[0], &w->size);
  if (io_nul(w->data, w->size)) {
    w->code = EILSEQ;
    return dir_make_pack(e, w);
  }
  return io_work(w, dir_make_call, dir_make_pack);
}

static void __attribute__((constructor)) dir_make_use(void) {
  io_eff(CID_DIR_MAKE, dir_make_run, 0);
}
