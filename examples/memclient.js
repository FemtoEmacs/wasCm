const { readFileSync } = require("fs");

const run = async () => {
  const buffer = readFileSync("./mem.wasm");
  const module = await WebAssembly.compile(buffer);
  const instance = await WebAssembly.instantiate(module);
  const mem = new Int32Array(instance.exports.mem.buffer);
    mem[0]= 42;
    mem[1]= 51;
    mem[2]= 64;
    mem[3]= 661;
    console.log(instance.exports.plusfive(0));
    console.log(instance.exports.plusfive(1));
    console.log(instance.exports.setmem(8, 16));
    console.log(mem[8]);
    console.log("=== End test ===");};

run();
