function dir_make(path) {
  const name = io_bytes(path);
  if (name.includes(0)) return io_fail(process.platform === "darwin" ? 92 : 84);
  try {
    require("node:fs").mkdirSync(name.length > 0 ? Buffer.from(name) : "");
    return io_done({ $: "Unit" });
  } catch (error) {
    return io_fail(Math.abs(error.errno ?? 5));
  }
}
